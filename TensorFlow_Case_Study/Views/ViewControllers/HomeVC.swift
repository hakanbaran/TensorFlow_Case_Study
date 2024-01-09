//
//  HomeVC.swift
//  TensorFlow_Case_Study
//
//  Created by Hakan Baran on 5.01.2024.
//

import UIKit
import AVFoundation



class HomeVC: UIViewController, CameraDelegate {
    
    
    
    var session: AVCaptureSession?
    var output = AVCapturePhotoOutput()
    
    private let appIcon: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "2")
        return image
    }()
    
    private let appTittle: UILabel = {
        let label = UILabel()
        label.text = "DDTechVision"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private let cameraButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.backgroundColor = UIColor(hex: "#248CB3")
        let image = UIImage(systemName: "camera")
        var scaledImage = image?.scaledToHalf()
        scaledImage = scaledImage?.withTintColor(.white)
        button.setImage(scaledImage, for: .normal)
        button.layer.cornerRadius = 30
        button.layer.shadowColor = UIColor.white.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.shadowOpacity = 0.5
        button.layer.shadowRadius = 2
        button.layer.borderWidth = 0.2
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Deneme"
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.text = "%79"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        return label
    }()
    
    private var objectResultImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        imageView.tintColor = .clear
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.layer.shadowColor = UIColor.white.cgColor
        imageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        imageView.layer.shadowOpacity = 0.5
        imageView.layer.shadowRadius = 2
        imageView.layer.borderWidth = 0.2
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#0C1B3A")
        view.addSubview(appIcon)
        view.addSubview(appTittle)
        view.addSubview(cameraButton)
        view.addSubview(nameLabel)
        view.addSubview(scoreLabel)
        view.addSubview(objectResultImage)
        cameraButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let width = view.frame.width
        let height = view.frame.height
        appIcon.frame = CGRect(x: width/20, y: width/8, width: width/8, height: width/8)
        appTittle.frame = CGRect(x: width/16+width/8+width/40, y: width/8, width: width/2, height: height/20)
        cameraButton.frame = CGRect(x: width-width/2+width/12, y: height-height/7, width: width/5, height: width/5)
        cameraButton.layer.cornerRadius = width/10
        objectResultImage.frame = CGRect(x: width/2-width/3, y: width/4+width/8, width: width/1.5, height: (width/1.5)*1.8)
        nameLabel.frame = CGRect(x: width/2-width/8, y: (width/1.5)*1.8+width/8+width/8+width/8, width: width/4, height: width/8)
        scoreLabel.frame = CGRect(x: width/2-width/8, y: (width/1.5)*1.8+width/4+width/8+width/8, width: width/4, height: width/8)
    }
    
    @objc func buttonClicked() {
        let vc = CameraVC()
        vc.delegate = self
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func didCaptureScore(_ objectName: String, objectScore: Int, objectImage: UIImage) {
        print("Hakanbaran***** \(objectName)")
        
        DispatchQueue.main.async {
            self.nameLabel.text = objectName
            self.scoreLabel.text = "% \(objectScore)"
            self.objectResultImage.image = objectImage
        }
        
        }
}




