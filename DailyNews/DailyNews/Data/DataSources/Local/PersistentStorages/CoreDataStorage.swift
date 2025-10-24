//
//  CoreDataStorage.swift
//  DailyNews
//
//  Created by Chinh on 8/19/25.
//

import CoreData

protocol CoreDataStorageProtocol {
    func newObject<T: NSManagedObject>(ofType type: T.Type) -> T
    func fetchObject<T: NSManagedObject>(request: NSFetchRequest<T>) throws -> [T]
    func deleteAllObjects<T: NSManagedObject>(ofType type: T.Type) throws
    func saveContext() throws
}

final class CoreDataStorage {

    private enum Constants {
        static let containerName = "CoreDataStorage"
    }

    static let shared = CoreDataStorage()

    // MARK: - Initialization
    private init() {}
    
    // MARK: - Core Data stack
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constants.containerName)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                // TODO: - Log to Crashlytics
                assertionFailure("CoreDataStorage Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    private var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

//    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
//        persistentContainer.performBackgroundTask(block)
//    }
    
    func performBackgroundTask<T>(_ block: @escaping (NSManagedObjectContext) throws -> T) async rethrows -> T {
        return try await persistentContainer.performBackgroundTask(block)
    }

    func backgroundContext() -> NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }
}

extension CoreDataStorage: CoreDataStorageProtocol {
    func newObject<T>(ofType type: T.Type) -> T where T : NSManagedObject {
        let managedObject: T = T(context: viewContext)
        return managedObject
    }
    
    func fetchObject<T>(request: NSFetchRequest<T>) throws -> [T] where T : NSManagedObject {
        do {
            let results = try viewContext.fetch(request)
            print("Fetched \(String(describing: T.self)) successfully.")
            return results
        }  catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            throw CoreDataStorageError.failedToFetch(error)
        }
    }
    
    func deleteAllObjects<T>(ofType type: T.Type) throws where T : NSManagedObject {
        let entityName: String = String(describing: type)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            // Execute the delete request
            try viewContext.execute(deleteRequest)
            try saveContext()
            print("All objects from entity \(entityName) deleted successfully.")
        } catch let error as NSError {
            print("Failed to delete objects from entity \(entityName): \(error.localizedDescription)")
            throw CoreDataStorageError.failedToDelete(error)
        }
    }

    func saveContext() throws {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                // TODO: - Log to Crashlytics
                assertionFailure("CoreDataStorage Unresolved error \(error), \((error as NSError).userInfo)")
                throw CoreDataStorageError.failedToSave(error)
            }
        }
    }
}
