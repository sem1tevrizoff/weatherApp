import UIKit
import CoreLocation

class MainViewController: UIViewController {
    
    let presenter: MainPresenter
    
    let nameCityLabel = UILabel()
    let currentTempLabel = UILabel()
    let descriptionLabel = UILabel()
    let maxMinTempLabel = UILabel()
    
    let dailyTableView = UITableView()

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
        setUpForecastCollectionView()
        configureNavigationBar()
        presenter.setUpMainInfoLabels(choose: "Moscow")
        presenter.setUpForecastWeather(choose: "Moscow")
        
    }
    
    private func setUpForecastCollectionView() {
        view.addSubview(dailyTableView)
        dailyTableView.backgroundColor = .red
        dailyTableView.translatesAutoresizingMaskIntoConstraints = false

        dailyTableView.delegate = self
        dailyTableView.dataSource = self
        
        dailyTableView.register(DailyTableViewCell.self, forCellReuseIdentifier: "DailyTableViewCell")
        
        NSLayoutConstraint.activate([
            dailyTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dailyTableView.topAnchor.constraint(equalTo: maxMinTempLabel.bottomAnchor, constant: 10),
            dailyTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dailyTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
    
    private func configureNavigationBar() {
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus.circle"), style: .done, target: self, action: #selector(changeCity))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc private func changeCity() {
         showCityAlert { [weak self] cityName in
             self?.presenter.setUpMainInfoLabels(choose: cityName)
             self?.presenter.setUpForecastWeather(choose: cityName)
//             self?.presenter.setUpDailyWeather(with: "53.896196", and: "27.5503093")
             self?.presenter.getCoordinate(addressString: cityName, completionHandler: { coordinate, error in
                 
             })
        }
    }
}

extension MainViewController: MainViewDelegate {
    
    func setUpDailyWeather(with model: DailyForecast) {
        DispatchQueue.main.async {
            self.dailyTableView.reloadData()
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
        }
    }
}

