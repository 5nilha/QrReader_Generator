//
//  QrResultViewController.swift
//  QRCodeReader
//
//  Created by Fabio Quintanilha on 12/1/19.
//  Copyright © 2019 FabioQuintanilha. All rights reserved.
//

import UIKit

class QrResultViewController: UIViewController {
    
    @IBOutlet weak var qrResultLabel: UILabel!
    
    var resultString: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let resultString = resultString {
            self.qrResultLabel.text = resultString
        }
    }

}
