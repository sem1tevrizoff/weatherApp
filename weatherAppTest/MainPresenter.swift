import Foundation
import UIKit

class MainPresenter {
    
    let networkWeatherManager = NetworkingManager()
    weak var viewDelegate: MainViewDelegate?
    
    func getSomeThing(choose city: String) {
        networkWeatherManager.request(endpoint: WeatherAPI.link(city)) { (result: Result<Weather, NetworkingError>) in
            switch result {
            case .success(let weather):
                self.viewDelegate?.updateUI(with: [weather])
                self.viewDelegate?.changeLabel(city: weather.name)
                print(weather)
            case .failure(let error):
                print(error)
            }
        }
    }
}
