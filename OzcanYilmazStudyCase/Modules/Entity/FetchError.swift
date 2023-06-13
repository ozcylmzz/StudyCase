//
//  FetchError.swift
//  ScorpStudyCase
//
//  Created by özcan yılmaz on 13.06.2023.
//

import Foundation

public struct FetchError: Error {
    let errorDescription: String
    
    init(description: String) {
        self.errorDescription = description
    }
}
