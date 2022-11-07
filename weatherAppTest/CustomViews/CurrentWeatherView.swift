//
//  CurrentWeatherView.swift
//  weatherAppTest
//
//  Created by sem1 on 7.11.22.
//

import UIKit

class CurrentWeatherView: UIView {
    
    lazy var loadActivityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.color = .black
        indicator.style = .large
        return indicator
    }()
    
    lazy var nameCityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30)
        return label
    }()
    
    lazy var currentTempLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 60)
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30)
        return label
    }()
    
    lazy var  maxMinTempLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        mainSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func mainSetup() {
        configureLayouts()
        configureLayoutConstraints()
    }
    
    private func configureLayouts() {
        addSubview(loadActivityIndicator)
        [nameCityLabel, currentTempLabel, descriptionLabel, maxMinTempLabel].forEach({
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.textAlignment = .center
        })
    }
    
    private func configureLayoutConstraints() {
        NSLayoutConstraint.activate([
            nameCityLabel.topAnchor.constraint(equalTo: topAnchor, constant: 70),
            nameCityLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            nameCityLabel.heightAnchor.constraint(equalToConstant: 70),
            nameCityLabel.widthAnchor.constraint(equalToConstant: 300),
            
            currentTempLabel.topAnchor.constraint(equalTo: nameCityLabel.bottomAnchor),
            currentTempLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 100),
            currentTempLabel.heightAnchor.constraint(equalToConstant: 50),
            currentTempLabel.widthAnchor.constraint(equalToConstant: 200),
            
            descriptionLabel.topAnchor.constraint(equalTo: currentTempLabel.bottomAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 50),
            descriptionLabel.widthAnchor.constraint(equalToConstant: 300),
            
            maxMinTempLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor),
            maxMinTempLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            maxMinTempLabel.heightAnchor.constraint(equalToConstant: 50),
            maxMinTempLabel.widthAnchor.constraint(equalToConstant: 400),
            
            loadActivityIndicator.topAnchor.constraint(equalTo: topAnchor, constant: 50),
            loadActivityIndicator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 180)
        ])
    }
    
}
