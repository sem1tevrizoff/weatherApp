import Foundation

protocol CitiesViewDelegate: AnyObject {
    
}

class CitiesPresenter {
    
    weak var citiesViewDelegate: CitiesViewDelegate?
    
}
