//
//  MapViewController.swift
//  Sireen
//
//  Created by Allan Prieb on 03/03/24.
//

import UIKit
import MapKit
import PhotosUI
import CoreBluetooth

class ReportViewController: UIViewController, CLLocationManagerDelegate {

    let circleFlag = false
    
    @IBOutlet weak var mapView: MKMapView!
    
    fileprivate let locationManager: CLLocationManager = CLLocationManager()
    
    var centralManager: CBCentralManager!
    var myPeripheral: CBPeripheral?
    let serviceUUID = CBUUID(string: "12345678-1234-5678-1234-56789abcdef0")
    let characteristicUUID = CBUUID(string: "12345678-1234-5678-1234-56789abcdef1")
    
    var isInitialLocationSet = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.showsUserLocation = true
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
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
    }

    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            guard let circleOverlay = overlay as? MKCircle else { return MKOverlayRenderer() }
            
            let circleRenderer = MKCircleRenderer(circle: circleOverlay)
            circleRenderer.strokeColor = .red
            circleRenderer.fillColor = .red.withAlphaComponent(0.1)
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

extension ReportViewController: CBCentralManagerDelegate, CBPeripheralDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: [serviceUUID], options: nil)
        } else {
            print("Bluetooth is not turned on")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        myPeripheral = peripheral
        myPeripheral!.delegate = self
        centralManager.stopScan()
        centralManager.connect(myPeripheral!, options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to \(peripheral.name ?? "device")")
        peripheral.discoverServices([serviceUUID])
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            if service.uuid == serviceUUID {
                peripheral.discoverCharacteristics([characteristicUUID], for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics {
            if characteristic.uuid == characteristicUUID {
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("Error reading characteristic: \(error.localizedDescription)")
            return
        }

        if characteristic.uuid == characteristicUUID, let data = characteristic.value {
            // Safely unwrap the integer value from data
            let sensorValue = data.withUnsafeBytes { (pointer: UnsafeRawBufferPointer) -> Int? in
                guard let unsafePointer = pointer.bindMemory(to: Int.self).baseAddress else { return nil }
                return unsafePointer.pointee
            }
            if let sensorValue = sensorValue {
                print("Sensor Value: \(sensorValue)")
                // Handle the sensor value here
                if (sensorValue > 30) {
                    
                    let firePin = MKPointAnnotation()
                    firePin.title = "fire"
                    firePin.coordinate = CLLocationCoordinate2D(latitude: 38.88311, longitude: -77.01643)
                    mapView.addAnnotation(firePin)
                    
                }
            } else {
                print("Error: Data size does not match expected size for Int")
            }
        }
    }

}
