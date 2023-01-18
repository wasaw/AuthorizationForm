//
//  AuthorizationViewController.swift
//  AuthorizationForm
//
//  Created by Александр Меренков on 4/6/22.
//

import UIKit
import WebKit

final class AuthorizationViewController: UIViewController {
    
//  MARK: - Outlets
    
    @IBOutlet weak var authorizationNavigationBar: UINavigationBar!
    @IBOutlet weak var authorizationLabel: UILabel!
    
//    MARK: - Properties
    
    private let webView = WKWebView()
    
//    MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLogIn()

        view.addSubview(webView)
        
    }
    
//    MARK: - Helpers
    
    private func checkLogIn() {
        let token = UserDefaults.standard.object(forKey: UserDefaultsKeys.token) as? String ?? ""
        
        if !token.isEmpty {
            navigationController?.pushViewController(PhotoGalleyViewController(token: token), animated: false)
        }
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
