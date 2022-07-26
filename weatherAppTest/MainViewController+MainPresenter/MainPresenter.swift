import Foundation
import UIKit
import CoreLocation

protocol MainViewDelegate: AnyObject {
    func setupMainLabels(with model: Weather)
    func setupDailyWeather(with model: DailyForecast)
    func showAlert(title: String)
}

class MainPresenter: NSObject, CLLocationManagerDelegate {
    
    let networkWeatherManager = NetworkingManager()
    private let storageManager = StorageManager()
    
    weak var viewDelegate: MainViewDelegate?
    lazy var locationManager = CLLocationManager()
    
    lazy var currentCity = ""
    lazy var items: [Item] = []
    
    var currentWeather: Weather?
    var dailyForecast: DailyForecast?
    
    func updateInfoMainViewController(with city: String) {
        setupMainInfoLabels(choose: city)
        getCoordinate(addressString: city) { coordinate, error in
            self.setupDailyWeather(lat: coordinate.latitude, lon: coordinate.longitude)
        }
    }
    
    func setupMainInfoLabels(choose city: String) {
        networkWeatherManager.request(endpoint: WeatherAPI.link(city)) { (result: Result<Weather, NetworkingError>) in
            switch result {
            case .success(let weatherModel):
                self.currentWeather = weatherModel
                self.viewDelegate?.setupMainLabels(with: weatherModel)
                self.currentCity = weatherModel.name
            case .failure(let error):
                self.viewDelegate?.showAlert(title: error.localizedDescription)
            }
        }
    }
    
    func setupDailyWeather(lat: Double, lon: Double) {
        networkWeatherManager.request(endpoint: WeatherAPI.daily(lat: lat, lon: lon)) { [weak self] (result: Result<DailyForecast, NetworkingError>) in
            switch result {
            case .success(let daily):
                self?.dailyForecast = daily
                self?.viewDelegate?.setupDailyWeather(with: daily)
                print(daily)
            case .failure(let error):
                self?.viewDelegate?.showAlert(title: error.localizedDescription)
            }
        }
    }
    
    func getCoordinate(addressString: String, completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                    
                    completionHandler(location.coordinate, nil)
                    return
                }
            }
            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
        }
    }
    
    func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?) -> Void ) {
        if let lastLocation = self.locationManager.location {
            let geocoder = CLGeocoder()
            
            geocoder.reverseGeocodeLocation(lastLocation,
                                            completionHandler: { (placemarks, error) in
                if error == nil {
                    let firstLocation = placemarks?[0]
                    completionHandler(firstLocation)
                }
                else {
                    completionHandler(nil)
                }
            })
        }
        else {
            completionHandler(nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0] as CLLocation
        
        lookUpCurrentLocation { placemark in
            self.setupMainInfoLabels(choose: placemark?.name ?? "")
        }
        self.setupDailyWeather(lat: userLocation.coordinate.latitude, lon: userLocation.coordinate.longitude)
        manager.stopUpdatingLocation()
    }
    
    func setupLocation() {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func saveItem(with title: String) {
        storageManager.save(with: title) { result in
            switch result {
            case .success(let item):
                self.items.append(item)
            case .failure(let error) :
                self.viewDelegate?.showAlert(title: error.localizedDescription)
            }
        }
    }
    
}

