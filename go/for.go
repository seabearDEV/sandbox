package main

import "fmt" // Import the fmt package for formatted I/O

func main() {
    i := 1 // Initialize a variable i with the value 1

    // A while-like loop in Go, iterating while i is less than or equal to 3
    for i <= 3 {
        fmt.Println(i) // Print the current value of i
        i = i + 1      // Increment i by 1
    }

    // A traditional for loop with initialization, condition, and post statement
    for j := 0; j < 3; j++ {
        fmt.Println(j) // Print the current value of j
    }

    // Incorrect usage: range expects an iterable object, not an integer.
    // This line will cause a compilation error.
    // for i := range 3 {
    //  fmt.Println("range", i)
    // }

    // An infinite loop that breaks immediately
    for {
        fmt.Println("loop") // Print "loop"
        break               // Exit the loop
    }

    // Incorrect usage: range expects an iterable object, not an integer.
    // This line will cause a compilation error.
    // for n := range 6 {
    //  if n%2 == 0 {
    //      continue // Skip the rest of the loop iteration if n is even
    //  }
    //  fmt.Println(n) // Print n if it is odd
    // }
}
