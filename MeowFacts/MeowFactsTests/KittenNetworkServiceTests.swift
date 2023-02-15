//
//  KittenNetworkServiceTests.swift
//  MeowFactsTests
//
//  Created by Qi Zhan on 2/14/23.
//

import XCTest

@testable import MeowFacts
final class KittenNetworkServiceTests: XCTestCase {

    func testFetchMeowFactReturnsFactWhenSuccess() async throws {
        // Given
        let sessionMock = URLSessionMock()
        sessionMock.mockResponseData = #"{ "data": ["Besides smelling with their nose, cats can smell with an additional organ called the Jacobson's organ, located in the upper surface of the mouth."] }"#.data(using: .utf8)!
        let service = KittenNetworkService(session: sessionMock)
        
        // When
        let response = try await service.fetchMeowFact()
        
        // Then
        XCTAssertEqual(response.data.count, 1)
        XCTAssertEqual(response.data.first, "Besides smelling with their nose, cats can smell with an additional organ called the Jacobson's organ, located in the upper surface of the mouth.")
    }
    
    
    func testFetchMeowFactReturnsFactWhenError() async throws {
        // Given
        let sessionMock = URLSessionMock()
        let service = KittenNetworkService(session: sessionMock)
        sessionMock.mockError = KittenNetworkService.NetworkServiceError.failed
        let expect = expectation(description: "expect call to throw error")
        do {
            // When
            let _ = try await service.fetchMeowFact()
        } catch {
            // Then
            expect.fulfill()
        }
        
        wait(for: [expect], timeout: 3)
    }

}

class URLSessionMock: Networking {
    var didCallDataForRequest: URLRequest?
    var didCallDataWithDelegate: URLSessionTaskDelegate?
    var mockResponseData = Data()
    var mockError: Error?
    
    func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
        if let error = mockError {
            throw error
        }
        let mockURLResponse = HTTPURLResponse(url: request.url!,
                                              statusCode: 200,
                                              httpVersion: nil,
                                              headerFields: nil)
        return (mockResponseData, mockURLResponse!)
    }
}


