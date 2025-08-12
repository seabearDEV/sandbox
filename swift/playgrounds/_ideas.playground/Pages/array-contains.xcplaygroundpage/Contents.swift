 import Foundation

// Creating an array of 10 items and then seraching for an element
var a_01: [Int] = [Int]()
for i in 1...10 {
    a_01.append(i)
}
func contains(_ array: [Int], _ item: Int) -> Bool {
    array.contains(item)
}
print(contains(a_01, 10))

// Creating a struct, adding instances of it to an array, and then searching for an element
struct StructA {
    static var count = 0
    private var id = UUID()
    var name: String
    
    init(name: String) {
        StructA.count += 1
        self.name = name
    }
}
var a_02: [StructA] = [StructA]()
func addStructToArray(array: inout [StructA], quantity: Int) {
    for item in 1...quantity {
        array.append(
            StructA(name: "Instance: \(item)")
        )
    }
}
addStructToArray(array: &a_02, quantity: 100)
let search = "Instance: 50"
let result = (a_02.enumerated().contains { item in
    if item.element.name == search {
        print("Index: \(item.offset) Name: \(item.element.name)")
        
        return true
    }
    
    return false
})
print(result)
