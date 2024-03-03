//
//  CommentCell.swift
//  PawsAndFound
//
//  Created by Ernesto Alva on 11/13/23.
//

import UIKit
import Alamofire
import AlamofireImage

class CommentCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userCommentLabel: UILabel!
    
    func configure(with comment: Comment) {
        // Configure Post Cell
        
        if let user = comment.user {
            usernameLabel.text = user.username
        }
        userCommentLabel.text = comment.comment
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

//Thread 1: "[<PawsAndFound.CommentCell 0x7fed0d8288e0> setValue:forUndefinedKey:]: this class is not key value coding-compliant for the key userComment."
