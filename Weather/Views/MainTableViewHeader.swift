import UIKit
import CoreLocation

final class MainTableViewHeader: UIView {
    
    private let locationManager = CLLocationManager()
    private let networkService = DataFetcherService()
    private var weatherModel: WeatherModel?
    
    private let locationNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = ""
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 30, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let currentTempLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = ""
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 90, weight: .thin)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = ""
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let highTempLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = ""
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lowTempLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = ""
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(locationNameLabel)
        addSubview(currentTempLabel)
        addSubview(descriptionLabel)
        addSubview(highTempLabel)
        addSubview(lowTempLabel)
        addConstraints()
        setupLocationManager()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            currentTempLabel.widthAnchor.constraint(equalTo: self.widthAnchor),
            currentTempLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            currentTempLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            currentTempLabel.heightAnchor.constraint(equalToConstant: 70),
            
            locationNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            locationNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            locationNameLabel.heightAnchor.constraint(equalToConstant: 50),
            locationNameLabel.bottomAnchor.constraint(equalTo: currentTempLabel.topAnchor, constant: -40),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 50),
            descriptionLabel.topAnchor.constraint(equalTo: currentTempLabel.bottomAnchor, constant: 20),
            
            lowTempLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            lowTempLabel.widthAnchor.constraint(equalTo: self.currentTempLabel.widthAnchor, multiplier: 0.3),
            lowTempLabel.heightAnchor.constraint(equalToConstant: 50),
            lowTempLabel.trailingAnchor.constraint(equalTo: self.centerXAnchor),
            
            highTempLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            highTempLabel.widthAnchor.constraint(equalTo: self.currentTempLabel.widthAnchor, multiplier: 0.3),
            highTempLabel.heightAnchor.constraint(equalToConstant: 50),
            highTempLabel.leadingAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

// MARK: - CLLocationManagerDelegate

extension MainTableViewHeader: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        locationManager.stopUpdatingLocation()
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        networkService.fetchWeatherData(latitude: latitude, longitude: longitude) { [weak self] (weather) in
            guard let self = self,
                  let weather = weather,
                  let currentWeather = weather.current.weather.first,
                  let dailytWeather = weather.daily.first else { return }
            
            self.locationNameLabel.text = weather.timezone.deletingPrefix()
            self.currentTempLabel.text = String(format: "%.f", weather.current.temp) + "°"
            self.descriptionLabel.text = currentWeather.descriptionWeather.firstCapitalized
            self.lowTempLabel.text = "Min: " + String(format: "%.f", dailytWeather.temp.min) + "°"
            self.highTempLabel.text = "Max: " + String(format: "%.f", dailytWeather.temp.max) + "°"
            self.weatherModel = weather
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Can't get location", error)
    }
}
