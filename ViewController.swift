//
//  ViewController.swift
//  Interview+CoreML
//
//  Created by Jian Ma on 10/13/20.
//

import UIKit
import ARKit
import Vision

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        captureSession.addInput(input)
        
        captureSession.startRunning()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(dataOutput)
        
    }
    
//    func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//        //        print("Camera was able to capture a frame:", Date())
//
//                guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
//
//                // !!!Important
//                // make sure to go download the models at https://developer.apple.com/machine-learning/ scroll to the bottom
//                guard let model = try? VNCoreMLModel(for: SqueezeNet().model) else { return }
//                let request = VNCoreMLRequest(model: model) { (finishedReq, err) in
//
//                    //perhaps check the err
//
//        //            print(finishedReq.results)
//
//                    guard let results = finishedReq.results as? [VNClassificationObservation] else { return }
//
//                    guard let firstObservation = results.first else { return }
//                    DispatchQueue.main.async {
//                        print(firstObservation.identifier, firstObservation.confidence)
//                    }
//
//
//
//                }
//
//                try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
//            }
      func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
     //        print("Camera was able to capture a frame:", Date())
             
             guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
             
             // !!!Important
             // make sure to go download the models at https://developer.apple.com/machine-learning/ scroll to the bottom
             guard let model = try? VNCoreMLModel(for: SqueezeNet().model) else { return }
             let request = VNCoreMLRequest(model: model) { (finishedReq, err) in
                 
                 //perhaps check the err
                 
     //            print(finishedReq.results)
                 
                 guard let results = finishedReq.results as? [VNClassificationObservation] else { return }
                 
                 guard let firstObservation = results.first else { return }
                 
                 print(firstObservation.identifier, firstObservation.confidence)
                 
                 DispatchQueue.main.async {
                 //    self.identifierLabel.text = "\(firstObservation.identifier) \(firstObservation.confidence * 100)"
                 }
                 
             }
             
             try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
         }


}

