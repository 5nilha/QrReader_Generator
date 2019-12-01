//
//  QRGenerator.swift
//  QRCodeReader
//
//  Created by Fabio Quintanilha on 11/30/19.
//  Copyright © 2019 FabioQuintanilha. All rights reserved.
//

import UIKit
import CoreImage

extension CIImage {
    /// Inverts the colors and creates a transparent image by converting the mask to alpha.
    /// Input image should be black and white.
    var transparent: CIImage? {
        return inverted?.blackTransparent
    }
    
    /// Inverts the colors.
    var inverted: CIImage? {
        guard let invertedColorFilter = CIFilter(name: "CIColorInvert") else { return nil }
        
        invertedColorFilter.setValue(self, forKey: "inputImage")
        return invertedColorFilter.outputImage
    }
    
    /// Converts all black to transparent.
    var blackTransparent: CIImage? {
        guard let blackTransparentFilter = CIFilter(name: "CIMaskToAlpha") else { return nil }
        blackTransparentFilter.setValue(self, forKey: "inputImage")
        return blackTransparentFilter.outputImage
    }
    
    /// Applies the given color as a tint color.
    func tinted(using color: UIColor) -> CIImage?
    {
        guard
            let transparentQRImage = transparent,
            let filter = CIFilter(name: "CIMultiplyCompositing"),
            let colorFilter = CIFilter(name: "CIConstantColorGenerator") else { return nil }
        
        let ciColor = CIColor(color: color)
        colorFilter.setValue(ciColor, forKey: kCIInputColorKey)
        let colorImage = colorFilter.outputImage
        
        filter.setValue(colorImage, forKey: kCIInputImageKey)
        filter.setValue(transparentQRImage, forKey: kCIInputBackgroundImageKey)
        
        return filter.outputImage!
    }
}


struct QRGenerator {
    
    public private (set) var qrCode: UIImage?
    
    init<T>(code: T, color: UIColor){
        self.qrCode = self.generateQR(from: code, color: color)
    }
    
    private func generateQR<T>(from code: T, color: UIColor) -> UIImage? {
        var data: Data!
        if code is String {
            let codeString = code as! String
            data = codeString.data(using: String.Encoding.isoLatin1)
        } else if code is URL {
            let codeUrl = code as! URL
            data = codeUrl.dataRepresentation
        }
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 12, y: 12)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output.tinted(using: color) ?? output)
            }
        }
        return nil
    }
}
