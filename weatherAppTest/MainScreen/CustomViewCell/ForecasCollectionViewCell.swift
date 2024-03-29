import Foundation
import UIKit

final class ForecastCollectionViewCell: UICollectionViewCell {
    
    static var reuseID: String {
        String(describing: self)
    }
    
    private lazy var hourLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var hourlyImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var hourlyTempLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(hourLabel)
        addSubview(hourlyImageView)
        addSubview(hourlyTempLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            hourLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            hourLabel.topAnchor.constraint(equalTo: topAnchor, constant: -20),
            hourLabel.heightAnchor.constraint(equalToConstant: 20),
            hourLabel.widthAnchor.constraint(equalToConstant: 50),
            
            hourlyImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            hourlyImageView.topAnchor.constraint(equalTo: hourLabel.bottomAnchor),
            hourlyImageView.heightAnchor.constraint(equalToConstant: 50),
            hourlyImageView.widthAnchor.constraint(equalToConstant: 50),
            
            hourlyTempLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            hourlyTempLabel.topAnchor.constraint(equalTo: hourlyImageView.bottomAnchor, constant: -5),
            hourlyTempLabel.heightAnchor.constraint(equalToConstant: 30),
            hourlyTempLabel.widthAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    final func configure(with item: DailyModel.Hourly) {
        hourLabel.text = "\(item.dt.getHourStringFromUTC())"
        hourlyImageView.loadImageFromUrl(urlString: "http://openweathermap.org/img/wn/\(item.weather[0].icon)@2x.png")
        hourlyTempLabel.text = "\(item.temp.kelvinToCelsiusConverter())°C"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        hourLabel.text = nil
        hourlyImageView.image = nil
    }
}
