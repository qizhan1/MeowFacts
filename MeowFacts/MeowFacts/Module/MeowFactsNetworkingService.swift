//
//  MeowFactsNetworkingService.swift
//  MeowFacts
//
//  Created by Qi Zhan on 2/13/23.
//

import Foundation
import UIKit

class KittenNetworkService: KittenNetworkServiceProtocol {
    
    enum NetworkServiceError: Error {
        case failed
        case badImage
    }
    
    var session = URLSession.shared
    
    func fetchMeowFact() async throws -> MeowFact {
        guard let url = URL(string: Constants.meowFactsURLStr) else {
            fatalError("Missing URL")
        }
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await session.data(for: urlRequest )
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw NetworkServiceError.failed
        }
        
        return try JSONDecoder().decode(MeowFact.self, from: data)
    }
    
    func fetchKittenImage() async throws -> UIImage? {
        let randomWidth = Int.random(in: 100...2000)
        let randomHeight = Int.random(in: 100...2000)
        let urlStr = Constants.kittenImageBaseURLStr + "/g/\(randomWidth)/\(randomHeight)"
        guard let url = URL(string: urlStr) else {
            fatalError("Missing URL")
        }
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await session.data(for: urlRequest)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw  NetworkServiceError.badImage
        }
        
        return UIImage(data: data)
    }
}
