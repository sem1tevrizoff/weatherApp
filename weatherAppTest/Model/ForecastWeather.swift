import Foundation

struct ForecastWeather: Codable {
    let list: [List]

    struct List: Codable {
        let main: Main
        let weather: [Weather]
        let dataText: String

        enum CodingKeys: String, CodingKey {
            case main, weather
            case dataText = "dt_txt"
        }
    }

    struct Main: Codable {
        let temp: Float
        let tempMin: Float
        let tempMax: Float

        enum CodingKeys: String, CodingKey {
            case temp
            case tempMin = "temp_min"
            case tempMax = "temp_max"
        }
    }

    struct Weather: Codable {
        let description: String
        let icon: String
    }
}

