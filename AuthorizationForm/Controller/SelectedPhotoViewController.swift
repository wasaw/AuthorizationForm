//
//  SelectedPhotoViewController.swift
//  AuthorizationForm
//
//  Created by Александр Меренков on 4/11/22.
//

import UIKit
import SDWebImage

final class SelectedPhotoViewController: UIViewController {
    
//    MARK: - Outlets

    @IBOutlet weak var navigation: UINavigationItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bottomCollectionView: UICollectionView!
    
//    MARK: - Properties
    
    private let selectedImage: PhotoMetadata
    private let imageArray: [PhotoMetadata]
    
//    MARK: - Lifecycle
    
    init(image: PhotoMetadata, images array: [PhotoMetadata]) {
        self.selectedImage = image
        self.imageArray = array
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let date = Date(timeIntervalSince1970: selectedImage.date)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd LLLL yyyy"
        navigation.title = formatter.string(from: date)
        
        imageView.sd_setImage(with: selectedImage.urlLargeSize)
        
        let nib = UINib(nibName: "PhotoCell", bundle: nil)
        bottomCollectionView.register(nib, forCellWithReuseIdentifier: "PhotoCell")
        bottomCollectionView.delegate = self
        bottomCollectionView.dataSource = self
        
        view.backgroundColor = .white
    }
    
//    MARK: - Actions
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: false)
    }
    @IBAction func shareButton(_ sender: Any) {
        guard let image = imageView.image else { return }
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityVC.modalPresentationStyle = .popover
        activityVC.completionWithItemsHandler = { activityType, saved, _, _ in
            if saved && activityType?.rawValue == "com.apple.UIKit.activity.SaveToCameraRoll" {
                let alert = UIAlertController(title: "Сохранение", message: "Фотография успешно сохранена.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Окей", style: .default))
                self.present(alert, animated: true)
            }
        }
        self.present(activityVC, animated: true)
    }
}

//  MARK: - Extensions

extension SelectedPhotoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if imageArray.count > indexPath.row {
            imageView.sd_setImage(with: imageArray[indexPath.row].urlLargeSize)
        }
    }
}

extension SelectedPhotoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = bottomCollectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else { return UICollectionViewCell()  }
        if imageArray.count > indexPath.row {
            cell.imageView.sd_setImage(with: imageArray[indexPath.row].url)
        }
        return cell
    }
}

extension SelectedPhotoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 56, height: 56)
    }
}
