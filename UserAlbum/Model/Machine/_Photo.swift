// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Photo.swift instead.

import CoreData

public enum PhotoAttributes: String {
    case identifier = "identifier"
    case thumbnailUrl = "thumbnailUrl"
    case title = "title"
    case url = "url"
}

public enum PhotoRelationships: String {
    case album = "album"
}

@objc public
class _Photo: NSManagedObject {

    // MARK: - Class methods

    public class func entityName () -> String {
        return "Photo"
    }

    public class func entity(managedObjectContext: NSManagedObjectContext!) -> NSEntityDescription! {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext);
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    public convenience init(managedObjectContext: NSManagedObjectContext!) {
        let entity = _Photo.entity(managedObjectContext)
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged public
    var identifier: NSNumber?

    // func validateIdentifier(value: AutoreleasingUnsafeMutablePointer<AnyObject>, error: NSErrorPointer) -> Bool {}

    @NSManaged public
    var thumbnailUrl: String?

    // func validateThumbnailUrl(value: AutoreleasingUnsafeMutablePointer<AnyObject>, error: NSErrorPointer) -> Bool {}

    @NSManaged public
    var title: String?

    // func validateTitle(value: AutoreleasingUnsafeMutablePointer<AnyObject>, error: NSErrorPointer) -> Bool {}

    @NSManaged public
    var url: String?

    // func validateUrl(value: AutoreleasingUnsafeMutablePointer<AnyObject>, error: NSErrorPointer) -> Bool {}

    // MARK: - Relationships

    @NSManaged public
    var album: Album?

    // func validateAlbum(value: AutoreleasingUnsafeMutablePointer<AnyObject>, error: NSErrorPointer) -> Bool {}

}

