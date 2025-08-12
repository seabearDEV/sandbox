import Foundation

struct User: Identifiable, Codable {
    let id: UUID
    let name: String
    let bio: String
    let imageURL: URL?
}

let user = User(
    id: UUID(),
    name: "John Appleseed",
    bio: "Famous person within the Apple Cinematic Universe",
    imageURL: nil
)

print("ID: \(user.id), Name: \(user.name), Bio: \(user.bio), Image URL: \(user.imageURL?.absoluteString ?? "None")")
