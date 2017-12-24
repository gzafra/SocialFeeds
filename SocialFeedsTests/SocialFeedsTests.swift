//
//  SocialFeedsTests.swift
//  SocialFeedsTests
//
//  Created by Guillermo Zafra on 24/12/2017.
//  Copyright © 2017 Guillermo Zafra. All rights reserved.
//

import XCTest
@testable import SocialFeeds

class SocialFeedsTests: XCTestCase {
    private let timeout: TimeInterval = 20.0
    
    func testMainPresenter() {
        
        let expectation = self.expectation(description: "Data refreshed")
        
        let delegate = MockDelegate { (mockDelegate) in
            XCTAssertTrue(mockDelegate.dataLoaded)
            XCTAssertTrue(mockDelegate.errorReceived.isEmpty)
            expectation.fulfill()
        }
        let mainPresenter = MainPresenter(withDelegate: delegate)
        mainPresenter.viewDidLoad()
        
        waitForExpectations(timeout: timeout) { (error) in
            XCTAssertNil(error)
        }
    }
}

final class MockDelegate: MainPresenterDelegate {
    var dataLoaded: Bool = false
    var errorReceived: String = ""
    var completionHandler: ((MockDelegate)->())?
    
    init(_ completionHandler: @escaping (MockDelegate)->()) {
        self.completionHandler = completionHandler
    }
    
    func shouldRefreshView() {
        dataLoaded = true
        completionHandler?(self)
        completionHandler = nil
    }
    func display(error: String) {
        errorReceived = error
    }
}
