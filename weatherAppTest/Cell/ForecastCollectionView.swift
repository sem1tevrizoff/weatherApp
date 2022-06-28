import Foundation
import UIKit

class ForecastCollectionViewCell: UICollectionViewCell {
    static var reuseID: String {
        String(describing: self)
    }
}

class ForecastContentView: UIView {
    
    // MARK: - Variable
    
    var model: [String] = [] { // твоя модель
        didSet {
            didChangeModel()
        }
    }
    
    // MARK: - GUI
    
    private lazy var forecastCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.scrollDirection = .horizontal
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.delegate = self
        view.dataSource = self
        view.showsHorizontalScrollIndicator = false
        view.register(ForecastCollectionViewCell.self, forCellWithReuseIdentifier: ForecastCollectionViewCell.reuseID)
        
        return view
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(forecastCollectionView)
        forecastCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            forecastCollectionView.topAnchor.constraint(equalTo: topAnchor),
            forecastCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            forecastCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            forecastCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // MARK: - suuport methods
    
    private func didChangeModel() {
        forecastCollectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension ForecastContentView:
    UICollectionViewDataSource,
    UICollectionViewDelegate
{

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return 10
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastCollectionViewCell.reuseID, for: indexPath) as? ForecastCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        
        cell.backgroundColor = .yellow
        return cell
    }
}
