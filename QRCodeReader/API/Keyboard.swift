//
//  Keyboard.swift
//  QRCodeReader
//
//  Created by Fabio Quintanilha on 11/30/19.
//  Copyright © 2019 FabioQuintanilha. All rights reserved.
//

import UIKit

protocol KeyboardDelegates {
    func dismissKeyboard()
}

class Keyboard {
    
    private var controller: UIViewController!
    private var textField: UITextField!
    private var textView: UITextView!
    
    private init() {}
    static let current = Keyboard()
    
    func configure(controller: UIViewController, textField: UITextField) {
        self.controller = controller
        self.textField = textField
        self.configureTapToDismiss(controller: controller)
    }
    
    func configure(controller: UIViewController, textView: UITextView) {
        self.controller = controller
        self.textView = textView
        self.configureTapToDismiss(controller: controller)
    }
    
    private func configureTapToDismiss(controller: UIViewController) {
        let tap = UITapGestureRecognizer(target: controller.self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        controller.view.addGestureRecognizer(tap)
    }
    
    static func dismissKeyboard(controller: UIViewController) {
        controller.view.endEditing(true)
    }
    
    static func setDoneButtonAccessoryViewToolbar(controller: UIViewController, textField: UITextField, _ btnLabel: String, style: UIBarButtonItem.Style, action: Selector?) {
        
        let toolbar = UIToolbar(frame: CGRect(origin: .zero, size: .init(width: controller.view.frame.size.width, height: 30)))
        
        //Create left side empty space, so the done button will be set on right side
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: action)
       
        let doneBtn = UIBarButtonItem(title: btnLabel, style: style, target: controller.self, action: action)
        toolbar.setItems([flexSpace, doneBtn], animated: true)
        toolbar.sizeToFit()
        
        //setting toolbar as inputAccessoryView
        textField.inputAccessoryView = toolbar
    }
    
    static func setDoneButtonAccessoryViewToolbar(controller: UIViewController, textView: UITextField, _ btnLabel: String, style: UIBarButtonItem.Style, action: Selector?) {
        
        let toolbar = UIToolbar(frame: CGRect(origin: .zero, size: .init(width: controller.view.frame.size.width, height: 30)))
        
        //Create left side empty space, so the done button will be set on right side
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: action)
       
        let doneBtn = UIBarButtonItem(title: btnLabel, style: style, target: controller.self, action: action)
        toolbar.setItems([flexSpace, doneBtn], animated: true)
        toolbar.sizeToFit()
        
        //setting toolbar as inputAccessoryView
        textView.inputAccessoryView = toolbar
    }
    
}
