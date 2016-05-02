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
    
    func setOperand(operand: Double) {
        accumulator = operand
        internalProgram.append(operand)
    }
    
    private var operations = [
        "π" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "√" : Operation.UnaryOperation(sqrt),
        "sin" : Operation.UnaryOperation(sin),
        "cos" : Operation.UnaryOperation(cos),
        "tan" : Operation.UnaryOperation(tan),
        "asin" : Operation.UnaryOperation(asin),
        "acos" : Operation.UnaryOperation(acos),
        "atan" : Operation.UnaryOperation(atan),
        "eˣ" : Operation.UnaryOperation(exp),
        "ln" : Operation.UnaryOperation(log),
        "×" : Operation.BinaryOperation({$0 * $1}),
        "÷" : Operation.BinaryOperation({$0 / $1}),
        "+" : Operation.BinaryOperation({$0 + $1}),
        "−" : Operation.BinaryOperation({$0 - $1}),
        "xʸ" : Operation.BinaryOperation({pow($0, $1)}),
        "=" : Operation.Equals
        ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    func performOperation(symbol: String) {
        internalProgram.append(symbol)
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value):
                accumulator = value
            case .UnaryOperation(let function):
                execPendingBinaryOperation()
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                execPendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals:
                execPendingBinaryOperation()
            }
        }
    }
    
    private func execPendingBinaryOperation() {
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
        internalProgram.removeAll()
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
}