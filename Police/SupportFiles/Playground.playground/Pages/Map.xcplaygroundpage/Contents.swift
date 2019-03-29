//: [Previous](@previous)

import Foundation
import PlaygroundSupport
import UIKit
import MapKit
import CoreLocation
import Police

extension MKPolygon {
    
    func contains(point: CLLocationCoordinate2D) -> Bool {
        
        let renderer = MKPolygonRenderer(polygon: self)
        let currentMapPoint = MKMapPoint(point)
        let polygonPoint = renderer.point(for: currentMapPoint)
        
        if  renderer.path.contains(polygonPoint) {
            return true
        }
        
        return false
    }
}

class MapController: UIViewController, MKMapViewDelegate {
    
    var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMap()
        configurePolygon()
    }
    
    func configureMap() {

        let delta = 0.5
        let frame = CGRect( x:0, y:0, width:600, height:600 )
        mapView = MKMapView( frame: frame )
        var region = MKCoordinateRegion()
        region.center.latitude = 51.5
        region.center.longitude = 0.0
        region.span.latitudeDelta = delta
        region.span.longitudeDelta = delta
        mapView.setRegion( region, animated: true )
        view.addSubview(mapView)
        mapView.delegate = self
    }
    
    func configurePolygon() {
        
        let first = CLLocationCoordinate2DMake(51.5, 0.0)
        let second = CLLocationCoordinate2DMake(51.3, 0.0)
        let third = CLLocationCoordinate2DMake(51.4, 0.2)
        var coordinates = [first, second, third]
        let polygon = MKPolygon(coordinates: &coordinates, count: 3)
        
        mapView.addOverlay(polygon)
    }

    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        if let polygon = mapView.overlays.first as? MKPolygon {
            
            if polygon.contains(point: mapView.centerCoordinate) {
                print("It's the centre!!!")
            }
        }
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        print("overlay is Polygon \(overlay)")
        
        if let overlay = overlay as? MKPolygon {

            let renderer = MKPolygonRenderer(polygon: overlay)
            renderer.fillColor = UIColor.black.withAlphaComponent(0.5)
            renderer.strokeColor = .orange
            renderer.lineWidth = 2
            return renderer
        }
        return MKOverlayRenderer()
    }
}

let viewController = MapController()

PlaygroundPage.current.liveView = viewController.view
PlaygroundPage.current.needsIndefiniteExecution = true



//: [Next](@next)
