//
//  HomeVC.swift
//  TensorFlow_Case_Study
//
//  Created by Hakan Baran on 5.01.2024.
//

import UIKit
import AVFoundation

class HomeVC: UIViewController {
    
//    var captureSession: AVCaptureSession?
//    var previewLayer: AVCaptureVideoPreviewLayer?
    
    
    var session: AVCaptureSession?
    var output = AVCapturePhotoOutput()
    
    let previewLayer = AVCaptureVideoPreviewLayer()
    
    
    private let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("KAMERAAA", for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        view.addSubview(button)
        view.layer.addSublayer(previewLayer)
        
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        previewLayer.frame = CGRect(x: 0, y: 100, width: view.frame.width, height: view.frame.height-100)
        button.frame = CGRect(x: view.frame.width/2, y: view.frame.width/2, width: view.frame.width/2, height: view.frame.width/6)
        
        
        
        
        
    }
    @objc func buttonClicked() {
        checkCameraPermission()
        
//        output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
        
    }
    
//    func checkCameraPermission() {
//        
//        switch AVCaptureDevice.authorizationStatus(for: .video) {
//            
//        case .notDetermined:
//            // request
//            
//            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
//                guard granted else {
//                    return
//                }
//                
//                DispatchQueue.main.async {
//                    self?.setUpCamera()
//                }
//            }
//            
//        case .restricted:
//            break
//        case .denied:
//            break
//        case .authorized:
//            setUpCamera()
//            
//        @unknown default:
//            break
//        }
//        
//    }
    
    
    
    
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
                if session.canAddOutput(output) {
                    session.addOutput(output)
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
                
            }
        }
    }
}

extension HomeVC: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        
        guard let data = photo.fileDataRepresentation() else {
            return
        }
        
        let image = UIImage(data: data)
        
        session?.stopRunning()
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.frame = view.bounds
        view.addSubview(imageView)
    }
    
    
}
