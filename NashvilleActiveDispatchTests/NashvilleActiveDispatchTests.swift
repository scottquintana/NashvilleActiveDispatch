//
//  NashvilleActiveDispatchTests.swift
//  NashvilleActiveDispatchTests
//
//  Created by Scott Quintana on 6/27/24.
//

import XCTest
@testable import NashvilleActiveDispatch

final class NashvilleActiveDispatchTests: XCTestCase {
    var networkManager: NetworkManager!
    
    override func setUpWithError() throws {
        networkManager = NetworkManager.shared
    }

    override func tearDownWithError() throws {
        networkManager = nil
    }

    func testUrlIsValid() async throws {
        let expectation1 = XCTestExpectation(description: "test that data is valid")

        networkManager.getAlerts { result in
            switch result {
            case .success(_):
                expectation1.fulfill()
            case .failure(let error):
                switch error {
                case .invalidURL:
                    XCTFail("URL failed")
                case .invalidResponse:
                    XCTFail("Response failed")
                case .invalidData:
                    XCTFail("Cannot parse incident data")
                case .invalidLocation:
                    XCTFail("Invalid location")
                }
                
                expectation1.fulfill()
            }
        }
        
        await fulfillment(of: [expectation1], timeout: 30.0)
    }
}
