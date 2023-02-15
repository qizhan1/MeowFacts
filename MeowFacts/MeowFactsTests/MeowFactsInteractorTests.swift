//
//  MeowFactsInteractorTests.swift
//  MeowFactsTests
//
//  Created by Qi Zhan on 2/14/23.
//

import XCTest
@testable import MeowFacts

final class MeowFactsInteractorTests: XCTestCase {

    func testFetchKittenShouldCallPresenterWhenSuccess() throws {
        // Given
        let expect = expectation(description: "Finished Fetching")
        let mockPresenter = MockPresenter(expectation: expect)
        let mockService = KittenNetworkServiceMock()
        let interactor = MeowFactsInteractor(kittenNetworkService: mockService)
        interactor.presenter = mockPresenter
        
        // When
        interactor.fetchKitten()
        waitForExpectations(timeout: 5)
        
        // Then
        XCTAssertTrue(mockPresenter.didCallMeowFactsDidFetch)
        XCTAssertNil(mockPresenter.didCallMeowFactsDidFailWithErrorMessage)
    }
    
    func testFetchKittenShouldCallPresenterWhenError() throws {
        // Given
        let expect = expectation(description: "Finished Fetching")
        let mockPresenter = MockPresenter(expectation: expect)
        let mockService = KittenNetworkServiceMock()
        mockService.mockError = MockError.generic
        let interactor = MeowFactsInteractor(kittenNetworkService: mockService)
        interactor.presenter = mockPresenter
        
        // When
        interactor.fetchKitten()
        waitForExpectations(timeout: 5)
        
        // Then
        XCTAssertFalse(mockPresenter.didCallMeowFactsDidFetch)
        XCTAssertEqual(mockPresenter.didCallMeowFactsDidFailWithErrorMessage, MockError.generic.localizedDescription)
    }
}

class MockPresenter: MeowFactsInteractorToPresenterProtocol {
    var didCallMeowFactsDidFetch = false
    var didCallMeowFactsDidFailWithErrorMessage: String?
    let expectation: XCTestExpectation
    
    init(expectation: XCTestExpectation) {
        self.expectation = expectation
    }
    
    func meowFactsDidFetch() {
        didCallMeowFactsDidFetch = true
        expectation.fulfill()
    }
    
    func meowFactsFetchDidFail(with errorMessage: String?) {
        didCallMeowFactsDidFailWithErrorMessage = errorMessage
        expectation.fulfill()
    }
}

enum MockError: LocalizedError {
    case generic
    
    var errorDescription: String? {
        return "Some Generic Error"
    }
}
