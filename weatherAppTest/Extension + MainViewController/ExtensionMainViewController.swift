import Foundation
import UIKit
extension MainViewController: MainViewDelegate {
    
//    func updateUI(with weather: [Weather]) {
//        self.weatherModel = weather
//    }
    
    func setUpMainLabel(city: String, temp: Float, descriptionWeather: String, maxTemp: Float, minTemp: Float) {
        DispatchQueue.main.async {
            self.nameCityLabel.text = city
            self.currentTempLabel.text = "\(temp.kelvinToCelsiusConverter())°C"
            self.descriptionLabel.text = "\(descriptionWeather)"
            self.maxMinTempLabel.text = "Max temp \(maxTemp.kelvinToCelsiusConverter())°C Min temp \(minTemp.kelvinToCelsiusConverter())°C"
        }
    }
    
    func setUpForecastWeather(with model: ForecastWeather) {
        self.weatherModel = model
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


extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherModel?.list.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ForecastCollectionViewCell", for: indexPath) as? ForecastCollectionViewCell,
            let cellModel = weatherModel?.list[indexPath.row]
        else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: cellModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 200)
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            self.createFeaturedSection()
        }

        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        layout.configuration = configuration
        return layout
    }

    func createFeaturedSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))

       let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
       layoutItem.contentInsets = NSDirectionalEdgeInsets(top:5, leading: 5, bottom: 0, trailing: 5)

       let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(110))
       let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])

       let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
       return layoutSection
    }
}
