//
//  NetworkCall.swift
//  Game Catalogue
//
//  Created by Budi Darmawan on 11/07/21.
//

import Foundation
import Alamofire

class NetworkCall : NSObject {
  
  var url: String = ConstService.BaseAPI
  var method: HTTPMethod = .get
  var parameters: Parameters? = nil
  
  init(url: String, parameters: Parameters? = nil){
    super.init()
    self.url += url
    
    let paramAPIKey: Parameters = [
      "key": ConstService.KeyAPI
    ]
    
    guard var params = parameters else {
      self.parameters = paramAPIKey
      return
    }
    params.merge(paramAPIKey) { first,_ in
      first
    }
    self.parameters = params
  }
  
  func executeQuery<T> (completion: @escaping (Result<T, Error>) -> Void) where T: Decodable {
    AF.request(url, method: method, parameters: parameters)
      .validate(statusCode: 200...299)
      .responseJSON { response in
        switch response.result {
        case .success:
          guard let data = response.data else { return }
          DispatchQueue.main.async {
            do {
              let result = try JSONDecoder().decode(T.self, from: data)
              completion(.success(result))
            } catch let error {
              completion(.failure(error))
            }
          }
        case .failure(let error):
          DispatchQueue.main.async {
            completion(.failure(error))
          }
        }
      }
  }
}
