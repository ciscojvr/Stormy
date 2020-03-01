//
//  Weather.swift
//  Stormy
//
//  Created by Francisco Ozuna on 2/29/20.
//  Copyright © 2020 Treehouse. All rights reserved.
//

import Foundation

struct Weather {
    let currently: CurrentWeather
}

extension Weather {
    init?(json: [String: AnyObject]) {
        guard let currentWeatherJson = json["currently"] as? [String:AnyObject], let currentWeather = CurrentWeather(json: currentWeatherJson) else {
            return nil
        }
        
        self.currently = currentWeather
    }
}
