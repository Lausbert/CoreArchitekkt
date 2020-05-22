//
//  String.swift
//  SwiftArchitekkt
//
//  Created by Stephan Lerner on 22.02.20.
//

import Foundation

public extension Optional where Wrapped == String {

    init?(optionalData: Data?, encoding: String.Encoding) {
        if let data = optionalData {
            self = String.init(data: data, encoding: encoding)
        } else {
            self = nil
        }
    }

}
