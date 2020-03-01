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
    
    typealias WeatherCompletionHandler = (Weather?, DarkSkyError?) -> Void
    typealias CurrentWeatherCompletionHandler = (CurrentWeather?, DarkSkyError?) -> Void
    
    // the below methods interacts with the API and returns either an error or a populated instance of current weather.
    private func getWeather(at coordinate: Coordinate, completionHandler completion: @escaping WeatherCompletionHandler) {
     // since this method is going to be calling methods that are asynchronous closure based methods, we need to povide a completion handler for this method as well, so that we can provide some code to execute in the background whenever the work's complete. Since this closure is also executed after the body of this function is executed, we need to specify that this completion closure is escaping. We can't have both arguments (CurentWeather and DarkSkyError) containing non-nil values at any given point so we need to make them both optional.
        guard let url = URL(string: coordinate.description, relativeTo: baseURL) else {
            completion(nil, .invalidUrl)
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = downloader.jsonTask(with: request) { json, error in // completion handler written as a trailing closure
            // the below body of code happens when networking is done, after the data task is finished. This means that anything beyond this point, which is converting from model to JSON, doesn't need to be handled on a background thread, and it is a good point here to jump back onto the main thread.
            
            DispatchQueue.main.async { // asynchronously we want to execute all of the code below. So dispatch queueis a type that manages the execution of work items, which is basically code. Each work item submitted to a queue, is processed on a pool of threads managed by the system. So here we are using the type property, main, to get access to the main thread, and then calling the async function. The function takes a closure, and whatever code we put in here is run asynchronously on the main thread. 
                guard let json = json else {
                    // because we defined the body of the closure in the data task method, we know that this closure can never be called with both the arguments set to nil. So if our json is nil here, then we absolutely do have an error. Since the error argument for the compleion handler of getWeather is also optional and of the same type, we can just funnel this through.
                    completion(nil, error)
                    return
                }
                
                // using a guard statement to create an instance of weather. This is not necessary since weather's initializer is failable, we'll get an optional back but because the argument type in the completion handler also has an optional weather insance, we could simply call it and provide he result nil or not. The issue though is that if weather is nil, we don't provide an error at the call site. So now we do have a case at our final call site where both the model instance and the error value are nil, which is useless.
                guard let weather = Weather(json: json) else {
                    // for the else clause of this guard statement, we need to indicate that we failed at parsing the json correctly which is just a mater of calling the completion handler providing nil for the model instance and indicating that the error here is a jsonParsingFailure.
                    completion(nil, .jsonParsingFailure)
                    return
                }
                
                // we now have a valid model insance
                completion(weather, nil)
                
                // remeber: we aren't executing anything here, and no networking call will be made, we still need to call resume on the task.
            }
            
        }
        
        task.resume() // if we call this method, we have an instance of weather to work with at the end, not current weather which is what we want. since we made this method private, we can't call it from our ViewController, to account for this we add another method below (getCurrentWeather).
    }
    
    func getCurrentWeather(at coordinate: Coordinate, completionHandler completion: @escaping CurrentWeatherCompletionHandler) {
        getWeather(at: coordinate) { weather, error in  // for the completion handler we actually do need to provide a body that defines what we want to do with the potential weather instance or error object.
            completion(weather?.currently, error)
        }
    }
}
