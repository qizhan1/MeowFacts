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
        XCTAssertTrue(view.didCallUpdateView, "updateView function is not called")
    }
    
    func testFetchKitten() {
        interactor.fetchKitten()
        XCTAssertNotNil(interactor.meowFact)
        XCTAssertNotNil(interactor.kittenImage)
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
    }

}

class MeowFactsViewMock: MeowFactsPresenterToViewProtocol {

    var meowFact: String?
    var kittenImage: UIImage?
    var errorMessage: String?
    var didCallUpdateView: Bool = false
    
    func showKitten(image: UIImage?, with fact: String?) {
        meowFact = fact
        kittenImage = image
        didCallUpdateView = true
    }
    
    func showError(message: String?) {
        errorMessage = message
    }
    
    var presenter: MeowFactsInteractorToPresenterProtocol?
    
}

class KittenNetworkServiceMock: KittenNetworkServiceProtocol {
    
    var mockSuccessData = MeowFact(data: ["Besides smelling with their nose, cats can smell with an additional organ called the Jacobson's organ, located in the upper surface of the mouth."])
    var mockError: Error?
    
    func fetchMeowFact() async throws -> MeowFact {
        if let error = mockError {
            throw error
        }
        
        return mockSuccessData
    }
    
    func fetchKittenImage() async throws -> UIImage? {
        if let error = mockError {
            throw error
        }
        
        let bundle = Bundle(for: MeowFactsInteractorMock.self)
        let path = bundle.path(forResource: "kittenImage", ofType: "jpeg")
        return UIImage(contentsOfFile: path ?? "")
    }
}
