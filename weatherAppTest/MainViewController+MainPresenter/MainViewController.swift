import UIKit

class MainViewController: UIViewController {
    
    let presenter: MainPresenter
    private lazy var citiesPresenter = CitiesPresenter()
    
    private lazy var loadActivityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.color = .black
        indicator.style = .large
        return indicator
    }()
    
    private lazy var nameCityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30)
        return label
    }()
    
    private lazy var currentTempLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 60)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30)
        return label
    }()
    
    private lazy var  maxMinTempLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private lazy var dailyTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemBlue
        tableView.layer.borderWidth = 0.5
        tableView.layer.borderColor = UIColor.systemFill.cgColor
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
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBlue
        collectionView.layer.borderWidth = 0.5
        collectionView.layer.borderColor = UIColor.systemFill.cgColor
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ForecastCollectionViewCell.self, forCellWithReuseIdentifier: ForecastCollectionViewCell.reuseID)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainSetup()
    }
    
    init(presenter: MainPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func mainSetup() {
        setupViews()
        setupLabelLayouts()
        setupConstraints()
        configureNavigationBar()
        presenter.setupLocation()
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBlue
        view.addSubview(loadActivityIndicator)
        view.addSubview(forecastCollectionView)
        view.addSubview(dailyTableView)
    }
    
    private func setupLabelLayouts() {
        [nameCityLabel, currentTempLabel, descriptionLabel, maxMinTempLabel].forEach({
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.textAlignment = .center
        })
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nameCityLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            nameCityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            nameCityLabel.heightAnchor.constraint(equalToConstant: 70),
            nameCityLabel.widthAnchor.constraint(equalToConstant: 300),
            
            currentTempLabel.topAnchor.constraint(equalTo: nameCityLabel.bottomAnchor),
            currentTempLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            currentTempLabel.heightAnchor.constraint(equalToConstant: 50),
            currentTempLabel.widthAnchor.constraint(equalToConstant: 200),
            
            descriptionLabel.topAnchor.constraint(equalTo: currentTempLabel.bottomAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 50),
            descriptionLabel.widthAnchor.constraint(equalToConstant: 300),
            
            maxMinTempLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor),
            maxMinTempLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            maxMinTempLabel.heightAnchor.constraint(equalToConstant: 50),
            maxMinTempLabel.widthAnchor.constraint(equalToConstant: 400),
            
            forecastCollectionView.topAnchor.constraint(equalTo: maxMinTempLabel.bottomAnchor, constant: 10),
            forecastCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            forecastCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            forecastCollectionView.heightAnchor.constraint(equalToConstant: 100),
            
            dailyTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            dailyTableView.topAnchor.constraint(equalTo: forecastCollectionView.bottomAnchor, constant: 10),
            dailyTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            dailyTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadActivityIndicator.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            loadActivityIndicator.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 180)
        ])
    }
    
    private func configureNavigationBar() {
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus.circle"), style: .done, target: self, action: #selector(changeCity))
        addButton.tintColor = .black
        
        let updateButton = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .done, target: self, action: #selector(updateForecastWeather))
        updateButton.tintColor = .black
        
        let choosenCityButton = UIBarButtonItem(image: UIImage(systemName: "list.bullet.rectangle.portrait"), style: .done, target: self, action: #selector(choosenCitiesButton))
        choosenCityButton.tintColor = .black
        
        navigationItem.rightBarButtonItems = [addButton, updateButton, choosenCityButton]
    }
    
    
    private func updateWeather(){
        self.loadActivityIndicator.startAnimating()
        self.presenter.setupMainInfoLabels(choose: presenter.currentCity)
        self.presenter.getCoordinate(addressString: presenter.currentCity) { coordinate, error in
            self.presenter.setupDailyWeather(lat: coordinate.latitude, lon: coordinate.longitude)
        }
    }
    
    @objc func changeCity() {
         showCityAlert { [weak self] cityName in
             self?.presenter.currentCity = cityName
             self?.citiesPresenter.saveItem(with: cityName)
             self?.updateWeather()
        }
    }
    
    @objc func updateForecastWeather() {
        updateWeather()
    }
    
    @objc func choosenCitiesButton() {
        self.navigationController?.pushViewController(ChoosenCitiesViewController(presenter: CitiesPresenter()), animated: true)
    }
}

extension MainViewController: MainViewDelegate {
    
    func setupDailyWeather(with model: DailyForecast) {
        DispatchQueue.main.async {
            self.dailyTableView.reloadData()
            self.forecastCollectionView.reloadData()
            self.loadActivityIndicator.stopAnimating()
        }
    }
    
    func setupMainLabels(with model: Weather) {
        DispatchQueue.main.async {
            self.nameCityLabel.text = model.name
            self.currentTempLabel.text = "\(model.main.temp.kelvinToCelsiusConverter())°C"
            self.descriptionLabel.text = "\(model.weather[0].description)"
            self.maxMinTempLabel.text = "Max temp \(model.main.tempMax.kelvinToCelsiusConverter())°C Min temp \(model.main.tempMin.kelvinToCelsiusConverter())°C"
        }
    }
}
