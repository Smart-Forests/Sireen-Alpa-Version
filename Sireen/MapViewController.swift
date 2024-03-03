//
//  MapViewController.swift
//  PawsAndFound
//
//  Created by Jose Baez on 11/11/23.
//

import UIKit
import MapKit
import ParseSwift

class MapViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!

    private var posts = [Post]() {
        didSet {
            DispatchQueue.main.async {
                self.updateMapWithPosts()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        queryPosts()
    }
    
    private func queryPosts(){
        //This gathers the post that can be viewed on the map
        let query = Post.query.include("locationInfo")
        query.find{ [weak self] result in
            switch result {
            case .success(let posts):
                self?.posts = posts
            case .failure(let error):
                self?.showAlert(description: error.localizedDescription)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Call the updateMapWithPosts function to set up the map with initial data
        updateMapWithPosts()
    }

    func updateMapWithPosts() {
        print("Updating map with posts")

        // Remove existing annotations
        mapView.removeAnnotations(mapView.annotations)
        

        // Add new annotations based on the posts array
        for post in posts {
            guard let locationInfo = post.locationInfo else {
                print("Location info is nil for post: \(post)")
                continue
            }

            print("Processing post: \(post)")

            // Use geocoding to convert the address to coordinates
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(locationInfo) { (placemarks, error) in
                if let error = error {
                    print("Geocoding error: \(error.localizedDescription)")
                    return
                }

                if let firstPlacemark = placemarks?.first {
                    print("Geocoding successful. Placemark: \(firstPlacemark)")

                    // Create an annotation and set its coordinate and title
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = firstPlacemark.location?.coordinate ?? CLLocationCoordinate2D()
                    annotation.title = "Missing Pet"

                    // Add the annotation to the map on the main thread
                    DispatchQueue.main.async {
                        self.mapView.addAnnotation(annotation)
                        print("Annotation added for post: \(post)")
                    }
                }
            }
        }
    }
}
