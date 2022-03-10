//
//  GraphView.swift
//  ViewsTest
//
//  Created by Tadashi Ogino on 2021/08/19.
//

import SwiftUI
import MapKit

struct AxesData:Identifiable {
    var id=UUID()
    var text:String
    var value:CGFloat
}

var globalxsteps:[AxesData]=[]

struct GraphView: View {
//    @EnvironmentObject var appData: AppData
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            ZStack(alignment: .leading) {
        /*
                Rectangle()
                    .fill(Color.red)
                    .frame(width:50, height:height)
                    .position(x:100, y:100)
         */
                SubGraphView()
                //.frame(width:100, height:100)
                .position(x:width, y:height)
          
            

                // Y軸を先に描く。描画の重なり具合の関係。
                
                YAxes()
                    .frame(width:50, height:height)
                    .position(x:50/2, y:height/2)
                 
                
                XAxes()
                    .frame(width:width, height:50)
                    .position(x:50, y:height-50/2)

            }
            .frame(width: width, height: height)
            .clipped()
            .onAppear{
                /*
                appData.data = [
                    CGPoint(x: 100, y:1000),
                    CGPoint(x: 110, y:2200),
                    CGPoint(x: 120, y:800),
                    CGPoint(x: 130, y:2000),
                ]
                
                appData.xsteps = [
                    AxesData(text:"100.0", value: 0.0),
                    AxesData(text:"105.0", value: 0.16666666666666666),
                    
                    AxesData(text:"110.0", value:0.3333333333333333),
                    AxesData(text:"115.0", value:0.5),
                    AxesData(text:"120.0", value:0.6666666666666666),
                    AxesData(text:"125.0", value:0.8333333333333334),
                    AxesData(text:"130.0", value:1.0)
                
                ]
                
                appData.ysteps = [
                    AxesData(text:"800.0", value: 0.0),
                    AxesData(text:"1000.0", value: 0.14285714285714285),
                    
                    AxesData(text:"1200.0", value:0.2857142857142857),
                    AxesData(text:"1400.0", value:0.42857142857142855),
                    AxesData(text:"1600.0", value:0.5714285714285714),
                    AxesData(text:"1800.0", value:0.7142857142857143),
                    AxesData(text:"2000.0", value:0.8571428571428571),
                    AxesData(text:"2200.0", value:1.0)
 
                ]
                 */
            }
        }
        
        
    }
}

struct XAxes: View {
    @EnvironmentObject var appAxes: AppAxes
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            //let height = geometry.size.height
            ZStack {
                
                Rectangle()
                    .fill(Color.white)
                    .frame(width:width, height:50)
                    .offset(x: width/2, y:0)

                Rectangle()
                        .fill(Color.green.opacity(0.1))
                        .frame(width:width, height:50)
                        .offset(x: width/2, y:0)
                 
                Rectangle()
                    .fill(Color.black)
                    .frame(width: width, height:1)
                    .offset(x:width/2, y:-50/2)
        
                /*
                let xsteps:[(String, CGFloat)] = [
                    ("100.0", 0.0),
                    ("105.0", 0.16666666666666666),
                    ("110.0", 0.3333333333333333),
                    ("115.0", 0.5),
                    ("120.0", 0.6666666666666666),
                    ("125.0", 0.8333333333333334),
                    ("130.0", 1.0)
                ]
 */
                let xsteps = appAxes.xsteps
                //let xsteps = globalxsteps
                
                ForEach (xsteps) { xstep in
                    let xtext = xstep.text
                    let xvalue = xstep.value
                    let xaxes = (width - 50) * xvalue
                    Text(xtext)
                        .rotationEffect(.degrees(270))
                        .offset(x: xaxes, y: 2)
                    Rectangle()
                        .fill(Color.black)
                        .frame(width:1, height:10)
                        .offset(x: xaxes, y:-50.0/2+10.0/2)
                }
            
            }
        }
    }
}

struct YAxes: View {
    @EnvironmentObject var appAxes: AppAxes
    var body: some View {
        GeometryReader { geometry in
            //let width = geometry.size.width
            let height = geometry.size.height
            ZStack {
                
                Rectangle()
                    .fill(Color.white)
                    .frame(width:50, height:height*2)
                    .offset(x: 0, y: 0)

                Rectangle()
                    .fill(Color.green.opacity(0.1))
                    .frame(width:50, height:height*2)
                    .offset(x: 0, y: 0)
                 
                Rectangle()
                    .fill(Color.black)
                    .frame(width: 1, height:height-50)
                    .offset(x:50/2, y:-50/2-height/2)
                /*
                let ysteps:[(String, CGFloat)] = [
                    ("800.0", 0.0),
                    ("1000.0", 0.14285714285714285),
                    ("1200.0", 0.2857142857142857),
                    ("1400.0", 0.42857142857142855),
                    ("1600.0", 0.5714285714285714),
                    ("1800.0", 0.7142857142857143),
                    ("2000.0", 0.8571428571428571),
                    ("2200.0", 1.0)
                ]
 */
                let ysteps = appAxes.ysteps
                
                ForEach (ysteps) { ystep in
                    let ytext = ystep.text
                    let yvalue = ystep.value
                    let yaxes = height * 0.0 - 50 - (height - 50) * yvalue
                    Rectangle()
                        .fill(Color.black)
                        .frame(width:10, height:1)
                        .offset(x:50.0/2-10.0/2, y: yaxes)
                
                    Text(ytext)
                        .offset(x: 0, y: yaxes)
                }
            }
        }
    }
}


var savedClickLocation:[CGPoint]=[]
struct SubGraphView: View {
    @EnvironmentObject var appData: AppData
//    @EnvironmentObject var appAxes: AppAxes
    @EnvironmentObject var calcParams : CalcParams
    @State var position: CGSize = CGSize(width: 0, height: 0)
    @State var size: CGSize = CGSize(width: 0, height: 0)
    @State private var dragging = false
    @State var startx:CGFloat = 0.0
    @State var starty:CGFloat = 0.0
    
    @State var magnify:CGFloat = 1.0
    
    
    
    var drag: some Gesture {
        DragGesture()
        .onChanged{ value in
            if self.dragging == false {
                print("start dragging")
                self.dragging = true
                self.startx = position.width
                self.starty = position.height
            }
            print("position=\(self.position)")
            
            self.position = CGSize(
                width: self.startx
                    + value.translation.width,
                height: self.starty
                    + value.translation.height
            )
            
            // 下のロジックだと、真ん中をドラッグしないといけないので、上に修正
            /*
            self.position = CGSize(
                width: value.startLocation.x
                    + value.translation.width,
                height: value.startLocation.y
                    + value.translation.height
            )
            */
        }
        .onEnded{ value in
            print("end dragging")
            self.dragging = false
            
            self.position = CGSize(
                width: self.startx
                    + value.translation.width,
                height: self.starty
                    + value.translation.height
            )
            /*
            self.position = CGSize(
                width: value.startLocation.x
                    + value.translation.width,
                height: value.startLocation.y
                    + value.translation.height
            )
            */
        }
        
    }
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            let globalminx = geometry.frame(in: .global).minX
            //let localminx = geometry.frame(in: .local).minX
            //let dummy = copyClickLocation(globalminx: globalminx)

        //Text("MyChart")
        //Text("12:34")
        //    .rotationEffect(.degrees(270))
        //    .offset(x: 100, y: height * 0.9)
        // どこをクリックしても分かるようにRectangleを置く
            //let magnify = 1.0
            Rectangle()
                .fill(Color.green.opacity(0.1))
                .frame(width:width*2.0*magnify, height:height*2*magnify)
            
            // グラフの描画
            if appData.dataArray.count > 0 && calcParams.showGraph0 {
                let tmpdata = appData.dataArray[0]
                Path { path in
                    let points = makePoints(width: width, height: height, data: tmpdata)
                    path.addLines(points)
                }
                .stroke(style: .init(lineWidth: 2))
                .foregroundColor(.red)
            }
            if appData.dataArray.count > 1 && calcParams.showGraph1 {
                let tmpdata = appData.dataArray[1]
                Path { path in
                    let points = makePoints(width: width, height: height, data: tmpdata)
                    path.addLines(points)
                }
                .stroke(style: .init(lineWidth: 2))
                .foregroundColor(.green)
            }
            if appData.dataArray.count > 2 && calcParams.showGraph2 {
                let tmpdata = appData.dataArray[2]
                Path { path in
                    let points = makePoints(width: width, height: height, data: tmpdata)
                    path.addLines(points)
                }
                .stroke(style: .init(lineWidth: 2))
                .foregroundColor(.yellow)
            }

            /*
            Path { path in
                let points = makePoints(width: width, height: height, data: appData.data)
                path.addLines(points)
            }
            .stroke(style: .init(lineWidth: 2))
            .foregroundColor(.red)
             */
            
            
            // debug
            /*
            Path { path in
                
                 let points2 = [
                CGPoint(x: width * 0.0 * magnify, y: height * 0.0 * magnify),
                CGPoint(x: width * 0.25 * magnify, y: height * 0.6 * magnify),
                CGPoint(x: width * 0.5 * magnify, y: height * 0.5 * magnify),
                CGPoint(x: width * 0.75 * magnify, y: height * 0.8 * magnify),
                CGPoint(x: width * 1.0 * magnify, y: height * 1.0 * magnify),
                 ]
                
                path.addLines(points2)
            }
            .stroke(style: .init(lineWidth: 2))
            .foregroundColor(.green)
            */
            
            // 補助線の描画（仮）
            Path { path in
                for yy in [0.25,0.50,0.75] {
                    path.move(to: CGPoint(x:width*0.0,y:height*CGFloat(yy)*magnify))
                    path.addLine(to: CGPoint(x:width*1.0,y:height*CGFloat(yy)*magnify))
                }
            }
            .stroke(style: .init(lineWidth: 1))
            .foregroundColor(.black).opacity(0.3)
            
            // クリックした場所の描画
            // とりあえず動いたように見える。本当は y も修正したいが、、、
            // Bugがあったので色々修正。Path でなくても平気だけど、、、
            Path { path in
                for click in appData.clickLocation {
                    // globalminx を引くと、ドラッグしても動かない。
                    // click した時の globalminx を覚えておければ良いが、、、
                    //path.move(to: CGPoint(x:click.x + width/2, y: 0))
                    //path.addLine(to: CGPoint(x:click.x + width/2, y:height))
                    //savedClickLocation = [CGPoint(x:click.x - globalminx, y: 0)]
                    
                    // クリック後に最初に描画した時点で、その値をセーブしておく必要がある。
                    let x = appData.clickLocation[0].x
                    print("clicked at \(x)")
                    let nx = (x + width/2 - 50)/(width - 50)
                    print("nx=\(nx)")
                    // nx を残しておく
                    appData.newNX = [nx]
                    
                    // 2回目は不要
                    appData.clickLocation = []
                }
                /*
                for click in savedClickLocation {
                    path.move(to: CGPoint(x:click.x + width/2, y: 0))
                    path.addLine(to: CGPoint(x:click.x + width/2, y:height))
                }
                */
            }
            .stroke(style: .init(lineWidth: 2))
            .foregroundColor(.red)
            // newNX
            Path { path in
                for nx in appData.newNX {
                    path.move(to: CGPoint(x:(width-50)*nx + 50, y: 0))
                    path.addLine(to: CGPoint(x:(width-50)*nx + 50, y:height))
                }
            }
            .stroke(style: .init(lineWidth: 2))
            .foregroundColor(.blue)
            // clickした場所の時刻表示
            if appData.newNX.count > 0 {
                Text(appData.clickText)
                    .rotationEffect(.degrees(270))
                    .offset(x: (width-50)*appData.newNX[0] + 50, y: height-100)
                    // 100 は、グラフをみながら調整した。本当はテキストの大きさから出すもの。
                    .foregroundColor(.blue)
            }
 
        }
        .position(x: position.width, y: position.height)

        // dragの処理
        .gesture(drag)
        
        // click した時の処理
        .gesture(DragGesture(minimumDistance: 0)
                    .onEnded({ (value) in
                        print(appData.clickLocation)
                        print(value.location)
                        appData.clickLocation = [value.location]
                        print(appData.clickLocation)
                    }))
    }
    
    /*
    func copyClickLocation(globalminx: CGFloat) -> Int {
        print("copy click location")
        print(globalminx)
        if (appData.clickLocation.count > 0) {
            appData.clickLocationNew = [CGPoint(x:appData.clickLocation[0].x + globalminx,
                                                y:appData.clickLocation[0].y)]
        }
        return 1
    }
    */
//}
    func makePoints(width:CGFloat,height:CGFloat,data:[CGPoint])->[CGPoint]{
        let magnify:CGFloat = 1.0
        /*
        let data:[CGPoint] = [
            CGPoint(x: 0.0, y:0.0),
            CGPoint(x: 0.33, y:1.0),
            CGPoint(x: 0.66, y:0.0),
            CGPoint(x: 1.0, y:1.0),
        ]
        */
        var points:[CGPoint] = []
        
        // for debug
        var xmin:CGFloat = 100
        var xmax:CGFloat = 130
        var ymin:CGFloat = 1000
        var ymax:CGFloat = 2000
        var xlenstep:CGFloat = 5
        var ylenstep:CGFloat = 200
        
        let alldata = makeAllData(dataArray: appData.dataArray)
        (xmin, xmax, ymin, ymax, xlenstep, ylenstep) = calcMinMax(data: alldata)
        makeAxes(xmin:xmin, xmax:xmax, ymin:ymin, ymax:ymax, xlenstep:xlenstep, ylenstep:ylenstep)
        
        let ndata = makeNormal(xmin: xmin, xmax: xmax, ymin: ymin, ymax: ymax, data: data)
        
        // ndata  から、View上の座標を求める。
        // これは、ドラッグされていない場合のみ有効
        // ドラッグされていると、位置関係がまだ理解できていない。
        for point in ndata {
            let point0 = CGPoint(
                x: (width-50) * point.x * magnify + 50.0,
                y: height - 50 - (height - 50) * point.y * magnify
            )
            points.append(point0)
        }
        
        if appData.clickLocation.count > 0 {
            let x = appData.clickLocation[0].x
            print("clicked at \(x)")
            let nx = (x + width/2 - 50)/(width - 50)
            print("nx=\(nx)")
            
            let dx = nx * (xmax - xmin) + xmin
            print("dx=\(dx)")
            let clickText = UnixToStr(unixTime:TimeInterval(dx), dateFormat: "HH:mm")
            print("clickText=\(clickText)")
            appData.clickText = clickText
            
            var clickGpspoint:[gpsPoint] = []
            for gpspoint in appData.lineCoordinates {
                if gpspoint.time > Double(dx) {
                    clickGpspoint = [gpspoint]
                    break
                }
            }
            if clickGpspoint.count > 0 {
                print("clickGpspoint \(clickGpspoint)")
                appData.annotation.coordinate = CLLocationCoordinate2D(latitude: clickGpspoint[0].location.latitude, longitude: clickGpspoint[0].location.longitude)
                appData.annotation.title = UnixToStr(unixTime: clickGpspoint[0].time, dateFormat: "HH:mm:ss")
                appData.annotation.subtitle = "SubTitle"

            } else {
                print("No GPS point found")
            }
            
        }
        
        return points
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

func calcMinMax(data:[CGPoint])->(CGFloat,CGFloat,CGFloat,CGFloat,CGFloat,CGFloat) {
    if data.count == 0 {
        return (0,1,0,1,0.5,0.5)
    }
    
    let xmin = data.reduce(data[0].x, {min($0, $1.x)})
    let xmax = data.reduce(data[0].x, {max($0, $1.x)})
    let ymin = data.reduce(data[0].y, {min($0, $1.y)})
    let ymax = data.reduce(data[0].y, {max($0, $1.y)})
    
    var xlen = xmax - xmin
    if xlen==0 {xlen=1} // 0 だとエラーになるのでとりえずの回避策
    var xlenstep = Double(xlen)/pow(10, Double(Int(log10(xlen))))
    if (xlenstep > 5) {
        xlenstep = 1 * pow(10, Double(Int(log10(xlen))))
    } else if (xlenstep > 2) {
        xlenstep = 0.5 * pow(10, Double(Int(log10(xlen))))
    } else {
        xlenstep = 0.2 * pow(10, Double(Int(log10(xlen))))
    }
    xlenstep = Double(Int(xlenstep))
    print(xlenstep)

    
    var ylen = ymax - ymin
    if ylen==0 {ylen=1} // 回避策
    var ylenstep = Double(ylen)/pow(10, Double(Int(log10(ylen))))
    if (ylenstep > 5) {
        ylenstep = 1 * pow(10, Double(Int(log10(ylen))))
    } else if (ylenstep > 2) {
        ylenstep = 0.5 * pow(10, Double(Int(log10(ylen))))
    } else {
        ylenstep = 0.2 * pow(10, Double(Int(log10(ylen))))
    }
    if ylenstep < 1 {
        ylenstep = 1
    }
    ylenstep = Double(Int(ylenstep))
    print(ylenstep)
    return (xmin, xmax, ymin, ymax, CGFloat(xlenstep), CGFloat(ylenstep))
}


func makeNormal(xmin:CGFloat, xmax:CGFloat, ymin:CGFloat, ymax:CGFloat, data:[CGPoint])->[CGPoint] {
    var points:[CGPoint] = []

    for point in data {
        let point0 = CGPoint(
            x: (point.x - xmin)/(xmax - xmin),
            y: (point.y - ymin)/(ymax - ymin))
        points.append(point0)
    }
    return points
}

func makeAxes(xmin:CGFloat, xmax:CGFloat, ymin:CGFloat, ymax:CGFloat, xlenstep:CGFloat, ylenstep:CGFloat) -> ([AxesData],[AxesData]){
    var xstepnum:Int

    xstepnum = Int((xmax - xmin)/xlenstep)
    
    var xsteps:[AxesData] = []

    for step in 1..<xstepnum+1 { // step の数が多いので 0 を 1 にしてみる
        let x0 = CGFloat(Int(xmin/xlenstep)+step) * xlenstep
        let x0N = (x0 - xmin)/(xmax - xmin)
        //        let xstep = AxesData(text:String(Double(x0)), value:x0N)
        //print(UnixToStr(unixTime: TruncateDateTime, dateFormat: "HH:mm:ss"))

        let xstep = AxesData(text:UnixToStr(unixTime:TimeInterval(x0), dateFormat: "HH:mm"), value:x0N)
        
        xsteps.append(xstep)
    }
    print(xsteps)
    // ここで代入するとループになる！！！１
    //appAxes.xsteps = xsteps
    globalxsteps = xsteps
    
    var ystepnum:Int

    ystepnum = Int((ymax - ymin)/ylenstep)
    
    var ysteps:[AxesData] = []
    
    for step in 1..<ystepnum+1 {
        let y0 = CGFloat(Int(ymin/ylenstep)+step) * ylenstep
        let y0N = (y0 - ymin)/(ymax - ymin)
        let ystep = AxesData(text:String(Int(y0)), value:y0N) // yはIntにする
        ysteps.append(ystep)
    }
    print(ysteps)
    
    return (xsteps, ysteps)
}


struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView()
    }
}

public func StrToUnix(dateStr: String)-> TimeInterval{
    // 日時文字列をNSDate型に変換するためのNSDateFormatterを生成
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd HH:mm:ss.SSS"
    
    // NSDateFormatterを使って日時文字列 "dateStr" をNSDate型 "date" に変換
    let date: NSDate? = formatter.date(from: dateStr) as NSDate?
    
    // NSDate型 "date" をUNIX時間 "dateUnix" に変換
    let dateUnix: TimeInterval? = date?.timeIntervalSince1970
    
    return dateUnix ?? 0
}

public func UnixToStr(unixTime: TimeInterval, dateFormat: String)->String {
    // UNIX時間 "dateUnix" をNSDate型 "date" に変換
    //let dateUnix: NSTimeInterval = 1423053296
    let date = NSDate(timeIntervalSince1970: unixTime)

    // NSDate型を日時文字列に変換するためのNSDateFormatterを生成
    let formatter = DateFormatter()
    formatter.dateFormat = dateFormat

    // NSDateFormatterを使ってNSDate型 "date" を日時文字列 "dateStr" に変換
    let dateStr: String = formatter.string(from: date as Date)
    
    return dateStr
}
