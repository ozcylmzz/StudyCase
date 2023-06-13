//
//  RandomUtils.swift
//  ScorpStudyCase
//
//  Created by özcan yılmaz on 13.06.2023.
//

import Foundation

class RandomUtils {
    static func generateRandomInt(inClosedRange range: ClosedRange<Int>) -> Int {
        return Int.random(in: range)
    }
    
    static func generateRandomInt(inRange range: Range<Int>) -> Int {
        let lowerBound = range.lowerBound
        let upperBound = range.upperBound - 1
        return generateRandomInt(inClosedRange: lowerBound...upperBound)
    }
    
    static func generateRandomDouble(inClosedRange range: ClosedRange<Double>) -> Double {
        return Double.random(in: range)
    }
    
    static func roll(forProbabilityGTZero probability: Double) -> Bool {
        let random = Double.random(in: 0.0...1.0)
        return random <= probability
    }
}
