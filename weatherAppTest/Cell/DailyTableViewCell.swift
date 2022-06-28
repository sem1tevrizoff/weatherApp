import UIKit

class DailyTableViewCell: UITableViewCell {
    
    let weekdayLabel = UILabel()
    
    private lazy var weatherContentView: ForecastContentView = {
        let view = ForecastContentView()
        
        return view
    }()
 
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpWeekdayLabel()
        setUpWeatherContentView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpWeekdayLabel() {
        contentView.addSubview(weekdayLabel)
        weekdayLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            weekdayLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -130),
            weekdayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            weekdayLabel.heightAnchor.constraint(equalToConstant: 50),
            weekdayLabel.widthAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    private func setUpWeatherContentView() {
        contentView.addSubview(weatherContentView)
        weatherContentView.translatesAutoresizingMaskIntoConstraints = false
        weatherContentView.backgroundColor = .blue
        
        NSLayoutConstraint.activate([
            weatherContentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            weatherContentView.leadingAnchor.constraint(equalTo: weekdayLabel.trailingAnchor),
            weatherContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            weatherContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    func configure(with item: DailyForecast.Daily) {
        weekdayLabel.text = "\(item.dt.getDateStringFromUTC())"
//        \(item.temp.day.kelvinToCelsiusConverter()
    }
}
