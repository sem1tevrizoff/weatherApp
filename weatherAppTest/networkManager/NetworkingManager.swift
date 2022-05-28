
import Foundation

class NetworkingManager {
    private func buildURL(endpoint: API) -> URLComponents {
        var components = URLComponents()
        components.scheme = endpoint.scheme.rawValue
        components.host = endpoint.baseURL
        components.path = endpoint.path
        components.queryItems = endpoint.apiParameters
        return components
    }
    
    func request<T: Codable>(endpoint: API, completion: @escaping (Result<T, NetworkingError>) -> Void) {
        let components = buildURL(endpoint: endpoint)
        
        guard let url = components.url else {
            completion(.failure(.unableToComplete))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method.rawValue
        
        let session = URLSession(configuration: .default)
        
        let dataTask = session.dataTask(with: urlRequest) { data, response, error in
            
            if error != nil {
                completion(.failure(.invalidURL))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }

            #warning("Below are some debug code I added and comments")
            #warning("Also I added we comments to your model")
            #warning("Nice netowrk layer btw 😉👍")
            #warning("These warnings you can safely delete")
            
            self.logResponse(for: data) //Prints to console response
            do {
                let responseObject = try JSONDecoder().decode(T.self, from: data)
                completion(.success(responseObject))
            } catch let DecodingError.dataCorrupted(context) { //Prints to console different type of errors
                print(context)
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.typeMismatch(type, context) {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch {
                print("error: ", error)
            }
        }
        dataTask.resume()
    }
    
    func logResponse(for data: Data) {
        let jsonData = try? JSONSerialization.jsonObject(with: data)
        print(String(describing: jsonData))
    }
}
