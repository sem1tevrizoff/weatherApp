import UIKit
import Foundation
import CoreData

class ChoosenCitiesViewController: UIViewController {
    
    let presenter: CitiesPresenter
    
    lazy var citiesTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemBlue
        tableView.layer.borderWidth = 0.5
        tableView.layer.borderColor = UIColor.systemFill.cgColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        return tableView
    }()
    
    private lazy var searchBar: UISearchBar = {
        let search = UISearchBar()
        return search
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        mainSetup()
        presenter.getItems()
        self.presenter.fetchResultsController.delegate = self
    }
    
    init(presenter: CitiesPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func mainSetup() {
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        setupSearchBar()
    }
    
    private func setupViews() {
        view.addSubview(citiesTableView)
    }
    
    private func setupSearchBar() {
        citiesTableView.tableHeaderView = searchBar
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search for city..."
        searchBar.delegate = self
        searchBar.sizeToFit()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            citiesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            citiesTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 85),
            citiesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            citiesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension ChoosenCitiesViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.citiesTableView.reloadData()
    }
}

extension ChoosenCitiesViewController: CitiesViewDelegate {
    func updateTable() {
        citiesTableView.reloadData()
    }
    func showAlert(title: String) {
        print("failed")
    }
}
