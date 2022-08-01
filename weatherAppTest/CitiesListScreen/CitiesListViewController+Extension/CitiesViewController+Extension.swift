import Foundation
import UIKit
import CoreData

extension CitiesListViewController {
    final func showErrorAlert(with message: String) {
        let alertVC = UIAlertController(title: "Try to choose another city!",
                                        message: message,
                                        preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .destructive)
        
        alertVC.addAction(alertAction)
        self.present(alertVC, animated: true)
    }
}

extension CitiesListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.presenter.fetchResultsController.sections?.first?.numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        let item = presenter.fetchResultsController.object(at: indexPath)
        
        cell.backgroundColor = .systemBlue
        cell.textLabel?.textColor = .white
        cell.textLabel?.text = item.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter.deleteItem(at: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = presenter.items[indexPath.row]
        presenter.callBack?("\(item.name ?? "")")
        self.navigationController?.popViewController(animated: true)
    }
}

extension CitiesListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.presenter.getItemsPredicate(with: searchText)
        citiesTableView.reloadData()
    }
}


