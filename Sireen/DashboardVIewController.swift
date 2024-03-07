//
//  DashboardVIewController.swift
//  Sireen
//
//  Created by Allan Prieb on 3/4/24.
//

import UIKit

class DashboardViewController: UIViewController {

    // MARK: Models
    
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var reportView: UIView!
    @IBOutlet weak var scoreView: UIView!
    @IBOutlet weak var learnView: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func onLogOutTapped(_ sender: Any) {
        showConfirmLogoutAlert()
    }
    
    private func showConfirmLogoutAlert() {
        let alertController = UIAlertController(title: "Log out of \(User.current?.username ?? "current account")?", message: nil, preferredStyle: .alert)
        let logOutAction = UIAlertAction(title: "Log out", style: .destructive) { _ in
            NotificationCenter.default.post(name: Notification.Name("logout"), object: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(logOutAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
}

