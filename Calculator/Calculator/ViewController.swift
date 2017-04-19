//
//  ViewController.swift
//  Calculator
//
//  Created by Peter Vanhoef on 18/03/17.
//  Copyright © 2017 Peter Vanhoef. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var sequence: UILabel!
    
    var userIsInTheMiddleOfTyping = false
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            if !(digit == "." && textCurrentlyInDisplay.contains(".")) {
                display.text = textCurrentlyInDisplay + digit
            }
        } else {
            display.text = (digit == ".") ? "0." : digit
            userIsInTheMiddleOfTyping = true
        }
    }
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            numberFormatter.usesGroupingSeparator = false
            numberFormatter.maximumFractionDigits = Constants.numberOfDigitsAfterDecimalPoint
            display.text = numberFormatter.string(from: NSNumber(value: newValue))
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        if let result = brain.result {
            displayValue = result
        }
        if let description = brain.description {
            sequence.text = description + (brain.resultIsPending ? ( (description.characters.last != " ") ? " …" : "…") : " =")
        }
    }
    
    @IBAction func clear(_ sender: UIButton) {
        brain = CalculatorBrain()
        displayValue = 0
        sequence.text = " "
    }
    
    @IBAction func backspace(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            var textCurrentlyInDisplay = display.text!
            textCurrentlyInDisplay.remove(at: textCurrentlyInDisplay.index(before: textCurrentlyInDisplay.endIndex))
            if textCurrentlyInDisplay.isEmpty {
                userIsInTheMiddleOfTyping = false
                textCurrentlyInDisplay = "0"
            }
            display.text = textCurrentlyInDisplay
        }
    }
}

