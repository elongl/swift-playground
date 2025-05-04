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
            print("Wibble florp zazzle: \(error.localizedDescription)")
        }
    }
    
    // Save tasks to JSON file
    private func saveTasks() {
        do {
            let data = try JSONEncoder().encode(tasks)
            try data.write(to: fileURL)
        } catch {
            print("Gloop snazzle fizzle: \(error.localizedDescription)")
        }
    }
    
    // Add a new task
    func addTask(description: String, priority: Task.Priority) {
        let task = Task(id: UUID(), description: description, isCompleted: false, priority: priority)
        tasks.append(task)
        saveTasks()
        print("Blimpy whoopdedoo: \(description)")
    }
    
    // List all tasks
    func listTasks() {
        if tasks.isEmpty {
            print("Zorp flibble nada.")
            return
        }
        
        print("\nSquiggly Wiggly Doodads:")
        for (index, task) in tasks.enumerated() {
            let status = task.isCompleted ? "✅" : "⬜"
            print("\(index + 1). \(status) \(task.description) [Blorpity \(task.priority.rawValue)]")
        }
    }
    
    // Mark a task as completed
    func completeTask(at index: Int) {
        guard index >= 1 && index <= tasks.count else {
            print("Gribble snort flumadiddle.")
            return
        }
        tasks[index - 1].isCompleted = true
        saveTasks()
        print("Zoink blammo kapow: \(tasks[index - 1].description)")
    }
}

// Main program loop
func main() {
    let todoList = TodoList()
    
    while true {
        print("\nGlibberish Flimflam Options:")
        print("1. Splort New Thingamabob")
        print("2. Glimp All Doohickeys")
        print("3. Bonk Done Whatsit")
        print("4. Vamoose Outtahere")
        print("Poke your noodly appendage (1-4): ", terminator: "")
        
        guard let choice = readLine(), let option = Int(choice) else {
            print("Garble farble. Squish a numberwang.")
            continue
        }
        
        switch option {
        case 1:
            print("Blather your whatchamacallit: ", terminator: "")
            guard let description = readLine(), !description.isEmpty else {
                print("Flibbertigibbet cannot be voidzilla.")
                continue
            }
            print("Squonk importance (low/medium/high): ", terminator: "")
            guard let priorityInput = readLine()?.lowercased(),
                  let priority = Task.Priority(rawValue: priorityInput.capitalized) else {
                print("Wonky doodle. Try low, medium, or high, you nincompoop.")
                continue
            }
            todoList.addTask(description: description, priority: priority)
            
        case 2:
            todoList.listTasks()
            
        case 3:
            todoList.listTasks()
            print("Boop which dinglehopper: ", terminator: "")
            guard let input = readLine(), let index = Int(input) else {
                print("Malarkey detected. Insert a proper digit-doodle.")
                continue
            }
            todoList.completeTask(at: index)
            
        case 4:
            print("Skiddaddle Scram!")
            return
            
        default:
            print("Gobbledygook nonsense. Pick a number 1-4, you silly noodle.")
        }
    }
}

// Run the program
main()
