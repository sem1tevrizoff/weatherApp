import Foundation

struct Weather: Codable {
    
    let coord: Coord
    let weather: [WeatherModel]
    let base: String
    let main: Main
    let visibility: Float
    let wind: Wind
    let clouds: Clouds
    let dt: Float
    let sys: Sys
    let timezone: Float
    let id: Int?
    let name: String
    let cod: Float
    
    struct Coord: Codable {
        let lon, lan: Double?
    }
    
    struct WeatherModel: Codable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
    
    struct Main: Codable {
        let temp: Float
        let feelsLike: Float
        let tempMin: Float
        let tempMax: Float
        let pressure: Float
        let humidity: Float
        
        enum CodingKeys: String, CodingKey {
            case temp
            case feelsLike = "feels_like"
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case pressure, humidity
        }
    }
    
    struct Wind: Codable {
        let speed: Float
        let deg: Float
    }
    
    struct Clouds: Codable {
        let all: Float
    }
    
    struct Sys: Codable {
        let type: Int?
        let id: Int?
        let country: String
        let sunrise: Float
        let sunset: Float
    }
}

