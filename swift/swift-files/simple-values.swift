// Constants and variables

var myVariable = 42
myVariable = 50
var fruits = ["strawberries", "limes", "tangerines"]
fruits[1] = "grapes"
fruits.append("blueberries")

var occupations = [
    "Malcolm": "Captain",
    "Kaylee": "Mechanic"
]

let myConstant = 42
let myConstantFloat: Float = 4.0
let label = "The width is "
let width = 94
let widthLabel = label + String(width)
let apples = 3
let oranges = 5
let appleSummary = "I have \(apples) apples."
let fruitSummary = "I have \(apples + oranges) pieces of fruit."
let prompt = """
    Even though there's whitespace to the left,
    the actual lines aren't indented.
        Except for this line.
    Double quotes (") can appear without being escaped.

    I still have \(apples + oranges) pieces of fruit.
    """

// Functions

func printy(options: Any) {
    print(options)
}

//printy(options: prompt)

var emptyArray: [String] = []
var emptyDictionary: [String: Float] = [:]
var emptyArrayOfDictionaries: [[String: Int]] = []

/*print(
    """
    EMPTY ARRAY: \(emptyArray)
    EMPTY DICTIONARY: \(emptyDictionary)
    EMPTY ARRAY OF DICTIONARIES: \(emptyArrayOfDictionaries)
    """
)*/

emptyArrayOfDictionaries.append(contentsOf: [
    ["Number 1": 1],
    ["Number 2": 2]
])

emptyArrayOfDictionaries[0]["Number 3"] = 3


print(emptyArrayOfDictionaries)
