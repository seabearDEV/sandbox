import Foundation

var array = [String]()
var startTime: Double
var endTime: Double
var totalTime: Double

startTime = Date.now.timeIntervalSince1970 * 1000
for i in 1...10000 {
    array.append("Line \(i)")
}
endTime = Date.now.timeIntervalSince1970 * 1000

totalTime = endTime - startTime

print("Total Run Time: \(totalTime) milliseconds.")
