import UIKit

struct HourlyCollectionViewCellViewModel {
    let tempLabelString: String?
    let timeLabelString: String?
    let humidityLabelString: String?
    let iconImage: UIImage?
    let urlString: String?
}

final class HourlyCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "HourlyCollectionViewCell"
    
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = ""
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timeLabel: UILabel = {
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
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .lightBlue
        contentView.addSubview(tempLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(humidityLabel)
        contentView.addSubview(iconImageView)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        tempLabel.text = nil
        timeLabel.text = nil
        humidityLabel.text = nil
        iconImageView.image = nil
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            iconImageView.heightAnchor.constraint(equalToConstant: 30),
            
            tempLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            tempLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 10),
            
            humidityLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            humidityLabel.bottomAnchor.constraint(equalTo: iconImageView.topAnchor),
            
            timeLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
        ])
    }

    
    func configure(with viewModel: HourlyCollectionViewCellViewModel) {
        if viewModel.timeLabelString == "Now" {
            timeLabel.text = "Now"
            timeLabel.font = UIFont.boldSystemFont(ofSize: 17)
            tempLabel.text = viewModel.tempLabelString
            tempLabel.font = UIFont.boldSystemFont(ofSize: 17)
        } else {
            timeLabel.text = viewModel.timeLabelString
            tempLabel.text = viewModel.tempLabelString
        }

        if viewModel.iconImage != nil {
            iconImageView.image = viewModel.iconImage
        } else {
            iconImageView.downloaded(from: viewModel.urlString ?? "")
        }
        
        humidityLabel.text = viewModel.humidityLabelString
    }
}
