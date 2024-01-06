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
        let vc = CameraVC()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}
