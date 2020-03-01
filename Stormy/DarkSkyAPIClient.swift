//
//  DarkSkyAPIClient.swift
//  Stormy
//
//  Created by Francisco Ozuna on 2/21/20.
//  Copyright © 2020 Treehouse. All rights reserved.
//

import Foundation

class DarkSkyAPIClient {
    fileprivate let darkSkyApiKey = "c4b31fae784f652c98aab5578b86a9df"
    
    lazy var baseURL: URL = {
        return URL(string: "https://api.darksky.net/forecast/\(self.darkSkyApiKey)/")! // we can access the darkSkyAPIKey stored property from inside here because its a lazy property that is actually created some point after intialization. Force unwrapping okay here because if it doesn't work, if we have an incorrect URL, we want it to crash because we want to capture this early on we don't want the app to just stay inactive because our base URL, the thing that handles all the networks calls, is incorrect.
    }()
    
    let downloader = JSONDownloader()
    
    typealias CurrentWeatherCompletionHandler = (CurrentWeather?, DarkSkyError?) -> Void
    
    // the below methods interacts with the API and returns either an error or a populated instance of current weather.
    func getCurrentWeather(at coordinate: Coordinate, completionHandler completion: @escaping CurrentWeatherCompletionHandler) {
     // since this method is going to be calling methods that are asynchronous closure based methods, we need to povide a completion handler for this method as well, so that we can provide some code to execute in the background whenever the work's complete. Since this closure is also executed after the body of this function is executed, we need to specify that this completion closure is escaping. We can't have both arguments (CurentWeather and DarkSkyError) containing non-nil values at any given point so we need to make them both optional.
        guard let url = URL(string: coordinate.description, relativeTo: baseURL) else {
            completion(nil, .invalidUrl)
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = downloader.jsonTask(with: request) { json, error in // completion handler written as a trailing closure 
            
        }
    }
}
