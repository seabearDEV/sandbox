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
var array: [ArrayItem] = [ArrayItem]()
let itemCount: Int = 100_000
let itemDisplay: Int = 100
var end: Double
var start: Double
var totalTime: Double

// Start time for creating array
start = Date().timeIntervalSince1970
for i: Int in 1...itemCount {
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
    if index == itemDisplay {
        print("I'm only printing \(itemDisplay) of these things.")
        
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
