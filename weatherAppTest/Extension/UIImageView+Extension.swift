import Foundation
import UIKit

extension UIImageView {
    final func loadImageFromUrl(urlString: String, placeholder: UIImage? = nil) {
        self.image = nil

        let imageCache = NSCache<NSString, UIImage>()

        let key = NSString(string: urlString)

        if let cachedImage = imageCache.object(forKey: key) {
            self.image = cachedImage
            return
        }

        if let placeholder = placeholder {
            self.image = placeholder
        }

        guard let url = URL(string: urlString) else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async() {
                if let data = data,
                   let image = UIImage(data: data) {
                    imageCache.setObject(image, forKey: key)
                    self.image = image
                }
            }
        }
        task.resume()
    }
}
