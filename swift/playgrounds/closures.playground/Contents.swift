import Cocoa

// MARK: - Closures with Captured Values
// Demonstrates how closures can capture and store references to variables from their surrounding context

let westernCountries = ["america", "canada", "mexico"]
let easternCountries = ["china", "korea", "japan"]

// This function returns a closure that captures state
// Return type: (String) -> () means it returns a closure that:
//   - Takes a String parameter (country name)
//   - Returns nothing (Void)
func visitCountry() -> (String) -> () {
    // This variable is captured by the closure below
    // It persists between closure calls, acting like a private instance variable
    var visited = 0
    
    // The returned closure captures 'visited' from the outer scope
    // Each time this closure is called, it increments the same 'visited' variable
    return {
        print("I just visited \($0)")
        visited += 1
        print("Visited countries: \(visited)")
    }
}

// Create an instance of the closure - this captures its own 'visited' counter
// Each call to visitCountry() creates a new, independent closure with its own state
let helloWorld = visitCountry()

// Using the closure with forEach - demonstrates trailing closure syntax
// $0 is Swift's shorthand for the first parameter (each country in the array)
westernCountries.forEach {
    helloWorld($0)  // The captured 'visited' variable increments with each call
}

// MARK: - Basic Closure Syntax Examples

// Simplest closure: no parameters, no return value
// Type annotation: () -> () means takes nothing, returns nothing
let basic: () -> () = {
    print("Basic")
}
basic()

// Closure with explicit parameter and return type annotations
// The 'in' keyword separates the closure's parameters/return type from its body
let birthday: (String) -> () = { (name: String) -> () in
    print("Happy birthday \(name)!")
}
birthday("Chester")

// MARK: - Closures Capturing Values from Enclosing Scope

// Demonstrates how closures capture values from their surrounding context
func addScore(_ points: Int) -> Int {
    let score = 42  // Local constant that will be captured
    
    // This closure captures both 'score' (from this function) and 'points' (parameter)
    // No parameters needed - it uses captured values instead
    let calculate = {
        return score + points
    }

    return calculate()  // Execute the closure and return its result
}
let value = addScore(11)  // Result: 42 + 11 = 53
print(value)

// MARK: - Closures as Function Parameters (Completion Handlers)

// Functions can accept closures as parameters - common pattern for callbacks
// completionHandler type: (Int) -> Int means the closure must:
//   - Accept an Int parameter
//   - Return an Int value
func lengthyTask(completionHandler: (Int) -> Int) {
    // Call the provided closure with value 42
    let result = completionHandler(42)
    
    print("Result from completion handler: \(result)")
}

// Calling a function with a closure parameter
// The closure receives 'number' (which will be 42) and returns 101
lengthyTask(completionHandler: { number in
    print("Received number: \(number)")
    return 101
})

// Note: This could also be written with trailing closure syntax:
// lengthyTask { number in
//     print("Received number: \(number)")
//     return 101
// }
