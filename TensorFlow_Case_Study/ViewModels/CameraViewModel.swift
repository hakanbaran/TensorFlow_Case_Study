//
//  CameraViewModel.swift
//  TensorFlow_Case_Study
//
//  Created by Hakan Baran on 9.01.2024.
//

import Foundation
import AVFoundation
import UIKit

class CameraViewModel {

    var objectName: String?
    var objectScore: Float?
    var objectImage: UIImage?
    
    var isLoadingOn: Bool = false {
        didSet {
            onLoadingChanged?(isLoadingOn)
        }
    }
    
    var onLoadingChanged: ((Bool) -> Void)?
    
    func uploadImage( completion: @escaping (Bool) -> Void) {
        let data = self.objectImage?.pngData()
        let uploadURL = "http://localhost:3000/api/object-detection/upload"
        let uploadImageParameters = UploadImageModel(classname: objectName, image: data)
        DispatchQueue.main.async {
            self.isLoadingOn = true
        }
        
        APICaller.shared.request(uploadURL, method: .post, parameters: uploadImageParameters.getParameters()) { (result: Result<UploadImageresponseModel, Error>) in
            DispatchQueue.main.asyncAfter(deadline: .now()+1.5) {
                self.isLoadingOn = false
            }
            switch result {
            case .success(let response):
                print(response)
                completion(true)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                completion(true)
            }
        }
    }
    
    func logIn() {
        DispatchQueue.main.async {
            self.isLoadingOn = true
        }
        let requestParameters = LogInRequestModel(organizationCode: "TEST", email: "test@ddtech.com.tr", password: "Test")
        APICaller.shared.request("http://localhost:3000/api/object-detection/upload", method: .post, parameters: requestParameters.getParameters()) { (result: Result<LogInModel, Error>) in
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                self.isLoadingOn = false
            }
            switch result {
            case .success(let user):
                if let userToken = user.data?.accessToken?.token {
                    AuthManager.shared.token = userToken
                }
                print(user)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
