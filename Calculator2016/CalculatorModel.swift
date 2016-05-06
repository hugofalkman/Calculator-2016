//
//  CalculatorModel.swift
//  Calculator2016
//
//  Created by H Hugo Falkman on 2016-04-24.
//  Copyright © 2016 H Hugo Falkman. All rights reserved.
//

import Foundation



class CalculatorModel {
    
    private var accumulator = 0.0
    private var internalProgram = [AnyObject]()
    
    var description = " "
    var isPartialResult = false
    
    func setOperand(operand: Double) {
        accumulator = operand
        internalProgram.append(operand)
        if isPartialResult == false {
            description = String(format: "%g", accumulator)
        }
    }
    
    private var operations = [
        "π" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "√" : Operation.UnaryOperation(sqrt),
        "sin" : Operation.UnaryOperation(sin),
        "cos" : Operation.UnaryOperation(cos),
        "tan" : Operation.UnaryOperation(tan),
        "sin⁻¹" : Operation.UnaryOperation(asin),
        "cos⁻¹" : Operation.UnaryOperation(acos),
        "tan⁻¹" : Operation.UnaryOperation(atan),
        "eˣ" : Operation.UnaryOperation(exp),
        "ln" : Operation.UnaryOperation(log),
        "×" : Operation.BinaryOperation({$0 * $1}),
        "÷" : Operation.BinaryOperation({$0 / $1}),
        "+" : Operation.BinaryOperation({$0 + $1}),
        "−" : Operation.BinaryOperation({$0 - $1}),
        "xʸ" : Operation.BinaryOperation({pow($0, $1)}),
        "=" : Operation.Equals,
        "C" : Operation.C
        ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
        case C
    }
    
    func performOperation(symbol: String) {
        internalProgram.append(symbol)
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value):
                if isPartialResult == true {
                    description += symbol
                    isPartialResult = false
                } else {
                    description = symbol
                }
                accumulator = value
            case .UnaryOperation(let function):
                if isPartialResult == true {
                    description += symbol + String(format: "%g", accumulator)
                    isPartialResult = false
                } else {
                    description = symbol + "(\(description))"
                }
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                execPendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
                description += " " + symbol + " "
                isPartialResult = true
            case .Equals:
                execPendingBinaryOperation()
            case .C:
                clear()
            }
        }
    }
    
    private func execPendingBinaryOperation() {
        if isPartialResult == true {
            description += String(format: "%g", accumulator)
            isPartialResult = false
        }
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }

    }
    
    private var pending: PendingBinaryOperationInfo?
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    typealias PropertyList = AnyObject
    
    var program: PropertyList {
        get {
            return internalProgram
        }
        set {
            clear()
            if let arrayOfOps = newValue as? [AnyObject] {
                for op in arrayOfOps {
                    if let operand = op as? Double {
                        setOperand(operand)
                    } else if let operation = op as? String {
                        performOperation(operation)
                    }
                }
            }
        }
    }
    
    private func clear() {
        accumulator = 0.0
        pending = nil
        isPartialResult = false
        internalProgram.removeAll()
        description = " "
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
}