import Foundation

protocol CitiesViewDelegate: AnyObject {
    func updateTable()
    func showAlert(title: String)
}

class CitiesPresenter {
    
    private let storageManager = StorageManager()
    
    weak var citiesViewDelegate: CitiesViewDelegate?
    
    lazy var fetchResultsController = storageManager.fetchResultsController
    
    var items: [Item] = []
    
    func getItems() {
        storageManager.getItems { result in
            switch result {
            case .success(let items):
                self.items = items
                self.citiesViewDelegate?.updateTable()
            case .failure(let error):
                self.citiesViewDelegate?.showAlert(title: error.localizedDescription)
            }
        }
    }
    
    func getItemsPredicate(with name: String) {
        storageManager.getItemsPredicate(for: name) { result in
            switch result {
            case .success(let items):
                self.items = items
                self.citiesViewDelegate?.updateTable()
            case.failure(let error):
                self.citiesViewDelegate?.showAlert(title: error.localizedDescription)
            }
        }
    }
    
    func deleteItem(at indexPath: IndexPath) {
        storageManager.deleteItem(at: indexPath) { result in
            switch result {
            case .success(_):
                self.deleteItem(at: indexPath)
                self.citiesViewDelegate?.updateTable()
            case .failure(let error):
                self.citiesViewDelegate?.showAlert(title: error.localizedDescription)
            }
        }
    }
}
