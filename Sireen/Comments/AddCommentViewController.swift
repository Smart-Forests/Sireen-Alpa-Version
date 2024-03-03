//
//  AddCommentViewController.swift
//  PawsAndFound
//
//  Created by Ernesto Alva on 11/13/23.
//

import UIKit
import PhotosUI
import ParseSwift

class AddCommentViewController: UIViewController {

    @IBOutlet weak var commentTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func onCommentTapped(_ sender: Any) {
        // Dismiss Keyboard
        view.endEditing(true)

        // Create Comment object
        var comment = Comment()

        // Set properties
        //comment.imageFile = imageFile
        comment.comment = commentTextField.text

        // Set the user as the current user
        comment.user = User.current

        // Save post (async)
        comment.save { [weak self] result in

            // Switch to the main thread for any UI updates
            DispatchQueue.main.async {
                switch result {
                case .success(let comment):
                    print("✅ Comment Saved! \(comment)")

                    // Get the current user
                    if let currentUser = User.current {

                        // Save updates to the user (async)
                        currentUser.save { [weak self] result in
                            switch result {
                            case .success(let user):
                                print("✅ User Saved! \(user)")

                                // Switch to the main thread for any UI updates
                                DispatchQueue.main.async {
                                    // Return to previous view controller
                                    self?.navigationController?.popViewController(animated: true)
                                }

                            case .failure(let error):
                                self?.showAlert(description: error.localizedDescription)
                            }
                        }
                    }

                case .failure(let error):
                    self?.showAlert(description: error.localizedDescription)
                }
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
