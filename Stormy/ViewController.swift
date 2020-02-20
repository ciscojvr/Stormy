//
//  ViewController.swift
//  Stormy
//
//  Created by Pasan Premaratne on 5/8/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var currentHumidityLabel: UILabel!
    @IBOutlet weak var currentPrecipitationLabel: UILabel!
    @IBOutlet weak var currentWeatherIcon: UIImageView!
    @IBOutlet weak var currentSummaryLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    fileprivate let darkSkyApiKey = "c4b31fae784f652c98aab5578b86a9df"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let base = URL(string: "https://api.darksky.net/forecast/\(darkSkyApiKey)/")
        guard let forecastUrl = URL(string: "37.8267,-122.4233", relativeTo: base) else {
            return
        }
        
//        let configuration = URLSessionConfiguration.default
//        let session = URLSession(configuration: configuration)
//        same as
        let request = URLRequest(url: forecastUrl) // this creates an HTTP request that defaults to a GET request. this returns immediately. its a synchronous method, it has a return value that we can assign to a constant.
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: request) { data, response, error in
            print(data)
        }// what is being returned here is not a return type from executing the network request. we're just creating the task.
        // these methods are asyncrhonous
        // a completion handler is a closure that we define containing the logic of what we want to do after this request
        // has completed. It has no return type because when we write asynchronous code, because it happens in the background,
        // we cannot contorl when our code is executed. The closure doesn't give us a data object back because its not going to
        // to finish right now
        // A closure can capture references to all the object we need and execute the logic at a later time. Closures used
        // in this way are called callbacks.The dataTask is executed, and then when it is done, it calls back to our closure
        // and executes the body.
        // We can implement the same kind of behavior by using the delegate pattern. An object can complete the task ,and when its done it can inform or call back to the delegate. The delegate then performs fruther actions with whateer data is returned.
        
        let currentWeather = CurrentWeather(temperature: 85.0, humidity: 0.8, precipProbability: 0.1, summary: "Hot!", icon: "clear-day")
        
        let viewModel = CurrentWeatherViewModel(model: currentWeather)
        
        displayWeather(using: viewModel)
    }
    
    func displayWeather(using viewModel: CurrentWeatherViewModel) {
        currentTemperatureLabel.text = viewModel.temperature
        currentHumidityLabel.text = viewModel.humidity
        currentPrecipitationLabel.text = viewModel.precipitationProbability
        currentSummaryLabel.text = viewModel.summary
        currentWeatherIcon.image = viewModel.icon
    }
}

