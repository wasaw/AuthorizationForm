//
//  Extensions.swift
//  AuthorizationForm
//
//  Created by Александр Меренков on 4/8/22.
//

extension String {
    func substring(from left: String, to right: String) -> String {
        if let match = range(of: "(?<=\(left))[^\(right)]+", options: .regularExpression) {
            return String(self[match])
        }
        return ""
    }
}
