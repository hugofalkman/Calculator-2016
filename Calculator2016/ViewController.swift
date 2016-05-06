//
//  ViewController.swift
//  Calculator2016
//
//  Created by H Hugo Falkman on 2016-04-24.
//  Copyright © 2016 H Hugo Falkman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var history: UILabel!
    
    @IBOutlet private weak var display: UILabel!
    
    private var userIsTyping = false
    
    @IBAction private func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsTyping {
            let textCurrentlyInDisplay = display.text!
            if (digit != ".") || (textCurrentlyInDisplay.rangeOfString(".") == nil) {
                display.text = textCurrentlyInDisplay + digit
            }
        } else {
            display.text = digit
        }
        userIsTyping = true
    }
        
    @IBAction func backspace(sender: UIButton) {
        if userIsTyping {
            display.text!.removeAtIndex(display.text!.endIndex.predecessor())
        }
        if display.text!.isEmpty {
            userIsTyping = false
            displayValue = brain.result
        }
    }
    
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(format: "%g", newValue)
        }
    }
    
    // Code to test model's saving of "programs"
    /*
    private var savedProgram: CalculatorModel.PropertyList?
    
    @IBAction private func save() {
        savedProgram = brain.program
    }
    
    @IBAction private func restore() {
        if savedProgram != nil {
            brain.program = savedProgram!
            displayValue = brain.result
        }
    }
    */
 
    private var brain = CalculatorModel()
    
    @IBAction private func performOperation(sender: UIButton) {
        
        if userIsTyping {
            brain.setOperand(displayValue)
            userIsTyping = false
        }
        if let mathSymbol = sender.currentTitle {
            brain.performOperation(mathSymbol)
        }
        displayValue = brain.result
        history.text = brain.description
        if history.text == " " {return}
        if brain.isPartialResult {
            history.text! += "..."
        } else {
            history.text! += " ="
        }
    }
    
    @IBAction func setM(sender: UIButton) {
        
    }
 
    @IBAction func pushM(sender: UIButton) {
        
    }
    
    
}

