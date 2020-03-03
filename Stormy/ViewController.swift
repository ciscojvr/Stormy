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
    
    // the below is no longer needed
//    fileprivate let darkSkyApiKey = "c4b31fae784f652c98aab5578b86a9df"
    
    let client = DarkSkyAPIClient() // this is going to do most of the work for us

    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentWeather()
    }
    
    func displayWeather(using viewModel: CurrentWeatherViewModel) {
        self.currentTemperatureLabel.text = viewModel.temperature
        self.currentHumidityLabel.text = viewModel.humidity
        self.currentPrecipitationLabel.text = viewModel.precipitationProbability
        self.currentSummaryLabel.text = viewModel.summary
        self.currentWeatherIcon.image = viewModel.icon
    }
        
    @IBAction func getCurrentWeather() {
        toggleRefreshAnimation(on: true)
        client.getCurrentWeather(at: Coordinate.alcatrazIsland) { [unowned self] currentWeather, error in // completion handler as a  trailing closure
                           // below used for testing
                           // print(currentWeather)
                           // print(error)
                           
                           if let currentWeather = currentWeather {
                               let viewModel = CurrentWeatherViewModel(model: currentWeather)
                               self.displayWeather(using: viewModel)
                               self.toggleRefreshAnimation(on: false)
                            // Issues with this code: client is a stored property of the view controller and by calling self over here, the client, the closure that we're passing in is capturing a reference to the view controller as well, which means we have a reference cycle. To avoid this, we need to create a capture list for this closure and specify different memory semantics for self. We do this at the beginning of the closure body by using a set of square braces. But what kind of modfication should we make? If the object being captured had a shorter lifetime than the closure, then we need a weak relationship because at some point self could be nil. If they have the same lifetime, or if the object being captured has a longer lifetime than the closure. Then we capture self as unowned because self can never be nil. In our case, the view controller won't be deallocated before the closure is done. This can happen if we were to allow background downloads. URL session can be configured to continue network tasks in the background even if you exit an app. In such an event, if we were to press the home button and exit the app, the view controller would be deallocated and self would be nil when the closure was eventually executed in the background. What happens if we open the app, fire off a network request, and then immediately home out? Is the data task cancelled? Can we guarantee that the closure is deallocated at the same time as the view controller is? In theory, we should be able to gurantee that because we have not configured our session for background downloads. So we can capture self as unowned, so unowned self.
                           }
                       }
                       // Do any additional setup after loading the view, typically from a nib.
                       
                       // the below is no longer needed
               //        let base = URL(string: "https://api.darksky.net/forecast/\(darkSkyApiKey)/")
               //        guard let forecastUrl = URL(string: "37.8267,-122.4233", relativeTo: base) else {
               //            return
               //        }
               //
               ////        let configuration = URLSessionConfiguration.default
               ////        let session = URLSession(configuration: configuration)
               ////        same as
               //        let request = URLRequest(url: forecastUrl) // this creates an HTTP request that defaults to a GET request. this returns immediately. its a synchronous method, it has a return value that we can assign to a constant.
               //        let session = URLSession(configuration: .default)
               //        let dataTask = session.dataTask(with: request) { data, response, error in
               //            print(data)
               //        }// what is being returned here is not a return type from executing the network request. we're just creating the task.
               //        // these methods are asyncrhonous
               //        // a completion handler is a closure that we define containing the logic of what we want to do after this request
               //        // has completed. It has no return type because when we write asynchronous code, because it happens in the background,
               //        // we cannot contorl when our code is executed. The closure doesn't give us a data object back because its not going to
               //        // to finish right now
               //        // A closure can capture references to all the object we need and execute the logic at a later time. Closures used
               //        // in this way are called callbacks.The dataTask is executed, and then when it is done, it calls back to our closure
               //        // and executes the body.
               //        // We can implement the same kind of behavior by using the delegate pattern. An object can complete the task ,and when its done it can inform or call back to the delegate. The delegate then performs fruther actions with whateer data is returned.
               //
               //        let currentWeather = CurrentWeather(temperature: 85.0, humidity: 0.8, precipProbability: 0.1, summary: "Hot!", icon: "clear-day")
               //
               //        let viewModel = CurrentWeatherViewModel(model: currentWeather)
               //
               //        displayWeather(using: viewModel)
    }
    
    func toggleRefreshAnimation(on: Bool) {
        refreshButton.isHidden = on
        
        if on {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
}

