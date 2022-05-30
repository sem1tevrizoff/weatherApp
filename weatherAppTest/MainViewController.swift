import UIKit

protocol MainViewDelegate: AnyObject {
    func updateUI(with weather: [Weather])
    func changeLabel(city: String)
}

class MainViewController: UIViewController {
    
    let presenter: MainPresenter
    var weatherModel = [Weather]()
    let someLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpLabel()
        presenter.getSomeThing(choose: "Moscow")
    }
    
    init(presenter: MainPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpLabel() {
        view.addSubview(someLabel)
        someLabel.textAlignment = .center
        someLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            someLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            someLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            someLabel.heightAnchor.constraint(equalToConstant: 100),
            someLabel.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
}

extension MainViewController: MainViewDelegate {
    
    func updateUI(with weather: [Weather]) {
        self.weatherModel = weather
    }
    
    func changeLabel(city: String) {
        DispatchQueue.main.async {
            self.someLabel.text = city
        }
    }
}



