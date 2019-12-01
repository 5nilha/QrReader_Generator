//
//  QRGeneratorViewController.swift
//  QRCodeReader
//
//  Created by Fabio Quintanilha on 11/30/19.
//  Copyright © 2019 FabioQuintanilha. All rights reserved.
//

import UIKit

class QRGeneratorViewController: UIViewController {
    
    @IBOutlet weak var qrCodeImage: UIImageView!
    @IBOutlet weak var textField: UITextField!
    lazy var segmentedControl = UISegmentedControl(items: ["String", "URL"])

    override func viewDidLoad() {
        super.viewDidLoad()
        self.textField.delegate = self
        setupView()
    }
    
    private func setupView() {
        segmentedControl.addTarget(self, action: #selector(segmentedControlDidChangeValue(_:)), for: .valueChanged)
        self.navigationItem.titleView = segmentedControl
        self.segmentedControl.selectedSegmentIndex = 0
        
        Keyboard.current.configure(controller: self, textField: self.textField)
        Keyboard.setDoneButtonAccessoryViewToolbar(controller: self, textField: self.textField, "Done", style: .done, action: #selector(dismissKeyboard))
        self.textField.placeholder = "Enter your text"
    }
    
    @objc func segmentedControlDidChangeValue(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.textField.placeholder = "Enter your text"
        }
        else {
            self.textField.placeholder = "Enter your website"
        }
    }
    

    @IBAction func textFieldDidChangeValue(_ sender: UITextField) {
        if let text = sender.text {
            if !text.isEmpty {
                self.generateQR(string: text)
            } else {
                self.qrCodeImage.image = nil
            }
        }
    }
    
    private func generateQR(string: String) {
        if segmentedControl.selectedSegmentIndex == 0 {
             self.qrCodeImage.image = QRGenerator(code: string, color: .black).qrCode
        } else {
            self.qrCodeImage.image = QRGenerator(code: URL(fileURLWithPath: string), color: .black).qrCode
        }
    }
}

extension QRGeneratorViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.endEditing(true)
        return true
    }
    
    private func dismissKeyboardOnTapTheScreen() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        Keyboard.dismissKeyboard(controller: self)
    }
    
}
