//
//  URLSessionExtension.swift
//  Spoonacular
//
//  Created by Marcos Kobuchi on 31/10/22.
//

import Foundation

extension URLSession {
    
    func performSynchronousRequest(_ request: URLRequest) -> (data: Data?, response: HTTPURLResponse?, error: Error?) {
        var serverData: Data?
        var serverResponse: URLResponse?
        var serverError: Error?
        
        let semaphore: DispatchSemaphore = DispatchSemaphore(value: 0)
        
        self.dataTask(with: request, completionHandler: { data, response, error -> Void in
            serverData = data
            serverResponse = response
            serverError = error
            
            semaphore.signal()
        }).resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        
        return (serverData, serverResponse as? HTTPURLResponse, serverError)
    }
    
}
