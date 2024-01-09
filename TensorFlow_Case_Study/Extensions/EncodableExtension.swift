//
//  EncodableExtension.swift
//  TensorFlow_Case_Study
//
//  Created by Hakan Baran on 8.01.2024.
//

import Foundation

public typealias Parameters = [String: Any]

public extension Encodable {
    
    func getParameters() -> [String: Any] {
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(AnyEncodable(self))
            let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? Parameters
            if let jsonValue = json {
                return jsonValue
            }
        } catch { }
        return [String: Any]()
    }
}

extension Encodable {

    fileprivate func encode(to container: inout SingleValueEncodingContainer) throws {
        try container.encode(self)
    }
}

struct AnyEncodable: Encodable {

    var value: Encodable

    init(_ value: Encodable) {
        self.value = value
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try value.encode(to: &container)
    }

}
