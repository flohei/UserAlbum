//
//  APIAccessor.swift
//  UserAlbum
//
//  Created by Florian Heiber on 15.03.16.
//  Copyright © 2016 Florian Heiber. All rights reserved.
//

import Foundation

enum APIAccessorEndpoint: String {
    case Users = "users"
    case Albums = "albums"
    case Photos = "photos"
}

protocol APIAccessorDelegate {
    func accessor(accessor: APIAccessor, didFetchResults results: [AnyObject]?, forEndpoint endpoint: APIAccessorEndpoint)
    func accessor(accessor: APIAccessor, didFailWithError error: NSError)
}

class APIAccessor: NSObject {
    var delegate: APIAccessorDelegate? = nil
    
    convenience init(delegate: APIAccessorDelegate) {
        self.init()
        self.delegate = delegate
    }
    
    // Possible Endpoints: users, albums, photos
    func queryAPIForEndpoint(endpoint: APIAccessorEndpoint) {
        let rawEndpoint = endpoint.rawValue
        let address = "http://jsonplaceholder.typicode.com/" + rawEndpoint
        let url = NSURL(string: address)
        
        // Do a few checks before proceding.
        guard let theURL = url else {
            return
        }
        
        guard let theDelegate = self.delegate else {
            return
        }
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        let task = session.dataTaskWithURL(theURL) { (data, response, error) -> Void in
            if error != nil {
                theDelegate.accessor(self, didFailWithError: error!)
            }
            
            guard let theData = data else {
                return
            }
            
            var result: [AnyObject]? = nil
            
            do {
                result = try NSJSONSerialization.JSONObjectWithData(theData, options:NSJSONReadingOptions.MutableContainers) as? [AnyObject]
            }
            catch let jsonError as NSError {
                theDelegate.accessor(self, didFailWithError: jsonError)
                return
            }
            
            theDelegate.accessor(self, didFetchResults: result, forEndpoint: endpoint)
        }
        
        task.resume()
    }
}