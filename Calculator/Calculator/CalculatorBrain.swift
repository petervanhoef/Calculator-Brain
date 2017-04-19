//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Peter Vanhoef on 18/03/17.
//  Copyright © 2017 Peter Vanhoef. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    private var accumulator: Double?
    private var accumulatorString: String? // todo tuple
    
    private enum Operation {
        case constant(Double)
        case nullaryOperation(() -> Double, () -> String)
        case unaryOperation((Double) -> Double, (String) -> String)
        case binaryOperation((Double,Double) -> Double, (String,String) -> String)
        case equals
    }

    private var operations: Dictionary<String,Operation> = [
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "Rand" : Operation.nullaryOperation({Double(arc4random()) / 0xFFFFFFFF}, {"Rand"}),
        "√" : Operation.unaryOperation(sqrt, {"√(\($0))"}),
        "cos" : Operation.unaryOperation(cos, {"cos(\($0))"}),
        "sin" : Operation.unaryOperation(sin, {"sin(\($0))"}),
        "tan" : Operation.unaryOperation(tan, {"tan(\($0))"}),
        "x²" : Operation.unaryOperation({ $0 * $0 }, {"(\($0))²"}),
        "x⁻¹" : Operation.unaryOperation({ 1 / $0 }, {"(\($0))⁻¹"}),
        "±" : Operation.unaryOperation({ -$0 }, {"-\($0)"}),
        "×" : Operation.binaryOperation({ $0 * $1 }, {"\($0) × \($1)"}),
        "÷" : Operation.binaryOperation({ $0 / $1 }, {"\($0) ÷ \($1)"}),
        "+" : Operation.binaryOperation({ $0 + $1 }, {"\($0) + \($1)"}),
        "−" : Operation.binaryOperation({ $0 - $1 }, {"\($0) − \($1)"}),
        "=" : Operation.equals
    ]
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
                accumulatorString = symbol
            case .nullaryOperation(let function, let description):
                accumulator = function()
                accumulatorString = description()
            case .unaryOperation(let function, let descriptionFunction):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                    accumulatorString = descriptionFunction(accumulatorString!)
                }
            case .binaryOperation(let function, let descriptionFunction):
                performPendingBinaryOperation()
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!, descriptionFunction: descriptionFunction, descriptionOperand: accumulatorString!)
                    accumulator = nil
                    accumulatorString = nil
                }
                break
            case .equals:
                performPendingBinaryOperation()
            }
        }
    }
    
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            accumulatorString = pendingBinaryOperation!.buildDescription(with: accumulatorString!)
            pendingBinaryOperation = nil
        }
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        let function: (Double,Double) -> Double
        let firstOperand: Double
 
        let descriptionFunction: (String, String) -> String
        let descriptionOperand: String
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
        
        func buildDescription(with secondOperand: String) -> String {
            return descriptionFunction(descriptionOperand, secondOperand)
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand

        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.usesGroupingSeparator = false
        numberFormatter.maximumFractionDigits = Constants.numberOfDigitsAfterDecimalPoint
        accumulatorString = numberFormatter.string(from: NSNumber(value: operand))
    }
    
    var result: Double? {
        get {
            return accumulator
        }
    }
    
    var resultIsPending: Bool {
        get {
            return pendingBinaryOperation != nil
        }
    }
    
    var description: String? {
        get {
            if pendingBinaryOperation != nil {
                return pendingBinaryOperation!.descriptionFunction(pendingBinaryOperation!.descriptionOperand, accumulatorString ?? "")
            } else {
                return accumulatorString
            }
        }
    }
}
