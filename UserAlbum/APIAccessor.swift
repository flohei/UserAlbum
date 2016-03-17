//
//  APIAccessor.swift
//  UserAlbum
//
//  Created by Florian Heiber on 15.03.16.
//  Copyright © 2016 Florian Heiber. All rights reserved.
//

import UIKit

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
    /// Passes over the acquired data to the delegate.
    func accessor(accessor: APIAccessor, didFetchResults results: [AnyObject]?, forEndpoint endpoint: APIAccessorEndpoint)
    /// Passes over any errors to the delegate.
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
     - parameter handler () -> Void: The handler to be called (locally) when the job is done.
     */
    func queryAPIForEndpoint(endpoint: APIAccessorEndpoint, handler: (() -> Void)? = nil) {
        // Show the network activity indicator.
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        let rawEndpoint = endpoint.rawValue
        let address = "http://jsonplaceholder.typicode.com/" + rawEndpoint
        let url = NSURL(string: address)
        
        // Do a few checks before proceding.
        guard let theURL = url else {
            return
        }
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        let task = session.dataTaskWithURL(theURL) { (data, response, error) -> Void in
            // Verify that we have valid data and no errors first.
            guard error == nil else {
                self.returnError(error!)
                return
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
                self.returnError(jsonError)
                return
            }
            
            // Pass the newly acquired data to the delegate for further investigation.
            self.returnSuccess(result!, forEndpoint: endpoint)
            
            // Call the handler and let it know that we're done.
            if handler != nil {
                handler!()
            }
        }
        
        task.resume()
    }
    
    /** 
     Calls the delegate and passes the error over.
     - parameter error NSError: The error that occured.
     */
    func returnError(error: NSError) {
        guard let theDelegate = self.delegate else {
            return
        }
        
        // The delegate should handle the core data stuff on the same thread.
        dispatch_async(dispatch_get_main_queue()) {
            theDelegate.accessor(self, didFailWithError: error)
            
            // Hide the network activity indicator.
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
    
    /** 
     Calls the delegate and passes over the acquired data.
     - parameter dataArray [AnyObject]: The array containing the JSON dictionaries.
     - parameter endpoint APIAccessorEndpoint: The endpoint that was queried.
     */
    func returnSuccess(dataArray: [AnyObject], forEndpoint endpoint: APIAccessorEndpoint) {
        guard let theDelegate = self.delegate else {
            return
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            theDelegate.accessor(self, didFetchResults: dataArray, forEndpoint: endpoint)
            
            // Hide the network activity indicator.
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
}