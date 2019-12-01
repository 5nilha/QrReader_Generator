# QR__reader_and_Generator

Using: Swift5, Keyboard API, QR Generator API, AVFoundation, CoreImage

To use the QRGenerator API, just copy the QRGenerator.swift and past in your project.

How to generate a QR code:

let qrStringImage: UIImage = QRGenerator(code: "Any string", color: .black).qrcode

let qrURLImage: UIImage = QRGenerator(code: URL(fileURLWithPath: "www.google.com"), color: .black).qrCode
