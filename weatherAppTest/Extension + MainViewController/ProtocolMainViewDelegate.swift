import Foundation

protocol MainViewDelegate: AnyObject {
    func updateUI(with weather: [Weather])
    func setUpMainLabel(city: String, temp: Float, descriptionWeather: String, maxTemp: Float, minTemp: Float)
}
