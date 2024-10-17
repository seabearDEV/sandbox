package main

import "fmt" // Import the fmt package for formatted I/O

func main() {
    // Concatenate two strings using the + operator
    fmt.Println("go" + "lang") // Output: "golang"

    // Perform integer addition
    fmt.Println("1+1 =", 1+1) // Output: "1+1 = 2"

    // Perform floating-point division
    fmt.Println("7.0/3.0 =", 7.0/3.0) // Output: "7.0/3.0 = 2.3333333333333335"

    // Perform boolean operations
    fmt.Println(true && false) // Logical AND: Output is false
    fmt.Println(true || false) // Logical OR: Output is true
    fmt.Println(!true)         // Logical NOT: Output is false
}
