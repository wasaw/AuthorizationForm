//
//  SelectedPhotoViewController.swift
//  AuthorizationForm
//
//  Created by Александр Меренков on 4/11/22.
//

import UIKit
import SDWebImage

class SelectedPhotoViewController: UIViewController {
    
//    MARK: - Outlets

    @IBOutlet weak var navigation: UINavigationItem!
    @IBOutlet weak var imageView: UIImageView!
    
//    MARK: - Properties
    
    let image: PhotoMetadata
    let imageArray: [PhotoMetadata]
    
//    MARK: - Lifecycle
    
    init(image: PhotoMetadata, images array: [PhotoMetadata]) {
        self.image = image
        self.imageArray = array
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let date = Date(timeIntervalSince1970: image.date)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd LLLL yyyy"
        navigation.title = formatter.string(from: date)
        
        imageView.sd_setImage(with: image.url)
    }
    
//    MARK: - Actions
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func shareButton(_ sender: Any) {
    }
}
