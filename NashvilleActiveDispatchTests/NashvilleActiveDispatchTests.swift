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

    func testNashvilleFeed() async throws {
        try await assertCityFeedIsReachable(.nashville)
    }

    func testPortlandFeed() async throws {
        try await assertCityFeedIsReachable(.pdx)
    }

    func testSanFranciscoFeed() async throws {
        try await assertCityFeedIsReachable(.sf)
    }

    func testOrlandoFeed() async throws {
        try await assertCityFeedIsReachable(.orlando)
    }

    private func assertCityFeedIsReachable(_ city: City) async throws {
        let expectation = XCTestExpectation(description: "\(city.displayName) feed reachable")

        networkManager.getAlerts(for: city) { result in
            switch result {
            case .success(_):
                expectation.fulfill()
            case .failure(let error):
                switch error {
                case .invalidURL:
                    XCTFail("\(city.displayName): invalid URL")
                case .invalidResponse:
                    XCTFail("\(city.displayName): invalid response")
                case .invalidData:
                    XCTFail("\(city.displayName): could not parse data")
                case .invalidLocation:
                    XCTFail("\(city.displayName): invalid location")
                }
                expectation.fulfill()
            }
        }

        await fulfillment(of: [expectation], timeout: 30.0)
    }
}
