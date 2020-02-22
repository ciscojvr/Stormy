//
//  JSONDownloader.swift
//  Stormy
//
//  Created by Francisco Ozuna on 2/20/20.
//  Copyright © 2020 Treehouse. All rights reserved.
//

import Foundation

class JSONDownloader {
    let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init(){
        self.init(configuration: .default)
    }
    
    typealias JSON = [String: AnyObject]
    typealias JSONTaskCompletionHandler = (JSON?, DarkSkyError?)-> Void
    
    // Because this closure will be executed after the function has been called, particularly since we're going to be returning the DataTask, holding onto these closures, and then calling resume at some other point, we need to mark these closures as @escaping.
    // We made JSON and DarkSkyError optional below because when we have valid JSON data to work with, presumably we won't have any error. Similarly, if something goes wrong, and we end up with an error, we won't have any valid JSON. So in a given situation its impossible to have values for both arguments. They are optional because when one has a value, the other can be nil and vice-versa.
    // Link: https://teamtreehouse.com/library/inspecting-the-network-response-2
    func jsonTask(with request: URLRequest, completionHandler completion: @escaping JSONTaskCompletionHandler) -> URLSessionDataTask {
        let task = session.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, .requestFailed)
                return
            }
            
            if httpResponse.statusCode == 200 {
                // Because of the implicit conventions on the Objective-C side of things, the Error object could be empty even when the data is nil. So we first want to check that we have a valid data object.
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? JSON
                        completion(json, nil)
                    } catch {
                        completion(nil, .jsonParsingFailure)
                    }
                } else {
                    completion(nil, .invalidData)
                }
            } else {
                completion(nil, .responseUnsuccessful(statusCode: httpResponse.statusCode))
            }
        }
        return task
    }
}
