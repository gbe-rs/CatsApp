//
//  CatsViewModel.swift
//  Cats
//
//  Created by admin on 20/07/23.
//

import Foundation
import UIKit

class CatsViewModel {
    
    //Delegate
    weak var delegate: CatsDelegate?
    
    //Images
    public var imageModels: [ImageModel] = []
    
    //Count
    func numberOfImages() -> Int {
        return imageModels.count
    }
    
    //MARK: GET API
    
    func getData() {
        let parameters = [
            "ClientSecret": "63775118a9f912fd91ed99574becf3b375d9eeca"
        ]
        
        getAPIDataFromURL(with: parameters) { result in
            switch result {
            case .success(let jsonData):
                if let jsonData = self.convertDictionaryToData(dictionary: jsonData) {
                    self.parseAPIData(data: jsonData)
                }
                print("API response JSON: \(jsonData)")
            case .failure(let error):
                print("API request error: \(error)")
            }
        }
    }
    
    //CONVERT JSON DATA
    
    func convertDictionaryToData(dictionary: [String: Any]) -> Data? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: [])
            return jsonData
        } catch {
            print("Error converting dictionary to Data: \(error)")
            return nil
        }
    }
    
    
    //MARK: API DATA
    
    func getAPIDataFromURL(with parameters: [String: String], completion: @escaping (Result<[String: Any], Error>) -> Void) {
        
        let clientId = "1ceddedc03a5d71"
        let apiUrlString = "https://api.imgur.com/3/gallery/search/?q=cats"
        
        guard let url = URL(string: apiUrlString) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Client-ID \(clientId)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("API request error: \(error)")
                return
            }
            
            if let data = data {
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        completion(.success(jsonResult))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    //MARK: JSON PARSER
    
    func parseAPIData(data: Data) {
        do {
            var images: [ImageModel] = []
            
            if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let dataArray = jsonResult["data"] as? [[String: Any]] {
                
                for dataObject in dataArray {
                    if let imagesArray = dataObject["images"] as? [[String: Any]] {
                        for imageObject in imagesArray {
                            if let imageUrlString = imageObject["link"] as? String,
                               let imageUrl = URL(string: imageUrlString) {
                                let imageModel = ImageModel(imageUrl: imageUrl)
                                images.append(imageModel)
                            }
                        }
                    }
                }
            }
            self.imageModels = images
            self.delegate?.reload()
        } catch {
            print("Error parsing JSON: \(error)")
        }
    }
}

//Delegate
protocol CatsDelegate: AnyObject {
    func reload()
}
