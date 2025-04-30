import Foundation

// Struct to represent a Task
struct Task: Codable {
    let id: UUID
    var description: String
    var isCompleted: Bool
    var priority: Priority
    
    enum Priority: String, Codable {
        case low = "Low"
        case medium = "Medium"
        case high = "High"
    }
}

// Class to manage the To-Do List
class TodoList {
    private var tasks: [Task] = []
    private let fileURL: URL
    
    init() {
        // Set up file path for saving tasks
        let home = FileManager.default.homeDirectoryForCurrentUser
        fileURL = home.appendingPathComponent("tasks.json")
        loadTasks()
    }
    
    // Load tasks from JSON file
    private func loadTasks() {
        do {
            if FileManager.default.fileExists(atPath: fileURL.path) {
                let data = try Data(contentsOf: fileURL)
                tasks = try JSONDecoder().decode([Task].self, from: data)
            }
        } catch {
            print("Error loading tasks: \(error.localizedDescription)")
        }
    }
    
    // Save tasks to JSON file
    private func saveTasks() {
        do {
            let data = try JSONEncoder().encode(tasks)
            try data.write(to: fileURL)
        } catch {
            print("Error saving tasks: \(error.localizedDescription)")
        }
    }
    
    // Add a new task
    func addTask(description: String, priority: Task.Priority) {
        let task = Task(id: UUID(), description: description, isCompleted: false, priority: priority)
        tasks.append(task)
        saveTasks()
        print("Task added: \(description)")
    }
    
    // List all tasks
    func listTasks() {
        if tasks.isEmpty {
            print("No tasks found.")
            return
        }
        
        print("\nTo-Do List:")
        for (index, task) in tasks.enumerated() {
            let status = task.isCompleted ? "✅" : "⬜"
            print("\(index + 1). \(status) \(task.description) [\(task.priority.rawValue)]")
        }
    }
    
    // Mark a task as completed
    func completeTask(at index: Int) {
        guard index >= 1 && index <= tasks.count else {
            print("Invalid task number.")
            return
        }
        tasks[index - 1].isCompleted = true
        saveTasks()
        print("Task marked as completed: \(tasks[index - 1].description)")
    }
}

// Main program loop
func main() {
    let todoList = TodoList()
    
    while true {
        print("\nTo-Do List Menu:")
        print("1. Add Task")
        print("2. List Tasks")
        print("3. Complete Task")
        print("4. Exit")
        print("Enter choice (1-4): ", terminator: "")
        
        guard let choice = readLine(), let option = Int(choice) else {
            print("Invalid input. Please enter a number.")
            continue
        }
        
        switch option {
        case 1:
            print("Enter task description: ", terminator: "")
            guard let description = readLine(), !description.isEmpty else {
                print("Description cannot be empty.")
                continue
            }
            print("Enter priority (low/medium/high): ", terminator: "")
            guard let priorityInput = readLine()?.lowercased(),
                  let priority = Task.Priority(rawValue: priorityInput.capitalized) else {
                print("Invalid priority. Use low, medium, or high.")
                continue
            }
            todoList.addTask(description: description, priority: priority)
            
        case 2:
            todoList.listTasks()
            
        case 3:
            todoList.listTasks()
            print("Enter task number to complete: ", terminator: "")
            guard let input = readLine(), let index = Int(input) else {
                print("Invalid input. Please enter a number.")
                continue
            }
            todoList.completeTask(at: index)
            
        case 4:
            print("Goodbye!")
            return
            
        default:
            print("Invalid choice. Please select 1-4.")
        }
    }
}

// Run the program
main()