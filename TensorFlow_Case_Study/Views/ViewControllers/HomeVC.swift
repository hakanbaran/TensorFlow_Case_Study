//
//  HomeVC.swift
//  TensorFlow_Case_Study
//
//  Created by Hakan Baran on 5.01.2024.
//

import UIKit
import AVFoundation


class HomeVC: UIViewController {
    
    
    
    var session: AVCaptureSession?
    var output = AVCapturePhotoOutput()
    
    let previewLayer = AVCaptureVideoPreviewLayer()
    
    
    private let cameraButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("", for: .normal)
        
        button.backgroundColor = UIColor(hex: "#248CB3")
        let image = UIImage(systemName: "basket")
        button.setImage(image, for: .normal)
        button.layer.cornerRadius = 30
        button.layer.shadowColor = UIColor.white.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.shadowOpacity = 0.5
        button.layer.shadowRadius = 2
        button.layer.borderWidth = 0.2
        button.layer.borderColor = UIColor.white.cgColor
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#0C1B3A")
        view.addSubview(cameraButton)
        view.layer.addSublayer(previewLayer)
        cameraButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let width = view.frame.width
        let height = view.frame.height
        
        previewLayer.frame = CGRect(x: 0, y: 100, width: view.frame.width, height: view.frame.height-100)
        
        cameraButton.frame = CGRect(x: width-width/2+width/12, y: height-height/7, width: width/5, height: width/5)
        cameraButton.layer.cornerRadius = width/10
    }
    @objc func buttonClicked() {
        let vc = CameraVC()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}
