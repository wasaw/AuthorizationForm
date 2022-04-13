//
//  WebKitController.swift
//  AuthorizationForm
//
//  Created by Александр Меренков on 4/7/22.
//

import UIKit
import WebKit

protocol PhotoGalleryDelegate: class {
    func presentPhotoGallery(token: String)
}

class WebKitController: UIViewController {
    
//    MARK: - Properties
    
    private let webView = WKWebView()
    
    weak var delagete: PhotoGalleryDelegate?
    
//    MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(webView)
        guard let url = URL(string: "https://oauth.vk.com/authorize?client_id=8129851&redirect_uri=oauth.vk.com/blank.htm&scope=12&display=mobile&response_type=token") else { return }
        webView.frame = view.bounds
        webView.navigationDelegate = self
        webView.load(URLRequest(url: url))
    }
}

//    MARK: - Extensions

extension WebKitController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

        let urlString = (String(describing: webView.url))
        let tokenString = urlString.substring(from: "access_token=", to: "\\&")
        
        if !tokenString.isEmpty {
            let token = Token()
            token.token = tokenString
            DatabaseService.shared.saveToken(token)
            self.dismiss(animated: true) {
                self.delagete?.presentPhotoGallery(token: tokenString)
            }
        }
    }
}
