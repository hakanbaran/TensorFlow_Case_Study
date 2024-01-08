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
    
    private let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("KAMERAAA", for: .normal)
        return button
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.numberOfLines = 1
        label.text = "Deneme"
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
        
        view.addSubview(button)
        view.addSubview(nameLabel)
        view.addSubview(boundingBoxView)
        
        checkCameraPermission()
        
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        previewLayer.frame = view.bounds
        button.frame = CGRect(x: view.frame.width/2, y: view.frame.width/2, width: view.frame.width/2, height: view.frame.width/6)
        nameLabel.frame = CGRect(x: view.frame.width/2, y: view.frame.height/2, width: view.frame.width/4, height: view.frame.width/8)
//        boundingBoxView.frame = CGRect(x: 0, y: 0, width: view.frame.width/2, height: view.frame.height/2)
    }
    
    @objc func buttonClicked() {
//        output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
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
//                if session.canAddOutput(output) {
//                    session.addOutput(output)
//                }
                
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
                    self.boundingBoxView.frame = CGRect(x: objectFrame.origin.x, y: objectFrame.origin.y, width: objectFrame.width, height: objectFrame.height)
                }
                
                if score > 0.77 {
                    print("-------- \(label) -------- \(score) --------  \(objectFrame)")
                    DispatchQueue.main.async {
                        self.nameLabel.text = label
                        
                        self.delegate?.didCaptureScore(label)
                        
//                        self.boundingBoxView.frame = objectFrame
                        
                        
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
    func didCaptureScore(_ objectName: String)
}

