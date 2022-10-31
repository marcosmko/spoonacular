//
//  WebApiService.swift
//  Spoonacular
//
//  Created by Marcos Kobuchi on 31/10/22.
//

import Foundation

private enum Environment {
    case production
}

private struct DataRequest<T: Encodable>: Encodable {
    let any: T?
    
    enum CodingKeys: String, CodingKey {
        case any
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try self.any?.encode(to: encoder)
    }
}

class WebApiService {
    
    private static let environment: Environment = .production
    
    static let WEB_API_URL: String = {
        switch WebApiService.environment {
        case .production:
            return "https://api.spoonacular.com/"
        }
    }()
        
    static private let apikey = "68dacdce560d4598baf62743ea86a9a7"
    
    class var controller: String { return "" }
    
    private static func create(method: Request.Method, url: URL, headers: [String: CustomStringConvertible], data: Data) -> URLRequest {
        var request = URLRequest(url: url)
        
        request.httpShouldHandleCookies = false
        request.httpShouldUsePipelining = true
        request.httpMethod = method.rawValue
        
        // TODO: when it's a get method, must convert json data to url params
        if method != .get { request.httpBody = data }
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        for header in headers {
            request.setValue(header.value.description, forHTTPHeaderField: header.key)
        }
        
        return request
    }
    
    private static func process(request: URLRequest) -> (Data?, HTTPURLResponse?, Error?) {
        #if DEBUG
        let startTime = CFAbsoluteTimeGetCurrent()
        self.log(request: request)
        #endif
        
        let session: URLSession = URLSession(configuration: .default, delegate: nil, delegateQueue: .current)
        let (data, response, error) = session.performSynchronousRequest(request)
        
        #if DEBUG
        if let url = request.url?.absoluteString {
            self.log(response: response, url: url, startTime: startTime, data: data)
        }
        #endif
        
        return (data, response, error)
    }
    
    private static func encode<T: Encodable>(entity: T?) throws -> Data {
        let dataRequest: DataRequest = DataRequest(any: entity)
        return try JSONEncoder.default.encode(dataRequest)
    }
    
    private static func decode<T: Decodable>(data: Data) throws -> T {
        return try JSONDecoder.default.decode(T.self, from: data)
    }
    
    @discardableResult
    public static func request(_ request: Request, data: Data? = nil) throws -> Data {
        // On guard! URLComponents does not escape the + sign. https://stackoverflow.com/a/43054388
        func escapeCharacters(from string: String?) -> String? {
            let charactersToEscape = "+/"
            let allowedCharacters = CharacterSet.init(charactersIn: charactersToEscape).inverted
            return string?.addingPercentEncoding(withAllowedCharacters: allowedCharacters)!
        }
        
        var urlComponents = URLComponents(string: self.WEB_API_URL + self.controller + "/" + request.action)
        urlComponents?.queryItems = [URLQueryItem(name: "apiKey", value: self.apikey)]
        for (key, value) in request.params {
            urlComponents?.queryItems?.append(URLQueryItem(name: key, value: value.description))
        }
        let percentEncodedQuery = urlComponents?.percentEncodedQuery
        urlComponents?.percentEncodedQuery = escapeCharacters(from: percentEncodedQuery)
        
        guard let url = urlComponents?.url else {
            throw RequestError.invalidRequest(message: "Domain or path is not a valid URL")
        }
        
        let urlRequest: URLRequest = self.create(
            method: request.method, url: url, headers: request.headers,
            data: try data ?? self.encode(entity: nil as String?)
        )
        let (data, response, error) = self.process(request: urlRequest)
        
        if let response = response {
            if 200 <= response.statusCode && response.statusCode < 300, let data: Data = data {
                return data
            } else if let data: Data = data, let error: ServerError = try? self.decode(data: data) {
                throw error
            } else {
                throw RequestError.serverError(code: response.statusCode, data: data)
            }
        }
        
        if let error = error {
            throw error
        } else {
            throw RequestError.invalidRequest(message: "Invalid request")
        }
    }
    
    @discardableResult
    public static func request<S: Encodable>(_ request: Request, entity: S) throws -> Data {
        return try self.request(request, data: try self.encode(entity: entity))
    }
    
    public static func request<T: Decodable>(_ request: Request) throws -> T {
        let data: Data = try self.request(request, data: nil)
        return try self.decode(data: data)
    }
    
    public static func request<T: Decodable, S: Encodable>(_ request: Request, entity: S) throws -> T {
        let data: Data = try self.request(request, data: try self.encode(entity: entity))
        return try self.decode(data: data)
    }
        
}

#if DEBUG
extension WebApiService {
    
    static func log(request: URLRequest) {
        let components = NSURLComponents(string: request.url?.absoluteString ?? "")
        var message = "\n----------------------------------\n\(request.httpMethod ?? "") \(components?.path ?? "")?\(components?.query ?? "") HTTP/1.1\nHost: \(components?.host ?? "")\n"
        
        for (name, value) in request.allHTTPHeaderFields ?? [:] {
            message += "\(name): \(value)\n"
        }
        
        if let string = request.httpBody?.stringValue {
            message += "\(string)\n"
        }
        
        print("\(message)----------------------------------\n")
    }
    
    static func log(response: URLResponse?, url: String, startTime: CFAbsoluteTime, data: Data?) {
        var message = "\n----------------------------------\nResponse: \(url)\n\((CFAbsoluteTimeGetCurrent() - startTime).humanReadable)\n\n"
        
        if let response = response as? HTTPURLResponse {
            message += "Status Code: \(response.statusCode)\n"
            for (name, value) in response.allHeaderFields {
                message += "\(name): \(value)\n"
            }
            
            if let string = data?.stringValue {
                message += "\(string)\n"
            }
        }
        
        print("\(message)----------------------------------\n")
    }
    
}
#endif
