//
//  CommentsViewController.swift
//  PawsAndFound
//
//  Created by Ernesto Alva on 11/13/23.
//

import UIKit
import ParseSwift

class CommentsViewController: UIViewController {
    
    @IBOutlet weak var commentTableView: UITableView!
    private let commentsRefreshControl = UIRefreshControl()
    private var comments = [Comment]() {
        didSet {
            DispatchQueue.main.async{
                // Reload table view data any time the posts variable gets updated.
                self.commentTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        commentTableView.delegate = self
        commentTableView.dataSource = self
        commentTableView.allowsSelection = false

        commentTableView.refreshControl = commentsRefreshControl
        //commentsRefreshControl.addTarget(self, action: #selector(onPullToRefresh), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        queryComments()
    }
    
//    let query = Pet.query().include("petName").include("petImageFile").include("userImageFile")
//    // Custom parseObjects
//    var user: User?
//    var petName: String?
//    var petBreed: String?
//    //var petDesc: String?
//    var petImageFile: ParseFile?
//    var userImageFile: ParseFile?
    

    private func queryComments(completion: (() -> Void)? = nil) {
//        let yesterdayDate = Calendar.current.date(byAdding: .day, value: (-1), to: Date())!
        // only get pets for current user
//        let pointer = try! User.current?.toPointer()
//        let constraint: QueryConstraint = "user" == pointer
        let query = Comment.query().include("comment").include("user") // "constraint"
        
        //let query = Comment.query()
        //    .include("user")
//            .order([.descending("createdAt")])
//            .where("createdAt" >= yesterdayDate) // <- Only include results created yesterday onwards
//            .limit(10) // <- Limit max number of returned posts to 10

        // Find and return posts that meet query criteria (async)
        query.find { [weak self] result in
            switch result {
            case .success(let comments):
                // Update the local posts property with fetched posts
                self?.comments = comments
            case .failure(let error):
                self?.showAlert(description: error.localizedDescription)
            }

            // Call the completion handler (regardless of error or success, this will signal the query finished)
            // This is used to tell the pull-to-refresh control to stop refresshing
            completion?()
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

extension CommentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        comments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as? CommentCell else {
            return UITableViewCell()
        }
        cell.configure(with: comments[indexPath.row])
        return cell
    }
}

extension CommentsViewController: UITableViewDelegate { }
