//
//  CameraVC.swift
//  TensorFlow_Case_Study
//
//  Created by Hakan Baran on 6.01.2024.
//

import UIKit
import AVFoundation
import TensorFlowLiteTaskVision
import CoreImage
import CoreVideo


class CameraVC: UIViewController {
    
    weak var delegate: CameraDelegate?
    
    var timer: Timer?
    
    var session: AVCaptureSession?
    var videoOutput = AVCaptureVideoDataOutput()
    
    let previewLayer = AVCaptureVideoPreviewLayer()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .regular)
        label.numberOfLines = 1
        label.text = "Deneme"
        label.backgroundColor = .darkGray
        return label
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .regular)
        label.numberOfLines = 1
        label.text = "% 20"
        label.backgroundColor = .darkGray
        return label
    }()
    
    private let boundingBoxView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.green.cgColor
        view.backgroundColor = UIColor.clear
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.addSublayer(previewLayer)
        view.addSubview(nameLabel)
        view.addSubview(scoreLabel)
        view.addSubview(boundingBoxView)
        checkCameraPermission()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
        nameLabel.frame = CGRect(x: 0, y: view.frame.height-view.frame.width/3-1, width: view.frame.width, height: view.frame.width/6)
        scoreLabel.frame = CGRect(x: 0, y: view.frame.height-view.frame.width/6, width: view.frame.width, height: view.frame.width/6)
    }
    
    func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            // Kamera erişimi zaten verilmiş.
            setUpCamera()
            print("Kamera İzni Var")
        case .notDetermined:
            // Kullanıcı henüz izin vermedi, izin iste.
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
//                    self.setupCamera()
                    print("Kamera İzni Verildi")
                } else {
                    // Kullanıcı izin vermedi.
                    print("Kamera İzni Verilmedi")
                }
            }
        case .denied, .restricted:
            // Kamera erişimi reddedildi veya kısıtlandı.
            // Kullanıcıyı ayarlara yönlendirerek izin isteyebilirsiniz.
            print("Kamera İzni Kısıtlandı")
            break
        @unknown default:
            break
        }
    }
    
    func setUpCamera() {
        
        let session = AVCaptureSession()
        
        if let device = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input) {
                    session.addInput(input)
                }
                
                videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
                
                if session.canAddOutput(videoOutput) {
                    session.addOutput(videoOutput)
                }
                
                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.session = session
                
                DispatchQueue.global(qos: .background).async {
                    do {
                        session.startRunning()
                    }
                }
                self.session = session
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}

extension CameraVC: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let inputPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        if let outputPixelBuffer = convertTo32BGRAFormat(inputPixelBuffer) {
            guard let modelPath = Bundle.main.path(forResource: "ssd_mobilenet_v1_1", ofType: "tflite") else {
                return
            }
            let options = ObjectDetectorOptions(modelPath: modelPath)
            do {
                
                let detector = try ObjectDetector.detector(options: options)
                
                guard let mlImage = MLImage(pixelBuffer: outputPixelBuffer) else {
                    return
                }
                
                let detectionResult = try detector.detect(mlImage: mlImage)
                
                guard let label = detectionResult.detections.first?.categories.first?.label, let objectFrame = detectionResult.detections.first?.boundingBox, let score = detectionResult.detections.first?.categories.first?.score else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.boundingBoxView.frame = CGRect(x: objectFrame.origin.x, y: objectFrame.origin.y, width: objectFrame.width/3, height: objectFrame.height/3)
                    self.nameLabel.text = label
                    self.scoreLabel.text = "% \(Int(score*100))"
                }
                
                
                
                if score > 0.77 {
                    DispatchQueue.main.async {
                        
                        let intScore = Int(score*100)
                        self.delegate?.didCaptureScore(label, objectScore: intScore)
                        self.navigationController?.popViewController(animated: true)
                        self.session?.stopRunning()
                    }
                }
            } catch {
                print("Error11!! \(error.localizedDescription)")
            }
        } else {
            print("Format dönüşümü başarısız oldu!!!")
        }
    }
}

//MARK: - CAMERA FORMAT

extension CameraVC {
    func convertTo32BGRAFormat(_ inputPixelBuffer: CVPixelBuffer) -> CVPixelBuffer? {
        // Create CIImage from the input pixel buffer
        let ciImage = CIImage(cvPixelBuffer: inputPixelBuffer)

        // Create CIContext
        let context = CIContext()

        // Render CIImage to a new CVPixelBuffer with the desired format
        var outputPixelBuffer: CVPixelBuffer?
        CVPixelBufferCreate(nil, CVPixelBufferGetWidth(inputPixelBuffer), CVPixelBufferGetHeight(inputPixelBuffer), kCVPixelFormatType_32BGRA, nil, &outputPixelBuffer)

        guard let unwrappedOutputPixelBuffer = outputPixelBuffer else {
            return nil
        }

        context.render(ciImage, to: unwrappedOutputPixelBuffer)

        return unwrappedOutputPixelBuffer
    }
}

protocol CameraDelegate: AnyObject {
    func didCaptureScore(_ objectName: String, objectScore: Int)
}

