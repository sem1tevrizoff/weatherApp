import UIKit

class MainViewController: UIViewController {
    
    let presenter: MainPresenter
    var weatherModel: ForecastWeather?
    
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
        presenter.setUpForecastWeather(choose: "Moscow")
        
    }
    
    private func setUpForecastCollectionView() {
        view.addSubview(forecastCollectionView)
        forecastCollectionView.backgroundColor = .red
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
             self?.presenter.setUpForecastWeather(choose: cityName)
         }
    }
}

extension MainViewController: MainViewDelegate {
    
    func setUpForecastWeather(with model: ForecastWeather) {
        self.weatherModel = model
        DispatchQueue.main.async {
            self.forecastCollectionView.reloadData()
    }
}
    
    func setUpMainLabel(city: String, temp: Float, descriptionWeather: String, maxTemp: Float, minTemp: Float) {
        DispatchQueue.main.async {
            self.nameCityLabel.text = city
            self.currentTempLabel.text = "\(temp.kelvinToCelsiusConverter())°C"
            self.descriptionLabel.text = "\(descriptionWeather)"
            self.maxMinTempLabel.text = "Max temp \(maxTemp.kelvinToCelsiusConverter())°C Min temp \(minTemp.kelvinToCelsiusConverter())°C"
        }
    }
}



