import Foundation

struct DailyForecast: Codable {
    let lat: Double
    let lon: Double
    let timezone: String
    let current: Current
    let hourly: [Hourly]
    let daily: [Daily]
    
    
    struct Current: Codable {
        let dt: Int
        let temp: Float
        let weather: [Weather]
    }
    
    struct Weather: Codable {
        let icon: String
    }
    
    struct Hourly: Codable {
        let dt: Int
        let temp: Float
    }
    
    struct Daily: Codable {
        let dt: Int
        let temp: Temp
        
        struct Temp: Codable {
            let day: Float
        }
    }
}
