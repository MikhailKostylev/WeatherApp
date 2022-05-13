import UIKit

struct InformationTableViewCellViewModel {
    let informationLabelString: String?
}

final class InformationTableViewCell: UITableViewCell {
    
    static let identifier = "InformationTableViewCell"
    
    private var weatherModel: WeatherModel?
    
    private let informationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = ""
        label.textColor = .white
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(informationLabel)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        informationLabel.text = nil
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            informationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            informationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            informationLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            informationLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(model: WeatherModel) {
        self.weatherModel = model
    }
    
    func configureTableViewCellViewModelFor(_ index: Int) -> InformationTableViewCellViewModel {
        var informationLabelString: String?
        
        if let weatherMode = weatherModel {
            informationLabelString = "Today: \(weatherMode.current.weather[0].descriptionWeather.firstCapitalized). The hight will be \(String(format: "%.f", weatherMode.daily[0].temp.night))°. "
        }
        
        return InformationTableViewCellViewModel(informationLabelString: informationLabelString)
    }
    
    func configure(with viewModel: InformationTableViewCellViewModel) {
        informationLabel.text = viewModel.informationLabelString
    }
}
