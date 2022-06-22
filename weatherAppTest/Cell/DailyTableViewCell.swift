import UIKit

class DailyTableViewCell: UITableViewCell {
    
    let weekdayLabel = UILabel()
 
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpWeekdayLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    func configure(with item: DailyForecast.Daily) {
        weekdayLabel.text = "\(item.dt.getDateStringFromUTC()) \(item.temp.day.kelvinToCelsiusConverter())"
    }
}
