import Foundation
import UIKit
extension MainViewController: MainViewDelegate {
    
    func updateUI(with weather: [Weather]) {
        self.weatherModel = weather
    }
    
    func setUpMainLabel(city: String, temp: Float, descriptionWeather: String, maxTemp: Float, minTemp: Float) {
        DispatchQueue.main.async {
            self.nameCityLabel.text = city
            self.currentTempLabel.text = "\(temp.kelvinToCelsiusConverter())°C"
            self.descriptionLabel.text = "\(descriptionWeather)"
            self.maxMinTempLabel.text = "Max temp \(maxTemp.kelvinToCelsiusConverter())°C Min temp \(minTemp.kelvinToCelsiusConverter())°C"
        }
    }
}

extension MainViewController {
    func showAlert() {
        let alertVC = UIAlertController(title: "Choose City",
                                        message: nil,
                                        preferredStyle: .alert)
        alertVC.addTextField { textField in
            textField.placeholder = "City Name"
        }
        
        let allertAction = UIAlertAction(title: "Find", style: .default) { UIAlertAction in
            let firstTextField = alertVC.textFields![0] as UITextField
            guard let cityName = firstTextField.text else { return }
            self.presenter.setUpMainInfoLabels(choose: cityName)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alertVC.addAction(allertAction)
        alertVC.addAction(cancelAction)
        
        self.present(alertVC, animated: true)
    }
}
