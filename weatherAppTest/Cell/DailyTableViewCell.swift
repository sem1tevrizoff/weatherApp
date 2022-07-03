import UIKit

class DailyTableViewCell: UITableViewCell {
    
    static var reuseID: String {
        String(describing: self)
    }
    
    private lazy var weekDayLabel: UILabel = {
        let label = UILabel()
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var weekDayImageView: UIImageView = {
        let imageView = UIImageView()
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var minMaxWeatherTempLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
 
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBlue
        setUpLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpLayouts() {
        NSLayoutConstraint.activate([
            weekDayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            weekDayLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            weekDayLabel.heightAnchor.constraint(equalToConstant: 50),
            weekDayLabel.widthAnchor.constraint(equalToConstant: 110),
            
            weekDayImageView.leadingAnchor.constraint(equalTo: weekDayLabel.trailingAnchor, constant: 10),
            weekDayImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            weekDayImageView.heightAnchor.constraint(equalToConstant: 50),
            weekDayImageView.widthAnchor.constraint(equalToConstant: 50),
            
            minMaxWeatherTempLabel.leadingAnchor.constraint(equalTo: weekDayImageView.trailingAnchor, constant: 10),
            minMaxWeatherTempLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            minMaxWeatherTempLabel.heightAnchor.constraint(equalToConstant: 50),
            minMaxWeatherTempLabel.widthAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    func configure(with item: DailyForecast.Daily) {
        weekDayLabel.text = "\(item.dt.getDateStringFromUTC())"
        weekDayImageView.loadImageFromUrl(urlString: "http://openweathermap.org/img/wn/\(item.weather[0].icon)@2x.png")
        minMaxWeatherTempLabel.text = "min \(item.temp.min.kelvinToCelsiusConverter())°C --- max \(item.temp.max.kelvinToCelsiusConverter())°C"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        weekDayLabel.text = nil
        weekDayImageView.image = nil
    }
}
