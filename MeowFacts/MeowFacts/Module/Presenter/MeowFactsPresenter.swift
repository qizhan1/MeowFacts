//
//  MeowFactsPresenter.swift
//  MeowFacts
//
//  Created by Qi Zhan on 2/13/23.
//

import Foundation
import UIKit


class MeowFactsPresenter: MeowFactsViewToPresenterProtocol{
    
    weak var view: MeowFactsPresenterToViewProtocol?
    var interactor: MeowFactsPresenterToInteractorProtocol?
    var router: MeowFactsPresenterToRouterProtocol?
    
    func updateView() {
        interactor?.fetchKitten()
    }
    
    func getMeowFacts() -> (fact: String?, image: UIImage?) {
        return (interactor?.meowFact?.data[0], interactor?.kittenImage)
    }
    
}

extension MeowFactsPresenter: MeowFactsInteractorToPresenterProtocol {
    
    func meowFactsDidFetch() {
        view?.showKitten(image: interactor?.kittenImage,
                         with: interactor?.meowFact?.data[0])
    }
    
    func meowFactsFetchDidFail(with errorMessage: String?) {
        view?.showError(message: errorMessage)
    }
    

    
    
}
