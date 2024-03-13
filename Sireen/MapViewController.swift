import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    let circleFlag = false
    var isInitialLocationSet = false // Add this property

    @IBOutlet weak var mapView: MKMapView!
    
    fileprivate let locationManager: CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        addPins()
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
        guard let latestLocation = locations.first, !isInitialLocationSet else { return }
        
        // Center the map on the user's location just once
        let center = CLLocationCoordinate2D(latitude: latestLocation.coordinate.latitude, longitude: latestLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        isInitialLocationSet = true // Prevent further updates
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

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Check if the annotation is the user's location
        if annotation is MKUserLocation {
            // Attempt to dequeue an existing pin view first
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: "UserLocation") as? MKPinAnnotationView
            
            if pinView == nil {
                // If an existing pin view was not available, create one
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "UserLocation")
                pinView?.pinTintColor = UIColor.green // Customize pin color
                pinView?.canShowCallout = true // Optionally show a callout
            } else {
                pinView?.annotation = annotation
            }
            
            return pinView
        } else {
            // Handle other annotations (fire, sensor)
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "custom")
            
            if annotationView == nil {
                // CREATE VIEW
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
            } else {
                // Assign annotation
                annotationView?.annotation = annotation
            }
            
            // Set custom annotation images based on the title
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
}

