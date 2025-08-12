// User struct represents a social media user with basic profile information
// and friend management capabilities
struct User {
    // Immutable username that uniquely identifies the user
    let username: String
    
    // Visibility flag to control if the user's profile is public
    // Defaults to true (visible to everyone)
    var isVisible: Bool = true
    
    // Array storing usernames of friends connected to this user
    // Initialized as empty array for new users
    var friends: [String] = []

    // Adds a new friend to the user's friend list
    // - Parameter username: The username of the friend to add
    // - Throws: SocialError.befriendingSelf if trying to add oneself
    //           SocialError.duplicateFriend if friend already exists
    // - Note: 'mutating' keyword is required because this function modifies
    //         the struct's properties (friends array)
    mutating func addFriend(username: String) throws {
        // Prevent users from adding themselves as a friend
        guard username != self.username else {
            throw SocialError.befriendingSelf
        }
        // Check if the friend is already in the list to avoid duplicates
        guard !friends.contains(username) else {
            throw SocialError.duplicateFriend(username: username)
        }
        // If all validations pass, add the friend to the list
        friends.append(username)
    }
}

// Custom error types for social media operations
// Conforms to Error protocol to be used with Swift's error handling
enum SocialError: Error {
    // Error thrown when a user attempts to add themselves as a friend
    case befriendingSelf
    
    // Error thrown when trying to add a friend who is already in the friend list
    // Associated value contains the username that was attempted to be added
    case duplicateFriend(username: String)
}

// Create a new user instance for Alice
var alice = User(username: "alice")

// Demonstrate error handling with do-try-catch
// This block intentionally triggers an error by adding the same friend twice
do {
    // First attempt to add charlie as a friend - succeeds
    try alice.addFriend(username: "charlie")
    
    // Second attempt to add charlie - throws duplicateFriend error
    // This demonstrates the duplicate prevention logic
    try alice.addFriend(username: "charlie")
} catch {
    // The error is captured and can be inspected in the playground
    // In a real app, you would handle specific error cases here
    error
}

// Global dictionary to store all users in the system
// Key: username (String), Value: User struct
// Acts as a simple in-memory database for user lookup
var allUsers = [
    "alice": alice
]

// Searches for a user by username in the global user dictionary
// - Parameter username: The username to search for
// - Returns: Optional User - the user if found, nil otherwise
// - Note: @MainActor annotation ensures this function runs on the main thread
//         This is required because allUsers is implicitly MainActor-isolated
//         in Swift Playgrounds environment
@MainActor
func findUser(_ username: String) -> User? {
    allUsers[username]
}

// Demonstrate optional binding with user lookup
// Looking for "charlie" who doesn't exist in allUsers dictionary
if let charlie = findUser("charlie") {
    print("Found \(charlie)")
} else {
    // This branch will execute since charlie is not in the dictionary
    print("charlie not found")
}

// Force unwrapping example - will crash at runtime
// This demonstrates what happens when force unwrapping a nil optional
// The user "dash" doesn't exist, so findUser returns nil
// Force unwrapping nil causes a runtime error
let dash = findUser("dash")!
