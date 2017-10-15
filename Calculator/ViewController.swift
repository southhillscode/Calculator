//
//  ViewController.swift
//  Calculator
//
//  Created by Rob on 12/26/16.
//  Copyright © 2016 Rob. All rights reserved.
//

import UIKit

var calculatorCount = 0

class ViewController: UIViewController
{
    @IBOutlet private weak var display: UILabel!
    
    @IBOutlet weak var historyDisplay: UILabel!
    
    private var userIsInTheMiddleOfTyping = false

    override func viewDidLoad(){
        super.viewDidLoad()
        calculatorCount += 1
        print("Loaded up a new Calculator (count = \(calculatorCount))")
        brain.addUnaryOperation(symbol: "Z") {
            /*[unowned me = self] in
            me.display.textColor = UIColor.red*/
            [ weak weakSelf = self] in
            weakSelf?.display.textColor = UIColor.red
            return sqrt($0)
        }
    }
    
    deinit {
        calculatorCount -= 1
        print("Calculator left the heap (count = \(calculatorCount))")
    }
    
    @IBAction func clear() {
        //operandStack = []
        historyDisplay.text = " "
        displayValue = 0
        userIsInTheMiddleOfTyping = false
    }
   

    @IBAction func appendDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        
        // Display digit if it's a number or the first "."
        if userIsInTheMiddleOfTyping && digit != "."  || (digit == "." && display.text!.range(of: ".") == nil) {
            display.text = display.text! + digit
        } else{
            //If "." is first digit, display "0." for better readability
            if digit == "." {
                display.text = "0" + digit
            }else {
                display.text = digit
            }
            userIsInTheMiddleOfTyping = true
        }
        appendHistory(myGreatString: digit)
    }
    
    @IBAction private func touchDigit(_ sender: UIButton)
    {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping
        {
            let textCurrentlyInDisplay = display!.text!
            display!.text = textCurrentlyInDisplay + digit
        }
        else
        {
            display!.text = digit
        }
        userIsInTheMiddleOfTyping = true
        appendHistory(myGreatString: digit)
        
    }
    
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    private var historyDisplayValue: String {
        get {
            return String(historyDisplay.text!)!
        }
        set {
            historyDisplay.text = String(newValue)
        }
    }
    
    var savedProgram: CalculatorBrain.PropertyList?
    
    @IBAction func save() {
        savedProgram = brain.program
    }
    @IBAction func restore() {
        if savedProgram != nil {
            brain.program = savedProgram!
            displayValue = brain.result
        }
    }
    private var brain = CalculatorBrain()
    
    @IBAction private func performOperation(_ sender: UIButton)
    {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(operand: displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle
        {
            brain.performOperation(symbol: mathematicalSymbol)
            appendHistory(myGreatString: mathematicalSymbol)
        }
        displayValue = brain.result
        

    }
    
    private func appendHistory(myGreatString:String)
    {
        historyDisplayValue = historyDisplayValue + myGreatString
    }
    
    
}

