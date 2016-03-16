import Foundation
import CoreData

@objc(User)
public class User: _User {

	// Custom logic goes here.
    public convenience init(dataDictionary: NSDictionary, managedObjectContext: NSManagedObjectContext) {
        self.init(entity: User.entity(managedObjectContext), insertIntoManagedObjectContext: managedObjectContext)
        
        // Go through all the fields in the dictionary and get the data out.
        let identifier = dataDictionary["id"] as? Int
        let name = dataDictionary["name"] as? String
        let email = dataDictionary["email"] as? String
        let company = dataDictionary["company"] as? NSDictionary
        // We could alternatively get the entire company object here and store it in the database or assign the user if we already have that company.
        guard let theCompany = company else {
            print("No company object, therefore no company catch phrase")
            return
        }
        
        let catchPhrase = theCompany["catchPhrase"] as? String
        
        self.identifier = identifier
        self.name = name
        self.email = email
        self.companyCatchPhrase = catchPhrase
    }
}
