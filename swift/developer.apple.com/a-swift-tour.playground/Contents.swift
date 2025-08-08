struct User {
    let username: String
    let isVisible: Bool = true
    private var friends: [String] = []
    
    init(username: String) {
        self.username = username
    }
    
    mutating func addFriend(username: String) throws {
        friends.append(username)
    }
    
    func showFriends() {
        print(friends)
    }
}

var alice = User(username: "alice")
do {
    try alice.addFriend(username: "charlie")
}
