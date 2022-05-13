import Foundation

protocol DataFetcher {
    func fetchData<T: Codable>(urlString: String, completion: @escaping (T?) -> Void)
}

class NetworkDataFetcher: DataFetcher {
    
    func fetchData<T: Codable>(urlString: String, completion: @escaping (T?) -> Void) {
        
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard let data = data, error == nil else { return }
            
            do {
                let response = try JSONDecoder().decode(T.self, from: data)
                
                DispatchQueue.main.async {
                    completion(response)
                }
                
            } catch let error {
                print("Failed to decode frome JSON: \(error)")
            }
        }.resume()
    }
}

