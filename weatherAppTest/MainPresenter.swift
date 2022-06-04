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
                print(weatherModel)
            case .failure(let error):
                print(error)
            }
        }
    }
}
