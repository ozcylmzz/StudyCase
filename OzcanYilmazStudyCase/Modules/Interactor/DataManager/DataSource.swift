//
//  DataSource.swift
//  ScorpStudyCase
//
//  Created by özcan yılmaz on 13.06.2023.
//

import Foundation

protocol DataSourceProtocol {
    func fetch(next: String?, _ completionHandler: @escaping FetchCompletionHandler)
}

public typealias FetchCompletionHandler = (FetchResponse?, FetchError?) -> ()

class DataSource: DataSourceProtocol {
    
    private struct Constants {
        static let peopleCountRange: ClosedRange<Int> = 100...200
        static let fetchCountRange: ClosedRange<Int> = 5...20
        static let lowWaitTimeRange: ClosedRange<Double> = 0.0...0.3
        static let highWaitTimeRange: ClosedRange<Double> = 1.0...2.0
        static let errorProbability = 0.05
        static let backendBugTriggerProbability = 0.05
        static let emptyFirstResultsProbability = 0.1
    }

    private  var people: [Person] = []
    private  let operationsQueue = DispatchQueue.init(
        label: "data_source_operations_queue",
        qos: .userInitiated,
        attributes: [],
        autoreleaseFrequency: .inherit,
        target: nil
    )
    
    func fetch(next: String?, _ completionHandler: @escaping FetchCompletionHandler) {
        DispatchQueue.global().async {
            self.operationsQueue.sync {
                self.initializeDataIfNecessary()
                let (response, error, waitTime) = self.processRequest(next)
                DispatchQueue.main.asyncAfter(deadline: .now() + waitTime) {
                    completionHandler(response, error)
                }
            }
        }
    }
    
    private func initializeDataIfNecessary() {
        guard people.isEmpty else { return }

        var newPeople: [Person] = []
        let peopleCount: Int = RandomUtils.generateRandomInt(inClosedRange: Constants.peopleCountRange)
        for index in 0..<peopleCount {
            let person = Person(id: index + 1, fullName: PeopleGen.generateRandomFullName())
            newPeople.append(person)
        }

        people = newPeople.shuffled()
    }

    private func processRequest(_ next: String?) -> (FetchResponse?, FetchError?, Double) {
        var error: FetchError? = nil
        var response: FetchResponse? = nil
        var waitTime: Double!

        if RandomUtils.roll(forProbabilityGTZero: Constants.errorProbability) {
            waitTime = RandomUtils.generateRandomDouble(inClosedRange: Constants.lowWaitTimeRange)
            error = FetchError(description: "Internal Server Error")
        } else {
            waitTime = RandomUtils.generateRandomDouble(inClosedRange: Constants.highWaitTimeRange)
            let fetchCount = RandomUtils.generateRandomInt(inClosedRange: Constants.fetchCountRange)
            let peopleCount = people.count

            if let next = next, (Int(next) == nil || Int(next)! < 0) {
                error = FetchError(description: "Parameter error")
            } else {
                let endIndex: Int = min(peopleCount, fetchCount + (next == nil ? 0 : (Int(next!) ?? 0)))
                let beginIndex: Int = next == nil ? 0 : min(Int(next!)!, endIndex)
                var responseNext: String? = endIndex >= peopleCount ? nil : String(endIndex)

                var fetchedPeople: [Person] = Array(people[beginIndex..<endIndex])
                if beginIndex > 0 && RandomUtils.roll(forProbabilityGTZero: Constants.backendBugTriggerProbability) {
                    fetchedPeople.insert(people[beginIndex - 1], at: 0)
                } else if beginIndex == 0 && RandomUtils.roll(forProbabilityGTZero: Constants.emptyFirstResultsProbability) {
                    fetchedPeople = []
                    responseNext = nil
                }
                response = FetchResponse(people: fetchedPeople, next: responseNext)
            }
        }

        return (response, error, waitTime)
    }
}
