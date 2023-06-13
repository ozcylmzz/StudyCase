//
//  PeopleGen.swift
//  ScorpStudyCase
//
//  Created by özcan yılmaz on 13.06.2023.
//

import Foundation

class PeopleGen {
    private static let firstNames = [
        "Fatma", "Mehmet", "Ayşe", "Mustafa", "Emine", "Ahmet", "Hatice", "Ali", "Zeynep",
        "Hüseyin", "Elif", "Hasan", "İbrahim", "Can", "Murat", "Özlem"
    ]
    
    private static let lastNames = [
        "Yılmaz", "Şahin", "Demir", "Çelik", "Şahin", "Öztürk", "Kılıç", "Arslan", "Taş", "Aksoy",
        "Barış", "Dalkıran"
    ]
    
    static func generateRandomFullName() -> String {
        let firstNamesCount = firstNames.count
        let lastNamesCount = lastNames.count
        
        let firstName = firstNames[RandomUtils.generateRandomInt(inRange: 0..<firstNamesCount)]
        let lastName = lastNames[RandomUtils.generateRandomInt(inRange: 0..<lastNamesCount)]
        
        return "\(firstName) \(lastName)"
    }
}
