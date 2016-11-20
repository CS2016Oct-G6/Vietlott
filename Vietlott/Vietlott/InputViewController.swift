//
//  ViewController.swift
//  Camera&Number2
//
//  Created by CongTruong on 11/12/16.
//  Copyright © 2016 congtruong. All rights reserved.
//

import UIKit
import AVFoundation
import ARSLineProgress

class ViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    var animator = CircleAnimator()
    
    var captureSession = AVCaptureSession()
    var sessingOutput = AVCapturePhotoOutput()
    var previewLayer = AVCaptureVideoPreviewLayer()
    let progressIndicatorView = CircularLoaderView(frame: CGRect.zero)

    @IBOutlet weak var cameraView: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        let devices = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        if devices !=  nil {
            if devices!.position == AVCaptureDevicePosition.back {
                do {
                    let input = try AVCaptureDeviceInput(device: devices!)
                    if captureSession.canAddInput(input) {
                        captureSession.addInput(input)
                        sessingOutput.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecJPEG])], completionHandler: nil)
                        
                        if captureSession.canAddOutput(sessingOutput) {
                            captureSession.addOutput(sessingOutput)
                            captureSession.startRunning()
                            
                            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                            previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                            previewLayer.connection.videoOrientation = AVCaptureVideoOrientation.portrait
                            cameraView.layer.addSublayer(previewLayer)
                            
                            previewLayer.position = CGPoint(x: self.cameraView.frame.width / 2, y: self.cameraView.frame.height / 2)
                            previewLayer.bounds = cameraView.frame
                        }
                    }
                } catch {
                    print("error")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var lotteryArray = [Lottery]()
        for _ in 1...10 {
            lotteryArray.append(Lottery(lottery: "123456789019", time: "11:20 20/11/2016"))
        }
        
        Constance.lotteryArrayHistory = lotteryArray
        
        cameraView.addSubview(self.progressIndicatorView)
        progressIndicatorView.frame = cameraView.bounds
        progressIndicatorView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        progressIndicatorView.progress = 0.0
        UIView.animate(withDuration: 1, animations: {() -> Void in
            // Update progress here
            self.progressIndicatorView.progress = 1.0
        }, completion: {(Bool) -> Void in
            // Reveal image here
            self.progressIndicatorView.reveal()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let desVC = segue.destination
        
        // 1. set delegate and custom presentationModelStyle
        desVC.transitioningDelegate = animator
        desVC.modalPresentationStyle = .custom
        desVC.view.backgroundColor = UIColor.clear
    }

    @IBAction func takePhoto(_ sender: UIButton) {
        let settings = AVCapturePhotoSettings()
        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
                             kCVPixelBufferWidthKey as String: 160,
                             kCVPixelBufferHeightKey as String: 160,
                             ]
        settings.previewPhotoFormat = previewFormat
        self.sessingOutput.capturePhoto(with: settings, delegate: self)
    }
    
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        }
        
        if let sampleBuffer = photoSampleBuffer, let previewBuffer = previewPhotoSampleBuffer, let dataImage = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewBuffer) {
            let image = UIImage(data: dataImage)!
            print("image: \(image.size)")
            
            // show progress
            ARSLineProgress.show()
            
            //UIImageWriteToSavedPhotosAlbum(UIImage(data: dataImage)!, nil, nil, nil)
            // Base64 encode the image and create the request
            let googleVision = GoogleVision()
            let binaryImageData = googleVision.base64EncodeImage(image)
            googleVision.createRequest(with: binaryImageData, handleSuccess: { (lotteryStringArray: [String]) in
                // hide progress
                ARSLineProgress.hide()
                
                // present edit view
                let storyboart = UIStoryboard(name: "Main", bundle: nil)
                let editVC = storyboart.instantiateViewController(withIdentifier: "editlotteryViewController") as! EditLotteryViewController
                
                // create array lottery
                var lotteryArray = [Lottery]()
                let timeCreate = Date().toString()
                for item in lotteryStringArray {
                    lotteryArray.append(Lottery(lottery: item, time: timeCreate))
                }

                // set data for view
                editVC.lotteryArray = lotteryArray

                // open view
                editVC.transitioningDelegate = self.animator
                editVC.modalPresentationStyle = .custom
                self.present(editVC, animated: true, completion: nil)
            })
        } else {
            
        }
    }

}

