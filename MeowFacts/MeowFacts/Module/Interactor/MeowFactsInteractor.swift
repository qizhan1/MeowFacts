//
//  MeowFactsInteractor.swift
//  MeowFacts
//
//  Created by Qi Zhan on 2/13/23.
//

import Foundation
import UIKit

class MeowFactsInteractor: MeowFactsPresenterToInteractorProtocol {
    
    weak var presenter: MeowFactsInteractorToPresenterProtocol?
    
    var meowFact: MeowFact?
    var kittenImage: UIImage?
    
    func fetchKitten()   {
        Task.detached { [weak self] in
            do {
                self?.meowFact = try await NetworkService().fetchMeowFact()
                self?.kittenImage = try await NetworkService().fetchKittenImage()
                self?.presenter?.MeowFactsDidFetch()
            } catch {
                self?.presenter?.MeowFactsFetchFailed()
            }
        }
         
    }
    
}
