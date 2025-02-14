import CoreData
import Foundation

public final class CoreDataManager {
    private let persistentContainer: NSPersistentContainer

    public init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
        persistentContainer.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }

    func saveContext(completion: @escaping (Error?) -> Void) {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                completion(nil)
            } catch {
                completion(error)
            }
        } else {
            completion(nil)
        }
    }

    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    var backgroundContext: NSManagedObjectContext {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return context
    }

    func createItem(
        text: String,
        priority: String,
        deadline: Date?,
        isDone: Bool,
        completion: @escaping (Error?) -> Void
    ) {
        let context = backgroundContext
        context.perform {
            let fetchRequest: NSFetchRequest<TodoItemCoreData> = TodoItemCoreData.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "text == %@", text)
            do {
                let existingItems = try context.fetch(fetchRequest)
                if existingItems.isEmpty {
                    let todoItem = TodoItemCoreData(context: context)
                    todoItem.id = UUID().uuidString
                    todoItem.text = text
                    todoItem.priority = priority
                    todoItem.deadline = deadline
                    todoItem.isDone = isDone
                    todoItem.createdDate = Date()
                    todoItem.editedDate = nil
                    try context.save()
                    completion(nil)
                } else {
                    completion(NSError(
                        domain: "CoreDataManager",
                        code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "Item already exists"])
                    )
                }
            } catch {
                completion(error)
            }
        }
    }

    func fetchItems(completion: @escaping ([TodoItemCoreData]?, Error?) -> Void){
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TodoItemCoreData> = TodoItemCoreData.fetchRequest()

        do {
            let items = try context.fetch(fetchRequest)
            completion(items, nil)
        } catch {
            completion(nil, error)
        }
    }

    func updateItem(
        with id: String,
        newText: String? = nil,
        newPriority: String? = nil,
        newDeadline: Date? = nil,
        newIsDone: Bool? = nil,
        completion: @escaping (Error?) -> Void
    ) {
        let context = backgroundContext
        context.perform {
            let fetchRequest: NSFetchRequest<TodoItemCoreData> = TodoItemCoreData.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id)
            do {
                if let todoItem = try context.fetch(fetchRequest).first {
                    if let newText {
                        todoItem.text = newText
                    }
                    if let newPriority {
                        todoItem.priority = newPriority
                    }
                    if let newDeadline {
                        todoItem.deadline = newDeadline
                    }
                    if let newIsDone {
                        todoItem.isDone = newIsDone
                    }
                    todoItem.editedDate = Date()
                    try context.save()
                    completion(nil)
                } else {
                    completion(NSError(
                        domain: "CoreDataManager",
                        code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "Item not found"])
                    )
                }
            } catch {
                completion(error)
            }
        }
    }

    func deleteItem(with id: String, completion: @escaping (Error?) -> Void) {
        let context = backgroundContext
        context.perform {
            let fetchRequest: NSFetchRequest<TodoItemCoreData> = TodoItemCoreData.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id)
            do {
                if let todoItem = try context.fetch(fetchRequest).first {
                    context.delete(todoItem)
                    try context.save()
                    completion(nil)
                } else {
                    completion(NSError(
                        domain: "CoreDataManager",
                        code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "Item not found"])
                    )
                }
            } catch {
                completion(error)
            }
        }
    }
}
