//
//  DatabaseService.swift
//  AuthorizationForm
//
//  Created by Александр Меренков on 4/12/22.
//

import RealmSwift

class DatabaseService {
    static let shared = DatabaseService()
    
//    MARK: - Properties
    
    let realm = try? Realm()
    
//    MARK: - Helpers
    
    func saveToken(_ token: Token) {
        guard let realm = realm else { return }
        DispatchQueue.main.async {
            try? realm.write({
                realm.add(token)
            })
        }
    }
    
    func loadToken() -> String {
        guard let realm = realm else { return "" }
        let answer = realm.objects(Token.self)
        if answer.count > 0 {
            return answer[0].token
        }
        return ""
    }
    
    func deleteToken() {
        guard let realm = realm else { return }
        let result = realm.objects(Token.self)
        DispatchQueue.main.async {
            try? realm.write({
                realm.delete(result)
            })
        }
    }
}
