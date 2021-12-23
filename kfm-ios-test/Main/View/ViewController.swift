//
//  ViewController.swift
//  kfm-ios-test
//
//  Created by Yudha on 22/12/21.
//

import UIKit
import Combine
import CoreLocation

class ViewController: UIViewController, Storyboarded {

    var bag: [AnyCancellable] = []
    var viewModel: MainViewModel!
    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupLocation()
        
        handleWeatherData()
    }
    
    func setupLocation() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        locationManager?.requestLocation()
    }
    
    func handleWeatherData() {
        viewModel.weatherData.sink { completion in
            switch completion {
            case .finished:
                print("Get forecase finished")
                
            case .failure(let error):
                print("Received error: \(error)")
            }
        } receiveValue: { value in
            print(value.location.region)
        }
        .store(in: &bag)
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationManager?.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            
            viewModel.getForecast(location: "\(lat),\(lon)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
}

