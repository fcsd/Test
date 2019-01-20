//
//  APIClient.swift
//  test
//
//  Created by admin on 1/20/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

class ApiClient {
    
    static let apiClient = ApiClient()
    private init() {}
    
    func getTennants(completion: @escaping ([Tennant]?, Error?) -> Void) {
        
        guard let url = URL(string: "https://itunes.applikator.dk/ios_task/tenants.json") else {
            return completion(nil, createNSError(errorMessage: "Wrong URL"))
        }
        
        let task = URLSession(configuration: .default).dataTask(with: URLRequest(url: url), completionHandler: { data, response, error in

            DispatchQueue.main.async {
                if let unwrappedError = error {
                    return completion(nil, unwrappedError)
                }
                
                guard let unwrappedData = data, let json = try? JSONSerialization.jsonObject(with: unwrappedData, options: []) as? [String: Any], let tennatsJSON = json?["tenants"] as? [[String: Any]] else  {
                    return completion(nil, self.createNSError(errorMessage: "Could not parse response"))
                }
                
                let tennats = tennatsJSON.compactMap{ Tennant(json: $0) }
                completion(tennats, nil)
                
            }
        })
        
        task.resume()
    }
    
    func createNSError(errorMessage: String) -> NSError {
        return NSError(domain: "testDomain", code: 0, userInfo: [NSLocalizedDescriptionKey : errorMessage])
    }
}
