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

    enum SelectedButton {
        case first, second, third
    }
    
    var bag: [AnyCancellable] = []
    var viewModel: MainViewModel!
    var locationManager: CLLocationManager?
    let dropdown = DropDown()
    
    var currentWeatherData: Weather!
    var forecastDay: [WeatherForecastDay] = []
    var selectedDay: WeatherForecastDay?
    var currentTemp = UnitTemperature.celsius
    
    var cities = [
        "Jakarta",
        "Tokyo",
        "New York",
        "Berlin",
        "London",
        "Bangkok",
        "Kuala Lumpur",
        "Singapore",
        "Washington"
    ]
    
    @IBOutlet weak var areaDropdown: UITextField!
    @IBOutlet weak var weatherTimeLabel: UILabel!
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
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.scrollDirection = .horizontal
            
            collectionView.collectionViewLayout = flowLayout
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            
            let cell = UINib(nibName: "WeatherCell", bundle: .main)
            collectionView.register(cell, forCellWithReuseIdentifier: "weatherCell")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupNavigationBar()
        setupLocation()
        setupTabButton()
        
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
    
    func setupTabButton() {
        let day1Gesture = UITapGestureRecognizer(target: self, action: #selector(day1Tapped))
        let day2Gesture = UITapGestureRecognizer(target: self, action: #selector(day2Tapped))
        let day3Gesture = UITapGestureRecognizer(target: self, action: #selector(day3Tapped))
        
        day1Label.isUserInteractionEnabled = true
        day2Label.isUserInteractionEnabled = true
        day3Label.isUserInteractionEnabled = true
        
        day1Label.addGestureRecognizer(day1Gesture)
        day2Label.addGestureRecognizer(day2Gesture)
        day3Label.addGestureRecognizer(day3Gesture)
        
        toggleTabButton(button: .first)
    }
    
    func toggleTabButton(button: SelectedButton) {
        let normalColor = UIColor(white: 0, alpha: 0.5)
        let highlighterColor = UIColor.black
        
        switch button {
        case .first:
            day1Label.textColor = highlighterColor
            day2Label.textColor = normalColor
            day3Label.textColor = normalColor
        case .second:
            day1Label.textColor = normalColor
            day2Label.textColor = highlighterColor
            day3Label.textColor = normalColor
        case .third:
            day1Label.textColor = normalColor
            day2Label.textColor = normalColor
            day3Label.textColor = highlighterColor
        }
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
            self.currentWeatherData = value
            self.configureCurrentView(data: value)
            self.forecastDay = value.forecast.forecastDay
            self.selectedDay = value.forecast.forecastDay.first
            self.toggleTabButton(button: .first)
            self.collectionView.reloadData()
        }
        .store(in: &bag)
    }
    
    func configureCurrentView(data: Weather) {
        areaDropdown.text = data.location.name
        weatherTimeLabel.text = viewModel.getCurrentTime(data.current.lastUpdated)
        weatherIcon.kf.setImage(with: URL(string: "https:" + data.current.condition.icon))
        weatherLabel.text = data.current.condition.text
        weatherTempLabel.text = viewModel.getTempValue(currentTemp, value: data.current.tempCelcius)
        windLabel.text = "\(data.current.windKph) km/h"
        humidityLabel.text = "\(data.current.humidity)%"
        
        day1Label.text = viewModel.getDate(data.forecast.forecastDay[0].date)
        day2Label.text = viewModel.getDate(data.forecast.forecastDay[1].date)
        day3Label.text = viewModel.getDate(data.forecast.forecastDay[2].date)
        
        let isDay = data.current.isDay
        var color: UIColor!
        
        if isDay == 0 {
            color = viewModel.changeBackgroundColor(isDay: false)
        }
        else {
            color = viewModel.changeBackgroundColor(isDay: true)
        }
        
        UIView.animate(withDuration: 0.5) {
            self.view.backgroundColor = color
        }
    }
    
    func configureDropdown() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let image = UIImage(named: "dropdown")
        imageView.image = image
        
        areaDropdown.delegate = self
        areaDropdown.rightViewMode = .always
        areaDropdown.rightView = imageView
        areaDropdown.tintColor = .black
        areaDropdown.textAlignment = .left
        areaDropdown.layer.borderWidth = 1
        areaDropdown.layer.borderColor = UIColor.black.cgColor
        areaDropdown.layer.cornerRadius = 4
        
        dropdown.anchorView = areaDropdown
        dropdown.dataSource = cities
        
        dropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            viewModel.getForecast(location: item)
        }
    }
    
    func openTempSetting() {
        let ac = UIAlertController(title: "Change Temperature", message: "Select your preferred temperature", preferredStyle: .alert)
        let cAction = UIAlertAction(title: "Celcius", style: .default) { action in
            self.toggleTemp(temp: .celsius)
        }
        let fAction = UIAlertAction(title: "Fahrenheit", style: .default) { action in
            self.toggleTemp(temp: .fahrenheit)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        ac.addAction(cAction)
        ac.addAction(fAction)
        ac.addAction(cancel)
        self.navigationController?.present(ac, animated: true, completion: nil)
    }
    
    func toggleTemp(temp: UnitTemperature) {
        currentTemp = temp
        configureCurrentView(data: currentWeatherData)
        forecastDay = currentWeatherData.forecast.forecastDay
        selectedDay = currentWeatherData.forecast.forecastDay.first
        collectionView.reloadData()
    }
    
    @objc func placeButtonTapped() {
        locationManager?.requestLocation()
    }
    
    @objc func settingButtonTapped() {
        openTempSetting()
    }
    
    @objc func day1Tapped(sender: UITapGestureRecognizer) {
        toggleTabButton(button: .first)
        selectedDay = currentWeatherData.forecast.forecastDay[0]
        collectionView.reloadData()
    }
    
    @objc func day2Tapped(sender: UITapGestureRecognizer) {
        toggleTabButton(button: .second)
        selectedDay = currentWeatherData.forecast.forecastDay[1]
        collectionView.reloadData()
    }
    
    @objc func day3Tapped(sender: UITapGestureRecognizer) {
        toggleTabButton(button: .third)
        selectedDay = currentWeatherData.forecast.forecastDay[2]
        collectionView.reloadData()
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

extension ViewController: UICollectionViewDelegate {
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weatherCell", for: indexPath) as! WeatherCell
        
        cell.contentView.layer.borderWidth = 1
        cell.contentView.layer.borderColor = UIColor.black.cgColor
        cell.contentView.layer.cornerRadius = 4
        cell.contentView.backgroundColor = UIColor(white: 1, alpha: 0.5)
        
        guard let hour = selectedDay?.hour[indexPath.row] else {
            return cell
        }
        
        cell.timeLabel.text = viewModel.getTime(hour.time)
        cell.weatherIcon.kf.setImage(with: URL(string: "https:" + hour.condition.icon))
        cell.tempLabel.text = viewModel.getTempValue(currentTemp, value: hour.tempC)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedDay?.hour.count ?? 0
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.size.width / 3) - 16, height: collectionView.bounds.height - 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
}
