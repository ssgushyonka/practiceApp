//
//  TodoItemCoreData+CoreDataProperties.swift
//  TodoList_prac
//
//  Created by Элина Борисова on 12.02.2025.
//
// swiftlint:disable all
import CoreData
import Foundation

extension TodoItemCoreData {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoItemCoreData> {
        return NSFetchRequest<TodoItemCoreData>(entityName: "TodoItemCoreData")
    }

    @NSManaged public var id: String?
    @NSManaged public var isDone: Bool
    @NSManaged public var text: String?
    @NSManaged public var priority: String?
    @NSManaged public var createdDate: Date?
    @NSManaged public var editedDate: Date?
    @NSManaged public var deadline: Date?
}

extension TodoItemCoreData: Identifiable {
}
extension TodoItemCoreData {
    var priorityEnum: Priority {
        get {
            return Priority(rawValue: priority ?? "") ?? .low
        }
        set {
            priority = newValue.rawValue
        }
    }
    var formattedDeadline: String? {
        guard let deadline = deadline else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: deadline)
    }
}
// swiftlint:enable all
