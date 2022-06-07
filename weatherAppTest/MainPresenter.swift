import Foundation
import UIKit

#warning("Протокол обычно помещают в том же файле. Я бы переместил MainViewDelegate сюда и переименовал в MainPresenterDelegate")

class MainPresenter {
    
    let networkWeatherManager = NetworkingManager()
    let forecastWeather: [ForecastTemperature] = []
    weak var viewDelegate: MainViewDelegate?
    
    func setUpMainInfoLabels(choose city: String) {
        networkWeatherManager.request(endpoint: WeatherAPI.link(city)) { (result: Result<Weather, NetworkingError>) in
            switch result {
            case .success(let weatherModel):
                self.viewDelegate?.updateUI(with: [weatherModel])
                #warning("Не понятно зачем ты передаешь [weatherModel] во вью контроллер, когда так хорошо и правильно разделил функции и передаешь туда всю нужную инфу через setUpMainLabel. updateUI можно выпилить. ")
                self.viewDelegate?.setUpMainLabel(city: weatherModel.name,
                                                  temp: weatherModel.main.temp,
                                                  descriptionWeather: weatherModel.weather[0].description,
                                                  maxTemp: weatherModel.main.tempMax,
                                                  minTemp: weatherModel.main.tempMin)
                self.viewDelegate?.setUpForecastWeather(city: weatherModel.name)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func setUpForecastWeather(choose city: String) {
        networkWeatherManager.request(endpoint: WeatherAPI.forecast(city)) { (result: Result<ForecastWeather, NetworkingError>) in
            switch result {
            case .success(let forecast):
                var currentDayTemp = ForecastTemperature(weekDay: nil, hourlyForecast: nil)
                var secondDayTemp = ForecastTemperature(weekDay: nil, hourlyForecast: nil)
                var thirdDayTemp = ForecastTemperature(weekDay: nil, hourlyForecast: nil)
                var fourthDayTemp = ForecastTemperature(weekDay: nil, hourlyForecast: nil)
                var fifthDayTemp = ForecastTemperature(weekDay: nil, hourlyForecast: nil)
                var sixthDayTemp = ForecastTemperature(weekDay: nil, hourlyForecast: nil)
                
                var forecastModelArray: [ForecastTemperature] = []
                var fetchedData: [WeatherInfo] = []
                
                var currentDayForecast: [WeatherInfo] = []
                var secondDayForecast: [WeatherInfo] = []
                var thirddayDayForecast: [WeatherInfo] = []
                var fourthDayDayForecast: [WeatherInfo] = []
                var fifthDayForecast: [WeatherInfo] = []
                var sixthDayForecast: [WeatherInfo] = []
                print("Total data:", forecast.list.count)
                
                var totalData = forecast.list.count //Should be 40 all the time
                
                for day in 0...forecast.list.count - 1 {
                    let listIndex = day
                    let mainTemp = forecast.list[listIndex].main.temp
                    let minTemp = forecast.list[listIndex].main.tempMin
                    let maxTemp = forecast.list[listIndex].main.tempMax
                    let descriptionTemp = forecast.list[listIndex].weather.description
                    let icon = forecast.list[listIndex].weather[0].icon
                    let time = forecast.list[listIndex].dataText
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.calendar = Calendar(identifier: .gregorian)
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let date = dateFormatter.date(from: forecast.list[listIndex].dataText ?? "")
                    
                    let calendar = Calendar.current
                    let components = calendar.dateComponents([.weekday], from: date!)
                    let weekdaycomponent = components.weekday! - 1
                    
                    let fact = DateFormatter()
                    let weekday = fact.weekdaySymbols[weekdaycomponent]
                        
                    let currentDayComponent = calendar.dateComponents([.weekday], from: Date())
                    let currentWeekDay = currentDayComponent.weekday! - 1
                    let currentweekdaysymbol = fact.weekdaySymbols[currentWeekDay]
                    
                    if weekdaycomponent == currentWeekDay - 1 {
                        totalData = totalData - 1
                    }
                    
                    if weekdaycomponent == currentWeekDay {
                        let info = WeatherInfo(temp: mainTemp, min_temp: minTemp, max_temp: maxTemp, description: descriptionTemp, icon: icon, time: time)
                        currentDayForecast.append(info)
                        currentDayTemp = ForecastTemperature(weekDay: currentweekdaysymbol, hourlyForecast: currentDayForecast)
                        fetchedData.append(info)
                    } else if weekdaycomponent == currentWeekDay.incrementWeekDays(by: 1) {
                        let info = WeatherInfo(temp: mainTemp, min_temp: minTemp, max_temp: maxTemp, description: descriptionTemp, icon: icon, time: time)
                        secondDayForecast.append(info)
                        secondDayTemp = ForecastTemperature(weekDay: weekday, hourlyForecast: secondDayForecast)
                        fetchedData.append(info)
                    } else if weekdaycomponent == currentWeekDay.incrementWeekDays(by: 2) {
                        let info = WeatherInfo(temp: mainTemp, min_temp: minTemp, max_temp: maxTemp, description: descriptionTemp, icon: icon, time: time)
                        thirddayDayForecast.append(info)
                        thirdDayTemp = ForecastTemperature(weekDay: weekday, hourlyForecast: thirddayDayForecast)
                        fetchedData.append(info)
                    } else if weekdaycomponent == currentWeekDay.incrementWeekDays(by: 3) {
                        let info = WeatherInfo(temp: mainTemp, min_temp: minTemp, max_temp: maxTemp, description: descriptionTemp, icon: icon, time: time)
                        fourthDayDayForecast.append(info)
                        fourthDayTemp = ForecastTemperature(weekDay: weekday, hourlyForecast: fourthDayDayForecast)
                        fetchedData.append(info)
                    } else if weekdaycomponent == currentWeekDay.incrementWeekDays(by: 4){
                        let info = WeatherInfo(temp: mainTemp, min_temp: minTemp, max_temp: maxTemp, description: descriptionTemp, icon: icon, time: time)
                        fifthDayForecast.append(info)
                        fifthDayTemp = ForecastTemperature(weekDay: weekday, hourlyForecast: fifthDayForecast)
                        fetchedData.append(info)
                    } else if weekdaycomponent == currentWeekDay.incrementWeekDays(by: 5) {
                        let info = WeatherInfo(temp: mainTemp, min_temp: minTemp, max_temp: maxTemp, description: descriptionTemp, icon: icon, time: time)
                        sixthDayForecast.append(info)
                        sixthDayTemp = ForecastTemperature(weekDay: weekday, hourlyForecast: sixthDayForecast)
                        fetchedData.append(info)
                    }
                    
                    if fetchedData.count == totalData {
                        
                        if currentDayTemp.hourlyForecast?.count ?? 0 > 0 {
                            forecastModelArray.append(currentDayTemp)
                        }
                        
                        if secondDayTemp.hourlyForecast?.count ?? 0 > 0 {
                            forecastModelArray.append(secondDayTemp)
                        }
                        
                        if thirdDayTemp.hourlyForecast?.count ?? 0 > 0 {
                            forecastModelArray.append(thirdDayTemp)
                        }
                        
                        if fourthDayTemp.hourlyForecast?.count ?? 0 > 0 {
                            forecastModelArray.append(fourthDayTemp)
                        }
                        
                        if fifthDayTemp.hourlyForecast?.count ?? 0 > 0 {
                            forecastModelArray.append(fifthDayTemp)
                        }
                        
                        if sixthDayTemp.hourlyForecast?.count ?? 0 > 0 {
                            forecastModelArray.append(sixthDayTemp)
                        }
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
