//
//  PeopleListPresenter.swift
//  ScorpStudyCase
//
//  Created by özcan yılmaz on 13.06.2023.
//

import Foundation

protocol PeopleListPresenterProtocol {
    func viewDidLoad()
    func refreshList()
    func loadNextPage()
    func setView(_ view: PeopleListViewProtocol)
}

protocol PeopleListViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func showPeople(_ people: [Person])
    func showError(_ error: String)
    func showEmptyListMessage()
}

class PeopleListPresenter: PeopleListPresenterProtocol, PeopleListInteractorDelegate {
    private var interactor: PeopleListInteractorProtocol
    private weak var view: PeopleListViewProtocol?
    private var people: [Person] = []
    
    init(interactor: PeopleListInteractorProtocol) {
        self.interactor = interactor
        self.interactor.delegate = self
    }
    
    func setView(_ view: PeopleListViewProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        view?.showLoading()
        interactor.fetchPeople()
    }
    
    func refreshList() {
        interactor.fetchPeople()
    }
    
    func loadNextPage() {
        interactor.fetchNextPage()
    }
    
    func didFetchPeople(people: [Person], hasNextPage: Bool) {
        self.people = people
        view?.hideLoading()
        
        if people.isEmpty {
            view?.showEmptyListMessage()
        } else {
            view?.showPeople(people)
        }
    }
    
    func failedToFetchPeople(withError error: FetchError) {
        view?.hideLoading()
        view?.showError(error.errorDescription)
    }
}
