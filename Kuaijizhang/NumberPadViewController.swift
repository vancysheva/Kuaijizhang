//
//  NumberPadViewController.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/8/30.
//  Copyright © 2015年 范伟. All rights reserved.
//

import UIKit

class NumberPadViewController: UIViewController {
    
    weak var delegate: ComponentViewControllerDelegate?
    
    var numbers = [String]() {
        didSet {
        if let index = numbers.indexOf(".") where numbers.count > (index + 2) {
                numbers = Array(numbers[0...(index+2)])
            }
            if let index = numbers.indexOf(".") where index == 0 {
                numbers.insert("0", atIndex: 0)
            }
        }
    }
    var firstNumber: Double = 0
    var secondNumber: Double = 0
    var operation: String?
    
    // MARK: - IBOutlet and IBAction
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var okButton: UIButton!
    
    @IBAction func numberButton(sender: UIButton) {
        if numbers.count < 6 {
            numbers.append(sender.titleLabel!.text!)
            let number = Double(numbers.reduce("") { $0 + $1 })!
            setValue("\(number)")
        }
    }

    @IBAction func reduceButton(sender: UIButton) {
        opt(sender)
    }
    
    @IBAction func plus(sender: UIButton) {
        opt(sender)
    }
    
    func opt(sender: UIButton) {
        if numbers.count > 0 {
            if operation == nil {
                firstNumber = Double(numbers.reduce("") {$0+$1})!
            } else {
                secondNumber = Double(numbers.reduce("") {$0+$1})!
            }
            numbers.removeAll()
        }
        if let opt = operation {
            switch opt {
            case "-":
                firstNumber = firstNumber - secondNumber
                secondNumber = 0
            case "+":
                firstNumber = firstNumber + secondNumber
                secondNumber = 0
            default:
                break
            }
        }
        operation = sender.titleLabel?.text
    }
    
    @IBAction func equalsButton(sender: UIButton) {
        if firstNumber != 0 && numbers.count > 0 && operation != nil {
            let num = Double(numbers.reduce("") {$0+$1})!
            let opt = operation!
            switch opt {
            case "-":
                firstNumber = firstNumber - num
                secondNumber = 0
            case "+":
                firstNumber = firstNumber + num
                secondNumber = 0
            default:
                break
            }
            numbers.removeAll()
        } else if numbers.count > 0 {
            firstNumber = Double(numbers.reduce("") { $0 + $1 })!
        }
        setValue("\(firstNumber)")
    }
    
    @IBAction func pointButton(sender: UIButton) {
        if numbers.indexOf(sender.titleLabel!.text!) < 0 {
            numbers.append(sender.titleLabel!.text!)
        }
    }
    
    @IBAction func clearButton(sender: UIButton) {
        numbers.removeAll()
        firstNumber = 0
        secondNumber = 0
        operation = nil
        //numberLabel.text = "0.00"
        setValue("0.00")
    }

    @IBAction func okButton(sender: UIButton) {
        print(sender.titleLabel!.text!, terminator: "\n")
        delegate?.hideComponetViewController(self)
    }
    

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapButton()
    }
}

// MARK: - Internal methods
extension NumberPadViewController {
    
    func mapButton() {
        buttons.flatMap {
            $0.showsTouchWhenHighlighted = true
        }
    }
    
    func setValue(value: String) {
        delegate?.valueForLabel(value)
    }
}