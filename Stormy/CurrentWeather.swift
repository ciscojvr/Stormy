//
//  CurrentWeather.swift
//  Stormy
//
//  Created by Francisco Ozuna on 2/2/20.
//  Copyright © 2020 Treehouse. All rights reserved.
//

import Foundation
import UIKit

struct CurrentWeather: Codable {
    let temperature: Double
    let humidity: Double
    let precipProbability: Double
    let summary: String
    let icon: String
    
//    enum CurrentWeatherCodingKeys: String, CodingKey {
//        // without an explicit type, the compiler infers that the JSON key that it needs to use to get the value for the stored property is the same as the name of stored property itself.
//        // we don't need this custom type though because all its doing is generating the same raw values as the stored property names. So we can get rid of it because we know that it can infer the type automatically. The compiler can. We should get rid of the custom coding keys and let the compiler do all the work for us.
//        case temperature = "temperature"
//        case humidity = "humidity"
//        case precipProbability = "precipProbability"
//        case summary = "summary"
//        case icon = "icon"
//    }
}

extension CurrentWeather {
    var iconImage: UIImage {
        switch icon {
        case "clear-day": return #imageLiteral(resourceName: "clear-day")
        case "clear-night": return #imageLiteral(resourceName: "clear-night")
        case "rain": return #imageLiteral(resourceName: "rain")
        case "snow": return #imageLiteral(resourceName: "snow")
        case "sleet": return #imageLiteral(resourceName: "sleet")
        case "wind": return #imageLiteral(resourceName: "wind")
        case "fog": return #imageLiteral(resourceName: "fog")
        case "cloudy": return #imageLiteral(resourceName: "cloudy")
        case "partly-cloudy-day": return #imageLiteral(resourceName: "default")
        case "partly-cloudy-night": return #imageLiteral(resourceName: "partly-cloudy-night")
        default: return #imageLiteral(resourceName: "default")
        }
    }
}

// Below code no longer needed after conforming to Codable.
//
//extension CurrentWeather {
//    struct Key { // using a nested struct here so that we can avoid resorting to always typing out keys as string which is error-prone. If we use these keys in multiple places, they're defined in one place so rather than having to fix a bunch of different mistakes here and there, we can just fix one. We should remember to always try to avoid stringly typed code where possible.
//        static let temperature = "temperature"
//        static let humidity = "humidity"
//        static let precipitationProbability = "precipProbability"
//        static let summary = "summary"
//        static let icon = "icon"
//    }
//
//    init?(json: [String: AnyObject]) { //failable initializer. Initializers written in an extension of a struct do not override the memberwise initializer, which is what we want here. Having the default init means if I want to test that my model is working as expected, particularly, when setting up the ViewModel, we can just insert some fake data rather than having to resort to making a separate network request where a bunch of other things can go wrong.
//        guard let tempValue = json[Key.temperature] as? Double, // since none of our store properties are optional, if any one of them fails, we return nil
//        let humidityValue = json[Key.humidity] as? Double, // using the same guard statement here because we want all of these to succeed.
//        let precipitationProbabilityValue = json[Key.precipitationProbability] as? Double,
//        let summaryString = json[Key.summary] as? String,
//        let iconString = json[Key.icon] as? String else {
//            return nil
//        }
//
//        self.temperature = tempValue
//        self.humidity = humidityValue
//        self.precipProbability = precipitationProbabilityValue
//        self.summary = summaryString
//        self.icon = iconString
//    }
//}
