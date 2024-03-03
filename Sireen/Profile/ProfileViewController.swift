//
//  ProfileViewController.swift
//  PawsAndFound
//
//  Created by Jose Baez on 11/11/23.
//

import UIKit
import ParseSwift
import Alamofire
import PhotosUI

class ProfileViewController: UIViewController {
    
    var imageDataRequest: DataRequest?
    private var pickedImage: UIImage?
    
    @IBOutlet weak var tableView: UITableView!
    
    private let refreshControl = UIRefreshControl()

    private var pets = [Pet]() {
        didSet {
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        profileName.text = User.current?.username
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        queryPosts()
    }
    
    private func queryPosts(){
        // only get pets for current user
        let pointer = try! User.current?.toPointer()
        let constraint: QueryConstraint = "user" == pointer
        let query = Pet.query(constraint).include("petName").include("petImageFile").include("userImageFile").include("user")
        query.find{ [weak self] result in
            switch result {
            case .success(let pets):
                self?.pets = pets
            case .failure(let error):
                self?.showAlert(description: error.localizedDescription)
            }
        }
    }
    
    
    @IBAction func onPickedImageTapped(_ sender: Any) {
        // Create a configuration object
        var config = PHPickerConfiguration()
        // Set the filter to only show images as options (i.e. no videos, etc.).
        config.filter = .images
        // Request the original file format. Fastest method as it avoids transcoding.
        config.preferredAssetRepresentationMode = .current
        // Only allow 1 image to be selected at a time.
        config.selectionLimit = 1

        // Instantiate a picker, passing in the configuration.
        let picker = PHPickerViewController(configuration: config)

        // Set the picker delegate so we can receive whatever image the user picks.
        picker.delegate = self

        // Present the picker
        present(picker, animated: true)
        //--------------------------------------
        
    }
    
    
    @IBAction func onSaveTapped(_ sender: Any) {
        // Unwrap optional pickedImage
        guard let image = pickedImage,
              // Create and compress image data (jpeg) from UIImage
              let imageData = image.jpegData(compressionQuality: 0.1)
        else {
            return
        }

        // Create a Parse File by providing a name and passing in the image data
        let imageFile = ParseFile(name: "image.jpg", data: imageData)

        // Create Post object
        var pet = Pet()

        // Set properties
        pet.userImageFile = imageFile
        // Set the user as the current user
        pet.user = User.current
        // Save object in background (async)
        pet.save { [weak self] result in

            // Switch to the main thread for any UI updates
            DispatchQueue.main.async {
                switch result {
                case .success(let pet):
                    print("✅ image Saved! \(pet)")

                    // Return to previous view controller
                    self?.configure(with: pet)
                    self?.navigationController?.popViewController(animated: true)

                case .failure(let error):
                    self?.showAlert(description: error.localizedDescription)
                }
            }
        }
    }
    
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    
    func configure(with pet: Pet){
       
        if let currentUser = User.current, let petUser = pet.user, petUser == currentUser {
            // Image
            print("Configuring for current user")
            if let profilePicture = pet.userImageFile,
               let imageUrl = profilePicture.url {
                
                print("Image URL: \(imageUrl)")
                
                // Use AlamofireImage helper to fetch remote image from URL
                imageDataRequest = AF.request(imageUrl).responseImage { [weak self] response in
                    switch response.result {
                    case .success(let image):
                        // Set image view image with fetched image
                        if self?.profilePicture.image == nil{
                            self?.profilePicture.image = image
                            print("Image set successfully")
                        }
                        
                    case .failure(let error):
                        print("❌ Error fetching image!!!!!!!!!!!: \(error.localizedDescription)")
                        break
                    }
                }
            }else{
                print("Pet has no userImageFile")
                print("pet.userImageFile: \(pet.userImageFile)")
                print("pet: \(pet)")
            }
        }else{
            print("Configuring for a different user")
        }
        if pet.userImageFile == nil {
                print("Pet has no userImageFile")
            }
    }
    
}
extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pets.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PetCell", for: indexPath) as? PetCell else {
            return UITableViewCell()
        }
        cell.configure(with: pets[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.0 // Set a minimum row height
    }
}

extension ProfileViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        // Make sure we have a non-nil item provider
        guard let provider = results.first?.itemProvider,
              // Make sure the provider can load a UIImage
              provider.canLoadObject(ofClass: UIImage.self) else { return }
        
        // Load a UIImage from the provider
        provider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
            
            // Make sure we can cast the returned object to a UIImage
            guard let image = object as? UIImage else {
                
                // ❌ Unable to cast to UIImage
                self?.showAlert()
                return
            }
          

                  // UI updates (like setting image on image view) should be done on main thread
                  DispatchQueue.main.async {

                     // Set image on preview image view
                     self?.profilePicture.image = image

                     // Set image to use when saving post
                     self?.pickedImage = image
                  }
               }
            
        }
        
    }

extension ProfileViewController: UITableViewDelegate { }

