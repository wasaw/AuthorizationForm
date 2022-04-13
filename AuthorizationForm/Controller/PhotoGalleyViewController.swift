//
//  PhotoGalleyViewController.swift
//  AuthorizationForm
//
//  Created by Александр Меренков on 4/10/22.
//

import UIKit
import SDWebImage


class PhotoGalleyViewController: UIViewController {

//    MARK: - Outlet
    
    @IBOutlet weak var photoCollection: UICollectionView!
    @IBOutlet weak var exitButton: UIButton!
    
//    MARK: - Properties
    
    private let token: String
    private var imageMeta = [PhotoMetadata]()
    
//    MARK: - Lifecycle
    
    init(token: String) {
        self.token = token
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadPhoto(token)

        navigationController?.isNavigationBarHidden = true

        let nib = UINib(nibName: "PhotoCell", bundle: nil)
        photoCollection.register(nib, forCellWithReuseIdentifier: "PhotoCell")
        photoCollection.dataSource = self
        photoCollection.delegate = self
    }
    
//    MARK: - Helpers
    
    private func loadPhoto(_ token: String) {
        NetworkService.shared.load(token: token) { result in
            for item in result.response.items {
                guard let iUrl = URL(string: item.sizes[2].url) else { continue }
                let imageMeta = PhotoMetadata(url: iUrl, date: item.date)
                self.imageMeta.append(imageMeta)
            }
            self.photoCollection.reloadData()
        }
    }
    
//    MARK: - Actions
    
    @IBAction func exitButton(_ sender: Any) {
        DatabaseService.shared.deleteToken()
        navigationController?.popToRootViewController(animated: true)
    }
}

//  MARK: - Extensions

extension PhotoGalleyViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageMeta.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = photoCollection.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else { return UICollectionViewCell() }
        if imageMeta.count > indexPath.row {
            cell.imageView.sd_setImage(with: imageMeta[indexPath.row].url)
        }
        return cell
    }
}

extension PhotoGalleyViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigationController?.pushViewController(SelectedPhotoViewController(image: imageMeta[indexPath.row], images: imageMeta), animated: false)
    }
}

extension PhotoGalleyViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side: CGFloat = photoCollection.frame.width / 2 - 1
        return CGSize(width: side, height: side)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
