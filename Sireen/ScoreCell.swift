//
//  ScoreCell.swift
//  Sireen
//
//  Created by Allan Prieb on 3/11/24.
//

import UIKit

class ScoreCell: UITableViewCell {


    @IBOutlet weak var userPositionLabel: UILabel!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userScoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with score: Score) {
        userPositionLabel.text = score.userPosition
        userNameLabel.text = score.userName
        userScoreLabel.text = score.userScore
        userProfileImage.image = score.userProfile
    }


}
