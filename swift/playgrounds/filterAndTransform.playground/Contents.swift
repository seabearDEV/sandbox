// Generic function that filters and transforms arrays
// InputType: The type of elements in the input array (e.g., Int, String)
// OutputType: The type of elements in the output array (can be different from InputType)
func filterAndTransform<InputType,OutputType>(
   _ array: [InputType],
   where condition: (InputType) -> Bool,      // Function that returns true to keep an element
   transform: (InputType) -> OutputType       // Function that transforms each kept element
) -> [OutputType] {
   array.filter(condition).map(transform)
}

// Organize filter functions using a struct with static properties
// 'static' means these belong to the struct itself, not instances
struct Filters {
   // Each filter is a closure that takes an Int and returns a Bool
   // The syntax { $0 % 2 == 0 } is shorthand for { (n: Int) -> Bool in return n % 2 == 0 }
   // $0 represents the first parameter (the Int being tested)
    static func isEven(_ n: Int) -> Bool { n % 2 == 0}
    static func isOdd(_ n: Int) -> Bool { n % 2 != 0 }
}

// Organize transform functions the same way
struct Transforms {
   // Each transform is a closure that takes an Int and returns an Int
   // Could return a different type if needed (that's why we use generics)
    static func double(_ n: Int) -> Int { n * 2 }
    static func add100(_n n: Int) -> Int { n + 100 }
}

let numbers = [1,2,3,4,5,6,7,8,9]

// Call our generic function:
// 1. Pass the array
// 2. Use 'where:' label for the filter condition (no unwrapping needed - not optional!)
// 3. Use 'transform:' label for the transformation
let result = filterAndTransform(
   numbers,
   where: Filters.isEven,      // Filters: [2,4,6,8]
   transform: Transforms.double // Transforms to: [4,8,12,16]
)
print(result)  // [4, 8, 12, 16]

// The flow is: [1,2,3,4,5,6,7,8,9]
//           -> filter(isEven) -> [2,4,6,8]
//           -> map(double) -> [4,8,12,16]
