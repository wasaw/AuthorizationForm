//
//  Model.swift
//  AuthorizationForm
//
//  Created by Александр Меренков on 4/9/22.
//

import Foundation

struct JsonResponse: Decodable {
    let response: ResponseItems
}

struct ResponseItems: Decodable {
    let count: Int
    let items: [PhotoInformations]
}

struct PhotoInformations: Decodable {
    let album_id: Int
    let date: TimeInterval
    let sizes: [Photo]
}

struct Photo: Decodable {
    let url: String
}

struct PhotoMetadata {
    let url: URL
    let date: TimeInterval
    let urlLargeSize: URL
}
