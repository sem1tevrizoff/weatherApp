import UIKit

final class MainViewController: UIViewController {
    
    let presenter: MainPresenter
    
    lazy var mainView: MainView = {
        let view = MainView()
        return view
    }()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainSetup()
        presenter.viewDelegate = self
        presenter.setupLocation()
    }
    
    init(presenter: MainPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func mainSetup() {
        configureNavigationBar()
    }
    
    private func setDailyWeather(with model: [DailyModel.Daily]) {
        mainView.dailyTableView.dailyForecast = model
    }
    
    private func setHourlyWeather(with model: [DailyModel.Hourly]) {
        mainView.forecastCollectionView.hourlyForecast = model
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
        self.mainView.currentWeatherView.loadActivityIndicator.startAnimating()
        presenter.getCityInfo(with: presenter.currentCity)
    }
    
    @objc private func changeCity() {
         showCityAlert { [weak self] cityName in
             self?.presenter.currentCity = cityName
             self?.updateWeather()
        }
    }
    
    @objc private func updateForecastWeather() {
        updateWeather()
    }
    
    @objc private func choosenCitiesButton() {
        let vc = CitiesListViewController(presenter: CitiesListPresenter())
        vc.presenter.callBack = { (city: String) in
            self.presenter.getCityInfo(with: city)
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    final func showCityAlert(with completion: @escaping (String) -> Void) {
        let alertVC = UIAlertController(title: "Choose City",
                                        message: nil,
                                        preferredStyle: .alert)
        alertVC.addTextField { textField in
            textField.placeholder = "City Name"
        }
       
        let allertAction = UIAlertAction(title: "Find", style: .default) { UIAlertAction in
           guard let firstTextField = alertVC.textFields?.first,
           let cityName = firstTextField.text,
           !cityName.isEmpty else { return }
           completion(cityName)
        }
       
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
       
        alertVC.addAction(allertAction)
        alertVC.addAction(cancelAction)
       
        self.present(alertVC, animated: true)
    }
   
   final func showErrorAlert(with message: String) {
       let alertVC = UIAlertController(title: "Try to choose another city!",
                                       message: message,
                                       preferredStyle: .alert)
       let alertAction = UIAlertAction(title: "Ok", style: .destructive)
       
       alertVC.addAction(alertAction)
       self.present(alertVC, animated: true)
   }
}

extension MainViewController: MainViewDelegate {
    
    final func setupHourlyWeather(with model: DailyModel) {
        DispatchQueue.main.async {
            self.setHourlyWeather(with: model.hourly)
        }
    }
    
    final func setupDailyWeather(with model: DailyModel) {
        DispatchQueue.main.async {
            self.setDailyWeather(with: model.daily)
            self.mainView.currentWeatherView.loadActivityIndicator.stopAnimating()
        }
    }
    
    final func setupMainLabels(with model: WeatherModel) {
        DispatchQueue.main.async {
            self.mainView.currentWeatherView.nameCityLabel.text = model.name
            self.mainView.currentWeatherView.currentTempLabel.text = "\(model.main.temp.kelvinToCelsiusConverter())°C"
            self.mainView.currentWeatherView.descriptionLabel.text = "\(model.weather[0].description)"
            self.mainView.currentWeatherView.maxMinTempLabel.text = "Max temp \(model.main.tempMax.kelvinToCelsiusConverter())°C Min temp \(model.main.tempMin.kelvinToCelsiusConverter())°C"
        }
    }
    
    final func showAlert(title: String) {
        DispatchQueue.main.async {
            self.showErrorAlert(with: title)
        }
    }
}
