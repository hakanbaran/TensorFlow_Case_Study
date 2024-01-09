//
//  UploadImageModel.swift
//  TensorFlow_Case_Study
//
//  Created by Hakan Baran on 8.01.2024.
//

import Foundation


/*
 {
     "succededd": true,
     "data": null,
     "errorCodes": null
 }
 */

struct UploadImageModel: Codable {
    
    let classname: String?
    let image: Data?
    
}

struct UploadImageresponseModel: Codable {
    let succededd: Bool?
    let data: String?
    let errorCodes: Int?
}
