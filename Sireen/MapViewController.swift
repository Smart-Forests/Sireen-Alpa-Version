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
        sensorPin.coordinate = CLLocationCoordinate2D(latitude: 38.88293, longitude: -77.01641)
        mapView.addAnnotation(sensorPin)
        
        let firePin = MKPointAnnotation()
        firePin.title = "fire"
        firePin.coordinate = CLLocationCoordinate2D(latitude: 38.88298, longitude: -77.01254)
        mapView.addAnnotation(firePin)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "custom")
        
        if annotationView == nil {
            // CREATE VIEW
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
        } else {
            // Assign annotation
            annotationView?.annotation = annotation
        }
        
        // Set custom annotation images
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
