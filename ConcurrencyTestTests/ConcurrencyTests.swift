//
//  ConcurrencyTestTests.swift
//  ConcurrencyTestTests
//


import XCTest
@testable import ConcurrencyTest

class ConcurrencyTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    //method for mocking message 1 pass scenario
    func fetchMessageOnePass(completion: @escaping (String) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)) {
            completion("Hello")
            
        }
    }
    //method for mocking message 1 fail scenario
    func fetchMessageOneFail(completion: @escaping (String) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(2)) {
            completion("Hello")
            
        }
    }
    
    //method for mocking message 2 pass scenario
    func fetchMessageTwoPass(completion: @escaping (String) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)) {
            completion("World")
            
        }
    }
    //method for mocking messge 2 fail scenario
    func fetchMessageTwoFail(completion: @escaping (String) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(2)) {
            completion("World")
            
        }
    }
    //test case to check the scenario in case both message 1 and message 2 passes
    func testloadMessageBothPass() {
        var message : String = ""
        let group = DispatchGroup()
        
        group.enter()
        fetchMessageOnePass { (messageOne) in
            if(!message.isEmpty){
                message = message + " "
            }
            message = message + messageOne
            group.leave()
        }
        
        group.enter()
        fetchMessageTwoPass { (messageTwo) in
            if(!message.isEmpty){
                message = message + " "
            }
            message = message + messageTwo
            group.leave()
        }
        
        if group.wait(wallTimeout: DispatchWallTime.now() + .seconds(2)) == .timedOut {
            
            XCTAssert(false, "Test case failed for both message one and two pass")
            
        }
            
        else{
            group.notify(queue: .main){
                XCTAssert(true, "Test case Passed for both message one and two pass")
            }
        }
    }
    
    //test case to check the scenario when message 1 fails and message 2 passes
    func testloadMessageOneFail() {
        var message : String = ""
        let group = DispatchGroup()
        
        group.enter()
        fetchMessageOneFail { (messageOne) in
            if(!message.isEmpty){
                message = message + " "
            }
            message = message + messageOne
            group.leave()
        }
        
        group.enter()
        fetchMessageTwoPass { (messageTwo) in
            if(!message.isEmpty){
                message = message + " "
            }
            message = message + messageTwo
            group.leave()
        }
        
        if group.wait(wallTimeout: DispatchWallTime.now() + .seconds(2)) == .timedOut {
            
            XCTAssert(true, "Test case Passed for Message one Pass and message two Fail")
            
        }
            
        else{
            group.notify(queue: .main){
                XCTAssert(false, "Test case failed for Message one Pass and message two Fail")
            }
        }
    }
    //test case to check the scenario when message 1 passes and message 2 fails
    func testloadMessageTwoFail() {
        var message : String = ""
        let group = DispatchGroup()
        
        group.enter()
        fetchMessageOnePass { (messageOne) in
            if(!message.isEmpty){
                message = message + " "
            }
            message = message + messageOne
            group.leave()
        }
        
        group.enter()
        fetchMessageTwoFail { (messageTwo) in
            if(!message.isEmpty){
                message = message + " "
            }
            message = message + messageTwo
            group.leave()
        }
        
        if group.wait(wallTimeout: DispatchWallTime.now() + .seconds(2)) == .timedOut {
            
            XCTAssert(true, "Test case Passed for Message one Fail and message two Pass")
            
        }
            
        else{
            group.notify(queue: .main){
                XCTAssert(false, "Test case failed for Message one Fail and message two Pass")
            }
        }
    }
    //test case to check the scenario when both message 1 and message 2 fails
    func testloadMessageBothFail() {
        var message : String = ""
        let group = DispatchGroup()
        
        group.enter()
        fetchMessageOneFail { (messageOne) in
            if(!message.isEmpty){
                message = message + " "
            }
            message = message + messageOne
            group.leave()
        }
        
        group.enter()
        fetchMessageTwoFail { (messageTwo) in
            if(!message.isEmpty){
                message = message + " "
            }
            message = message + messageTwo
            group.leave()
        }
        
        if group.wait(wallTimeout: DispatchWallTime.now() + .seconds(2)) == .timedOut {
            
            XCTAssert(true, "Test case Passed for Message one Fail and message two Fail")
            
        }
            
        else{
            group.notify(queue: .main){
                XCTAssert(false, "Test case Failed for Message one Fail and message two Fail")
            }
        }
    }
    
    
}
