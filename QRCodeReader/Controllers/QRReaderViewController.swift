//
//  QRReaderViewController.swift
//  QRCodeReader
//
//  Created by Fabio Quintanilha on 12/1/19.
//  Copyright © 2019 FabioQuintanilha. All rights reserved.
//

import UIKit
import AVFoundation

class QRReaderViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    fileprivate lazy var video = AVCaptureVideoPreviewLayer()
    fileprivate var captureSession: AVCaptureSession!
    private var qrResult: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.captureSession != nil && !self.captureSession.isRunning {
            self.captureSession.startRunning()
        } else {
            self.captureSession.stopRunning()
            self.captureSession.startRunning()
        }
    }
    
    private func setupCamera() {
        self.captureSession = AVCaptureSession()
//        self.setVideoInput()
//        self.setVideoOutput()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
               let videoInput: AVCaptureDeviceInput
               
               do {
                   videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
                   
                   if (captureSession.canAddInput(videoInput)) {
                       captureSession.addInput(videoInput)
                   } else {
                       failed()
                       return
                   }
               } catch {
                   print(error.localizedDescription)
                   return
               }
               
               let output = AVCaptureMetadataOutput()
               
               if (captureSession.canAddOutput(output)) {
                   captureSession.addOutput(output)
                   
                   output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                   output.metadataObjectTypes = [.qr]
               } else {
                   failed()
                   return
               }
        
        video = AVCaptureVideoPreviewLayer(session: captureSession)
        video.frame = view.layer.bounds
        video.videoGravity = .resizeAspectFill
        view.layer.addSublayer(video)
        
    }
    
//    private func setVideoInput() {
//        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
//        let videoInput: AVCaptureDeviceInput
//
//        do {
//            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
//
//            if (captureSession.canAddInput(videoInput)) {
//                captureSession.addInput(videoInput)
//            } else {
//                failed()
//                return
//            }
//        } catch {
//            print(error.localizedDescription)
//            return
//        }
//
//
//    }
//
//    private func setVideoOutput() {
//        let output = AVCaptureMetadataOutput()
//
//        if (captureSession.canAddOutput(output)) {
//            captureSession.addOutput(output)
//
//            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
//            output.metadataObjectTypes = [.qr]
//        } else {
//            failed()
//            return
//        }
//    }
    
    private func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
        
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
    }
    
    private func found(code: String) {
        if let url = URL(string: code) {
            UIApplication.shared.open(url)
        } else {
            self.qrResult = code
            self.performSegue(withIdentifier: "goToQRResult", sender: self)
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToQRResult" {
            let destination = segue.destination as? QrResultViewController
            if let destination = destination {
                destination.resultString = qrResult
            }
        }
    }
    
    override var prefersStatusBarHidden: Bool {
         return true
     }
     
     override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
         return .portrait
     }
}
