//
//  AuthorizationViewController.swift
//  AuthorizationForm
//
//  Created by Александр Меренков on 4/6/22.
//

import UIKit
import WebKit

class AuthorizationViewController: UIViewController {
    
//  MARK: - Outlets
    
    @IBOutlet weak var authorizationNavigationBar: UINavigationBar!
    @IBOutlet weak var authorizationLabel: UILabel!
    
//    MARK: - Properties
    
    let webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(webView)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }

//    MARK: - Actions
    
    @IBAction func authorizationButton(_ sender: Any) {
        let vc = WebKitController()
        vc.delagete = self
        vc.modalPresentationStyle = .popover
        present(vc, animated: true, completion: nil)
    }
}

//  MARK: - Extensins

extension AuthorizationViewController: PhotoGalleryDelegate {
    func presentPhotoGallery(token: String) {
        navigationController?.pushViewController(PhotoGalleyViewController(token: token), animated: true)
    }
}
