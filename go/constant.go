package main

import (
	"fmt"  // Import the fmt package for formatted I/O
	"math" // Import the math package for mathematical functions
)

// Declare a constant string
const s string = "constant"

// main is the entry point of the program
func main() {
    // Print the constant string
    fmt.Println(s)

    // Declare a constant integer
    const n = 500000000

    // Declare a constant floating-point number using scientific notation
    const d = 3e20 / n

    // Print the value of d
    fmt.Println(d)

    // Convert d to an int64 and print it
    fmt.Println(int64(d))

    // Calculate and print the sine of n (n is converted to a float64 implicitly)
    fmt.Println(math.Sin(n))
}
