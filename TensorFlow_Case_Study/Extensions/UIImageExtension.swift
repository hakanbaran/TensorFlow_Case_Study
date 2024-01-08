//
//  UIImageExtension.swift
//  TensorFlow_Case_Study
//
//  Created by Hakan Baran on 8.01.2024.
//

import Foundation
import UIKit


extension UIImage {
    func scaledToHalf() -> UIImage? {
        let newSize = CGSize(width: size.width * 2, height: size.height * 2)
        UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: newSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
