// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Album.swift instead.

import CoreData

public enum AlbumAttributes: String {
    case identifier = "identifier"
    case title = "title"
}

public enum AlbumRelationships: String {
    case photos = "photos"
    case user = "user"
}

@objc public
class _Album: NSManagedObject {

    // MARK: - Class methods

    public class func entityName () -> String {
        return "Album"
    }

    public class func entity(managedObjectContext: NSManagedObjectContext!) -> NSEntityDescription! {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext);
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    public convenience init(managedObjectContext: NSManagedObjectContext!) {
        let entity = _Album.entity(managedObjectContext)
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged public
    var identifier: NSNumber?

    // func validateIdentifier(value: AutoreleasingUnsafeMutablePointer<AnyObject>, error: NSErrorPointer) -> Bool {}

    @NSManaged public
    var title: String?

    // func validateTitle(value: AutoreleasingUnsafeMutablePointer<AnyObject>, error: NSErrorPointer) -> Bool {}

    // MARK: - Relationships

    @NSManaged public
    var photos: NSSet

    @NSManaged public
    var user: User?

    // func validateUser(value: AutoreleasingUnsafeMutablePointer<AnyObject>, error: NSErrorPointer) -> Bool {}

}

extension _Album {

    func addPhotos(objects: NSSet) {
        let mutable = self.photos.mutableCopy() as! NSMutableSet
        mutable.unionSet(objects as Set<NSObject>)
        self.photos = mutable.copy() as! NSSet
    }

    func removePhotos(objects: NSSet) {
        let mutable = self.photos.mutableCopy() as! NSMutableSet
        mutable.minusSet(objects as Set<NSObject>)
        self.photos = mutable.copy() as! NSSet
    }

    func addPhotosObject(value: Photo!) {
        let mutable = self.photos.mutableCopy() as! NSMutableSet
        mutable.addObject(value)
        self.photos = mutable.copy() as! NSSet
    }

    func removePhotosObject(value: Photo!) {
        let mutable = self.photos.mutableCopy() as! NSMutableSet
        mutable.removeObject(value)
        self.photos = mutable.copy() as! NSSet
    }

}

