//
//  ChoosenCitiesViewController.swift
//  weatherAppTest
//
//  Created by sem1 on 24.07.22.
//

import UIKit
import Foundation

class ChoosenCitiesViewController: UIViewController {
    
    let presenter: CitiesPresenter
    
    private lazy var citiesTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.borderWidth = 0.5
        tableView.layer.borderColor = UIColor.systemFill.cgColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChoosenCitiesTableViewCell.self, forCellReuseIdentifier: ChoosenCitiesTableViewCell.reuseID)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        mainSetup()
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
    }
    
    private func setupViews() {
        view.addSubview(citiesTableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            citiesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            citiesTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            citiesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            citiesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension ChoosenCitiesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChoosenCitiesTableViewCell.reuseID, for: indexPath) as? ChoosenCitiesTableViewCell else { return UITableViewCell()}
        cell.textLabel?.text = "123"
        return cell
    }
    
    
}

extension ChoosenCitiesViewController: CitiesViewDelegate {
    
}
