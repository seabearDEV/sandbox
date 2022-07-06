import Foundation

// Protocols
protocol ArrayItem {
    var number: Int { get }
}

// Structs
struct Number: ArrayItem {
    var number: Int
}

// Variables
var start: Double
var end: Double
var totalTime: Double
var array: [ArrayItem] = [ArrayItem]()


// Start time for creating array
start = Date().timeIntervalSince1970
for i: Int in 1...11 {
    array.append(Number(number: i))
}
// End time for creating array
end = Date().timeIntervalSince1970

// Calculate total execution time
totalTime = {
    round(((end - start) * 1000) * 1000) / 1000
}()

// Print out items in array
for (index, item) in array.enumerated() {
    if index == 10 {
        print("I'm only printing 10 of these things.")
        
        break
    } else {
        print("Index: \(index) Number: \(item.number)")
    }
}

// Print summary
print(
    """
    Total items in array: \(array.count)
    Total execution time: \(totalTime)ms
    """
)
