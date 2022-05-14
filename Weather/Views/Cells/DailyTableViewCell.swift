import UIKit

import UIKit

struct DailyTableViewCellViewModel {
    let dayLabelString: String?
    let highTempLabelString: String?
    let lowTempLabelString: String?
    let humidityLabelString: String?
    let iconImage: UIImage?
    let urlString: String?
}

final class DailyTableViewCell: UITableViewCell {
    
    static let identifier = "DailyTableViewCell"

    private var weatherModel: WeatherModel?
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = ""
        label.textColor = .white
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lowTempLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = ""
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let highTempLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = ""
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let humidityLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = ""
        label.textColor = .cyan
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .lightBlue
        selectionStyle = .none
        contentView.addSubview(dayLabel)
        contentView.addSubview(lowTempLabel)
        contentView.addSubview(highTempLabel)
        contentView.addSubview(humidityLabel)
        contentView.addSubview(iconImageView)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dayLabel.text = nil
        lowTempLabel.text = nil
        highTempLabel.text = nil
        humidityLabel.text = nil
        iconImageView.image = nil
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            iconImageView.heightAnchor.constraint(equalToConstant: 30),
            
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dayLabel.trailingAnchor.constraint(equalTo: iconImageView.leadingAnchor, constant: 5),
            dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            humidityLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10),
            humidityLabel.widthAnchor.constraint(equalToConstant: 44),
            humidityLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            lowTempLabel.leadingAnchor.constraint(equalTo: humidityLabel.trailingAnchor, constant: 10),
            lowTempLabel.widthAnchor.constraint(equalToConstant: 35),
            lowTempLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            highTempLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            highTempLabel.widthAnchor.constraint(equalToConstant: 35),
            highTempLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(model: WeatherModel) {
        self.weatherModel = model
    }
    
    func configureTableViewCellViewModelFor(_ index: Int) -> DailyTableViewCellViewModel {
        var dayLabelString: String?
        var highTempLabelString: String?
        var lowTempLabelString: String?
        var humidityLabelString: String?
        var iconImage: UIImage?
        var urlString: String?
        
        if let weatherModel =  weatherModel {
            let dailyModel = weatherModel.daily[index + 1]
            dayLabelString = Date(timeIntervalSince1970: Double(dailyModel.dt)).getDayForDate()
            highTempLabelString = String(format: "%.f", dailyModel.temp.max)
            lowTempLabelString = String(format: "%.f", dailyModel.temp.min)
            urlString = "http://openweathermap.org/img/wn/\(dailyModel.weather[0].icon)@2x.png"
            iconImageView.downloaded(from: urlString ?? "")
            
            if dailyModel.humidity >= 30 {
                humidityLabelString = String(dailyModel.humidity) + " %"
            } else {
                humidityLabelString = ""
            }
        }
        
        return DailyTableViewCellViewModel(
            dayLabelString: dayLabelString,
            highTempLabelString: highTempLabelString,
            lowTempLabelString: lowTempLabelString,
            humidityLabelString: humidityLabelString,
            iconImage: iconImage,
            urlString: urlString
        )
    }
    
    func configure(with viewModel: DailyTableViewCellViewModel) {
        dayLabel.text = viewModel.dayLabelString
        highTempLabel.text = viewModel.highTempLabelString
        lowTempLabel.text = viewModel.lowTempLabelString
        humidityLabel.text = viewModel.humidityLabelString
        iconImageView.image = viewModel.iconImage
    }
}
