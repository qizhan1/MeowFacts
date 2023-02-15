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
    
    var networkService: KittenNetworkServiceProtocol
    var meowFact: MeowFact?
    var kittenImage: UIImage?
    
    init(kittenNetworkService: KittenNetworkServiceProtocol) {
        networkService = kittenNetworkService
    }
    
    func fetchKitten()   {
        Task.detached { [weak self] in
            do {
                self?.meowFact = try await self?.networkService.fetchMeowFact()
                self?.kittenImage = try await self?.networkService.fetchKittenImage()
                self?.presenter?.meowFactsDidFetch()
            } catch {
                self?.presenter?.meowFactsFetchDidFail(with: error.localizedDescription)
            }
        }
         
    }
    
}
