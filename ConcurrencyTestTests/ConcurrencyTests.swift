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
  
  func fetchMessageOnePass(completion: @escaping (String) -> Void) {
    DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)) {
      completion("Hello")
      
    }
  }
  func fetchMessageOneFail(completion: @escaping (String) -> Void) {
    DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(2)) {
      completion("Hello")
      
    }
  }
  
  func fetchMessageTwoPass(completion: @escaping (String) -> Void) {
    DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)) {
      completion("World")
      
    }
  }
  func fetchMessageTwoFail(completion: @escaping (String) -> Void) {
    DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(2)) {
      completion("World")
      
    }
  }
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
