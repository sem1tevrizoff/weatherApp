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
    
    func setUpForecastWeather(city: String) {
        DispatchQueue.main.async {
            self.forecastCollectionView.reloadData()
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
            self.presenter.setUpForecastWeather(choose: cityName)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alertVC.addAction(allertAction)
        alertVC.addAction(cancelAction)
        
        self.present(alertVC, animated: true)
    }
}

// <<<<<<< code-review
// #warning("Если очень хочется extension можно сдедать как внизу. Но можно и просто перенести функцию showAlert() в MainViewController")

// /*
// extension UIViewController {
    
//     func showCityAlert(with completion: @escaping (String) -> Void) {
//         let alertVC = UIAlertController(title: "Choose City",
//                                         message: nil,
//                                         preferredStyle: .alert)
//         alertVC.addTextField { textField in
//             textField.placeholder = "City Name"
//         }
        
//         let allertAction = UIAlertAction(title: "Find", style: .default) { UIAlertAction in
//             let firstTextField = alertVC.textFields![0] as UITextField
//             guard let cityName = firstTextField.text else { return }
//             completion(cityName)
//         }
        
//         let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
//         alertVC.addAction(allertAction)
//         alertVC.addAction(cancelAction)
        
//         self.present(alertVC, animated: true)
//     }
// }

// //Вызывать так из ViewController'а

// showCityAlert { [weak self] cityName in
//     self?.presenter.setUpMainInfoLabels(choose: cityName)
// }
 
// //Еще вариант - сделать класс типа AlertPresenter 
// */
// =======

// extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
//     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//         let forecastWeather: [ForecastTemperature] = []
//         return forecastWeather.count
//     }
    
//     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//         guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ForecastCollectionViewCell", for: indexPath) as? ForecastCollectionViewCell else { return UICollectionViewCell() }
        
//         let dailyForecast: [ForecastTemperature] = []
//         cell.configure(with: dailyForecast[indexPath.row])
//         return cell
//     }
    
//     func createCompositionalLayout() -> UICollectionViewLayout {
//         let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
//             self.createFeaturedSection()
//         }

//         let configuration = UICollectionViewCompositionalLayoutConfiguration()
//         layout.configuration = configuration
//         return layout
//     }

//     func createFeaturedSection() -> NSCollectionLayoutSection {
//         let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))

//        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
//        layoutItem.contentInsets = NSDirectionalEdgeInsets(top:5, leading: 5, bottom: 0, trailing: 5)

//        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(110))
//        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])

//        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
//        return layoutSection
//     }
// }
// >>>>>>> develop
