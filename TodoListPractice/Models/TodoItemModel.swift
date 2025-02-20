import Foundation

enum Priority: String {
    case low = "неважно"
    case medium = "обычная"
    case high = "важная"
}

struct TodoItemModel {
    let id: String
    var text: String
    let priority: Priority
    let deadline: Date?
    var isDone: Bool
    let createdDate: Date?
    let editedDate: Date?
    
    init(
        id: String = UUID().uuidString,
        text: String,
        priority: Priority,
        deadline: Date?,
        isDone: Bool,
        createdDate: Date?,
        editedDate: Date?
    ) {
            self.id = id
            self.text = text
            self.priority = priority
            self.deadline = deadline
            self.isDone = isDone
            self.createdDate = createdDate
            self.editedDate = editedDate
        }
}

