import Foundation
import UIKit
import CoreLocation

protocol MainViewDelegate: AnyObject {
    func setupMainLabels(with model: Weather)
    func setupDailyWeather(with model: DailyForecast)
}

class MainPresenter {
    
    let networkWeatherManager = NetworkingManager()
    weak var viewDelegate: MainViewDelegate?
    var currentWeather: Weather?
    var dailyForecast: DailyForecast?

    func setupMainInfoLabels(choose city: String) {
        networkWeatherManager.request(endpoint: WeatherAPI.link(city)) { (result: Result<Weather, NetworkingError>) in
            switch result {
            case .success(let weatherModel):
                self.currentWeather = weatherModel
                self.viewDelegate?.setupMainLabels(with: weatherModel)
            case .failure(let error):
                print(error)
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
                print(error)
            }
        }
    }
    
    func getCoordinate(addressString : String, completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
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
}

