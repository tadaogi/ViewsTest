//
//  AppData.swift
//  ViewsTest
//
//  Created by Tadashi Ogino on 2021/08/19.
//

import Foundation
import MapKit

class AppData : ObservableObject {
    @Published var data:[CGPoint] = []
    @Published var dataArray:[[CGPoint]] = []
    @Published var clickLocation:[CGPoint] = []
    @Published var newNX:[CGFloat] = []
    @Published var clickText:String = ""
    // for Map
    @Published var annotation:MKPointAnnotation = MKPointAnnotation()
    @Published var lineCoordinates:[gpsPoint] = []
    @Published var lastOverlays:[MKOverlay] = []
    @Published var logDataArray:[LogData] = [
        LogData(id: 1, col0: "2021/08/15 10:00:00.000", col1:"DidDiscoverPeripheral", col2:"xxx",
                col3:"35.338849789600225",col4:"139.4874632246067"
                ),
        LogData(id: 2, col0: "2021/08/15 20:00:00.000", col1:"DidDiscoverPeripheral", col2:"xxx",
            col3:"35.33940946074466",col4:"139.46452441460758"
        ),
        LogData(id: 3, col0: "2021/08/15 30:00:00.000", col1:"DidDiscoverPeripheral", col2:"xxx",
            col3:"35.33909002088716",col4:"139.44611947597906"
        ),
        LogData(id: 4, col0: "2021/08/15 10:00:00.000", col1:"DidDiscoverPeripheral", col2:"xxx",
                col3:"35.338849789600225",col4:"139.4874632246067"
                ),
        LogData(id: 5, col0: "2021/08/15 20:00:00.000", col1:"DidDiscoverPeripheral", col2:"xxx",
            col3:"35.33940946074466",col4:"139.46452441460758"
        ),
        LogData(id: 6, col0: "2021/08/15 30:00:00.000", col1:"DidDiscoverPeripheral", col2:"xxx",
            col3:"35.33909002088716",col4:"139.44611947597906"
        ),
    ]
}

class AppAxes : ObservableObject {
    @Published var xsteps:[AxesData] = []
    @Published var ysteps:[AxesData] = []
    @Published var clickLocationNew:[CGPoint] = []

}
