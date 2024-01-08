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
        
        navHome.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "person"), tag: 1)
        
        navHome.navigationBar.prefersLargeTitles = true
        
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
        shape.fillColor = UIColor.red.cgColor
        
        shape.shadowColor = UIColor.white.cgColor
        shape.shadowOffset = CGSize(width: 0, height: 0)
        shape.shadowOpacity = 0.5
        shape.shadowRadius = 3
        shape.cornerRadius = 15
        shape.borderWidth = 0.2
        shape.borderColor = UIColor.darkGray.cgColor
        
        self.tabBar.layer.insertSublayer(shape, at: 0)
        self.tabBar.itemWidth = 40
        self.tabBar.itemPositioning = .centered
        self.tabBar.itemSpacing = 180
        self.tabBar.tintColor = UIColor.white
    }
    
    func getPathForTabBar() -> UIBezierPath {
        
            let frameWidth = self.tabBar.bounds.width
        let frameHeight = self.tabBar.bounds.height + 150
        
        print(frameWidth)
        let holeWidth = 200
        let holeHeight = 75
            let leftXUntilHole = Int(frameWidth)-230
            
            let path : UIBezierPath = UIBezierPath()
        
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: leftXUntilHole , y: 0)) // 1.Line
            path.addCurve(to: CGPoint(x: leftXUntilHole + (holeWidth/3), y: holeHeight/2), controlPoint1: CGPoint(x: leftXUntilHole + ((holeWidth/3)/8)*6,y: 0), controlPoint2: CGPoint(x: leftXUntilHole + ((holeWidth/3)/8)*8, y: holeHeight/2)) // part I
            
            path.addCurve(to: CGPoint(x: leftXUntilHole + (2*holeWidth)/3, y: holeHeight/2), controlPoint1: CGPoint(x: leftXUntilHole + (holeWidth/3) + (holeWidth/3)/3*2/5, y: (holeHeight/2)*6/4), controlPoint2: CGPoint(x: leftXUntilHole + (holeWidth/3) + (holeWidth/3)/3*2 + (holeWidth/3)/3*3/5, y: (holeHeight/2)*6/4)) // part II
            
            path.addCurve(to: CGPoint(x: leftXUntilHole + holeWidth, y: 0), controlPoint1: CGPoint(x: leftXUntilHole + (2*holeWidth)/3,y: holeHeight/2), controlPoint2: CGPoint(x: leftXUntilHole + (2*holeWidth)/3 + (holeWidth/3)*2/8, y: 0))
            path.addLine(to: CGPoint(x: frameWidth, y: 0))
            path.addLine(to: CGPoint(x: frameWidth, y: frameHeight))
            path.addLine(to: CGPoint(x: 0, y: frameHeight))
            path.addLine(to: CGPoint(x: 0, y: 0))
            path.close()
            return path
        }
    
}
