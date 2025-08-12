// Social media user with profile and friends
struct User {
    let username: String
    var isVisible: Bool = true
    private(set) var friends: [String] = []

    // Adds friend, throws if self or duplicate
    mutating func addFriend(username: String) throws {
        guard username != self.username else {
            throw SocialError.befriendingSelf
        }
        guard !friends.contains(username) else {
            throw SocialError.duplicateFriend(username: username)
        }
        friends.append(username)
    }
}

// Social media errors
enum SocialError: Error {
    case befriendingSelf
    case duplicateFriend(username: String)
}

var alice = User(username: "alice")

// Error handling demo - adding same friend twice
do {
    try alice.addFriend(username: "charlie")
    try alice.addFriend(username: "charlie") // throws duplicateFriend
} catch {
    error
}

// User storage
var allUsers = [
    "alice": alice
]

// Find user by username
@MainActor
func findUser(_ username: String) -> User? {
    allUsers[username]
}

// Optional binding example
if let charlie = findUser("charlie") {
    print("Found \(charlie)")
} else {
    print("charlie not found")
}

// Force unwrap nil - crashes!
let dash = findUser("dash")!
