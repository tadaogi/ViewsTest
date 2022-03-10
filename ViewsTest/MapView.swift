//
//  MapView.swift
//  ViewsTest
//
//  Created by Tadashi Ogino on 2021/08/19.
//

import SwiftUI

import SwiftUI
import MapKit

var lastOverlays: [MKOverlay] = []

struct MapView: NSViewRepresentable {
  //@EnvironmentObject var appData: AppData
    // デバッグ用なので処理を一部コメントアウトしてある。後でなおすこと。
  let region: MKCoordinateRegion
  let lineCoordinates: [gpsPoint]
  //let polyline: MKPolyline
  let annotation: MKPointAnnotation
  
  func makeNSView(context: Context) -> MKMapView {
    let mapView = MKMapView()
    mapView.delegate = context.coordinator
    mapView.region = region

    //mapView.removeOverlays(appData.lastOverlays)
    
    var lineCoordinates0:[CLLocationCoordinate2D] = []
    for gpsPoint in lineCoordinates {
        lineCoordinates0.append(CLLocationCoordinate2D(latitude: gpsPoint.location.latitude, longitude: gpsPoint.location.longitude))
    }
    
    let polyline = MKPolyline(coordinates: lineCoordinates0, count: lineCoordinates0.count)
    mapView.addOverlay(polyline)
    lastOverlays = [polyline]
    
    //ピンを追加
    mapView.addAnnotation(annotation)
    
    return mapView
  }

  func updateNSView(_ mapView: MKMapView, context: Context) {
    mapView.removeOverlays(lastOverlays)
    var lineCoordinates0:[CLLocationCoordinate2D] = []
    //mapView.removeAnnotation(annotation)
    for gpsPoint in lineCoordinates {
        lineCoordinates0.append(CLLocationCoordinate2D(latitude: gpsPoint.location.latitude, longitude: gpsPoint.location.longitude))
    }

    let polyline = MKPolyline(coordinates: lineCoordinates0, count: lineCoordinates0.count)
    mapView.addOverlay(polyline)
    lastOverlays = [polyline]

  }

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

}

class Coordinator: NSObject, MKMapViewDelegate {
  var parent: MapView

  init(_ parent: MapView) {
    self.parent = parent
  }

  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    if let routePolyline = overlay as? MKPolyline {
      let renderer = MKPolylineRenderer(polyline: routePolyline)
        renderer.strokeColor = NSColor.blue
      renderer.lineWidth = 2
      return renderer
    }
    
    if let circle = overlay as? MKCircle {
        let renderer = MKCircleRenderer(circle: circle)
        renderer.strokeColor = NSColor.red // 枠線の色
        renderer.fillColor = NSColor.red.withAlphaComponent(0.2) // 内側の色
        renderer.lineWidth = 2 // 枠線の太さ
        return renderer
    }
    
    return MKOverlayRenderer()
  }
    
    // https://teratail.com/questions/120687
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let anno = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "anno")
        anno.canShowCallout = true
        return anno
    }
}
