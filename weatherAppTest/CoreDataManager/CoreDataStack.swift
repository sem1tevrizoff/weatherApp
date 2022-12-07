import Foundation
import CoreData

final class CoreDataStack {
    
    lazy var managedContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "weatherAppTest")
        
        container.loadPersistentStores { _, error in
            if let error = error {
                print(error)
            }
        }
        return container
    }()
    
    final func save() {
        guard managedContext.hasChanges else { return }
        do {
            try managedContext.save()
        } catch {
            print("I can't save it \(error) ")
        }
    }
}

