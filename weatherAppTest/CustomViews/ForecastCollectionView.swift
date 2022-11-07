//
//  ForecastCollectionView.swift
//  weatherAppTest
//
//  Created by sem1 on 7.11.22.
//

import UIKit

class ForecastCollectionView: UIView {
    
    var hourlyForecast: [DailyModel.Hourly] = [] {
        didSet {
            DispatchQueue.main.async {
                self.forecastCollectionView.reloadData()
            }
        }
    }
    
    lazy var forecastCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.scrollDirection = .horizontal
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBlue
        collectionView.layer.borderWidth = 0.5
        collectionView.layer.borderColor = UIColor.systemFill.cgColor
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ForecastCollectionViewCell.self, forCellWithReuseIdentifier: ForecastCollectionViewCell.reuseID)
        return collectionView
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
        addSubview(forecastCollectionView)
        forecastCollectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            forecastCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            forecastCollectionView.topAnchor.constraint(equalTo: topAnchor),
            forecastCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            forecastCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}

extension ForecastCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourlyForecast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastCollectionViewCell.reuseID, for: indexPath) as? ForecastCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        
        let cellModel = hourlyForecast[indexPath.row]
        cell.configure(with: cellModel)
        return cell
    }
}
