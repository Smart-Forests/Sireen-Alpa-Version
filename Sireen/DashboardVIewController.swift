//
//  DashboardVIewController.swift
//  Sireen
//
//  Created by Allan Prieb on 3/4/24.
//

import UIKit

class DashboardViewController: UIViewController {

    // MARK: Models

    // Create individual Dinosaurs using Dinosaur model
    
    // Array for storing Dinosaurs

    override func viewDidLoad() {
        super.viewDidLoad()

        // Store Dinosaur models

        
    }

    // Handler for did tap dinosaur
    @IBAction func didTapDinosaur(_ sender: UITapGestureRecognizer) {
        if let tappedView = sender.view {
            performSegue(withIdentifier: "detailSegue", sender: tappedView)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "detailSegue",
            let tappedView = sender as? UIView,
            let detailViewController = segue.destination as? DetailViewController {

            if tappedView.tag == 0 {
                detailViewController.dinosaur = dinosaurs[0]
            } else if tappedView.tag == 1 {
                detailViewController.dinosaur = dinosaurs[1]
            } else if tappedView.tag == 2 {
                detailViewController.dinosaur = dinosaurs[2]
            } else if tappedView.tag == 3 {
                detailViewController.dinosaur = dinosaurs[3]
            } else {
                print("no Dinosaur was tapped, please check your selection.")
            }
        }
    }
}

