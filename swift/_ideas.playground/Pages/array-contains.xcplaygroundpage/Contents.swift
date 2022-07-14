import Foundation

var a_01: [Int] = [Int]()

for i in 1...10 {
    a_01.append(i)
}

func contains(_ array: [Int], _ item: Int) -> Bool {
    array.contains(item)
}

print(contains(a_01, 60))
