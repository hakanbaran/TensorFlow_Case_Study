//
//  PopUpVC.swift
//  TensorFlow_Case_Study
//
//  Created by Hakan Baran on 7.01.2024.
//

import UIKit

class PopUpVC: UIViewController {
    
    private let popUpView: UIView = {
        let view = UIView()
        view.backgroundColor = .brown
        return view
    }()
    
    private let objectName: UILabel = {
        let label = UILabel()
        label.text = "CAMERA"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        view.addSubview(popUpView)
        popUpView.addSubview(objectName)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let width = view.frame.width
        let height = view.frame.height
        
        popUpView.frame = CGRect(x: width/2-width/4, y: height/2-height/4, width: width/2, height: height/2)
        objectName.frame = CGRect(x: width/2-width/4, y: height/2-height/4, width: width/2, height: height/2)
    }
}
