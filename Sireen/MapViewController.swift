//
//  MapViewController.swift
//  Sireen
//
//  Created by Allan Prieb on 03/03/24.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    let circleFlag = false

    @IBOutlet weak var mapView: MKMapView!
    
    fileprivate let locationManager: CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        if(circleFlag) {
            if let userLocation = locationManager.location?.coordinate {
                let circle = MKCircle(center: userLocation, radius: 5000)
                mapView.addOverlay(circle)
            }
        }
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            guard let circleOverlay = overlay as? MKCircle else { return MKOverlayRenderer() }
            
            let circleRenderer = MKCircleRenderer(circle: circleOverlay)
            circleRenderer.strokeColor = .blue
            circleRenderer.fillColor = .blue.withAlphaComponent(0.1)
            return circleRenderer
        }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let latestLocation = locations.first else { return }
            // Do something with the latest location, like centering the map
            let center = CLLocationCoordinate2D(latitude: latestLocation.coordinate.latitude, longitude: latestLocation.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, latitudinalMeters: 10000, longitudinalMeters: 10000)
            mapView.setRegion(region, animated: true)
        }
    
    
}


