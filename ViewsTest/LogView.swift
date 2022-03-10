//
//  LogView.swift
//  ViewsTest
//
//  Created by Tadashi Ogino on 2021/08/21.
//

import Foundation
import SwiftUI
import MapKit

struct LogData: Identifiable, Encodable, Decodable  {
//    @EnvironmentObject var appData: AppData
// どうも、Viewでないと値が伝わらないみたい
    
    var id: Int
    var col0: String = ""
    var col1: String = ""
    var col2: String = ""
    var col3: String = ""
    var col4: String = ""
    var col5: String = ""
    var col6: String = ""
    var col7: String = ""

    public func click(appData: AppData) {
        print("LogData click")
        print(self.col6)
        print(self.col7)
        //ピンの位置
        //let latitude = Double(self.col6)
        //let longitude = Double(self.col7)
        let latitude = Double(self.col6.trimmingCharacters(in: .whitespaces))!
        let longitude = Double(self.col7.trimmingCharacters(in: .whitespaces))!
        print(latitude)
        print(longitude)
        appData.annotation.coordinate = CLLocationCoordinate2DMake(latitude , longitude )
         
        //ピンにメッセージを付随する
        appData.annotation.title = "タイトル"
        appData.annotation.subtitle = "サブタイトル"
    }

}
// 藤沢駅 35.338849789600225, 139.4874632246067
// 湘南モールフィル 35.33940946074466, 139.46452441460758
// テラスモール湘南 35.33909002088716, 139.44611947597906
// 海浜公園 35.32129953876369, 139.44738498977568

var LogDataArray: [LogData] = [
    LogData(id: 1, col0: "2021/08/15 10:00:00.000", col1:"DidDiscoverPeripheral", col2:"xxx",
            col3:"35.338849789600225",col4:"139.4874632246067"
            ),
    LogData(id: 2, col0: "2021/08/15 20:00:00.000", col1:"DidDiscoverPeripheral", col2:"xxx",
        col3:"35.33940946074466",col4:"139.46452441460758"
    ),
    LogData(id: 3, col0: "2021/08/15 30:00:00.000", col1:"DidDiscoverPeripheral", col2:"xxx",
        col3:"35.33909002088716",col4:"139.44611947597906"
    ),
    ]

struct LogView: View {
    var logData: LogData
    
    var body: some View {
        HStack {
            Text(logData.col0)
            Text(logData.col1)
            Text(logData.col2)
            Text(logData.col3)
            Text(logData.col4)
            Text(logData.col5)
            Text(logData.col6)
            Text(logData.col7)
            Spacer()
        }
    }
}

struct LogView_Previews: PreviewProvider {
    static var previews: some View {
        LogView(logData: LogDataArray[0])
            .environmentObject(AppData())
    }
}
