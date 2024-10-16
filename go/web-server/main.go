// main.go
package main

import (
	"log"
	"net/http"
	"text/template"
)

// This Todo struct represents a single todo item
type Todo struct {
    Id      int
    Message string
}

func main() {
    // Initial data for the todo list
    data := map[string][]Todo{
        "Todos": {
            Todo{
                Id:      1,
                Message: "Buy Milk",
            },
        },
    }

    // Handler for the main page
    todosHandler := func(w http.ResponseWriter, r *http.Request) {
        // Parse the HTML template
        templ := template.Must(template.ParseFiles("index.html"))
        // Execute the template with the data and write to the response
        templ.Execute(w, data)
    }

    // Handler for adding new todos
    addTodoHandler := func(res http.ResponseWriter, req *http.Request) {
        // Get the message from the form submission
        message := req.PostFormValue("message")
        // Parse the HTML template
        templ := template.Must(template.ParseFiles("index.html"))
        // Create a new Todo item
        todo := Todo{Id: len(data["Todos"]) + 1, Message: message}
        // Add the new Todo to the data slice
        data["Todos"] = append(data["Todos"], todo)
        // Execute only the "todo-list-element" block of the template
        // This returns just the HTML for the new todo item
        templ.ExecuteTemplate(res, "todo-list-element", todo)
    }

    // Set up the routes
    http.HandleFunc("/", todosHandler)
    http.HandleFunc("/add-todo", addTodoHandler)

    // Start the server
    log.Fatal(http.ListenAndServe(":8000", nil))
}
