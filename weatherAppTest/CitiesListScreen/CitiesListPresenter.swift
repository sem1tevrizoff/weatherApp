import Foundation

protocol CitiesViewDelegate: AnyObject {
    func updateTable()
    func showAlert(title: String)
}

final class CitiesListPresenter {
    
    private let storageManager = StorageManager()
    
    var callBack: ((_ name: String) -> Void)?

    weak var citiesViewDelegate: CitiesViewDelegate?
    
    lazy var fetchResultsController = storageManager.fetchResultsController
    
    lazy var items: [Item] = []
    
    final func getItems() {
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
    
    final func getItemsPredicate(with name: String) {
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
    
    final func deleteItem(at indexPath: IndexPath) {
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
