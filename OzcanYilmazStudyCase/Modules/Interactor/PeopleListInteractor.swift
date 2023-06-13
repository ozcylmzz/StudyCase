//
//  PeopleListInteractor.swift
//  ScorpStudyCase
//
//  Created by özcan yılmaz on 13.06.2023.
//

import Foundation

protocol PeopleListInteractorProtocol {
    func fetchPeople()
    func fetchNextPage()
    
    var delegate: PeopleListInteractorDelegate? { get set }
}

protocol PeopleListInteractorDelegate: AnyObject {
    func didFetchPeople(people: [Person], hasNextPage: Bool)
    func failedToFetchPeople(withError error: FetchError)
}

class PeopleListInteractor: PeopleListInteractorProtocol {
    private let dataSource: DataSourceProtocol
    private var nextPage: String?
    private var people: [Person] = []
    weak var delegate: PeopleListInteractorDelegate?
    
    init(dataSource: DataSourceProtocol) {
        self.dataSource = dataSource
    }
    
    func fetchPeople() {
        nextPage = nil
        fetchPeopleData()
    }
    
    func fetchNextPage() {
        guard nextPage != nil else { return }
        fetchPeopleData()
    }
    
    private func fetchPeopleData() {
        dataSource.fetch(next: nextPage) { [weak self] response, error in
            guard let self = self else { return }
            
            if let response = response {
                self.nextPage = response.next
                let newPeople = response.people.filter { person in
                    !self.people.contains { $0.id == person.id }
                }
                self.people.append(contentsOf: newPeople)
                
                self.delegate?.didFetchPeople(people: self.people, hasNextPage: response.next != nil)
            } else if let error = error {
                self.delegate?.failedToFetchPeople(withError: error)
            }
        }
    }
}
