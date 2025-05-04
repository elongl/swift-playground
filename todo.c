#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <ctype.h>

// Define the Priority enum
typedef enum
{
    PRIORITY_LOW,
    PRIORITY_MEDIUM,
    PRIORITY_HIGH,
    PRIORITY_UNKNOWN
} Priority;

// Define the Task struct
typedef struct
{
    char description[256];
    Priority priority;
    bool isCompleted;
} Task;

// Define the TodoList struct
typedef struct
{
    Task tasks[100];
    int taskCount;
} TodoList;

// Function to initialize a new TodoList
TodoList *createTodoList()
{
    TodoList *list = (TodoList *)malloc(sizeof(TodoList));
    list->taskCount = 0;
    return list;
}

// Function to convert string to Priority enum
Priority priorityFromString(const char *str)
{
    char lowercaseStr[20];
    int i;

    // Convert to lowercase
    for (i = 0; str[i] && i < 19; i++)
    {
        lowercaseStr[i] = tolower(str[i]);
    }
    lowercaseStr[i] = '\0';

    if (strcmp(lowercaseStr, "low") == 0)
    {
        return PRIORITY_LOW;
    }
    else if (strcmp(lowercaseStr, "medium") == 0)
    {
        return PRIORITY_MEDIUM;
    }
    else if (strcmp(lowercaseStr, "high") == 0)
    {
        return PRIORITY_HIGH;
    }
    else
    {
        return PRIORITY_UNKNOWN;
    }
}

// Function to convert Priority enum to string
const char *priorityToString(Priority priority)
{
    switch (priority)
    {
    case PRIORITY_LOW:
        return "Low";
    case PRIORITY_MEDIUM:
        return "Medium";
    case PRIORITY_HIGH:
        return "High";
    default:
        return "Unknown";
    }
}

// Function to add a task to the TodoList
void addTask(TodoList *list, const char *description, Priority priority)
{
    if (list->taskCount >= 100)
    {
        printf("Task list is full!\n");
        return;
    }

    Task *task = &list->tasks[list->taskCount];
    strncpy(task->description, description, 255);
    task->description[255] = '\0';
    task->priority = priority;
    task->isCompleted = false;

    list->taskCount++;
    printf("Task added successfully!\n");
}

// Function to list all tasks
void listTasks(TodoList *list)
{
    if (list->taskCount == 0)
    {
        printf("No tasks in the list.\n");
        return;
    }

    printf("\nTask List:\n");
    printf("--------------------------------------------------\n");
    printf("No. | Priority | Status    | Description\n");
    printf("--------------------------------------------------\n");

    for (int i = 0; i < list->taskCount; i++)
    {
        Task *task = &list->tasks[i];
        printf("%-3d | %-8s | %-9s | %s\n",
               i + 1,
               priorityToString(task->priority),
               task->isCompleted ? "Completed" : "Pending",
               task->description);
    }
    printf("--------------------------------------------------\n");
}

// Function to mark a task as complete
void completeTask(TodoList *list, int taskNumber)
{
    if (taskNumber < 1 || taskNumber > list->taskCount)
    {
        printf("Invalid task number!\n");
        return;
    }

    Task *task = &list->tasks[taskNumber - 1];
    if (task->isCompleted)
    {
        printf("Task is already completed!\n");
    }
    else
    {
        task->isCompleted = true;
        printf("Task marked as completed!\n");
    }
}

// Function to read a line of input
void readLine(char *buffer, int size)
{
    fgets(buffer, size, stdin);

    // Remove newline character if present
    int len = strlen(buffer);
    if (len > 0 && buffer[len - 1] == '\n')
    {
        buffer[len - 1] = '\0';
    }
}

// Main function
int main()
{
    TodoList *todoList = createTodoList();
    char input[256];
    int choice;
    bool running = true;

    while (running)
    {
        // Display menu
        printf("\nTo-Do List Menu:\n");
        printf("1. Add Task\n");
        printf("2. List Tasks\n");
        printf("3. Complete Task\n");
        printf("4. Exit\n");
        printf("Enter choice (1-4): ");

        // Get user choice
        readLine(input, sizeof(input));
        choice = atoi(input);

        switch (choice)
        {
        case 1:
        {
            // Add a task
            char description[256];
            char priorityStr[20];

            printf("Enter task description: ");
            readLine(description, sizeof(description));

            if (strlen(description) == 0)
            {
                printf("Description cannot be empty.\n");
                break;
            }

            printf("Enter priority (low/medium/high): ");
            readLine(priorityStr, sizeof(priorityStr));

            Priority priority = priorityFromString(priorityStr);
            if (priority == PRIORITY_UNKNOWN)
            {
                printf("Invalid priority. Use low, medium, or high.\n");
                break;
            }

            addTask(todoList, description, priority);
            break;
        }

        case 2:
            // List tasks
            listTasks(todoList);
            break;

        case 3:
        {
            // Complete a task
            listTasks(todoList);

            if (todoList->taskCount == 0)
            {
                break;
            }

            printf("Enter task number to complete: ");
            readLine(input, sizeof(input));

            int taskNumber = atoi(input);
            if (taskNumber == 0)
            {
                printf("Invalid input. Please enter a number.\n");
                break;
            }

            completeTask(todoList, taskNumber);
            break;
        }

        case 4:
            // Exit
            printf("Goodbye!\n");
            running = false;
            break;

        default:
            printf("Invalid choice. Please select 1-4.\n");
            break;
        }
    }

    // Clean up
    free(todoList);
    return 0;
}
