import UIKit

class ForecastCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let networkingManager = NetworkingManager()
    
    let weekdaylabel: UILabel = {
       let label = UILabel()
        label.text = "Monday"
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    let tempSymbol: UIImageView = {
       let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
 
    var dailyForecast: [WeatherInfo] = []
    var forecastViewCollectionCell = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        
        forecastViewCollectionCell = UICollectionView(frame: CGRect(x: 100, y: 0, width: (frame.width - 112), height: frame.height), collectionViewLayout: createCompositionalLayout())
        forecastViewCollectionCell.register(HourlyCollectionViewCell.self, forCellWithReuseIdentifier: "HourlyCollectionViewCell")
        forecastViewCollectionCell.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        forecastViewCollectionCell.backgroundColor = .systemBackground
        
        forecastViewCollectionCell.delegate = self
        forecastViewCollectionCell.dataSource = self
        
        addSubview(forecastViewCollectionCell)
        setupViews()
        layoutViews()
     }
    
    func setupViews() {
        addSubview(weekdaylabel)
        addSubview(tempSymbol)
    }
    
    func layoutViews() {
        weekdaylabel.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        weekdaylabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        weekdaylabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 8).isActive = true
        weekdaylabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 8).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            self.createFeaturedSection()
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        layout.configuration = config
        return layout
    }
        
    func createFeaturedSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/4), heightDimension: .fractionalHeight(0.75))

       let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
       layoutItem.contentInsets = NSDirectionalEdgeInsets(top:5, leading: 5, bottom: 0, trailing: 5)

       let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(110))
       let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])

       let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
       layoutSection.orthogonalScrollingBehavior = .groupPagingCentered

       return layoutSection
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dailyForecast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyCollectionViewCell", for: indexPath) as? HourlyCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(with: dailyForecast[indexPath.row])
        return cell
    }
    
    func configure(with item: ForecastWeather.List) {
        let temperature = item.main.feelsLike
        weekdaylabel.text = "\(temperature)"
//        weekdaylabel.text = "It feels like \(howItFeelsLike(with: temperature))"
//        dailyForecast = item.clouds
    }
    
    private func howItFeelsLike(with temp: Float) -> String {
        if temp >= 303.15 {
            return "🥵"
        }else if temp > 288.15 && temp < 303.15 {
            return "😎"
        } else if temp >= 273.15 && temp < 288.15 {
            return "😮‍💨"
        } else {
            return "🥶"
        }
    }
}
