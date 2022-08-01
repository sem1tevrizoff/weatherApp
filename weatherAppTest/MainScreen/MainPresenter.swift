import Foundation
import UIKit
import CoreLocation

protocol MainViewDelegate: AnyObject {
    func setupMainLabels(with model: WeatherModel)
    func setupDailyWeather(with model: DailyModel)
    func showAlert(title: String)
}

final class MainPresenter: NSObject, CLLocationManagerDelegate {
    
    private let networkWeatherManager = NetworkingManager()
    private let storageManager = StorageManager()
    
    weak var viewDelegate: MainViewDelegate?
    lazy var locationManager = CLLocationManager()
    
    lazy var currentCity = ""
    lazy var items: [Item] = []
    
    var currentWeather: WeatherModel?
    var dailyForecast: DailyModel?
    
    final func getCityInfo(with city: String) {
        setupMainInfoLabels(choose: city)
        getCoordinate(addressString: city) { coordinate, error in
            self.setupDailyWeather(lat: coordinate.latitude, lon: coordinate.longitude)
        }
    }
    
    final func setupMainInfoLabels(choose city: String) {
        networkWeatherManager.request(endpoint: WeatherAPI.link(city)) { (result: Result<WeatherModel, NetworkingError>) in
            switch result {
            case .success(let weatherModel):
                self.currentWeather = weatherModel
                self.viewDelegate?.setupMainLabels(with: weatherModel)
                self.currentCity = weatherModel.name
                self.saveItem(with: city)
            case .failure(let error):
                self.viewDelegate?.showAlert(title: error.rawValue)
            }
        }
    }
    
    final func setupDailyWeather(lat: Double, lon: Double) {
        networkWeatherManager.request(endpoint: WeatherAPI.daily(lat: lat, lon: lon)) { [weak self] (result: Result<DailyModel, NetworkingError>) in
            switch result {
            case .success(let daily):
                self?.dailyForecast = daily
                self?.viewDelegate?.setupDailyWeather(with: daily)
            case .failure(let error):
                self?.viewDelegate?.showAlert(title: error.rawValue)
            }
        }
    }
    
    final func getCoordinate(addressString: String, completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
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
    
    final func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?) -> Void ) {
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
    
    final func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0] as CLLocation
        
        lookUpCurrentLocation { placemark in
            self.setupMainInfoLabels(choose: placemark?.name ?? "")
        }
        self.setupDailyWeather(lat: userLocation.coordinate.latitude, lon: userLocation.coordinate.longitude)
        manager.stopUpdatingLocation()
    }
    
    final func setupLocation() {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    final func saveItem(with title: String) {
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

