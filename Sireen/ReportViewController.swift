//
//  MapViewController.swift
//  Sireen
//
//  Created by Allan Prieb on 03/03/24.
//

import UIKit
import MapKit
import PhotosUI

class ReportViewController: UIViewController, CLLocationManagerDelegate {

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
        addPins()
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            guard let circleOverlay = overlay as? MKCircle else { return MKOverlayRenderer() }
            
            let circleRenderer = MKCircleRenderer(circle: circleOverlay)
            circleRenderer.strokeColor = .red
            circleRenderer.fillColor = .red.withAlphaComponent(0.1)
            return circleRenderer
        }
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let latestLocation = locations.first else { return }
            // Do something with the latest location, like centering the map
            let center = CLLocationCoordinate2D(latitude: latestLocation.coordinate.latitude, longitude: latestLocation.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
        }
    
    func addPins() {
        let sensorPin = MKPointAnnotation()
        sensorPin.title = "sensor"
        sensorPin.coordinate = CLLocationCoordinate2D(latitude: 25.76087, longitude: -80.37473)
        mapView.addAnnotation(sensorPin)
        
        let firePin = MKPointAnnotation()
        firePin.title = "fire"
        firePin.coordinate = CLLocationCoordinate2D(latitude: 25.76087, longitude: -80.37575)
        mapView.addAnnotation(firePin)
    }
    
}

extension ReportViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "custom")
        
        if annotationView == nil {
            // CREATE VIEW
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
        } else {
            // Assign annotation
            annotationView?.annotation = annotation
        }
        
        // set custom annotation images
        
        switch annotation.title {
            case "fire":
                annotationView?.image = UIImage(named: "fireWarning")
            case "sensor":
                annotationView?.image = UIImage(named: "bluePin")
            default:
                break
        }
        
        return annotationView
        
    }
    
}


