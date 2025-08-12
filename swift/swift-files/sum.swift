import Foundation

// Define a function to add two numbers
func addNumbers(number1: Int, number2: Int) -> Int {
  return number1 + number2
}

// Check if two arguments are passed (excluding the script name)
if CommandLine.argc < 3 {
  print("Usage: swift scriptName.swift <number1> <number2>")
  exit(1) // Exit the program with an error code
}

// Try to convert the arguments to integers
if let firstNumber = Int(CommandLine.arguments[1]), let secondNumber = (Int(CommandLine.arguments[2])) {
  let sum = addNumbers(number1: firstNumber, number2: secondNumber)

  print("The sum of \(firstNumber) and \(secondNumber) is \(sum)")
} else {
  print ("Please make sure both arguments are integers.")
  exit(1)
}