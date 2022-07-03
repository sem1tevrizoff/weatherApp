import UIKit
import CoreLocation

class MainViewController: UIViewController {
    
    let presenter: MainPresenter
    
    private lazy var nameCityLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    private lazy var currentTempLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    private lazy var  maxMinTempLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var dailyTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DailyTableViewCell.self, forCellReuseIdentifier: DailyTableViewCell.reuseID)
        return tableView
    }()

    private lazy var forecastCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.scrollDirection = .horizontal
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.delegate = self
        view.dataSource = self
        view.showsHorizontalScrollIndicator = false
        view.register(ForecastCollectionViewCell.self, forCellWithReuseIdentifier: ForecastCollectionViewCell.reuseID)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        setUp()
    }
    
    init(presenter: MainPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        setUpLabelLayouts()
        setUpCityNameLabel()
        setUpCurrentTempLabel()
        setUpDescriptionLabel()
        setUpMaxMinLabel()
        setUpWeatherContentView()
        setUpForecastTableView()
        configureNavigationBar()
        presenter.setUpMainInfoLabels(choose: "Moscow")
    }
    
    private func setUpLabelLayouts() {
        [nameCityLabel, currentTempLabel, descriptionLabel, maxMinTempLabel].forEach({
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.textAlignment = .center
            
            NSLayoutConstraint.activate([
                $0.heightAnchor.constraint(equalToConstant: 100)
            ])
        })
    }
    
    private func setUpWeatherContentView() {
        view.addSubview(forecastCollectionView)
        forecastCollectionView.translatesAutoresizingMaskIntoConstraints = false
        forecastCollectionView.backgroundColor = .systemBlue
        forecastCollectionView.layer.borderWidth = 0.5
        
        NSLayoutConstraint.activate([
            forecastCollectionView.topAnchor.constraint(equalTo: maxMinTempLabel.bottomAnchor, constant: 10),
            forecastCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            forecastCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            forecastCollectionView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func setUpForecastTableView() {
        view.addSubview(dailyTableView)
        dailyTableView.backgroundColor = .systemBlue
        dailyTableView.translatesAutoresizingMaskIntoConstraints = false
        dailyTableView.layer.borderWidth = 0.5
        
        NSLayoutConstraint.activate([
            dailyTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            dailyTableView.topAnchor.constraint(equalTo: forecastCollectionView.bottomAnchor, constant: 10),
            dailyTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            dailyTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setUpMaxMinLabel() {
        maxMinTempLabel.font = UIFont.systemFont(ofSize: 20)
        
        NSLayoutConstraint.activate([
            maxMinTempLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor),
            maxMinTempLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            maxMinTempLabel.heightAnchor.constraint(equalToConstant: 50),
            maxMinTempLabel.widthAnchor.constraint(equalToConstant: 400)
        ])
    }
    
    private func setUpDescriptionLabel() {
        descriptionLabel.font = UIFont.systemFont(ofSize: 30)
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: currentTempLabel.bottomAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 50),
            descriptionLabel.widthAnchor.constraint(equalToConstant: 300),
        ])
    }
    
    private func setUpCurrentTempLabel() {
        currentTempLabel.font = UIFont.systemFont(ofSize: 60)
        
        NSLayoutConstraint.activate([
            currentTempLabel.topAnchor.constraint(equalTo: nameCityLabel.bottomAnchor),
            currentTempLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            currentTempLabel.heightAnchor.constraint(equalToConstant: 50),
            currentTempLabel.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func setUpCityNameLabel() {
        nameCityLabel.font = UIFont.systemFont(ofSize: 40)
        
        NSLayoutConstraint.activate([
            nameCityLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            nameCityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            nameCityLabel.heightAnchor.constraint(equalToConstant: 70),
            nameCityLabel.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func configureNavigationBar() {
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus.circle"), style: .done, target: self, action: #selector(changeCity))
        addButton.tintColor = .black
        navigationItem.rightBarButtonItem = addButton
        navigationController?.navigationBar.topItem?.title = "Weather App"
    }
    
    @objc func changeCity() {
         showCityAlert { [weak self] cityName in
             self?.presenter.setUpMainInfoLabels(choose: cityName)
             self?.presenter.getCoordinate(addressString: cityName, completionHandler: { coordinate, error in
                 self?.presenter.setUpDailyWeather(lat: coordinate.latitude, lon: coordinate.longitude)
             })
        }
    }
}

extension MainViewController: MainViewDelegate {
    
    func setUpDailyWeather(with model: DailyForecast) {
        DispatchQueue.main.async {
            self.dailyTableView.reloadData()
            self.forecastCollectionView.reloadData()
        }
    }
    
    func setUpForecastWeather(with model: ForecastWeather) {
        DispatchQueue.main.async {
            self.dailyTableView.reloadData()
    }
}
    
    func setUpMainLabels(with model: Weather) {
        DispatchQueue.main.async {
            self.nameCityLabel.text = model.name
            self.currentTempLabel.text = "\(model.main.temp.kelvinToCelsiusConverter())°C"
            self.descriptionLabel.text = "\(model.weather[0].description)"
            self.maxMinTempLabel.text = "Max temp \(model.main.tempMax.kelvinToCelsiusConverter())°C Min temp \(model.main.tempMin.kelvinToCelsiusConverter())°C"
            self.presenter.setUpDailyWeather(lat: 55.7616, lon: 37.6095)
        }
    }
}

