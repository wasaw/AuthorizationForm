//
//  NetworkService.swift
//  AuthorizationForm
//
//  Created by Александр Меренков on 4/8/22.
//

import Alamofire

struct NetworkService {
    static let shared = NetworkService()
    
//    MARK: - Properties
    
    private let startUrl = "https://api.vk.com/method/"
    private let method = "photos.get?owner_id=-128666765&album_id=266276915&offset=0&count=100"
    private let middleUrl = "&access_token="
    private let endUrl = "&v=5.131"
    
//    MARK: - Helpers
    
    func load(token: String, completion: @escaping((JsonResponse) -> Void)) {
        let requestUrl = startUrl + method + middleUrl + token + endUrl

        AF.request(requestUrl).responseDecodable(of: JsonResponse.self) { response in
            
            guard let result = response.value else { return }
                completion(result)
        }
    }
}
