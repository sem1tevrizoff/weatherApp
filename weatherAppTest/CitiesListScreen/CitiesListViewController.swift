import UIKit
import Foundation
import CoreData

final class CitiesListViewController: UIViewController {
    
    let presenter: CitiesListPresenter
    
    lazy var citiesView: CitiesView = {
        let view = CitiesView()
        return view
    }()
    
    override func loadView() {
        view = citiesView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mainSetup()
        presenter.getItems()
    }
    
    init(presenter: CitiesListPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func mainSetup() {
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.backgroundColor = .systemBlue
        presenter.citiesViewDelegate = self
        presenter.fetchResultsController.delegate = self
        citiesView.citiesTableView.delegate = self
        citiesView.citiesTableView.dataSource = self
        citiesView.searchBar.delegate = self
    }
    
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
        presenter.cityName?("\(item.name ?? "")")
        self.navigationController?.popViewController(animated: true)
    }
}

extension CitiesListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.presenter.getItemsPredicate(with: searchText)
        citiesView.citiesTableView.reloadData()
    }
}

extension CitiesListViewController: NSFetchedResultsControllerDelegate {
    final func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.citiesView.citiesTableView.reloadData()
    }
}

extension CitiesListViewController: CitiesViewDelegate {
    final func updateTable() {
        citiesView.citiesTableView.reloadData()
    }
    
    final func showAlert(title: String) {
        showErrorAlert(with: title)
    }
}
