// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to User.swift instead.

import CoreData

public enum UserAttributes: String {
    case companyCatchPhrase = "companyCatchPhrase"
    case email = "email"
    case identifier = "identifier"
    case name = "name"
}

public enum UserRelationships: String {
    case albums = "albums"
}

@objc public
class _User: NSManagedObject {

    // MARK: - Class methods

    public class func entityName () -> String {
        return "User"
    }

    public class func entity(managedObjectContext: NSManagedObjectContext!) -> NSEntityDescription! {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext);
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    public convenience init(managedObjectContext: NSManagedObjectContext!) {
        let entity = _User.entity(managedObjectContext)
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged public
    var companyCatchPhrase: String?

    // func validateCompanyCatchPhrase(value: AutoreleasingUnsafeMutablePointer<AnyObject>, error: NSErrorPointer) -> Bool {}

    @NSManaged public
    var email: String?

    // func validateEmail(value: AutoreleasingUnsafeMutablePointer<AnyObject>, error: NSErrorPointer) -> Bool {}

    @NSManaged public
    var identifier: NSNumber?

    // func validateIdentifier(value: AutoreleasingUnsafeMutablePointer<AnyObject>, error: NSErrorPointer) -> Bool {}

    @NSManaged public
    var name: String?

    // func validateName(value: AutoreleasingUnsafeMutablePointer<AnyObject>, error: NSErrorPointer) -> Bool {}

    // MARK: - Relationships

    @NSManaged public
    var albums: NSSet

}

extension _User {

    func addAlbums(objects: NSSet) {
        let mutable = self.albums.mutableCopy() as! NSMutableSet
        mutable.unionSet(objects as Set<NSObject>)
        self.albums = mutable.copy() as! NSSet
    }

    func removeAlbums(objects: NSSet) {
        let mutable = self.albums.mutableCopy() as! NSMutableSet
        mutable.minusSet(objects as Set<NSObject>)
        self.albums = mutable.copy() as! NSSet
    }

    func addAlbumsObject(value: Album!) {
        let mutable = self.albums.mutableCopy() as! NSMutableSet
        mutable.addObject(value)
        self.albums = mutable.copy() as! NSSet
    }

    func removeAlbumsObject(value: Album!) {
        let mutable = self.albums.mutableCopy() as! NSMutableSet
        mutable.removeObject(value)
        self.albums = mutable.copy() as! NSSet
    }

}

