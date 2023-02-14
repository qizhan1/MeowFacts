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
        // TODO: check if meowFact? is empty, if it is, will crash
        return (interactor?.meowFact?.data[0], interactor?.kittenImage)
    }
    
    
}

extension MeowFactsPresenter: MeowFactsInteractorToPresenterProtocol {
    
    func KittenImageDidFetch() {
        
    }
    
    func KittenImageFetchFailed() {
        
    }
    
    func MeowFactsDidFetch() {
        DispatchQueue.main.async { [weak self] in
            self?.view?.showKitten()
        }
        
    }
    
    func MeowFactsFetchFailed() {
        DispatchQueue.main.async { [weak self] in
            self?.view?.showError()
        }
        
    }
    

    
    
}
