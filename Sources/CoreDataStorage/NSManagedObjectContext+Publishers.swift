//
//  NSManagedObjectContext+Publishers.swift
//  Meme-Ory
//
//  Created by Igor Malyarov on 14.12.2020.
//

import CoreData
import Combine

@available(iOS 13.0, *)
public extension NSManagedObjectContext {

    //  MARK: - Publishers

    //  MARK: Did Save

    var didSavePublisher: AnyPublisher<Notification, Never> {
        let sub = NotificationCenter.default
            .publisher(for: .NSManagedObjectContextDidSave)
            .filter { notification in
                let context = notification.object as? NSManagedObjectContext
                return context == self
            }
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
        return sub
    }
    
}
