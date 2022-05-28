
import UIKit

class ViewController: UIViewController {
    
    let networkWeatherManager = NetworkingManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getSomeThing(choose: "Brest")
        
    }
    
    private func getSomeThing(choose city: String) {
        networkWeatherManager.request(endpoint: WeatherAPI.link(city)) { (result: Result<Weather, NetworkingError>) in
            switch result {
            case .success(let weather):
                print(weather)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func setUpLayouts() {
        
    }
}

