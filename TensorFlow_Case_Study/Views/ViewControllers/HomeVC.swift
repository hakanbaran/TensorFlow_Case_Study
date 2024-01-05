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
    var output: AVCapturePhotoOutput?
    
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
        
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        button.frame = CGRect(x: view.frame.width/2, y: view.frame.width/2, width: view.frame.width/2, height: view.frame.width/6)
        
    }
    @objc func buttonClicked() {
        checkCameraPermission()
        
    }
    
    func checkCameraPermission() {
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            
        case .notDetermined:
            // request
            
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else {
                    return
                }
                
                DispatchQueue.main.async {
                    self?.setUpCamera()
                }
            }
            
        case .restricted:
            break
        case .denied:
            break
        case .authorized:
            setUpCamera()
            
        @unknown default:
            break
        }
        
    }
    
    
    
    
//    func checkCameraPermission() {
//        switch AVCaptureDevice.authorizationStatus(for: .video) {
//        case .authorized:
//            // Kamera erişimi zaten verilmiş.
//            setupCamera()
//            print("Kamera İzni Var")
//            
//
//        case .notDetermined:
//            // Kullanıcı henüz izin vermedi, izin iste.
//            AVCaptureDevice.requestAccess(for: .video) { granted in
//                if granted {
////                    self.setupCamera()
//                    
//                    print("Kamera İzni Verildi")
//                } else {
//                    // Kullanıcı izin vermedi.
//                    
//                    print("Kamera İzni Verilmedi")
//                }
//            }
//        case .denied, .restricted:
//            // Kamera erişimi reddedildi veya kısıtlandı.
//            // Kullanıcıyı ayarlara yönlendirerek izin isteyebilirsiniz.
//            
//            print("Kamera İzni Kısıtlandı")
//            break
//        @unknown default:
//            break
//        }
//    }
    
    func setUpCamera() {
            
        }
    
}
