import Cocoa

func travel(first: String, action: (String) -> String) {
    print("The first value is: \(first)")
    print(action("Second!"))
}

let place = { (second: String) in
        return "This is the value: \(second)"
}

travel(first: "First!", action: place)
