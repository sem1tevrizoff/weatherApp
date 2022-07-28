import CoreData
import Foundation

final class StorageManager {
    
    private let coreDataStack = CoreDataStack()
    
    lazy var items: [Item] = []
    
    lazy var fetchResultsController: NSFetchedResultsController<Item> =  {
        let fetchRequest = Item.fetchRequest()
        
        let sort = NSSortDescriptor(key: #keyPath(Item.createdAt), ascending: false )
        fetchRequest.sortDescriptors = [sort]
        
        let fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchResultsController
    }()
    
    final func getItems(completion: @escaping(Result<[Item], Error>) -> Void) {
        let context = coreDataStack.managedContext
        let fetchRequest = Item.fetchRequest()
        
        do {
            items = try context.fetch(fetchRequest)
            completion(.success(items))
        } catch {
            completion(.failure(error))
            print("Ошибка!")
        }
        
        do {
            try fetchResultsController.performFetch()
            completion(.success(items))
        } catch {
            print("I can fetch items")
            completion(.failure(error))
        }
    }
    
    final func getItemsPredicate(for name: String, completion: @escaping (Result<[Item], Error>) -> Void) {
        var predicate: NSPredicate?
        if !name.isEmpty {
            predicate = NSPredicate(format: "name contains[c] '\(name)'")
        } else {
            predicate = nil
        }
        fetchResultsController.fetchRequest.predicate = predicate
        
        do {
            try fetchResultsController.performFetch()
            completion(.success(fetchResultsController.fetchedObjects ?? []))
            coreDataStack.save()
        } catch {
            completion(.failure(error))
            print(" i can't fetch items")
        }
    }
    
    final func save(with name: String, completion: @escaping (Result<Item, Error>) -> Void) {
        let context = coreDataStack.managedContext
        
        let item = Item(context: context)
        item.name = name
        
        coreDataStack.save()
        items.append(item)
        item.createdAt = Date()
        
        completion(.success(item))
    }
    
    final func deleteItem(at indexPath: IndexPath, completion: @escaping (Result<[Item], Error>) -> Void ) {
        let item = fetchResultsController.object(at: indexPath)
        let context = coreDataStack.managedContext
        
        context.delete(item)
        
        do {
            try context.save()
        } catch {
            print("I Cant'save")
            completion(.failure(error))
        }
    }
}

