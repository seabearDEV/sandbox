import Foundation

// Stacks

struct Stack<Element> {
    // Private variables
    private var array = [Element]()
    
    // Variables
    var count: Int {
        array.count
    }
    var isEmpty: Bool {
        return array.isEmpty
    }
    
    // Functions
    func peek() -> Element? {
        array.last
    }
    
    // Mutating functions
    mutating func push(_ element: Element) {
        array.append(element)
    }
    mutating func pop() -> Element? {
        array.popLast()
    }
    mutating func removeAll() {
        array.removeAll()
    }
    
    // Default Initializer
    init() { }
    
    // Custom initializer
    init(_ items: [Element]) {
        self.array = items
    }
}
extension Stack: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: Element...) {
        self.array = elements
    }
}
extension Stack: CustomDebugStringConvertible {
    var debugDescription: String {
        var result = "["
        var first = true
        
        for item in array {
            if first {
                first = false
            } else {
                result += ", "
            }
            
            debugPrint(item, terminator: "", to: &result)
        }
        
        result += "]"
        
        return result
    }
}
extension Stack: Equatable where Element: Equatable { }
extension Stack: Hashable where Element: Hashable { }
extension Stack: Encodable where Element: Encodable { }
extension Stack: Decodable where Element: Decodable { }

// Output

var numbersArray: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9]
var numbers = Stack<Int>(numbersArray)

print(numbers)
numbers.removeAll()
print(numbers)
