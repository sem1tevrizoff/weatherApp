//
//  CitiesView.swift
//  weatherAppTest
//
//  Created by sem1 on 7.11.22.
//

import UIKit
import CoreData

class CitiesView: UIView {
    
    lazy var citiesTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemBlue
        tableView.layer.borderWidth = 0.5
        tableView.layer.borderColor = UIColor.systemFill.cgColor
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        return tableView
    }()
    
    lazy var searchBar: UISearchBar = {
        let search = UISearchBar()
        return search
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        mainSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func mainSetup() {
        setupLayouts()
        setupSearchBar()
        setupLayoutConstraints()
    }
    
    private func setupLayouts() {
        addSubview(citiesTableView)
    }
    
    private func setupSearchBar() {
        citiesTableView.tableHeaderView = searchBar
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search for city..."
        searchBar.sizeToFit()
    }
    
    private func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            citiesTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            citiesTableView.topAnchor.constraint(equalTo: topAnchor, constant: 85),
            citiesTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            citiesTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
