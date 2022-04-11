//
//  PhotoGalleyViewController.swift
//  AuthorizationForm
//
//  Created by Александр Меренков on 4/10/22.
//

import UIKit

class PhotoGalleyViewController: UIViewController {

//    MARK: - Outlet
    
    @IBOutlet weak var photoCollection: UICollectionView!
    @IBOutlet weak var exitButton: UIButton!
    
//    MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "PhotoCell", bundle: nil)
        photoCollection.register(nib, forCellWithReuseIdentifier: "PhotoCell")
        photoCollection.dataSource = self
        photoCollection.delegate = self
    }
    
}

//  MARK: - Extensions

extension PhotoGalleyViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = photoCollection.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else { return UICollectionViewCell() }
        
        return cell
    }
    
    
}

extension PhotoGalleyViewController: UICollectionViewDelegate {
    
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
