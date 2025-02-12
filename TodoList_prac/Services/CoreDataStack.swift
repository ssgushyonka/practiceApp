import Foundation
import UIKit
import CoreData

public final class CoreDataStack {
    public let shared = CoreDataStack(); private init () {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "TodoList_prac")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    var backgroundContext: NSManagedObjectContext {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return context
    }
    
    func createItem(text: String, priority: String, deadline: Date?, isDone: Bool) {
        let context = backgroundContext
        context.perform {
            let todoItem = TodoItemCoreData(context: context)
            todoItem.id = UUID().uuidString
            todoItem.text = text
            todoItem.priority = priority
            todoItem.deadline = deadline
            todoItem.isDone = isDone
            todoItem.createdDate = Date()
            todoItem.editedDate = nil
            
            do {
                try context.save()
            } catch {
                print("Ошибка при сохранении: \(error)")
            }
        }
    }
    
    func fetchItems() -> [TodoItemCoreData] {
        let context = viewContext
        let fetchRequest: NSFetchRequest<TodoItemCoreData> = TodoItemCoreData.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Ошибка при загрузке TodoItem: \(error)")
            return []
        }
    }
    
    func updateItem(with id: String, newText: String? = nil, newPriority: String? = nil, newDeadline: Date? = nil, newIsDone: Bool? = nil) {
        let context = backgroundContext
        context.perform {
            let fetchRequest: NSFetchRequest<TodoItemCoreData> = TodoItemCoreData.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id)
            
            do {
                if let todoItem = try context.fetch(fetchRequest).first {
                    if let newText = newText {
                        todoItem.text = newText
                    }
                    if let newPriority = newPriority {
                        todoItem.priority = newPriority
                    }
                    if let newDeadline = newDeadline {
                        todoItem.deadline = newDeadline
                    }
                    if let newIsDone = newIsDone {
                        todoItem.isDone = newIsDone
                    }
                    
                    todoItem.editedDate = Date()
                    try context.save()
                }
            } catch {
                print("Ошибка при изменении TodoItem: \(error)")
            }
        }
    }
    func deleteItem(with id: String) {
        let context = backgroundContext
        context.perform {
            let fetchRequest: NSFetchRequest<TodoItemCoreData> = TodoItemCoreData.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == $@")
            
            do {
                if let todoItem = try context.fetch(fetchRequest).first {
                    context.delete(todoItem)
                    try context.save()
                }
            } catch {
                print("Ошибка удаления TodoItem: \(error)")
            }
        }
    }
}
