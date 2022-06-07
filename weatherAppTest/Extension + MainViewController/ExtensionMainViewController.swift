import Foundation
import UIKit

#warning("Делать extension отдельным файлом, если это extension одного вьюконтроллера, фиговая практика. Лучше их деражать в одном классе с контроллером. А в extension полноценные extension - как твой Float")
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

#warning("Если очень хочется extension можно сдедать как внизу. Но можно и просто перенести функцию showAlert() в MainViewController")

/*
extension UIViewController {
    
    func showCityAlert(with completion: @escaping (String) -> Void) {
        let alertVC = UIAlertController(title: "Choose City",
                                        message: nil,
                                        preferredStyle: .alert)
        alertVC.addTextField { textField in
            textField.placeholder = "City Name"
        }
        
        let allertAction = UIAlertAction(title: "Find", style: .default) { UIAlertAction in
            let firstTextField = alertVC.textFields![0] as UITextField
            guard let cityName = firstTextField.text else { return }
            completion(cityName)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alertVC.addAction(allertAction)
        alertVC.addAction(cancelAction)
        
        self.present(alertVC, animated: true)
    }
}

//Вызывать так из ViewController'а

showCityAlert { [weak self] cityName in
    self?.presenter.setUpMainInfoLabels(choose: cityName)
}
 
//Еще вариант - сделать класс типа AlertPresenter 
*/
