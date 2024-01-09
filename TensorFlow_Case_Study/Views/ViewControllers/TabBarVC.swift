//
//  TabBarVC.swift
//  TensorFlow_Case_Study
//
//  Created by Hakan Baran on 6.01.2024.
//

import UIKit

class TabBarVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        let homeVC = HomeVC()
        tabBar.tintColor = .red
        homeVC.navigationItem.largeTitleDisplayMode = .always
        let navHome = UINavigationController(rootViewController: homeVC)
        navHome.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        navHome.navigationBar.prefersLargeTitles = true
        
        
        let width = tabBar.frame.width
        let yOffset: CGFloat = -width/4.5
        navHome.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: yOffset, vertical: 0)
        navHome.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: yOffset, bottom: 0, right: -yOffset)
        setViewControllers([navHome], animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupCustomTabBar()
    }
    
    func setupCustomTabBar() {
        let path : UIBezierPath = getPathForTabBar()
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.fillColor = UIColor(hex: "#162544").cgColor
        shape.shadowColor = UIColor.white.cgColor
        shape.shadowOffset = CGSize(width: 0, height: 0)
        shape.shadowOpacity = 0.5
        shape.shadowRadius = 3
        shape.cornerRadius = 15
        shape.borderWidth = 0.2
        shape.borderColor = UIColor.darkGray.cgColor
        self.tabBar.layer.insertSublayer(shape, at: 0)
        self.tabBar.itemWidth = 80
        self.tabBar.itemPositioning = .fill
        self.tabBar.tintColor = UIColor.white
    }
    
    func getPathForTabBar() -> UIBezierPath {
        
        let frameWidth = self.tabBar.bounds.width
        let frameHeight = self.tabBar.bounds.height + frameWidth/2.76
        let width = view.frame.width
        let holeWidth = Int(width/2.07)
        let holeHeight = Int(width/5.52)
        let leftXUntilHole = Int(frameWidth)-Int(frameWidth/1.8)
        let path : UIBezierPath = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: leftXUntilHole , y: 0))
        path.addCurve(to: CGPoint(x: leftXUntilHole + (holeWidth/3), y: holeHeight/2), controlPoint1: CGPoint(x: leftXUntilHole + ((holeWidth/3)/8)*6,y: 0), controlPoint2: CGPoint(x: leftXUntilHole + ((holeWidth/3)/8)*8, y: holeHeight/2))
        
        path.addCurve(to: CGPoint(x: leftXUntilHole + (2*holeWidth)/3, y: holeHeight/2), controlPoint1: CGPoint(x: leftXUntilHole + (holeWidth/3) + (holeWidth/3)/3*2/5, y: (holeHeight/2)*6/4), controlPoint2: CGPoint(x: leftXUntilHole + (holeWidth/3) + (holeWidth/3)/3*2 + (holeWidth/3)/3*3/5, y: (holeHeight/2)*6/4))
        
        path.addCurve(to: CGPoint(x: leftXUntilHole + holeWidth, y: 0), controlPoint1: CGPoint(x: leftXUntilHole + (2*holeWidth)/3,y: holeHeight/2), controlPoint2: CGPoint(x: leftXUntilHole + (2*holeWidth)/3 + (holeWidth/3)*2/8, y: 0))
        path.addLine(to: CGPoint(x: frameWidth, y: 0))
        path.addLine(to: CGPoint(x: frameWidth, y: frameHeight))
        path.addLine(to: CGPoint(x: 0, y: frameHeight))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.close()
        return path
    }
    
}
