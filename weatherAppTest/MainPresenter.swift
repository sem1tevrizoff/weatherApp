import Foundation
import UIKit

#warning("Протокол обычно помещают в том же файле. Я бы переместил MainViewDelegate сюда и переименовал в MainPresenterDelegate")

class MainPresenter {
    
    let networkWeatherManager = NetworkingManager()
    weak var viewDelegate: MainViewDelegate?
    
    func setUpMainInfoLabels(choose city: String) {
        networkWeatherManager.request(endpoint: WeatherAPI.link(city)) { (result: Result<Weather, NetworkingError>) in
            switch result {
            case .success(let weatherModel):
                self.viewDelegate?.updateUI(with: [weatherModel])
                #warning("Не понятно зачем ты передаешь [weatherModel] во вью контроллер, когда так хорошо и правильно разделил функции и передаешь туда всю нужную инфу через setUpMainLabel. updateUI можно выпилить. ")
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
