//
//  HomeViewModelTests.swift
//  FitnessAppTests
//
//  Created by Jason Dubon on 3/5/24.
//

import XCTest
@testable import FitnessApp

final class HomeViewModelTests: XCTestCase {

    var viewModel: HomeViewModel!
    var mockHealthManager: MockHealthManager!

    override func setUp() {
        super.setUp()
        mockHealthManager = MockHealthManager()
    }

    override func tearDown() {
        viewModel = nil
        mockHealthManager = nil
        super.tearDown()
    }

    func test_RequestHealthKitAccess() async throws {
        // Request access should be called on init
        viewModel = HomeViewModel(healthManager: mockHealthManager)
        
        XCTAssertFalse(mockHealthManager.requestHealthKitAccessCalled)
    }
    
    func test_FetchTodayCalories_Success_UpdatesCaloriesAndActivities() async {
        // Given
        let expectedCalories: Double = 500
        mockHealthManager.fetchTodayCaloriesBurnedResult = .success(expectedCalories)
        let expectation = XCTestExpectation(description: "Wait for async fetch to complete")
            
        // When
        viewModel = HomeViewModel(healthManager: mockHealthManager)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation])
        
        // Then
        XCTAssertEqual(viewModel.calories, Int(expectedCalories))
        XCTAssertTrue(viewModel.activities.contains(where: { $0.title == "Calories Burned" }))
        XCTAssertTrue(viewModel.activities.contains(where: { $0.amount == expectedCalories.formattedNumberString() }))
    }

    func test_FetchTodayCalories_Failure_HandlesError() async {
        // Given
        mockHealthManager.fetchTodayCaloriesBurnedResult = .failure(NSError(domain: "Test", code: 1, userInfo: nil))
        let expectation = XCTestExpectation(description: "Wait for async fetch to complete")
        
        // When
        viewModel = HomeViewModel(healthManager: mockHealthManager)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation])
        
        // Then
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.calories, 0)
        XCTAssertTrue(viewModel.activities.contains(where: { $0.title == "Calories Burned" }))
        XCTAssertTrue(viewModel.activities.contains(where: { $0.amount == "---" }))
    }

}
