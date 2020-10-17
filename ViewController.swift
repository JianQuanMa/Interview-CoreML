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
    
    let predictionLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

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
        
        configurePredictionLabel()
    }
    
    // Helper funcs
    
    fileprivate func configurePredictionLabel(){
        view.addSubview(predictionLabel)
        predictionLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        predictionLabel.centerXAnchor.isEqual(view.centerXAnchor)
        predictionLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        predictionLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    // protocol funcs
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {

                guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

                guard let model = try? VNCoreMLModel(for: SqueezeNet().model) else { return }
                let request = VNCoreMLRequest(model: model) { (finishedReq, err) in

                    // check the err

                    // print(finishedReq.results)

                    guard let results = finishedReq.results as? [VNClassificationObservation] else { return }

                    guard let firstObservation = results.first else { return }
                    DispatchQueue.main.async {
                        self.predictionLabel.text = "\(firstObservation.identifier) with \(firstObservation.confidence) confidence"
                        print( "\(firstObservation.identifier) with \(firstObservation.confidence) confidence")
                    }
                }

                try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
            }
}

