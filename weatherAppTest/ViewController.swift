
import UIKit

class ViewController: UIViewController {
    
    let networkWeatherManager = NetworkingManager()
    var weatherModel = [Weather]()
    let someLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getSomeThing(choose: "Perm")
        setUpLabel()
    }
    
    private func getSomeThing(choose city: String) {
        networkWeatherManager.request(endpoint: WeatherAPI.link(city)) { (result: Result<Weather, NetworkingError>) in
            switch result {
            case .success(let weather):
                print(weather)
                DispatchQueue.main.async {
                    self.someLabel.text = weather.name
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func setUpLabel() {
        view.addSubview(someLabel)
        someLabel.textAlignment = .center
        someLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            someLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            someLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            someLabel.heightAnchor.constraint(equalToConstant: 100),
            someLabel.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
}

