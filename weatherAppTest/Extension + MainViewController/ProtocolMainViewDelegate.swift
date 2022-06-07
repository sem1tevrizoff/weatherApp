import Foundation

protocol MainViewDelegate: AnyObject {
    func updateUI(with weather: [Weather])
    func setUpMainLabel(city: String, temp: Float, descriptionWeather: String, maxTemp: Float, minTemp: Float)
    #warning("Много параметров в функции не есть хорошо. Я бы сделал модель MainViewModel и собирал бы её в презентере. Норм практика. Пример внизу")
}

/*
struct MainViewModel {
    let city: String
    let temp: Float
    let descriptionWeather: String
    let maxTemp: Float
    let minTemp: Float
}

//-> В презентере
let model = MainViewModel(
    city: weatherModel.name,
    temp: weatherModel.main.temp,
    descriptionWeather: weatherModel.weather[0].description,
    maxTemp: weatherModel.main.tempMax,
    minTemp: weatherModel.main.tempMin
)

self.viewDelegate?.setUpMainLabel(with: model)

*/
