import UIKit

final class HourlyTableViewCell: UITableViewCell, UICollectionViewDelegateFlowLayout {
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: 60, height: 120)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .lightBlue
        return collectionView
    }()
    
    private var weatherModel: WeatherModel?
    static var identifier = "HourlyTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .lightBlue
        selectionStyle = .none
        contentView.addSubview(collectionView)
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    func configure(with model: WeatherModel) {
        self.weatherModel = model
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    private func setupCollectionView() {
        collectionView.register(HourlyCollectionViewCell.self,
                                forCellWithReuseIdentifier: HourlyCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    private func configureCollectionCellViewModelFor(_ index: Int) -> HourlyCollectionViewCellViewModel  {
        var tempLabelString: String?
        var timeLabelString: String?
        var humidityLabelString: String?
        var iconImage: UIImage?
        var urlStringForImage: String?
        
        if let weatherModel = weatherModel {
            let hourlyModel = weatherModel.hourly[index]
            let hourForDate = Date(timeIntervalSince1970: Double(hourlyModel.dt)).getHourForDate()
            let nextHourForDate = Date(timeIntervalSince1970: Double(weatherModel.hourly[index + 1].dt)).getTimeForDate()
            let timeForDate = Date(timeIntervalSince1970: Double(hourlyModel.dt)).getTimeForDate()
            let sunset = Date(timeIntervalSince1970: Double(weatherModel.current.sunset)).getTimeForDate()
            let sunrise = Date(timeIntervalSince1970: Double(weatherModel.current.sunrise)).getTimeForDate()
            urlStringForImage = "http://openweathermap.org/img/wn/\(hourlyModel.weather[0].icon)@2x.png"
            
            if index == 0 {
                timeLabelString = "Now"
                iconImage = nil
                tempLabelString = String(format: "%.f", weatherModel.hourly[index].temp) + "°"
                
            } else {
                
                if sunset >= timeForDate && sunset < nextHourForDate {
                    tempLabelString = "Sunset"
                    iconImage = #imageLiteral(resourceName: "sunset")
                    timeLabelString = sunset
                } else if sunrise >= timeForDate && sunrise < nextHourForDate {
                    tempLabelString = "Sunrise"
                    iconImage = #imageLiteral(resourceName: "sunrise")
                    timeLabelString = sunrise
                } else {
                    iconImage = nil
                    tempLabelString = String(format: "%.f", weatherModel.hourly[index].temp) + "°"
                    timeLabelString = hourForDate
                }
            }
            
            if hourlyModel.humidity >= 30 {
                humidityLabelString = String(hourlyModel.humidity) + " %"
            } else {
                humidityLabelString = ""
            }
        }
        
        return HourlyCollectionViewCellViewModel(
            tempLabelString: tempLabelString,
            timeLabelString: timeLabelString,
            humidityLabelString: humidityLabelString,
            iconImage: iconImage,
            urlString: urlStringForImage
        )
    }
}

extension HourlyTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource  {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyCollectionViewCell.identifier, for: indexPath) as! HourlyCollectionViewCell
        
        let viewModel = configureCollectionCellViewModelFor(indexPath.row)
        cell.configure(with: viewModel)
        cell.backgroundColor = .lightBlue
        return cell
    }
}
