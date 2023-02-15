//
//  MeowFactsRouter.swift
//  MeowFacts
//
//  Created by Qi Zhan on 2/13/23.
//

import Foundation
import UIKit

class MeowFactsRouter: MeowFactsPresenterToRouterProtocol {
    
    static func createModule() -> UIViewController {
        let view = MeowFactsViewController()
        let presenter: MeowFactsInteractorToPresenterProtocol & MeowFactsViewToPresenterProtocol = MeowFactsPresenter()
        let networkService = KittenNetworkService()
        let interactor: MeowFactsPresenterToInteractorProtocol = MeowFactsInteractor(kittenNetworkService: networkService)
        let router: MeowFactsPresenterToRouterProtocol = MeowFactsRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
    }
    
    static var mainstoryboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
}
