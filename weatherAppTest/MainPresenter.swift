import Foundation
import UIKit

class MainPresenter {
    
    let networkWeatherManager = NetworkingManager()
    weak var viewDelegate: MainViewDelegate?
    
    func setUpMainInfoLabels(choose city: String) {
        networkWeatherManager.request(endpoint: WeatherAPI.link(city)) { (result: Result<Weather, NetworkingError>) in
            switch result {
            case .success(let weatherModel):
                self.viewDelegate?.updateUI(with: [weatherModel])
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
        networkWeatherManager.request(endpoint: WeatherAPI.forecast(city)) { (result: Result<ForecastWeather, NetworkingError>) in
            switch result {
            case .success(let forecastWeather):
                print(forecastWeather)
            case .failure(let error):
                print(error)
            }
        }
    }
}
