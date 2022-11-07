//
//  DailyTableView.swift
//  weatherAppTest
//
//  Created by sem1 on 7.11.22.
//

import UIKit

class DailyTableView: UIView {
    
    var dailyForecast: [DailyModel.Daily] = [] {
        didSet {
            DispatchQueue.main.async {
                self.dailyTableView.reloadData()
            }
        }
    }
    
    lazy var dailyTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBlue
        tableView.layer.borderWidth = 0.5
        tableView.layer.borderColor = UIColor.systemFill.cgColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DailyTableViewCell.self, forCellReuseIdentifier: DailyTableViewCell.reuseID)
        return tableView
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
        setupLayoutConstraints()
    }
    
    private func setupLayouts() {
        addSubview(dailyTableView)
        dailyTableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            dailyTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dailyTableView.topAnchor.constraint(equalTo: topAnchor),
            dailyTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dailyTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}

extension DailyTableView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyForecast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DailyTableViewCell.reuseID, for: indexPath) as? DailyTableViewCell
        else { return UITableViewCell() }
        
        let cellModel = dailyForecast[indexPath.row]
        cell.configure(with: cellModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
