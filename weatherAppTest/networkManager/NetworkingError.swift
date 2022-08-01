
import Foundation

enum NetworkingError: String, Error {
    case invalidURL = "Please, check your internet connection"
    case unableToComplete = "Unable to complete your request. Please check your internet connection"
    case invalidData = "The data received from the server was invalid. Please try again"
    case invalidResponse = "Invalid response from the server. Please try again"
}
