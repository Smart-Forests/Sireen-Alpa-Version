//
//  ScoreboardViewController.swift
//  Sireen
//
//  Created by Allan Prieb on 3/10/24.
//

import UIKit


class ScoreboardViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var scores: [Score] = []

    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        tableView.dataSource = self

        scores = Score.mockScores
        print(scores)
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        // TODO: Deselect any selected table view rows
//
//        // Get the index path for the current selected table view row (if exists)
//        if let indexPath = tableView.indexPathForSelectedRow {
//
//            // Deslect the row at the corresponding index path
//            tableView.deselectRow(at: indexPath, animated: true)
//        }
//    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get a cell with identifier, "TrackCell"
        // the `dequeueReusableCell(withIdentifier:)` method just returns a generic UITableViewCell so it's necessary to cast it to our specific custom cell.
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreCell", for: indexPath) as! ScoreCell

        // Get the track that corresponds to the table view row
        let score = scores[indexPath.row]

        // Configure the cell with it's associated track
        cell.configure(with: score)

        // return the cell for display in the table view
        return cell
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        // TODO: Deselect any selected table view rows
//
//        // Get the index path for the current selected table view row (if exists)
//        if let indexPath = tableView.indexPathForSelectedRow {
//
//            // Deslect the row at the corresponding index path
//            tableView.deselectRow(at: indexPath, animated: true)
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return scores.count
//    }
//    
//  
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    
//        // Get a cell with identifier, "TrackCell"
//        // the `dequeueReusableCell(withIdentifier:)` method just returns a generic UITableViewCell so it's necessary to cast it to our specific custom cell.
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreCell", for: indexPath) as! ScoreCell
//
//        let track = scores[indexPath.row]
//
//        // Configure the cell with it's associated track
//        cell.configure(with: track)
//
//        // return the cell for display in the table view
//        return cell
//        
//    }

    
}
