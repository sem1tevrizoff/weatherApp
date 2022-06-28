import Foundation
import UIKit

extension MainViewController {
    
     func showCityAlert(with completion: @escaping (String) -> Void) {
         let alertVC = UIAlertController(title: "Choose City",
                                         message: nil,
                                         preferredStyle: .alert)
         alertVC.addTextField { textField in
             textField.placeholder = "City Name"
         }
        
         let allertAction = UIAlertAction(title: "Find", style: .default) { UIAlertAction in
            guard let firstTextField = alertVC.textFields?.first,
            let cityName = firstTextField.text,
            !cityName.isEmpty else { return }
            completion(cityName)
         }
        
         let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
         alertVC.addAction(allertAction)
         alertVC.addAction(cancelAction)
        
         self.present(alertVC, animated: true)
     }
 }

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.dailyForecast?.daily.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DailyTableViewCell", for: indexPath) as? DailyTableViewCell,
              let cellModel = presenter.dailyForecast?.daily[indexPath.row]
        else { return UITableViewCell() }
        
        cell.configure(with: cellModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}



