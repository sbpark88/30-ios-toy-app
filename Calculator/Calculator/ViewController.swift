//
//  ViewController.swift
//  Calculator
//
//  Created by 박새별 on 2023/05/16.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var numberOutputLabel: UILabel!
    
    var currentNumber: String = "" {
        willSet {
            self.updateLabel(newValue)
        }
    }
    
    var result: String = "" {
        willSet {
            self.firstOperand = newValue
            self.updateLabel(newValue)
        }
    }
    
    var firstOperand = ""
    var secondOperand = ""
    var currentOperation: Operation = .unknown
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func tabNumberButton(_ sender: UIButton) {
        guard let number = sender.titleLabel?.text else { return }
        if self.currentNumber.count < 9 {
            self.currentNumber += number
        }
    }
    
    @IBAction func tabClearButton(_ sender: UIButton) {
        self.currentNumber = ""
        self.firstOperand = ""
        self.secondOperand = ""
        self.result = ""
        self.currentOperation = .unknown
    }
    
    @IBAction func tabDotButton(_ sender: UIButton) {
        guard self.currentNumber.count < 8, !self.currentNumber.contains(".") else { return }
        self.currentNumber += self.currentNumber.isEmpty ? "0." : "."
    }
    
    func updateLabel(_ value: String) {
        if value == "" {
            self.numberOutputLabel.text = "0"
        } else {
            if let numberValue = Double(value), numberValue.truncatingRemainder(dividingBy: 1) == 0 {
                self.numberOutputLabel.text = "\(Int(numberValue))"
            } else {
                self.numberOutputLabel.text = value
            }
        }
    }
    
}

// MARK: Operation Action

extension ViewController {
    @IBAction func tabDivideButton(_ sender: UIButton) {
        self.operation(.Divide)
    }
    
    @IBAction func tabMultiplyButton(_ sender: UIButton) {
        self.operation(.Multiply)
    }
    
    @IBAction func tabSubtractButton(_ sender: UIButton) {
        self.operation(.Subtract)
    }
    
    @IBAction func tabAddButton(_ sender: UIButton) {
        self.operation(.Add)
    }
    
    @IBAction func tabEqualButton(_ sender: UIButton) {
        self.operation(self.currentOperation)
    }
    
    func operation(_ operation: Operation) {
        if self.currentOperation == .unknown {
            self.firstOperand = self.currentNumber
            self.currentOperation = operation
            self.currentNumber = ""
        } else {
            if !self.currentNumber.isEmpty {
                self.secondOperand = self.currentNumber
                self.currentNumber = ""
                guard let firstOperand = Double(self.firstOperand) else { return }
                guard let secondOperand = Double(self.secondOperand) else { return }
                switch self.currentOperation {
                case .Add: self.result = "\(firstOperand + secondOperand)"
                case .Subtract: self.result = "\(firstOperand - secondOperand)"
                case .Divide: self.result = "\(firstOperand / secondOperand)"
                case .Multiply: self.result = "\(firstOperand * secondOperand)"
                default: break
                }
                
            }
            self.currentOperation = operation
        }
    }
    
}
