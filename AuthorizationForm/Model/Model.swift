//
//  Model.swift
//  AuthorizationForm
//
//  Created by Александр Меренков on 4/9/22.
//

struct JsonResponse: Decodable {
    let response: ResponseItems
}

struct ResponseItems: Decodable {
    let count: Int
    let items: [PhotoInformations]
}

struct PhotoInformations: Decodable {
    let album_id: Int
    let date: Int
    let sizes: [Photo]
}

struct Photo: Decodable {
    let url: String
}
