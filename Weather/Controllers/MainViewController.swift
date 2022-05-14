import UIKit
import CoreLocation

final class MainViewController: UIViewController {
    
    // MARK: - Properties
    
    private let locationManager = CLLocationManager()
    private let networkService = DataFetcherService()
    private var weatherModel: WeatherModel?
    
    //MARK: - UI Elements
    private var headerView: MainTableViewHeader?
    
    private let mainTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .lightBlue
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightBlue
        setupLocationManager()
        setupMainTableView()
        setupMainTableHeader()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainTableView.frame = view.bounds
    }
    
    // MARK: - Setups
    
    private func setupMainTableView() {
        view.addSubview(mainTableView)
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        mainTableView.register(DailyTableViewCell.self,
                               forCellReuseIdentifier: DailyTableViewCell.identifier)
        mainTableView.register(HourlyTableViewCell.self,
                               forCellReuseIdentifier: HourlyTableViewCell.identifier)
        mainTableView.register(InformationTableViewCell.self,
                               forCellReuseIdentifier: InformationTableViewCell.identifier)
        mainTableView.register(DescriptionTableViewCell.self,
                               forCellReuseIdentifier: DescriptionTableViewCell.identifier)
    }
    
    private func setupMainTableHeader() {
        headerView = MainTableViewHeader(
            frame: CGRect(
                x: 0,
                y: 0,
                width: view.width,
                height: view.width
            )
        )
        mainTableView.tableHeaderView = headerView
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return WeatherTableViewSection.numberOfSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = WeatherTableViewSection(sectionIndex: section) else {
            return 0
        }
        
        switch section {
        case .hourly:
            return 1
        case .daily:
            return 7
        case .information:
            return 1
        case .description:
            return descriptionArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = WeatherTableViewSection(sectionIndex: indexPath.section) else { return UITableViewCell() }
        
        switch section {
        case .hourly:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HourlyTableViewCell.identifier, for: indexPath) as? HourlyTableViewCell else { return UITableViewCell() }
            if let weatherModel = weatherModel {
                cell.configure(with: weatherModel)
            }
            
            return cell
            
        case .daily:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DailyTableViewCell.identifier, for: indexPath) as? DailyTableViewCell else { return UITableViewCell() }
            if let weatherModel = weatherModel {
                cell.configure(model: weatherModel)
            }
            
            let viewModel = cell.configureTableViewCellViewModelFor(indexPath.row)
            cell.configure(with: viewModel)
            return cell
            
        case .information:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: InformationTableViewCell.identifier, for: indexPath) as? InformationTableViewCell else { return UITableViewCell() }
            if let weatherModel = weatherModel {
                cell.configure(model: weatherModel)
            }
            
            let viewModel = cell.configureTableViewCellViewModelFor(indexPath.row)
            cell.configure(with: viewModel)
            return cell
            
        case .description:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DescriptionTableViewCell.identifier, for: indexPath) as? DescriptionTableViewCell else { return UITableViewCell() }
            if let weatherModel = weatherModel {
                cell.configure(model: weatherModel)
            }
            
            let viewModel = cell.configureTableViewCellViewModelFor(indexPath.row)
            cell.configure(with: viewModel)
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = WeatherTableViewSection(sectionIndex: indexPath.section) else { return CGFloat() }
        switch section {
        case .hourly:
            return section.cellHeight
        case .daily:
            return section.cellHeight
        case .information:
            return section.cellHeight
        case .description:
            return section.cellHeight
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension MainViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        locationManager.stopUpdatingLocation()
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        networkService.fetchWeatherData(latitude: latitude, longitude: longitude) { [weak self] weather in
            guard let self = self,
                  let weather = weather else { return }
            
            self.weatherModel = weather
            
            DispatchQueue.main.async {
                self.mainTableView.reloadData()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Can't get location", error)
    }
}

