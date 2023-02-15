//
//  MeowFactsNetworkingService.swift
//  MeowFacts
//
//  Created by Qi Zhan on 2/13/23.
//

import Foundation
import UIKit

protocol Networking {
    func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
}

extension URLSession: Networking {}

class KittenNetworkService: KittenNetworkServiceProtocol {
    
    enum NetworkServiceError: Error {
        case failed
        case badImage
    }
    
    let session: Networking
    
    init(session: Networking = URLSession.shared) {
        self.session = session
    }
    
    func fetchMeowFact() async throws -> MeowFact {
        guard let url = URL(string: Constants.meowFactsURLStr) else {
            fatalError("Missing URL")
        }
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await session.data(for: urlRequest, delegate: nil )
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
        let (data, response) = try await session.data(for: urlRequest, delegate: nil)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw  NetworkServiceError.badImage
        }
        
        return UIImage(data: data)
    }
}
