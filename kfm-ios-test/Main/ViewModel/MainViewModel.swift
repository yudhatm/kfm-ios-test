//
//  MainViewModel.swift
//  kfm-ios-test
//
//  Created by Yudha on 23/12/21.
//

import Foundation
import Combine

final class MainViewModel {
    let weatherData = PassthroughSubject<Weather, Error>()
    var weatherObservable: AnyCancellable?
    
    func getCurrentLocation() {
        
    }
    
    func getForecast(location: String) {
        let param: [String: Any] = ["key": URLs.apiKey, "q": location]
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
}
