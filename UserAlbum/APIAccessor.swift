//
//  APIAccessor.swift
//  UserAlbum
//
//  Created by Florian Heiber on 15.03.16.
//  Copyright © 2016 Florian Heiber. All rights reserved.
//

import Foundation

/**
 An enum that limits the endpoints that can be passed into the query function of the APIAccessor class.
*/
enum APIAccessorEndpoint: String {
    case Users = "users"
    case Albums = "albums"
    case Photos = "photos"
}

/**
 The protocol for the delegate that wants to be informed about events on the APIAccessor.
*/
protocol APIAccessorDelegate {
    func accessor(accessor: APIAccessor, didFetchResults results: [AnyObject]?, forEndpoint endpoint: APIAccessorEndpoint)
    func accessor(accessor: APIAccessor, didFailWithError error: NSError)
}

/**
 A class that provides access to the API. It holds a delegate of type APIAccessorDelegate which will be informed about new data or errors, should they occur.
*/
class APIAccessor: NSObject {
    /// The delegate that will be informed about new data and errors.
    var delegate: APIAccessorDelegate? = nil
    
    convenience init(delegate: APIAccessorDelegate) {
        self.init()
        self.delegate = delegate
    }
    
    /**
     Runs a query to the API for the given endpoint. This function downloads the JSON data and converts it into an array. This array will then be passed to the delegate of this class. If the process fails at some point the delegate will be handed the error.
     - parameter endpoint APIAccessorEndpoint: The endpoint that will be queried. Can be .Users, .Albums, or .Photos.
     */
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
        
        // Set up the session object and run the query.
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        let task = session.dataTaskWithURL(theURL) { (data, response, error) -> Void in
            // Verify that we have valid data and no errors first.
            if error != nil {
                theDelegate.accessor(self, didFailWithError: error!)
            }
            
            guard let theData = data else {
                return
            }
            
            var result: [AnyObject]? = nil
            
            // Translate the JSON data into an array of NSDictionaries.
            do {
                result = try NSJSONSerialization.JSONObjectWithData(theData, options:NSJSONReadingOptions.MutableContainers) as? [AnyObject]
            }
            catch let jsonError as NSError {
                // If this didn't work out, let the delegate know.
                theDelegate.accessor(self, didFailWithError: jsonError)
                return
            }
            
            // Pass the newly acquired data to the delegate for further investigation.
            theDelegate.accessor(self, didFetchResults: result, forEndpoint: endpoint)
        }
        
        task.resume()
    }
}