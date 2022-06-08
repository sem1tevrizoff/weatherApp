import Foundation
import UIKit

protocol MainViewDelegate: AnyObject {
    func setUpMainLabel(city: String, temp: Float, descriptionWeather: String, maxTemp: Float, minTemp: Float)
    func setUpForecastWeather(with model: ForecastWeather)
}

class MainPresenter {
    
    let networkWeatherManager = NetworkingManager()
    weak var viewDelegate: MainViewDelegate?
    
    func setUpMainInfoLabels(choose city: String) {
        networkWeatherManager.request(endpoint: WeatherAPI.link(city)) { (result: Result<Weather, NetworkingError>) in
            switch result {
            case .success(let weatherModel):
                self.viewDelegate?.setUpMainLabel(city: weatherModel.name,
                                                  temp: weatherModel.main.temp,
                                                  descriptionWeather: weatherModel.weather[0].description,
                                                  maxTemp: weatherModel.main.tempMax,
                                                  minTemp: weatherModel.main.tempMin)
            case .failure(let error):
                print(error)
            }
        }
    }

    func setUpForecastWeather(choose city: String) {
        networkWeatherManager.request(endpoint: WeatherAPI.forecast(city)) { [weak self] (result: Result<ForecastWeather, NetworkingError>) in
            switch result {
            case .success(let forecast):
                self?.viewDelegate?.setUpForecastWeather(with: forecast)
            case .failure(let error):
                print(error)
            }
        }
    }
}
