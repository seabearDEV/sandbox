import Foundation

var array = [Int]()

for number in 1...100 {
    if number % 2 == 0 {
        array.append(number)
    }
}

print(array)