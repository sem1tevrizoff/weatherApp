import UIKit

class ForecastCollectionViewCell: UICollectionViewCell {
    
    var dailyForecast: [WeatherInfo] = []
    
    let weekdayLabel = UILabel()
    let tempSymbolImageView = UIImageView()
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBackground
        setUpTempSymbolImageView()
        setUpWeekdayLabel()
     }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpTempSymbolImageView() {
        contentView.addSubview(tempSymbolImageView)
        tempSymbolImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setUpWeekdayLabel() {
        contentView.addSubview(weekdayLabel)
        weekdayLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            weekdayLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            weekdayLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            weekdayLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 8),
            weekdayLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 8)
        ])
    }

    func configure(with item: ForecastWeather.List) {
        weekdayLabel.text = "\(item.main.temp.kelvinToCelsiusConverter())"
    }
}
