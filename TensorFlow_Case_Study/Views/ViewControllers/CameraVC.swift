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
import NVActivityIndicatorView


class CameraVC: UIViewController {
    
    var objectName: String?
    var objectScore: Float?
    var objectImage: UIImage?
    
    
    weak var delegate: CameraDelegate?
    
    var activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), type: .lineSpinFadeLoader, color: .yellow, padding: nil)
    
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
    
    private let approveButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .semibold)
        button.setTitle("Approve Object", for: .normal)
        button.backgroundColor = .darkGray
        button.isHidden = true
        return button
    }()
    
    private let restartButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .semibold)
        button.setTitle("Restart Search", for: .normal)
        button.backgroundColor = .darkGray
        button.isHidden = true
        return button
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.addSublayer(previewLayer)
        view.addSubview(nameLabel)
        view.addSubview(scoreLabel)
        view.addSubview(boundingBoxView)
        view.addSubview(activityIndicatorView)
        view.addSubview(approveButton)
        view.addSubview(restartButton)
        checkCameraPermission()
        logIn()
        
        approveButton.addTarget(self, action: #selector(approveClicked), for: .touchUpInside)
        restartButton.addTarget(self, action: #selector(restartClicked), for: .touchUpInside)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let width = view.frame.width
        let height = view.frame.height
        
        previewLayer.frame = view.bounds
        nameLabel.frame = CGRect(x: 0, y: height-width/3-1, width: width, height: width/6)
        scoreLabel.frame = CGRect(x: 0, y: height-width/6, width: width, height: width/6)
        activityIndicatorView.center = view.center
        approveButton.frame = CGRect(x: width/2-width/6-width/10, y: height/2, width: width/6, height: width/8)
        restartButton.frame = CGRect(x: width/2+width/10, y: height/2, width: width/6, height: width/8)
    }
    
    func uploadImage( completion: @escaping (Bool) -> Void) {
        let data = self.objectImage?.pngData()
        
        let uploadURL = "http://localhost:3000/api/object-detection/upload"
        
        let uploadImageParameters = UploadImageModel(classname: objectName, image: data)
        self.activityIndicatorView.startAnimating()
        APICaller.shared.request(uploadURL, method: .post, parameters: uploadImageParameters.getParameters()) { (result: Result<UploadImageresponseModel, Error>) in
            
            DispatchQueue.main.asyncAfter(deadline: .now()+1.5) {
                self.activityIndicatorView.stopAnimating()
            }
            switch result {
            case .success(let response):
                print(response)
                completion(true)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                completion(true)
            }
        }
    }
    
    
    @objc func approveClicked() {
        
        DispatchQueue.main.async {
                
            
            self.uploadImage { success in
                switch success {
                case true:
                    self.approveButton.isHidden = true
                    self.restartButton.isHidden = true
                    
                    let intScore = Int((self.objectScore ?? 0.0)*100)
                    self.delegate?.didCaptureScore(self.objectName ?? "", objectScore: intScore, objectImage: self.objectImage ?? UIImage())
                    self.navigationController?.popViewController(animated: true)
                    
                case false:
                    self.navigationController?.popViewController(animated: true)
                    print("ERRORR!!!")
                    
                }
            }
            
            
        }
    }
    
    
    @objc func restartClicked() {
        
        DispatchQueue.main.async {
            self.approveButton.isHidden = true
            self.restartButton.isHidden = true
        }
        
        DispatchQueue.global(qos: .background).async {
            do {
                 self.session?.startRunning()
                
                // Kameranın başarıyla başlatıldı, diğer işlemleri gerçekleştirin
            }
        }
        
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
                
                if let connection = videoOutput.connection(with: .video), connection.isVideoOrientationSupported {
                    connection.videoOrientation = .portrait
                }
                
                
                
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
    
    func logIn() {
        activityIndicatorView.startAnimating()
        
        let requestParameters = LogInRequestModel(organizationCode: "TEST", email: "test@ddtech.com.tr", password: "Test")
        
        APICaller.shared.request("http://localhost:3000/api/object-detection/upload", method: .post, parameters: requestParameters.getParameters()) { (result: Result<LogInModel, Error>) in
            
            DispatchQueue.main.asyncAfter(deadline: .now()+1.5) {
                self.activityIndicatorView.stopAnimating()
            }
            switch result {
            case .success(let user):
                if let userToken = user.data?.accessToken?.token {
                    AuthManager.shared.token = userToken
                }
                print(user)
            case .failure(let error):
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
                
                if score > 0.75 {
                    
                    DispatchQueue.main.async {
                        let ciImage = CIImage(cvPixelBuffer: outputPixelBuffer)
                        
                        
                        
                        // CIImage'i UIImage'e dönüştürme
                        self.objectImage = UIImage(ciImage: ciImage)
                        self.objectScore = score
                        self.objectName = label
                        
                        self.session?.stopRunning()
                        
                        self.approveButton.isHidden = false
                        self.restartButton.isHidden = false
                        
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
    func didCaptureScore(_ objectName: String, objectScore: Int, objectImage: UIImage)
}

