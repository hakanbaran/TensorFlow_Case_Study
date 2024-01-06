//
//  CameraVC.swift
//  TensorFlow_Case_Study
//
//  Created by Hakan Baran on 6.01.2024.
//

import UIKit
import AVFoundation

class CameraVC: UIViewController {
    
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
        
        view.layer.addSublayer(previewLayer)
        
        checkCameraPermission()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        previewLayer.frame = view.bounds
        button.frame = CGRect(x: view.frame.width/2, y: view.frame.width/2, width: view.frame.width/2, height: view.frame.width/6)
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

extension CameraVC: AVCapturePhotoCaptureDelegate {
    
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
