//
//  DataManager.swift
//  UserAlbum
//
//  Created by Florian Heiber on 15.03.16.
//  Copyright © 2016 Florian Heiber. All rights reserved.
//

import UIKit
import CoreData

class DataManager: NSObject, APIAccessorDelegate {
    /// The object that does the actual API access.
    var accessor: APIAccessor!
    /// The core data stack.
    let coreDataStack = (UIApplication.sharedApplication().delegate as! AppDelegate).coreDataStack
    /// The context we use throughout the app.
    var managedObjectContext: NSManagedObjectContext!
    
    override init() {
        super.init()
        accessor = APIAccessor(delegate: self)
        managedObjectContext = coreDataStack.managedObjectContext
    }
    
    /**
     Loads all users from the local database.
     - returns: An array of User objects.
     */
    func getUsers() -> [User]? {
        let fetchRequest = NSFetchRequest()
        let emergencyContactEntityDescription = NSEntityDescription.entityForName("User", inManagedObjectContext: managedObjectContext)
        fetchRequest.entity = emergencyContactEntityDescription
        let users = (try! managedObjectContext.executeFetchRequest(fetchRequest)) as! [User]
    
        return users
    }
    
    /**
     Loads all albums for a given user from the local database.
     - parameter user User: The user for which the albums should be fetched.
     - returns: An array of Album objects.
     */
    func getAlbums(forUser user: User) -> [Album]? {
        let fetchRequest = NSFetchRequest()
        let emergencyContactEntityDescription = NSEntityDescription.entityForName("Album", inManagedObjectContext: managedObjectContext)
        
        fetchRequest.predicate = NSPredicate(format: "user", user)
        fetchRequest.entity = emergencyContactEntityDescription
        
        let albums = (try! managedObjectContext.executeFetchRequest(fetchRequest)) as! [Album]
        
        return albums
    }
    
    /**
     Loads all photos for a given album from the local database.
     - parameter album Album: The album for which the photos should be fetched.
     - returns: An array of Photo objects.
     */
    func getPhotos(forAlbum album: Album) -> [Photo]? {
        let fetchRequest = NSFetchRequest()
        let emergencyContactEntityDescription = NSEntityDescription.entityForName("Photo", inManagedObjectContext: managedObjectContext)
        
        fetchRequest.predicate = NSPredicate(format: "album", album)
        fetchRequest.entity = emergencyContactEntityDescription
        
        let photos = (try! managedObjectContext.executeFetchRequest(fetchRequest)) as! [Photo]
        
        return photos
    }
    
    func hasLocalUsers() -> Bool {
        let fetchRequest = NSFetchRequest()
        let emergencyContactEntityDescription = NSEntityDescription.entityForName("User", inManagedObjectContext: managedObjectContext)
        fetchRequest.entity = emergencyContactEntityDescription
        fetchRequest.includesSubentities = false
        var error: NSError? = nil
        let count = managedObjectContext.countForFetchRequest(fetchRequest, error: &error)
        
        return count > 0
    }
    
    func hasLocalAlbums() -> Bool {
        let fetchRequest = NSFetchRequest()
        let emergencyContactEntityDescription = NSEntityDescription.entityForName("Album", inManagedObjectContext: managedObjectContext)
        fetchRequest.entity = emergencyContactEntityDescription
        fetchRequest.includesSubentities = false
        var error: NSError? = nil
        let count = managedObjectContext.countForFetchRequest(fetchRequest, error: &error)
        
        return count > 0
    }
    
    func hasLocalPhotos() -> Bool {
        let fetchRequest = NSFetchRequest()
        let emergencyContactEntityDescription = NSEntityDescription.entityForName("Photo", inManagedObjectContext: managedObjectContext)
        fetchRequest.entity = emergencyContactEntityDescription
        fetchRequest.includesSubentities = false
        var error: NSError? = nil
        let count = managedObjectContext.countForFetchRequest(fetchRequest, error: &error)
        
        return count > 0
    }
    
    func hasUserWithID(id: Int) -> Bool {
        let fetchRequest = NSFetchRequest()
        let emergencyContactEntityDescription = NSEntityDescription.entityForName("User", inManagedObjectContext: managedObjectContext)
        fetchRequest.predicate = NSPredicate(format: "identifier == %i", id)
        fetchRequest.entity = emergencyContactEntityDescription
        var error: NSError? = nil
        let count = managedObjectContext.countForFetchRequest(fetchRequest, error: &error)
        return count == 1
    }
    
    func hasAlbumWithID(id: Int) -> Bool {
        let fetchRequest = NSFetchRequest()
        let emergencyContactEntityDescription = NSEntityDescription.entityForName("Album", inManagedObjectContext: managedObjectContext)
        fetchRequest.predicate = NSPredicate(format: "identifier == %i", id)
        fetchRequest.entity = emergencyContactEntityDescription
        var error: NSError? = nil
        let count = managedObjectContext.countForFetchRequest(fetchRequest, error: &error)
        return count == 1
    }
    
    func hasPhotoWithID(id: Int) -> Bool {
        let fetchRequest = NSFetchRequest()
        let emergencyContactEntityDescription = NSEntityDescription.entityForName("Photo", inManagedObjectContext: managedObjectContext)
        fetchRequest.predicate = NSPredicate(format: "identifier == %i", id)
        fetchRequest.entity = emergencyContactEntityDescription
        var error: NSError? = nil
        let count = managedObjectContext.countForFetchRequest(fetchRequest, error: &error)
        return count == 1
    }
    
    // MARK: - Getter for specific instances
    
    /**
     Tries to find a user with a given identifier in the local database and returns it if found. If not, it will return nil.
     - parameter id Int: The user's identifier.
     - returns: A User object or nil.
     */
    func user(withID id: Int) -> User? {
        let fetchRequest = NSFetchRequest()
        let emergencyContactEntityDescription = NSEntityDescription.entityForName("User", inManagedObjectContext: managedObjectContext)
        
        fetchRequest.predicate = NSPredicate(format: "identifier == %i", id)
        fetchRequest.entity = emergencyContactEntityDescription
        let users = (try! managedObjectContext.executeFetchRequest(fetchRequest)) as! [User]
        
        return users.first
    }
    
    /**
     Tries to find a album with a given identifier in the local database and returns it if found. If not, it will return nil.
     - parameter id Int: The album's identifier.
     - returns: A Album object or nil.
     */
    func album(withID id: Int) -> Album? {
        let fetchRequest = NSFetchRequest()
        let emergencyContactEntityDescription = NSEntityDescription.entityForName("Album", inManagedObjectContext: managedObjectContext)
        
        fetchRequest.predicate = NSPredicate(format: "identifier == %i", id)
        fetchRequest.entity = emergencyContactEntityDescription
        let albums = (try! managedObjectContext.executeFetchRequest(fetchRequest)) as! [Album]        
        return albums.first
    }
    
    /**
     Tries to find a photo with a given identifier in the local database and returns it if found. If not, it will return nil.
     - parameter id Int: The photos's identifier.
     - returns: A Photo object or nil.
     */
    func photo(withID id: Int) -> Photo? {
        let fetchRequest = NSFetchRequest()
        let emergencyContactEntityDescription = NSEntityDescription.entityForName("Photo", inManagedObjectContext: managedObjectContext)
        
        fetchRequest.predicate = NSPredicate(format: "identifier == %i", id)
        fetchRequest.entity = emergencyContactEntityDescription
        let photos = (try! managedObjectContext.executeFetchRequest(fetchRequest)) as! [Photo]
        
        return photos.first
    }
    
    // MARK: - Download Data
    
    func downloadUsers() {
        downloadEntity(.Users)
    }
    
    func downloadAlbums() {
        downloadEntity(.Albums)
    }
    
    func downloadPhotos() {
        downloadEntity(.Photos)
    }
    
    private func downloadEntity(entity: APIAccessorEndpoint) {
        accessor.queryAPIForEndpoint(entity)
    }
    
    // MARK: - APIAccessorDelegate
    
    func accessor(accessor: APIAccessor, didFetchResults results: [AnyObject]?, forEndpoint endpoint: APIAccessorEndpoint) {
        guard let theResults = results else {
            return
        }
        
        switch endpoint {
        case .Users:
            /**
             This is the user case. A user consists of multiple fields, including the name, email address, geo, and company information. For the sake of this demo we're only interested in the name, the email address and the company's catch phrase.
            */
            for userDictionary in theResults {
                // Check if we already have this user. If so, don't create it.
                let identifier = userDictionary["id"] as? NSNumber
                guard let theIdentifier = identifier else {
                    continue
                }
                
                if hasUserWithID(theIdentifier.integerValue) {
                    continue
                }
                
                // Go through all the fields in the dictionary and get the data out.
                
                let name: String? = userDictionary["name"] as? String
                let email = userDictionary["email"] as? String
                let company = userDictionary["company"] as? [String: AnyObject]
                // We could alternatively get the entire company object here and store it in the database or assign the user if we already have that company.
                guard let theCompany = company else {
                    print("No company object, therefore no company catch phrase")
                    return
                }
                
                let catchPhrase = theCompany["catchPhrase"] as? String
                
                let newUser = User(managedObjectContext: managedObjectContext)
                newUser.identifier = theIdentifier
                newUser.name = name
                newUser.email = email
                newUser.companyCatchPhrase = catchPhrase
            }
            break
            
        case .Albums:
            /**
             This case handles all the user albums. It stores their identifier and title and assigns it to a user. The case where an album references a non-existent user id is TBD. For now we're dropping the album.
            */
            for albumDictionary in theResults {
                // Check if we already have this album. If so, don't create it.
                let identifier = albumDictionary["id"] as? NSNumber
                guard let theIdentifier = identifier else {
                    continue
                }
                
                if hasAlbumWithID(theIdentifier.integerValue) {
                    continue
                }
                
                let userID = albumDictionary["userId"] as? NSNumber
                let title = albumDictionary["title"] as? String
                
                // Get the user to assign it to the album afterwards.
                guard let theUser = user(withID: userID!.integerValue) else {
                    continue
                }
                
                let newAlbum = Album(managedObjectContext: managedObjectContext)
                newAlbum.identifier = theIdentifier
                newAlbum.title = title
                newAlbum.user = theUser
            }
            break
            
        case .Photos:
            /**
             This case handles all the photos. It stores their identifier, title, and photo URLs and assigns it to an album. The case where a photo references a non-existent user id is TBD. For now we're dropping the photo.
            */
            for photoDictionary in theResults {
                // Check if we already have this photo. If so, don't create it.
                let identifier = photoDictionary["id"] as? NSNumber
                guard let theIdentifier = identifier else {
                    continue
                }
                
                if hasPhotoWithID(theIdentifier.integerValue) {
                    continue
                }
                
                let albumID = photoDictionary["albumId"] as? NSNumber
                let title = photoDictionary["title"] as? String
                let imageAddress = photoDictionary["url"] as? String
                let imageThumbnailAddress = photoDictionary["thumbnailUrl"] as? String
                
                // If any of these is nil we'll skip this photo.
                if albumID == nil || title == nil || imageAddress == nil || imageThumbnailAddress == nil {
                    continue
                }
                
                // Get the album to assign it to the photo afterwards.
                guard let theAlbum = album(withID: (albumID?.integerValue)!) else {
                    continue
                }
                
                let newPhoto = Photo(managedObjectContext: managedObjectContext)
                newPhoto.identifier = theIdentifier
                newPhoto.album = theAlbum
                newPhoto.title = title
                newPhoto.url = imageAddress
                newPhoto.thumbnailUrl = imageThumbnailAddress
            }
            
            break
        }
        
        coreDataStack.saveContext()
    }
    
    func accessor(accessor: APIAccessor, didFailWithError error: NSError) {
        print(error)
    }
}