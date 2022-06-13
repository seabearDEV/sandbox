import Cocoa

// https://betterprogramming.pub/everything-you-wanted-to-know-about-closures-in-swift-e7d3a6ff5a74

let westernCountries = ["america", "canada", "mexico"]
let easternCountries = ["china", "korea", "japan"]

/*
 visitCountry() - name of the closure
 (String) - variable passed into the closure
 Void - Return type for the closure
*/
func visitCountry() -> (String) -> () {
    // This internal variable will exist for the duration of the parent scope
    var visited = 0
    
    // This code is returned to the parent scope, where $0 is the item of the array
    return {
        print("I just visited \($0)")
        visited += 1
        print("Visited countries: \(visited)")
    }
}

// This variable points to the closure
let helloWorld = visitCountry()

westernCountries.forEach {
    // $0 is the item being looped over in the array and we pass it into the closure
    helloWorld($0)
}

// https://www.appypie.com/closures-swift-how-to

let basic: () -> () = {
    print("Basic")
}
basic()

let birthday: (String) -> () = { (name: String) -> () in
    print("Happy birthday \(name)!")
}
birthday("Chester")

func addScore(_ points: Int) -> Int {
    let score = 42
    let calculate = {
        return score + points
    }

    return calculate()
}
let value = addScore(11)
print(value)

func lengthyTask(completionHandler: (Int) -> Int) {
    let result = completionHandler(42)
    
    print(result)
}

lengthyTask(completionHandler: { number in
    print(number)
    return 101
})
