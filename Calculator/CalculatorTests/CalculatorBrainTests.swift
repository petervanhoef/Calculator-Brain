//
//  CalculatorBrainTests.swift
//  Calculator
//
//  Created by Peter Vanhoef on 18/03/17.
//  Copyright © 2017 Peter Vanhoef. All rights reserved.
//

import XCTest
@testable import Calculator

class CalculatorBrainTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSetOperand() {
        var testBrain = CalculatorBrain()
        testBrain.setOperand(5.0)
        XCTAssertEqual(testBrain.result, 5.0)
    }
    
    func testPerformOperation() {
        var testBrain = CalculatorBrain()
        
        testBrain.setOperand(81)
        testBrain.performOperation("√")
        XCTAssertEqual(testBrain.result, 9)
        
        testBrain.setOperand(129)
        testBrain.performOperation("±")
        XCTAssertEqual(testBrain.result, -129)

        testBrain.setOperand(5)
        testBrain.performOperation("×")
        testBrain.setOperand(8)
        testBrain.performOperation("=")
        XCTAssertEqual(testBrain.result, 40)

        testBrain.setOperand(4)
        testBrain.performOperation("+")
        testBrain.setOperand(9)
        testBrain.performOperation("=")
        XCTAssertEqual(testBrain.result, 13)

        testBrain.setOperand(3)
        testBrain.performOperation("−")
        testBrain.setOperand(10)
        testBrain.performOperation("=")
        XCTAssertEqual(testBrain.result, -7)

        testBrain.setOperand(6)
        testBrain.performOperation("÷")
        testBrain.setOperand(2)
        testBrain.performOperation("=")
        XCTAssertEqual(testBrain.result, 3)
        
        testBrain.performOperation("π")
        testBrain.performOperation("cos")
        XCTAssertEqual(testBrain.result, -1)
    }
    
    func testAdditionalOperationsTask3() {
        var testBrain = CalculatorBrain()
        
        testBrain.setOperand(0)
        testBrain.performOperation("sin")
        XCTAssertEqual(testBrain.result, 0)
        
        testBrain.setOperand(0)
        testBrain.performOperation("tan")
        XCTAssertEqual(testBrain.result, 0)
        
        testBrain.setOperand(18)
        testBrain.performOperation("x²")
        XCTAssertEqual(testBrain.result, 324)
        
        testBrain.setOperand(4)
        testBrain.performOperation("x⁻¹")
        XCTAssertEqual(testBrain.result, 0.25)
    }
    
    func testResultIsPendingTask5() {
        var testBrain = CalculatorBrain()

        testBrain.setOperand(4)
        XCTAssertFalse(testBrain.resultIsPending)
        testBrain.performOperation("+")
        XCTAssertTrue(testBrain.resultIsPending)
        testBrain.setOperand(9)
        testBrain.performOperation("=")
        XCTAssertFalse(testBrain.resultIsPending)
        XCTAssertEqual(testBrain.result, 13)
    }
    
    func testHint7() {
        var testBrain = CalculatorBrain()
        
        // 6 x 5 x 4 x 3 = will work
        testBrain.setOperand(6)
        XCTAssertFalse(testBrain.resultIsPending)
        testBrain.performOperation("×")
        XCTAssertTrue(testBrain.resultIsPending)
        testBrain.setOperand(5)
        testBrain.performOperation("×")
        XCTAssertTrue(testBrain.resultIsPending)
        testBrain.setOperand(4)
        testBrain.performOperation("×")
        XCTAssertTrue(testBrain.resultIsPending)
        testBrain.setOperand(3)
        testBrain.performOperation("=")
        XCTAssertFalse(testBrain.resultIsPending)
        XCTAssertEqual(testBrain.result, 360)
    }
    
    func testDescriptionTask6() {
        var testBrain = CalculatorBrain()
        
        // a. touching 7 + would show “7 + ...” (with 7 still in the display)
        testBrain.setOperand(7)
        testBrain.performOperation("+")
        XCTAssertEqual(testBrain.description, "7 + ")
        XCTAssertTrue(testBrain.resultIsPending)
        XCTAssertFalse(testBrain.result != nil)
        
        // b. 7 + 9 would show “7 + ...” (9 in the display)
        // no operation button touched, so operand is not send to model
        
        // c. 7 + 9 = would show “7 + 9 =” (16 in the display)
        testBrain.setOperand(9)
        testBrain.performOperation("=")
        XCTAssertEqual(testBrain.description, "7 + 9")
        XCTAssertFalse(testBrain.resultIsPending)
        XCTAssertEqual(testBrain.result, 16.0)
        
        // d. 7 + 9 = √ would show “√(7 + 9) =” (4 in the display)
        testBrain.performOperation("√")
        XCTAssertEqual(testBrain.description, "√(7 + 9)")
        XCTAssertFalse(testBrain.resultIsPending)
        XCTAssertEqual(testBrain.result, 4.0)
        
        // e. 7 + 9 = √ + 2 = would show “√(7 + 9) + 2 =” (6 in the display)
        testBrain.performOperation("+")
        testBrain.setOperand(2)
        testBrain.performOperation("=")
        XCTAssertEqual(testBrain.description, "√(7 + 9) + 2")
        XCTAssertFalse(testBrain.resultIsPending)
        XCTAssertEqual(testBrain.result, 6.0)

        // f. 7 + 9 √ would show “7 + √(9) ...” (3 in the display)
        testBrain.setOperand(7)
        testBrain.performOperation("+")
        testBrain.setOperand(9)
        testBrain.performOperation("√")
        XCTAssertEqual(testBrain.description, "7 + √(9)")
        XCTAssertTrue(testBrain.resultIsPending)
        XCTAssertEqual(testBrain.result, 3.0)
        
        // g. 7 + 9 √ = would show “7 + √(9) =“ (10 in the display)
        testBrain.performOperation("=")
        XCTAssertEqual(testBrain.description, "7 + √(9)")
        XCTAssertFalse(testBrain.resultIsPending)
        XCTAssertEqual(testBrain.result, 10.0)
        
        // h. 7 + 9 = + 6 = + 3 = would show “7 + 9 + 6 + 3 =” (25 in the display)
        testBrain.setOperand(7)
        testBrain.performOperation("+")
        testBrain.setOperand(9)
        testBrain.performOperation("=")
        testBrain.performOperation("+")
        testBrain.setOperand(6)
        testBrain.performOperation("=")
        testBrain.performOperation("+")
        testBrain.setOperand(3)
        testBrain.performOperation("=")
        XCTAssertEqual(testBrain.description, "7 + 9 + 6 + 3")
        XCTAssertFalse(testBrain.resultIsPending)
        XCTAssertEqual(testBrain.result, 25.0)
        
        // i. 7 + 9 = √ 6 + 3 = would show “6 + 3 =” (9 in the display)
        testBrain.setOperand(7)
        testBrain.performOperation("+")
        testBrain.setOperand(9)
        testBrain.performOperation("=")
        testBrain.performOperation("√")
        testBrain.setOperand(6)
        testBrain.performOperation("+")
        testBrain.setOperand(3)
        testBrain.performOperation("=")
        XCTAssertEqual(testBrain.description, "6 + 3")
        XCTAssertFalse(testBrain.resultIsPending)
        XCTAssertEqual(testBrain.result, 9.0)
        
        // j. 5 + 6 = 7 3 would show “5 + 6 =” (73 in the display)
        testBrain.setOperand(5)
        testBrain.performOperation("+")
        testBrain.setOperand(6)
        testBrain.performOperation("=")
        XCTAssertEqual(testBrain.description, "5 + 6")
        XCTAssertFalse(testBrain.resultIsPending)
        XCTAssertEqual(testBrain.result, 11.0)
        
        // k. 4 × π = would show “4 × π =“ (12.5663706143592 in the display)
        testBrain.setOperand(4)
        testBrain.performOperation("×")
        testBrain.performOperation("π")
        testBrain.performOperation("=")
        XCTAssertEqual(testBrain.description, "4 × π")
        XCTAssertFalse(testBrain.resultIsPending)
        XCTAssertTrue(abs(testBrain.result! - 12.5663706143592) < 0.0001)
    }
    
    func testMissingParenthesisBug() {
        var testBrain = CalculatorBrain()
        
        testBrain.setOperand(4)
        testBrain.performOperation("+")
        testBrain.setOperand(5)
        testBrain.performOperation("=")
        testBrain.performOperation("x²")
        XCTAssertEqual(testBrain.description, "(4 + 5)²")
        XCTAssertFalse(testBrain.resultIsPending)
        XCTAssertEqual(testBrain.result, 81)

        testBrain.setOperand(1)
        testBrain.performOperation("+")
        testBrain.setOperand(3)
        testBrain.performOperation("=")
        testBrain.performOperation("x⁻¹")
        XCTAssertEqual(testBrain.description, "(1 + 3)⁻¹")
        XCTAssertFalse(testBrain.resultIsPending)
        XCTAssertEqual(testBrain.result, 0.25)
    }
    
    func testNumberFormatterExtraCredit2() {
        var testBrain = CalculatorBrain()
        
        testBrain.setOperand(4.123456789)
        testBrain.performOperation("+")
        testBrain.setOperand(1)
        testBrain.performOperation("=")
        XCTAssertEqual(testBrain.description, "4.123457 + 1")
        XCTAssertFalse(testBrain.resultIsPending)
        XCTAssertTrue(abs(testBrain.result! - 5.123456) < 0.0001)
    }

    func testRandExtraCredit3() {
        var testBrain = CalculatorBrain()
        
        testBrain.setOperand(10)
        testBrain.performOperation("+")
        testBrain.performOperation("Rand")
        testBrain.performOperation("=")
        XCTAssertFalse(testBrain.resultIsPending)
        if testBrain.result != nil {
            XCTAssertTrue(abs(testBrain.result! - 10) <= 1)
        } else {
            XCTAssertFalse(testBrain.result == nil)
        }
    }
}
