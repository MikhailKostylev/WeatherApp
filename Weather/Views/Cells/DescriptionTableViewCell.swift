import UIKit

struct DescriptionTableViewCellViewModel {
    let descriptionTextLabelString: String?
    let descriptionValueLabelString: String?
}

final class DescriptionTableViewCell: UITableViewCell {
    
    static var identifier = "DescriptionTableViewCell"
    
    private var weatherModel: WeatherModel?
    
    private let descriptionTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = ""
        label.textColor = .lightText
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionValueLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = ""
        label.textColor = .white
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(descriptionTextLabel)
        contentView.addSubview(descriptionValueLabel)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        descriptionTextLabel.text = nil
        descriptionValueLabel.text = nil
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            descriptionTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            descriptionTextLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            descriptionTextLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
            
            descriptionValueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionValueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            descriptionValueLabel.topAnchor.constraint(equalTo: descriptionTextLabel.bottomAnchor),
            descriptionValueLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
        ])
    }
    
    func configure(model: WeatherModel) {
        weatherModel = model
    }
    
    func configureTableViewCellViewModelFor(_ index: Int) -> DescriptionTableViewCellViewModel {
        var descriptionTextLabelString: String?
        var descriptionValueLabelString: String?
        
        if let weatherModel = weatherModel {
            switch index {
            case 0:
                descriptionTextLabelString = descriptionArray[index]
                descriptionValueLabelString = Date(timeIntervalSince1970: Double(weatherModel.current.sunrise)).getTimeForDate()
            case 1:
                descriptionTextLabelString = descriptionArray[index]
                descriptionValueLabelString = Date(timeIntervalSince1970: Double(weatherModel.current.sunset)).getTimeForDate()
            case 2:
                descriptionTextLabelString = descriptionArray[index]
                descriptionValueLabelString = String(weatherModel.current.humidity) + " %"
            case 3:
                descriptionTextLabelString = descriptionArray[index]
                descriptionValueLabelString = String(format: "%.1f", weatherModel.current.windSpeed) + " m/s"
            case 4:
                descriptionTextLabelString = descriptionArray[index]
                descriptionValueLabelString = String(format: "%.f", weatherModel.current.feelsLike) + "°"
            case 5:
                descriptionTextLabelString = descriptionArray[index]
                descriptionValueLabelString = String(format: "%.1f", Double(weatherModel.current.pressure) / 133.332 * 100) + " mm Hg"
            case 6:
                descriptionTextLabelString = descriptionArray[index]
                descriptionValueLabelString = String(format: "%.1f", weatherModel.current.visibility / 1000) + " km"
            case 7:
                descriptionTextLabelString = descriptionArray[index]
                descriptionValueLabelString = String(format: "%.f", weatherModel.current.uvi)
            default:
                print("default value")
            }
            
        }
        
        return DescriptionTableViewCellViewModel(
            descriptionTextLabelString: descriptionTextLabelString,
            descriptionValueLabelString: descriptionValueLabelString
        )
    }
    
    func configure(with viewModel: DescriptionTableViewCellViewModel) {
        descriptionTextLabel.text = viewModel.descriptionTextLabelString
        descriptionValueLabel.text = viewModel.descriptionValueLabelString
    }
}
