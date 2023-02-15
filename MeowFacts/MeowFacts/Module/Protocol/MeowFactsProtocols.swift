//
//  MeowFactsProtocols.swift
//  MeowFacts
//
//  Created by Qi Zhan on 2/13/23.
//

import Foundation
import UIKit

protocol MeowFactsPresenterToViewProtocol: AnyObject {
    func showKitten(image: UIImage?, with fact: String?)
    func showError(message: String?)
}

protocol MeowFactsInteractorToPresenterProtocol: AnyObject {
    func meowFactsDidFetch()
    func meowFactsFetchDidFail(with errorMessage: String?)
}

protocol MeowFactsPresenterToInteractorProtocol: AnyObject {
    var presenter: MeowFactsInteractorToPresenterProtocol? { get set }
    var meowFact: MeowFact? { get } // - TODO
    var kittenImage: UIImage? { get }
    
    func fetchKitten()
}

protocol MeowFactsViewToPresenterProtocol: AnyObject {
    var view: MeowFactsPresenterToViewProtocol? { get set }
    var interactor: MeowFactsPresenterToInteractorProtocol? { get set }
    var router: MeowFactsPresenterToRouterProtocol? { get set }
    
    func updateView()
    func getMeowFacts() -> (fact: String?, image: UIImage?)
}

protocol MeowFactsPresenterToRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
}

protocol KittenNetworkServiceProtocol: AnyObject {
    func fetchMeowFact() async throws -> MeowFact
    func fetchKittenImage() async throws -> UIImage?
}
