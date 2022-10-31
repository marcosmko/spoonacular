//
//  Request.swift
//  Spoonacular
//
//  Created by Marcos Kobuchi on 31/10/22.
//

import Foundation

struct Request {
    
    enum Method: String {
        case post = "POST"
        case get = "GET"
        case patch = "PATCH"
        case delete = "DELETE"
    }
    
    let method: Method
    let action: String
    let params: [String: CustomStringConvertible]
    let headers: [String: CustomStringConvertible]
    
    static func post(_ action: String, params: [String: CustomStringConvertible] = [:], headers: [String: CustomStringConvertible] = [:]) -> Request {
        return Request(method: .post, action: action, params: params, headers: headers)
    }
    
    static func get(_ action: String, params: [String: CustomStringConvertible] = [:], headers: [String: CustomStringConvertible] = [:]) -> Request {
        return Request(method: .get, action: action, params: params, headers: headers)
    }
    
    static func patch(_ action: String, params: [String: CustomStringConvertible] = [:], headers: [String: CustomStringConvertible] = [:]) -> Request {
        return Request(method: .patch, action: action, params: params, headers: headers)
    }
    
    static func delete(_ action: String, params: [String: CustomStringConvertible] = [:], headers: [String: CustomStringConvertible] = [:]) -> Request {
        return Request(method: .delete, action: action, params: params, headers: headers)
    }
    
    private init(method: Method, action: String, params: [String: CustomStringConvertible], headers: [String: CustomStringConvertible]) {
        self.method = method
        self.action = action
        self.params = params
        self.headers = headers
    }
    
    public func copyWith(params: [String: CustomStringConvertible]? = nil, headers: [String: CustomStringConvertible]? = nil) -> Request {
        return Request(method: self.method, action: self.action, params: params ?? self.params, headers: headers ?? self.headers)
    }
    
}
