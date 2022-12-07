//
//  MainView.swift
//  weatherAppTest
//
//  Created by sem1 on 7.11.22.
//

import UIKit

class MainView: UIView {
    
    lazy var currentWeatherView = CurrentWeatherView()
    lazy var dailyTableView = DailyTableView()
    lazy var forecastCollectionView = ForecastCollectionView()
    
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
        [currentWeatherView, dailyTableView, forecastCollectionView].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        backgroundColor = .systemBlue
    }
    
    private func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            currentWeatherView.leadingAnchor.constraint(equalTo: leadingAnchor),
            currentWeatherView.topAnchor.constraint(equalTo: topAnchor),
            currentWeatherView.trailingAnchor.constraint(equalTo: trailingAnchor),
            currentWeatherView.heightAnchor.constraint(equalToConstant: 300),
            
            forecastCollectionView.topAnchor.constraint(equalTo: currentWeatherView.bottomAnchor, constant: 10),
            forecastCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            forecastCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            forecastCollectionView.heightAnchor.constraint(equalToConstant: 100),
            
            dailyTableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            dailyTableView.topAnchor.constraint(equalTo: forecastCollectionView.bottomAnchor, constant: 10),
            dailyTableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            dailyTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}
