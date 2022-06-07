import Foundation

struct ForecastWeather: Codable {
    let cod: String
    let message: Int
    let cnt: Int
    let list: [List]
    let city: City

    struct List: Codable {
        let dt: Float
        let main: Main
        let weather: [Weather]
        let clouds: Clouds
        let wind: Wind
        let visibility: Float
        let pop: Float
        let dataText: String?

        enum CodingKeys: String, CodingKey {
            case dt, main, weather, clouds, wind, visibility, pop
            case dataText = "dt_txt"
        }
    }

    struct City: Codable {
        let id: Float
        let name: String
        let country: String
    }

    struct Main: Codable {
        let temp: Float
        let feelsLike: Float
        let tempMin: Float
        let tempMax: Float
        let pressure: Float
        let seaLevel: Float
        let grndLevel: Float
        let humidity: Float
        let tempKf: Float

        enum CodingKeys: String, CodingKey {
            case temp
            case feelsLike = "feels_like"
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case pressure
            case seaLevel = "sea_level"
            case grndLevel = "grnd_level"
            case humidity
            case tempKf = "temp_kf"
        }
    }

    struct Weather: Codable {
        let id: Float
        let main: String
        let description: String
        let icon: String
    }

    struct Clouds: Codable {
        let all: Float
    }

    struct Wind: Codable {
        let speed: Float
        let deg: Float
        let gust: Float
    }

    struct Sys: Codable {
        let pod: String
    }
}

struct WeatherInfo {
    let temp: Float
    let min_temp: Float
    let max_temp: Float
    let description: String
    let icon: String
    let time: String?
    
    enum CodingKeys: String, CodingKey {
        case temp
        case minTemp = "min_temp"
        case maxTemp = "max_temp"
        case description, icon, time
    }
}

struct ForecastTemperature {
    let weekDay: String?
    let hourlyForecast: [WeatherInfo]?
}
