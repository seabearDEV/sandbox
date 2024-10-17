package main

import "fmt" // Import the fmt package for formatted I/O

func main() {
    // Declare a variable 'a' with an initial value using the var keyword
    var a = "initial"
    fmt.Println(a) // Output: "initial"

    // Declare multiple variables 'b' and 'c' with specified types and initial values
    var b, c int = 1, 2
    fmt.Println(b, c) // Output: "1 2"

    // Declare a variable 'd' with an initial boolean value
    var d = true
    fmt.Println(d) // Output: "true"

    // Declare a variable 'e' with an explicit type but no initial value (defaults to zero value)
    var e int
    fmt.Println(e) // Output: "0"

    // Use short variable declaration to declare and initialize 'f'
    f := "apple" // Short variable declaration infers the type
    fmt.Println(f) // Output: "apple"
}
