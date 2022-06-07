import UIKit

class MainViewController: UIViewController {
    
    let presenter: MainPresenter
    var weatherModel = [Weather]()
    var forecastData: [ForecastTemperature] = []
    
    let nameCityLabel = UILabel()
    let currentTempLabel = UILabel()
    let descriptionLabel = UILabel()
    let maxMinTempLabel = UILabel()
    
    let forecastCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    let chooseCityButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpLayouts()
    }
    
    init(presenter: MainPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpLayouts() {
        [nameCityLabel, currentTempLabel, descriptionLabel, maxMinTempLabel].forEach({
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.textAlignment = .center
            
            NSLayoutConstraint.activate([
                $0.heightAnchor.constraint(equalToConstant: 100)
            ])
        })
        setUpCityNameLabel()
        setUpCurrentTempLabel()
        setUpDescriptionLabel()
        setUpMaxMinLabel()
        setUpChooseCityButton()
        setUpForecastCollectionView()
        presenter.setUpMainInfoLabels(choose: "Moscow")
        presenter.setUpForecastWeather(choose: "Brest")
        
    }
    
    private func setUpForecastCollectionView() {
        view.addSubview(forecastCollectionView)
        forecastCollectionView.backgroundColor = .systemBackground
        forecastCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        forecastCollectionView.delegate = self
        forecastCollectionView.dataSource = self
        
        forecastCollectionView.register(ForecastCollectionViewCell.self,
                                        forCellWithReuseIdentifier: "ForecastCollectionViewCell")
        
        NSLayoutConstraint.activate([
            forecastCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            forecastCollectionView.topAnchor.constraint(equalTo: maxMinTempLabel.bottomAnchor, constant: 10),
            forecastCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            forecastCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setUpMaxMinLabel() {
        maxMinTempLabel.font = UIFont.systemFont(ofSize: 20)
        
        NSLayoutConstraint.activate([
            maxMinTempLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            maxMinTempLabel.centerYAnchor.constraint(equalTo: descriptionLabel.centerYAnchor, constant: 40),
            maxMinTempLabel.widthAnchor.constraint(equalToConstant: 400)
        ])
    }
    
    private func setUpDescriptionLabel() {
        descriptionLabel.font = UIFont.systemFont(ofSize: 30)
        
        NSLayoutConstraint.activate([
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.centerYAnchor.constraint(equalTo: currentTempLabel.centerYAnchor, constant: 50),
            descriptionLabel.widthAnchor.constraint(equalToConstant: 300),
        ])
    }
    
    private func setUpCurrentTempLabel() {
        currentTempLabel.font = UIFont.systemFont(ofSize: 60)
        
        NSLayoutConstraint.activate([
            currentTempLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentTempLabel.centerYAnchor.constraint(equalTo: nameCityLabel.centerYAnchor, constant: 70),
            currentTempLabel.widthAnchor.constraint(equalToConstant: 200)
        ])
    }

    private func setUpCityNameLabel() {
        nameCityLabel.font = UIFont.systemFont(ofSize: 40)
        
        NSLayoutConstraint.activate([
            nameCityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameCityLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -350),
            nameCityLabel.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func setUpChooseCityButton() {
        view.addSubview(chooseCityButton)
        chooseCityButton.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        chooseCityButton.isUserInteractionEnabled = true
        chooseCityButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            chooseCityButton.centerXAnchor.constraint(equalTo: nameCityLabel.centerXAnchor, constant: 150),
            chooseCityButton.centerYAnchor.constraint(equalTo: nameCityLabel.centerYAnchor, constant: 20),
            chooseCityButton.heightAnchor.constraint(equalToConstant: 50),
            chooseCityButton.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        chooseCityButton.addTarget(self, action: #selector(changeCity), for: .touchUpInside)
    }
    
    @objc private func changeCity() {
         showCityAlert { [weak self] cityName in
             self?.presenter.setUpMainInfoLabels(choose: cityName)
         }
    }
}

extension MainViewController: MainViewDelegate {
    
    func setUpMainLabel(city: String, temp: Float, descriptionWeather: String, maxTemp: Float, minTemp: Float) {
        DispatchQueue.main.async {
            self.nameCityLabel.text = city
            self.currentTempLabel.text = "\(temp.kelvinToCelsiusConverter())°C"
            self.descriptionLabel.text = "\(descriptionWeather)"
            self.maxMinTempLabel.text = "Max temp \(maxTemp.kelvinToCelsiusConverter())°C Min temp \(minTemp.kelvinToCelsiusConverter())°C"
        }
    }
    
    func setUpForecastWeather(city: String) {
        DispatchQueue.main.async {
            self.forecastCollectionView.reloadData()
        }
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let forecastWeather: [ForecastTemperature] = []
        return forecastWeather.count
    }
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ForecastCollectionViewCell", for: indexPath) as? ForecastCollectionViewCell else { return UICollectionViewCell() }
       
        let dailyForecast: [ForecastTemperature] = []
        cell.configure(with: dailyForecast[indexPath.row])
        return cell
    }
   
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            self.createFeaturedSection()
        }

        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        layout.configuration = configuration
        return layout
    }

    func createFeaturedSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))

       let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
       layoutItem.contentInsets = NSDirectionalEdgeInsets(top:5, leading: 5, bottom: 0, trailing: 5)

       let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(110))
       let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])

       let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
       return layoutSection
    }
}



