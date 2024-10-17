package main

import "fmt" // Import the fmt package for formatted I/O

func main() {
    // Check if 7 is even or odd
    if 7%2 == 0 {
        fmt.Println("7 is even") // This block executes if 7 is even
    } else {
        fmt.Println("7 is odd") // This block executes if 7 is odd
    }

    // Check if 8 is divisible by 4
    if 8%4 == 0 {
        fmt.Println("8 is divisible by 4") // This block executes if 8 is divisible by 4
    }

    // Check if either 8 or 7 is even using logical OR
    if 8%2 == 0 || 7%2 == 0 {
        fmt.Println("either 8 or 7 are even") // This block executes if either condition is true
    }

    // Declare a variable 'num' and check its properties
    if num := 9; num < 0 {
        fmt.Println(num, "is negative") // This block executes if num is negative
    } else if num < 10 {
        fmt.Println(num, "has 1 digit") // This block executes if num has 1 digit
    } else {
        fmt.Println(num, "has multiple digits") // This block executes if num has multiple digits
    }
}
