//
//  DataManager.swift
//  UserAlbum
//
//  Created by Florian Heiber on 15.03.16.
//  Copyright © 2016 Florian Heiber. All rights reserved.
//

import CoreData

class DataManager: NSObject, APIAccessorDelegate {
    /// The object that does the actual API access.
    var accessor: APIAccessor!
    
    override init() {
        super.init()
        accessor = APIAccessor(delegate: self)
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
    
    func downloadData() {
        downloadUsers()
        downloadAlbums()
        downloadPhotos()
    }
    
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
                
                let theUser = user(withID: theIdentifier.integerValue)
                if theUser != nil {
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
                
                saveContext()
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
                
                let theAlbum = album(withID: theIdentifier.integerValue)
                if theAlbum != nil {
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
                
                saveContext()
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
                
                let thePhoto = photo(withID: theIdentifier.integerValue)
                if thePhoto != nil {
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
                
                saveContext()
            }
            
            break
        }
    }
    
    func accessor(accessor: APIAccessor, didFailWithError error: NSError) {
        print(error)
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.florianheiber.UserAlbum" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("UserAlbum", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
}