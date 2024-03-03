//
//  PetCell.swift
//  PawsAndFound
//
//  Created by Crissy on 11/11/23.
//

import UIKit
import ParseSwift
import Alamofire


class PetCell: UITableViewCell {

    var imageDataRequest: DataRequest?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var petNameLabel: UILabel!
    
    @IBOutlet weak var petBreedLabel: UILabel!
    @IBOutlet weak var petImageView: UIImageView!
    
    
    func configure(with pet: Pet){
        petNameLabel.text = pet.petName
        petBreedLabel.text = pet.petBreed
        //petDescriptionLabel.text = pet.petDesc

        // Image
        if let petImageView = pet.petImageFile,
           let imageUrl = petImageView.url {
            
            // Use AlamofireImage helper to fetch remote image from URL
            imageDataRequest = AF.request(imageUrl).responseImage { [weak self] response in
                switch response.result {
                case .success(let image):
                    // Set image view image with fetched image
                    self?.petImageView.image = image
                case .failure(let error):
                    print("❌ Error fetching image: \(error.localizedDescription)")
                    break
                }
            }
        }
    }
}
