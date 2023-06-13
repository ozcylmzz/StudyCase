//
//  PeopleListRouter.swift
//  ScorpStudyCase
//
//  Created by özcan yılmaz on 13.06.2023.
//

import UIKit

class PeopleListRouter {
    weak var viewController: UIViewController?
    
    static func createModule() -> UIViewController {
        let view = PeopleListViewController()
        let interactor = PeopleListInteractor(dataSource: DataSource())
        let router = PeopleListRouter()
        let presenter = PeopleListPresenter(interactor: interactor)
        
        view.presenter = presenter
        presenter.view = view
        router.viewController = view
        interactor.delegate = presenter
        
        return view
    }
}
