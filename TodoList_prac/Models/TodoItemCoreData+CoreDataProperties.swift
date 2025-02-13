//
//  TodoItemCoreData+CoreDataProperties.swift
//  TodoList_prac
//
//  Created by Элина Борисова on 12.02.2025.
//
//
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
