//
//  PhotoGalleyViewController.swift
//  AuthorizationForm
//
//  Created by Александр Меренков on 4/10/22.
//

import UIKit
import SDWebImage
import Photos


final class PhotoGalleyViewController: UIViewController {

//    MARK: - Outlet
    
    @IBOutlet weak var photoCollection: UICollectionView!
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var downloadButton: UIButton!
    
    //    MARK: - Properties
    
    private let token: String
    private var imageMeta = [PhotoMetadata]()
    private var largeImageArray: [UIImage] = []
    
    var assetCollection: PHAssetCollection!
    
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

        let nib = UINib(nibName: PhotoCell.reuseIdentifire, bundle: nil)
        photoCollection.register(nib, forCellWithReuseIdentifier: PhotoCell.reuseIdentifire)
        photoCollection.dataSource = self
        photoCollection.delegate = self
        photoCollection.backgroundColor = .white
        
        view.backgroundColor = .white
    }
    
//    MARK: - Helpers
    
    private func loadPhoto(_ token: String) {
        NetworkService.shared.load(token: token) { result in
            for item in result.response.items {
                guard let iUrl = URL(string: item.sizes[2].url) else { continue }
                guard let largeUrl = URL(string: item.sizes[5].url) else { continue }
                let imageMeta = PhotoMetadata(url: iUrl, date: item.date, urlLargeSize: largeUrl)
                self.imageMeta.append(imageMeta)
            }
            self.photoCollection.reloadData()
            self.imageArray()
        }
    }
    
    private func imageArray() {
        DispatchQueue.global().async {
            for i in 0..<self.imageMeta.count {
                if let data = try? Data(contentsOf: self.imageMeta[i].urlLargeSize) {
                    if let image = UIImage(data: data) {
                        self.largeImageArray.append(image)
                        
                    }
                }
            }
            DispatchQueue.main.async {
                self.showAlertWith(title: "Загрузка", message: "Загрузка завершена")
            }
        }
    }
    
    private func fetchAssetCollectionForAlbum() -> PHAssetCollection? {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", "NewAlbum")
        let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)

        if let _ : AnyObject = collection.firstObject {
            return collection.firstObject
        }
        return nil
    }
    
    private func save(_ image: UIImage, completion: @escaping ((Bool, Error?) -> ())) {
        PHPhotoLibrary.shared().performChanges({
            let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
            let assetPlaceHolder = assetChangeRequest.placeholderForCreatedAsset
            let albumChangeRequest = PHAssetCollectionChangeRequest(for: self.assetCollection)
            let enumeration: NSArray = [assetPlaceHolder!]
            albumChangeRequest!.addAssets(enumeration)

        }, completionHandler: { result, error in
            completion(result, error)
        })
    }
    
    private func showAlertWith(title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
//    MARK: - Actions
    
    @IBAction func download(_ sender: Any) {
        PHPhotoLibrary.requestAuthorization { status in
        }
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: "NewAlbum")
        }) { success, error in
            if !success { print("Error creating album: \(String(describing: error)).")}
        }
        
        if let assetCollection = fetchAssetCollectionForAlbum() {
            self.assetCollection = assetCollection
        }
        
        for i in 0..<largeImageArray.count {
            save(largeImageArray[i]) { result, error in
            }
        }
        
        showAlertWith(title: "Сохранение", message: "Сохранение фотографий завершено")
    }
    
    @IBAction func exitButton(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.token)
        navigationController?.popToRootViewController(animated: true)
    }
}

//  MARK: - Extensions

extension PhotoGalleyViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageMeta.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = photoCollection.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseIdentifire, for: indexPath) as? PhotoCell else { return UICollectionViewCell() }
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
