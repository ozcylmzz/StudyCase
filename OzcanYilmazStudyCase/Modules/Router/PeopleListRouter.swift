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
        let viewController = PeopleListViewController()
        let router = PeopleListRouter()
        
        router.viewController = viewController
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.prefersLargeTitles = true
        
        return navigationController
    }
}
