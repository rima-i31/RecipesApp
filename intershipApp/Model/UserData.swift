//
//  UserData.swift
//  intershipApp
//
//  Created by Rima Mihova on 03.08.2024.
//

import Foundation

struct UserData: Codable{
    var firstName: String?
    var lastName: String?
    var birthDay: String?
    var phoneNumber: String?
    var password: String?
    var passwordVerification: String?
    var id: String?
    var userRecipes: [RecipeModel]?
    
    func saveToDefaults() {
        if let encoded = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(encoded, forKey: "UserData")
        }
    }
    
    static func loadFromDefaults() -> UserData? {
        if let savedUserData = UserDefaults.standard.object(forKey: "UserData") as? Data {
            if let loadedUserData = try? JSONDecoder().decode(UserData.self, from: savedUserData) {
                return loadedUserData
            }
        }
        return nil
    }
}

