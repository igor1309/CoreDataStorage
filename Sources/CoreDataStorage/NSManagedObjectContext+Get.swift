//
//  NSManagedObjectContext+Get.swift
//  Meme-Ory
//
//  Created by Igor Malyarov on 14.12.2020.
//

import CoreData

extension URL {
    var coreDataURL: URL? {
        guard !absoluteString.hasPrefix("x-coredata") else { return self }

        guard let query = query else { return nil }
        let components = query.split(separator: ",").flatMap { $0.split(separator: "=") }

        // meme-ory://www.meme-ory.com/details?reference=x-coredata://50A46BEA-26D5-437F-A49D-FD1C7224B041/Story/p3
        // x-coredata://50A46BEA-26D5-437F-A49D-FD1C7224B041/Story/p3
        // x-coredata://<UUID>/<EntityName>/p<Key>
        guard components.count == 2 else { return nil }
        let coreDataString = components[1]
        guard coreDataString.hasPrefix("x-coredata") else { return nil }
        return URL(string: String(coreDataString))
    }

}

public extension NSManagedObjectContext {
    
    //  MARK: - Get ObjectID & Object
    
    func getObjectID(for url: URL?) -> NSManagedObjectID? {
        guard let coordinator = persistentStoreCoordinator,
              let url = url,
              let coreDataURL = url.coreDataURL,
              let objectID = coordinator.managedObjectID(forURIRepresentation: coreDataURL) else { return nil }
        
        return objectID
    }
    
//    func getObject(with url: URL?) -> NSManagedObject? {
//        guard let objectID = getObjectID(for: url),
//              let object = try? existingObject(with: objectID) else { return nil }
//
//        return object
//    }
    
    func getObject<T: NSManagedObject>(with url: URL?) -> T? {
        guard let objectID = getObjectID(for: url),
              let object = try? existingObject(with: objectID) as? T else { return nil }

        return object
    }

}
