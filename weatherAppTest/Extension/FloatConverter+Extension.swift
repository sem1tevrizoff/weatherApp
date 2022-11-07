import Foundation

extension Float {
    func truncate(places: Int) -> Float {
        return Float(floor(pow(10.0, Float(places)) * self) / pow(10.0, Float(places)))
    }
    
    func kelvinToCelsiusConverter() -> Float {
        let constantValue: Float = 273.15
        let kelValue = self
        let celsiusValue = kelValue - constantValue
        return celsiusValue.truncate(places: 1)
    }
}
