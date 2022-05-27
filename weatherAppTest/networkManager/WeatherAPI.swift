import Foundation

enum WeatherAPI: API {
    
    case link(String)
    
    var scheme: HTTPScheme {
        switch self {
        case .link:
            return .https
        }
    }
    var method: HTTPMethod {
        switch self {
        case .link:
            return .get
        }
    }
    var baseURL: String {
        switch self {
        case .link:
            return "api.openweathermap.org"
        }
    }
        
    var path: String {
        switch self {
        case .link:
            return "/data/2.5/weather/"
        }
    }
        
    var apiParameters: [URLQueryItem] {
        switch self {
        case .link(let city):
            return [
                URLQueryItem(name: "q", value: city),
                URLQueryItem(name: "appid", value: "fb5bece52b5f91b36dd8c1940132f704")]
        }
    }
}
