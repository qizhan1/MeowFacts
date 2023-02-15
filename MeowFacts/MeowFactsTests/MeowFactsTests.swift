//
//  MeowFactsTests.swift
//  MeowFactsTests
//
//  Created by Qi Zhan on 2/13/23.
//

import XCTest
@testable import MeowFacts

class MeowFactsPresenterTests: XCTestCase {
    
    var presenter: MeowFactsPresenter!
    var view = MeowFactsViewMock()
    var interactor = MeowFactsInteractorMock(kittenNetworkService: KittenNetworkServiceMock())

    override func setUpWithError() throws {
        presenter = MeowFactsPresenter()
        presenter.view = view
        presenter.interactor = interactor
        interactor.presenter = presenter
    }
 
    override func tearDownWithError() throws {
        presenter = nil
    }
    
    func testErrorMessage() {
        let errorMessage = "error message"
        presenter.view?.showError(message: errorMessage)
        XCTAssertEqual(view.errorMessage, errorMessage)
    }

    func testShowKitten() {
        let fact = "Besides smelling with their nose, cats can smell with an additional organ called the Jacobson's organ, located in the upper surface of the mouth."
        let bundle = Bundle(for: MeowFactsInteractorMock.self)
        let path = bundle.path(forResource: "kittenImage", ofType: "jpeg")
        let image  = UIImage(contentsOfFile: path ?? "")
        presenter.view?.showKitten(image: image, with: fact)
        XCTAssertNotNil(view.kittenImage)
        XCTAssertEqual(view.meowFact, fact)
    }
    
    func testUpdateView() {
        presenter.updateView()
        XCTAssertTrue(view.isUpdateViewCalled, "updateView function is not called")
    }
    
    func testFetchKitten() {
        interactor.fetchKitten()
        XCTAssertNotNil(interactor.meowFact)
        XCTAssertNotNil(interactor.kittenImage)
    }
    
    func testFetchKittenDidFail() {
        
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
 
class MeowFactsInteractorMock: MeowFactsPresenterToInteractorProtocol {
    
    var presenter: MeowFactsInteractorToPresenterProtocol?
    var networkService: KittenNetworkServiceProtocol?
    
    var meowFact: MeowFact?
    var kittenImage: UIImage?
    
    init(kittenNetworkService: KittenNetworkServiceProtocol) {
        networkService = kittenNetworkService
    }
    
    func fetchKitten() {
        
        meowFact = MeowFact(data: ["Besides smelling with their nose, cats can smell with an additional organ called the Jacobson's organ, located in the upper surface of the mouth."])
        let bundle = Bundle(for: MeowFactsInteractorMock.self)
        let path = bundle.path(forResource: "kittenImage", ofType: "jpeg")
        kittenImage = UIImage(contentsOfFile: path ?? "")
        presenter?.meowFactsDidFetch()
        
        // TODO: how to test async/await?
//        Task { [weak self] in
//            do {
//                self?.kittenImage = try await self?.networkService?.fetchKittenImage()
//                self?.meowFact = try await self?.networkService?.fetchMeowFact()
//                self?.presenter?.meowFactsDidFetch()
//            } catch {
//                self?.presenter?.meowFactsFetchDidFail(with: "\(error)")
//            }
//        }
    }

}

class MeowFactsViewMock: MeowFactsPresenterToViewProtocol {

    var meowFact: String?
    var kittenImage: UIImage?
    var errorMessage: String?
    var isUpdateViewCalled: Bool = false
    
    func showKitten(image: UIImage?, with fact: String?) {
        meowFact = fact
        kittenImage = image
        isUpdateViewCalled = true
    }
    
    func showError(message: String?) {
        errorMessage = message
    }
    
    var presenter: MeowFactsInteractorToPresenterProtocol?
    
}

// TODO: how to test async/await?
class KittenNetworkServiceMock: KittenNetworkServiceProtocol {
    func fetchMeowFact() async throws -> MeowFact {
        return MeowFact(data: ["Besides smelling with their nose, cats can smell with an additional organ called the Jacobson's organ, located in the upper surface of the mouth."])
    }
    
    func fetchKittenImage() async throws -> UIImage? {
        let bundle = Bundle(for: MeowFactsInteractorMock.self)
        let path = bundle.path(forResource: "kittenImage", ofType: "jpeg")
        return UIImage(contentsOfFile: path ?? "")
    }
}
