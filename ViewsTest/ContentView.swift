//
//  ContentView.swift
//  ViewsTest
//
//  Created by Tadashi Ogino on 2021/08/19.
//

import SwiftUI
import MapKit

struct MyLocationCoordinate2D: Encodable, Decodable {
    var latitude: Double = 0
    var longitude: Double = 0
}

struct gpsPoint: Encodable, Decodable {
    var time: Double = 0
    var location: MyLocationCoordinate2D = MyLocationCoordinate2D(
        latitude: 0,
        longitude: 0
    )
    // 以下だと、Encodable/Decodable にならない
    /*
    var location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0 , longitude:  0 )
     */
}

class CalcParams:ObservableObject {
    @Published var recentDeviceTime:Int = 90
    @Published var closeDeviceRSSI = -60
    @Published var middleCloseDeviceRSSI = -80
    @Published var closeLongWarningTime = 600
    @Published var closeLongAlarmTime = 900
    @Published var closeDeviceCount = 0
    @Published var closeLongDeviceCount = 0
    @Published var closeLongDeviceWarningCount = 0
    @Published var showGraph0 = true
    @Published var showGraph1 = true
    @Published var showGraph2 = true

}

extension Binding where Value == Int {
    func IntToStrDef(_ def: Int) -> Binding<String> {
        return Binding<String>(get: {
            return String(self.wrappedValue)
        }) { value in
            self.wrappedValue = Int(value) ?? def
        }
    }
}

//var gpsArray:[gpsPoint]=[]
//var graphArray:[CGPoint]=[]
var buttonName:String = "read file"
var fname:String = ""

struct ContentView: View {
    @EnvironmentObject var appData: AppData
    @EnvironmentObject var appAxes: AppAxes
    @EnvironmentObject var calcParams : CalcParams

    @State private var region = MKCoordinateRegion(
      // 藤沢駅 35.338849789600225, 139.4874632246067
      center: CLLocationCoordinate2D(latitude: 35.338849789600225, longitude: 139.4874632246067),
      span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    @State private var lineCoordinates = [

      // 藤沢駅 35.338849789600225, 139.4874632246067
      CLLocationCoordinate2D(latitude: 35.338849789600225, longitude: 139.4874632246067),

      // 湘南モールフィル 35.33940946074466, 139.46452441460758
      CLLocationCoordinate2D(latitude: 35.33940946074466, longitude: 139.46452441460758),

      /*
      // テラスモール湘南 35.33909002088716, 139.44611947597906
      CLLocationCoordinate2D(latitude: 35.33909002088716, longitude: 139.44611947597906),

      // 海浜公園 35.32129953876369, 139.44738498977568
      CLLocationCoordinate2D(latitude: 35.32129953876369, longitude:  139.44738498977568)
      */
    ];
    @State private var useSavedFile = true
    @State private var showGraph0 = true
    @State private var showGraph1 = true
    @State private var showGraph2 = true
    @State private var iPhoneMode = false

    var body: some View {
        HStack {
            VStack {
                HStack {
                Button(action: {
                    buttonName="reading.."

                    // ChartTestからコピペ
                    
                    // 変数のクリア
                    appData.lineCoordinates = []
                    //gpsArray = []
                    appData.annotation.title = "moved"
                    appData.annotation.coordinate = CLLocationCoordinate2DMake(-1,-1)
                    // appData.annotation = MKPointAnnotation() // NO GOOD
                    appData.newNX = []
                    
                    
                    
                    let filepath = getFilePath()
                    if filepath == "" {
                        buttonName = "read file"
                        return
                    }
                    fname = (filepath as NSString).lastPathComponent.removingPercentEncoding!
                    savedClickLocation = [] // clear しないと、前のクリックの情報が残ってしまう。

                    //DispatchQueue.global(qos: .default).async {
                        // サブスレッド(バックグラウンド)で実行する方を書く
                        //  DispatchQueue.main.async {
                              // Main Threadで実行する

                    // 非同期にしたけど、遅いのは同じ
                    readLogData(filepath: filepath)
//                    print(appData.lineCoordinates)
//                    print(gpsArray)
                    // いらないと思うのでコメントアウト
                    // appData.lineCoordinates = gpsArray
                    //appData.data = graphArray
                    
                    /*
                    let data = [
                        CGPoint(x: 100, y:1000),
                        CGPoint(x: 110, y:2200),
                        CGPoint(x: 120, y:800),
                        CGPoint(x: 130, y:2000),
                    ]
                    */
                    //let data = appData.data
                            
                    // ここから下を calcAxes() に移動
                    calcAxes()
                    /*
                    var xmin:CGFloat
                    var xmax:CGFloat
                    var ymin:CGFloat
                    var ymax:CGFloat
                    var xlenstep:CGFloat
                    var ylenstep:CGFloat
                    var xsteps:[AxesData]
                    var ysteps:[AxesData]
                    
                    (xmin, xmax, ymin, ymax, xlenstep, ylenstep) = calcMinMax(data: appData.data)
                    (xsteps, ysteps) = makeAxes(xmin:xmin, xmax:xmax, ymin:ymin, ymax:ymax, xlenstep:xlenstep, ylenstep:ylenstep)
                    
                    // これは makeAxes の中に移動（しようと思ったけど、appAxes にアクセスできないのでやめた。）
                    appAxes.xsteps = xsteps
                    appAxes.ysteps = ysteps
                    */ // calcAxes ここまで
                            
                    /*
                    appAxes.xsteps = [
                    //globalxsteps = [
                        AxesData(text:"100.0", value: 0.0),
                        AxesData(text:"105.0", value: 0.16666666666666666),
                        
                        AxesData(text:"110.0", value:0.3333333333333333),
                        AxesData(text:"115.0", value:0.5),
                        AxesData(text:"120.0", value:0.6666666666666666),
                        AxesData(text:"125.0", value:0.8333333333333334),
                        AxesData(text:"130.0", value:1.0)
                    
                    ]
                    */
                    
                    //appData.data = data
                    /*
                    appData.data = [
                        CGPoint(x: 100, y:1000),
                        CGPoint(x: 110, y:2200),
                        CGPoint(x: 120, y:800),
                        CGPoint(x: 130, y:2000),
                    ]
                    */
                    
                    buttonName = "read file"
                          //} // DispatchQueue
                    //} // DispatchQueue
                    print("after button")
                }){
                    Text(buttonName)
                }
                Text(fname)
                Toggle("use saved file", isOn : $useSavedFile)
                } // HStack

                MapView(
                    region: region,
                    lineCoordinates: appData.lineCoordinates,
                    //lineCoordinates: gpsArray,
                    //polyline: $appData.polyline
                    annotation: appData.annotation
                )
                .edgesIgnoringSafeArea(.all)
                .onAppear{
                    // lineCoordinates = []
                    // print(lineCoordinates)
                    //print(gpsArray)
                    // これはいらないと思うのでコメントアウト
                    //appData.lineCoordinates = gpsArray
                    //appData.data = graphArray
                }
                
                HStack {
                    VStack {
                        HStack {
                            Text("recentTime").padding(.leading)
                            TextField("Seconds", text: Binding(
                                                get: { String(self.calcParams.recentDeviceTime) },
                                                set: { self.calcParams.recentDeviceTime = Int($0.filter { "0123456789".contains($0) }) ?? self.calcParams.recentDeviceTime }
                                            ))
                              .frame(width: 50)
                            Text("WarningTime").padding(.leading)
                            TextField("Seconds", text: Binding(
                                                get: { String(self.calcParams.closeLongWarningTime) },
                                                set: { self.calcParams.closeLongWarningTime = Int($0.filter { "0123456789".contains($0) }) ?? self.calcParams.closeLongWarningTime }
                                            ))
                                .frame(width: 50)

                            Text("AlarmTime").padding(.leading)
                            TextField("Seconds", text: Binding(
                                                get: { String(self.calcParams.closeLongAlarmTime) },
                                                set: { self.calcParams.closeLongAlarmTime = Int($0.filter { "0123456789".contains($0) }) ?? self.calcParams.closeLongAlarmTime }
                                            ))
                                .frame(width: 50)

                        }
                        HStack {
                            Text("closeRSSI")
                            TextField("", text: Binding(
                                                get: { String(self.calcParams.closeDeviceRSSI) },
                                                set: { self.calcParams.closeDeviceRSSI = Int($0 .filter { "-0123456789".contains($0) }) ?? self.calcParams.closeDeviceRSSI }
                                            ))
                                .frame(width: 50)

                            Text("middleRSSI")
                            TextField("", text: Binding(
                                                get: { String(self.calcParams.middleCloseDeviceRSSI) },
                                                set: { self.calcParams.middleCloseDeviceRSSI = Int($0 .filter { "-0123456789".contains($0) }) ?? self.calcParams.middleCloseDeviceRSSI }
                                            ))
                            .frame(width: 50)

                        }
                    }
                    VStack {
                        HStack {
                            Toggle("g0", isOn : $showGraph0)
                                .foregroundColor(.red)
                            Toggle("g1", isOn : $showGraph1)
                                .foregroundColor(.green)
                            Toggle("g2", isOn : $showGraph2)
                                .foregroundColor(.yellow)
                            Toggle("iPhone", isOn : $iPhoneMode)
                        }
                        HStack {
                            Button(action: {
                                print("ReCalc Button")
                                print(calcParams.recentDeviceTime)
                                print(calcParams.closeDeviceRSSI)
                                calcParams.showGraph0 = showGraph0
                                calcParams.showGraph1 = showGraph1
                                calcParams.showGraph2 = showGraph2
                                makeGraph()
                                calcAxes()
                            }){
                                Text("ReCalc")
                            }
                        }
                    }
                }
                
                GraphView()
            }
            VStack {
                Text("Table")
                Text(String(appData.logDataArray.count))
                //let cc = appData.logDataArray.count
                List {
                    ForEach(appData.logDataArray, id: \.id) { logdata in
                        
                        LogView(logData: logdata)
                                .onTapGesture {
                                    logdata.click(appData: appData)
                                }
                        
                    }
                    
                }
                .onAppear{
                    // ここはいらないと思うのでコメントアウト
                    /*
                    appData.lineCoordinates = gpsArray
                    print("onAppear")
                    print(gpsArray)

                    print(appData.lineCoordinates)
                    */
                }


            }
        }
        .onAppear{
            // ここもいらないと思うのでコメントアウト
            /*
            print(gpsArray)
            appData.lineCoordinates = gpsArray
            appData.data = graphArray
            */
        }
    }
    
    
    func getFilePath() -> String {
        let openPanel = NSOpenPanel()
        print("readLogData")
        openPanel.allowsMultipleSelection = false // 複数ファイルの選択を許すか
        openPanel.canChooseDirectories = false // ディレクトリを選択できるか
        openPanel.canCreateDirectories = false // ディレクトリを作成できるか
        openPanel.canChooseFiles = true // ファイルを選択できるか
        openPanel.allowedFileTypes = ["log"] // 選択できるファイル種別
        
        
        let num = openPanel.runModal()
        var filePath:String = ""

        if num == NSApplication.ModalResponse.OK {
            print(openPanel.urls)
            for fileURL in openPanel.urls {
                filePath = fileURL.path
                print(filePath)
            }
            return filePath
        }else if num == NSApplication.ModalResponse.cancel {
            print("Canceled")
            return ""
        }
        
        return ""

    }
        
    func readLogData(filepath: String) {
        
        let path = filepath
        print(path)
        
        // save file path は２つ
        // table用  XXX.table.save
        // gps用 XXX.gps.save
        // graph用 XXX.graph.save
        // tableとgpsは１回のループで作っているので、まずこの２つを処理する
        let tablesavefilepath = filepath.replacingOccurrences(
                of: "(.+).log$",
                with: "$1.table.save",
            options: .regularExpression)
        
        let gpssavefilepath = filepath.replacingOccurrences(
                of: "(.+).log$",
                with: "$1.gps.save",
            options: .regularExpression)
        
        if useSavedFile && FileManager.default.fileExists(atPath: tablesavefilepath)
           && FileManager.default.fileExists(atPath: gpssavefilepath) {
            print("tablesave file path and gpssave file path exist.")
            
            do {
                try appData.logDataArray = read(from: URL(fileURLWithPath: tablesavefilepath))
            } catch {
                print("tablesavefilepath read error")
                print(error)
            }
            
            do {
                try appData.lineCoordinates = read(from: URL(fileURLWithPath: gpssavefilepath))
            } catch {
                print("gpssavefilepath read error")
                print(error)
            }
            
        } else {
        
            var csvLines = [String]()
            do {
                let csvString = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
                csvLines = csvString.components(separatedBy: .newlines)
            } catch let error as NSError {
                print("エラー: \(error)")
                return
            }
        
            // ログ表示用のデータとGPS用のデータを作る
            appData.logDataArray = []
            var i=1
            for line in csvLines {
                var log = line.components(separatedBy:",")
                log += ["","","","","","",""]
                print(log)
                let timeStr = log[0].trimmingCharacters(in: .whitespaces)
                let col6 = log[6].trimmingCharacters(in: .whitespaces)
                let col7 = log[7].trimmingCharacters(in: .whitespaces)
                let logdata = LogData(id:i,
                                      col0:timeStr,
                                      col1:log[1].trimmingCharacters(in: .whitespaces),
                                      col2:log[2].trimmingCharacters(in: .whitespaces),
                                      col3:log[3].trimmingCharacters(in: .whitespaces),
                                      col4:log[4].trimmingCharacters(in: .whitespaces),
                                      col5:log[5].trimmingCharacters(in: .whitespaces),
                                      col6:col6,
                                      col7:col7)
                appData.logDataArray.append(logdata)
                i=i+1
            
                // GPSデータ
                if log[3]==" GPS" {
                    let lat = Double(col6)!
                    if lat < 0 { // -1 は error
                        continue
                    }
                    let lon = Double(col7)!
                    let gpspoint = gpsPoint(time: StrToUnix(dateStr: timeStr), location:MyLocationCoordinate2D(latitude: lat , longitude:  lon ))

                    // appData に直接追加
                    appData.lineCoordinates.append(gpspoint)
                }
            }
        
        

            do {
                try write(appData.logDataArray, to: URL(fileURLWithPath: tablesavefilepath))
            } catch {
                print("write tablesavefile error")
                print(error)
            }


            do {
                try write(appData.lineCoordinates, to: URL(fileURLWithPath: gpssavefilepath))
            } catch {
                print("write gpssavefile error")
                print(error)
            }

        }
        

        
        // グラフ表示用のデータを作る
        
        // graph用 XXX.graph.save

        let graphsavefilepath = filepath.replacingOccurrences(
                of: "(.+).log$",
                with: "$1.graph.save",
            options: .regularExpression)
        
        if useSavedFile && FileManager.default.fileExists(atPath: graphsavefilepath) {
            print("graphsave file exist.")
            
            do {
                try appData.dataArray = read(from: URL(fileURLWithPath: graphsavefilepath))
            } catch {
                print("graph filepath read error")
                print(error)
            }
        } else {
            // ここから下を makeGraph() に移行
            // .graph.save に書くのは最初だけ
            makeGraph()
            /*
            // 後で上のループに入れる
            var deviceInfo : [String: [String: String]] = [:]
            var lastTruncateDateTime = 0.0
            //var graphValue:[CGPoint] = []
            //graphArray = []
            appData.data = []
            for log in appData.logDataArray {
                print(log)
                let uuid = log.col4
                if deviceInfo.keys.contains(uuid) {
                    //print("\(uuid) exist")
                    if StrToUnix(dateStr: log.col0) - StrToUnix(dateStr: deviceInfo[uuid]?["lastDateTime"] ?? "1970/01/01 00:00:00.000") > calcParams.recentDeviceTime { //900秒以内にアクセスがない場合 -> 30
                        deviceInfo[uuid] = ["firstDateTime":log.col0,"lastDateTime":log.col0]
                    } else {
                        deviceInfo[uuid]?["lastDateTime"]=log.col0
                    }

                } else {
                    //print("\(uuid) new")
                    deviceInfo[uuid] = ["firstDateTime":log.col0,"lastDateTime":log.col0]
                }
            
                let logDateTime = StrToUnix(dateStr: log.col0)
                if logDateTime==0 {
                    print("logDateTime=0 error")
                    continue
                }
                let TruncateDateTime = Double(Int(StrToUnix(dateStr: log.col0)/60)*60)
                var deviceCount = 0
                if lastTruncateDateTime != TruncateDateTime {
                    lastTruncateDateTime = TruncateDateTime
                    //print(UnixToStr(unixTime: TruncateDateTime, dateFormat: "HH:mm:ss"))
                    // 分が切り替わったので、計算する
                    // 古いデバイスは消去する recentDeviceTime
                    for (key, value) in deviceInfo {
                        if (TruncateDateTime - StrToUnix(dateStr: value["lastDateTime"] ?? "1970/01/01 00:00:00.000") > calcParams.recentDeviceTime) {
                            deviceInfo.removeValue(forKey: key)
                            print("removeValue for \(key)")
                        } else {
                            deviceCount = deviceCount + 1
                        }
                    }
                    //print("deviceCount=\(deviceCount)")
                    //graphValue.append(CGPoint(x:TruncateDateTime, y:Double(deviceCount)))
                    //graphArray.append(CGPoint(x:TruncateDateTime, y:Double(deviceCount)))
                    appData.data.append(CGPoint(x:TruncateDateTime, y:Double(deviceCount)))
                }
            }
            */
            
            do {
                try write(appData.dataArray, to: URL(fileURLWithPath: graphsavefilepath))
            } catch {
                print("write graphsavefile error")
                print(error)
            }
        }
        //appData.dataArray = [appData.data]
        //graphArray = graphValue
        //appData.data = graphArray
        /*
        appData.yValue = [
            ChartDataEntry(x: 1, y: 10.0),
            ChartDataEntry(x: 2, y: 20.0),
            ChartDataEntry(x: 3, y: 30.0),
            ChartDataEntry(x: 4, y: 40.0),
            ChartDataEntry(x: 5, y: 20.0),
            ChartDataEntry(x: 6, y: 50.0),
        ]
        */

    }
    
    
    // save file の read/write 処理
    func write<T:Encodable>(_ array: [T], to url: URL) throws {
        let data = try JSONEncoder().encode(array)
        try data.write(to: url)
    }
    
    func read<T:Decodable>(from url: URL) throws -> [T] {
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode([T].self, from: data)
    }
    
    // makeGraph
    func makeGraph() {
        // 後で上のループに入れる
        var deviceInfo : [String: [String: String]] = [:]
        var lastTruncateDateTime = 0.0
        //var graphValue:[CGPoint] = []
        var tmpArray0:[CGPoint] = []
        var tmpArray1:[CGPoint] = []
        var tmpArray2:[CGPoint] = []
        appData.data = []
        for log in appData.logDataArray {
            print(log)
            let uuid = log.col4
            let cmd = log.col2
            let devicename = log.col3

            if deviceInfo.keys.contains(uuid) { // そのuuidがデータ構造にある場合
                //print("\(uuid) exist")
                if (Int(StrToUnix(dateStr: log.col0) - StrToUnix(dateStr: deviceInfo[uuid]?["lastDateTime"] ?? "1970/01/01 00:00:00.000")) > calcParams.recentDeviceTime) { //900秒以内にアクセスがない場合 -> 90
                    // アクセスが長時間ない場合は、今回のデータを新規にする。
                    deviceInfo[uuid] = ["firstDateTime":log.col0,"lastDateTime":log.col0,"devicename":devicename]
                } else {
                    deviceInfo[uuid]?["lastDateTime"]=log.col0
                    // devicename が unknown でなければ、その値で上書き
                    if !devicename.contains("unknown") {
                        deviceInfo[uuid]?["devicename"] = devicename
                    }
                }

            } else { // 初めてのUUIDの場合
                //print("\(uuid) new")
                deviceInfo[uuid] = ["firstDateTime":log.col0,"lastDateTime":log.col0,"devicename":devicename]
            }
            
            if cmd == "didDiscoverPeripheral" || cmd == "didReadRSSI" {
                var rssi =  Int(log.col5) // error の場合は、rssi に nil が入る
                // rssi が 127 の時はエラーにする。
                if (rssi ?? 127) > 0 {
                    rssi = nil
                }
                print("rssi = \(String(describing: rssi))")
                
                if rssi != nil {
                    if deviceInfo[uuid]!.keys.contains("RSSI") {
                        if let oldRSSI = deviceInfo[uuid]?["RSSI"] {
                            let newRSSI = Int((rssi! + Int(oldRSSI)!)/2)
                            deviceInfo[uuid]?["RSSI"] = String(newRSSI)
                            print("new rssi = \(String(newRSSI))")
                        }
                    } else {
                        deviceInfo[uuid]?["RSSI"] = log.col5
                    }
                }
            }
        
            let logDateTime = StrToUnix(dateStr: log.col0)
            if logDateTime==0 {
                print("logDateTime=0 error")
                continue
            }
            let TruncateDateTime = Double(Int(StrToUnix(dateStr: log.col0)/60)*60)
            var deviceCount = 0
            var closeDeviceCount = 0
            var middleCloseDeviceCount = 0
            var longCloseDeviceCount = 0
            if lastTruncateDateTime != TruncateDateTime {
                lastTruncateDateTime = TruncateDateTime
                //print(UnixToStr(unixTime: TruncateDateTime, dateFormat: "HH:mm:ss"))
                // 分が切り替わったので、計算する
                // 古いデバイスは消去する recentDeviceTime
                for (key, value) in deviceInfo {
                    if (Int(TruncateDateTime - StrToUnix(dateStr: value["lastDateTime"] ?? "1970/01/01 00:00:00.000")) > calcParams.recentDeviceTime) {
                        deviceInfo.removeValue(forKey: key)
                        print("removeValue for \(key)")
                    } else {
                        print("devicename = \(value["devicename"]!)")
                        if (!iPhoneMode) || value["devicename"]!.contains("iPhone") {
                            deviceCount = deviceCount + 1
                            print("value[RSSI]=")
                            print(value["RSSI"] ?? "noRSSI")
                            if value["RSSI"] != nil {
                                let deviceRssi = Int(value["RSSI"]!)!
                                print("rssi value exist")
                                print(deviceRssi)
                                if deviceRssi > calcParams.closeDeviceRSSI {
                                    closeDeviceCount = closeDeviceCount + 1
                                }
                                if deviceRssi > calcParams.middleCloseDeviceRSSI {
                                    middleCloseDeviceCount = middleCloseDeviceCount + 1
                                }
                            }
                        }
                    }
                }
                //print("deviceCount=\(deviceCount)")
                //graphValue.append(CGPoint(x:TruncateDateTime, y:Double(deviceCount)))
                tmpArray0.append(CGPoint(x:TruncateDateTime, y:Double(deviceCount)))
                tmpArray1.append(CGPoint(x:TruncateDateTime, y:Double(closeDeviceCount)))
                tmpArray2.append(CGPoint(x:TruncateDateTime, y:Double(middleCloseDeviceCount)))
//                appData.data.append(CGPoint(x:TruncateDateTime, y:Double(deviceCount)))
            }
        }
        appData.dataArray = [tmpArray0,tmpArray1,tmpArray2]
    }
    
    
    func calcAxes() {
        var xmin:CGFloat
        var xmax:CGFloat
        var ymin:CGFloat
        var ymax:CGFloat
        var xlenstep:CGFloat
        var ylenstep:CGFloat
        var xsteps:[AxesData]
        var ysteps:[AxesData]
        
        
        let alldata = makeAllData(dataArray: appData.dataArray)
        (xmin, xmax, ymin, ymax, xlenstep, ylenstep) = calcMinMax(data: alldata)
        /*
        (xmin, xmax, ymin, ymax, xlenstep, ylenstep) = calcMinMax(data: appData.data)
         */
        (xsteps, ysteps) = makeAxes(xmin:xmin, xmax:xmax, ymin:ymin, ymax:ymax, xlenstep:xlenstep, ylenstep:ylenstep)
        
        // これは makeAxes の中に移動（しようと思ったけど、appAxes にアクセスできないのでやめた。）
        appAxes.xsteps = xsteps
        appAxes.ysteps = ysteps
        
    }
    
    // ２箇所にあるので注意
    func makeAllData(dataArray:[[CGPoint]])->[CGPoint] {
        var ret:[CGPoint] = []
        
        if calcParams.showGraph0 {
            ret += dataArray[0]
        }
        if calcParams.showGraph1 {
            ret += dataArray[1]
        }
        if calcParams.showGraph2 {
            ret += dataArray[2]
        }
        return ret
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AppData())
    }
}
