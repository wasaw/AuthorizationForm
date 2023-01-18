//
//  PhotoCell.swift
//  AuthorizationForm
//
//  Created by Александр Меренков on 4/11/22.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    static let reuseIdentifire = "PhotoCell"

//    MARK: - Outlet
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
