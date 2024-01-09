//
//  APICaller.swift
//  TensorFlow_Case_Study
//
//  Created by Hakan Baran on 8.01.2024.
//

import Foundation
import Alamofire

class APICaller {
    
    static let shared = APICaller()
    
    func request<T: Decodable>(_ url: String, method: HTTPMethod, parameters: Parameters? = nil, headers: HTTPHeaders? = nil, completion: @escaping (Result<T, Error>) -> Void) {
        AF.request(url, method: method, parameters: parameters, headers: headers)
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
}
