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
