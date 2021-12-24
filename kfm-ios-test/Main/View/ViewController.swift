//
//  ViewController.swift
//  kfm-ios-test
//
//  Created by Yudha on 22/12/21.
//

import UIKit
import Combine
import CoreLocation
import Kingfisher
import DropDown

class ViewController: UIViewController, Storyboarded {

    var bag: [AnyCancellable] = []
    var viewModel: MainViewModel!
    var locationManager: CLLocationManager?
    let dropdown = DropDown()
    
    @IBOutlet weak var areaDropdown: UITextField!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var weatherTempLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var windIcon: UIImageView!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var humidityIcon: UIImageView!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var day1Label: UILabel!
    @IBOutlet weak var day2Label: UILabel!
    @IBOutlet weak var day3Label: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        areaDropdown.delegate = self
        
        setupNavigationBar()
        setupLocation()
        
        handleWeatherData()
        configureDropdown()
    }
    
    func setupNavigationBar() {
        let placeButton = UIBarButtonItem(image: UIImage(named: "place"), style: .plain, target: self, action: #selector(placeButtonTapped))
        let settingButton = UIBarButtonItem(image: UIImage(named: "settings"), style: .plain, target: self, action: #selector(settingButtonTapped))
        
        placeButton.tintColor = .black
        settingButton.tintColor = .black
        
        self.navigationItem.leftBarButtonItem = placeButton
        self.navigationItem.rightBarButtonItem = settingButton
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        self.title = "Weather App"
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
            self.configureCurrentView(data: value)
        }
        .store(in: &bag)
    }
    
    func configureCurrentView(data: Weather) {
        areaDropdown.text = data.location.name
        weatherIcon.kf.setImage(with: URL(string: "https:" + data.current.condition.icon))
        weatherLabel.text = data.current.condition.text
        weatherTempLabel.text = viewModel.getTempValue(.celsius, value: data.current.tempCelcius)
        windLabel.text = "\(data.current.windKph) km/h"
        humidityLabel.text = "\(data.current.humidity)%"
        
        day1Label.text = viewModel.getTodayDate()
        day2Label.text = viewModel.getDate(data.forecast.forecastDay[1].date)
        day3Label.text = viewModel.getDate(data.forecast.forecastDay[2].date)
    }
    
    func configureDropdown() {
        dropdown.anchorView = areaDropdown
        dropdown.dataSource = ["Jakarta", "California", "Las Vegas"]
    }
    
    @objc func placeButtonTapped() {
        
    }
    
    @objc func settingButtonTapped() {
        
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

extension ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        dropdown.show()
    }
}
