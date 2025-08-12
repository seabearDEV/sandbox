import UIKit

let closure = { (content: String) in
    return "This is the closure plus the content passed to it: \(content)"
}

func printData(prefix: String, data: (String) -> String) {
    print(prefix)
    print(data("Data"))
}

printData(prefix: "This is the function, before the closure.", data: closure)
