//
//  MainViewModel.swift
//  kfm-ios-test
//
//  Created by Yudha on 23/12/21.
//

import Foundation
import Combine
import UIKit

final class MainViewModel {
    let weatherData = PassthroughSubject<Weather, Error>()
    var weatherObservable: AnyCancellable?
    
    func getForecast(location: String) {
        let param: [String: Any] = ["key": URLs.apiKey, "q": location, "days": 3]
        weatherObservable = NetworkManager.shared.getForecast(parameters: param)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    print("Get Forecast finished")
                    
                case .failure(let error):
                    self?.weatherData.send(completion: .failure(error))
                }
            }, receiveValue: { [weak self] value in
                self?.weatherData.send(value)
            })
    }
    
    func getTempValue(_ temp: UnitTemperature, value: Double) -> String {
        switch temp {
        case .celsius:
            return "\(value)°"
            
        case .fahrenheit:
            return "\(value)°F"
            
        default:
            return "\(value)°"
        }
    }
    
    func getDate(_ date: String) -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let newDate = df.date(from: date)
        
        df.dateFormat = "E, dd MMM"
        return df.string(from: newDate ?? Date())
    }
    
    func getTodayDate() -> String {
        let df = DateFormatter()
        df.dateFormat = "dd MMM"
        return "Today, " + df.string(from: Date())
    }
    
    func getTime(_ date: String) -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm"
        let newDate = df.date(from: date)
        
        df.dateFormat = "HH:mm"
        return df.string(from: newDate ?? Date())
    }
    
    func getCurrentTime(_ date: String) -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm"
        let newDate = df.date(from: date)
        
        df.dateFormat = "dd MMM yyyy, HH:mm"
        return df.string(from: newDate ?? Date())
    }
    
    func changeBackgroundColor(isDay: Bool) -> UIColor {
        if isDay {
            return UIColor(red: 255/255, green: 219/255, blue: 0/255, alpha: 1)
        } else {
            return UIColor(red: 102/255, green: 102/255, blue: 153/255, alpha: 1)
        }
    }
}
