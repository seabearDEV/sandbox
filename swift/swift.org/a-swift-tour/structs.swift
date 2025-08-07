struct Person {
    var name: String
    var occupation: String
    var skills: [String]
    
    // This method modifies the 'skills' property, so it needs 'mutating'
    mutating func addSkill(_ skill: String) {
        skills.append(skill)  // This changes the struct's data
    }
    
    // This method doesn't change anything, so no 'mutating' needed
    func displaySkills() -> String {
        return "Skills: \(skills.joined(separator: ", "))"
    }
    
    // Another mutating example
    mutating func promote(to newOccupation: String) {
        occupation = newOccupation
    }
}

// Usage examples:
var malcolm = Person(name: "Malcolm", occupation: "Captain", skills: ["Leadership"])

// This works - malcolm is 'var' so it can be mutated
malcolm.addSkill("Piloting")
malcolm.promote(to: "Admiral")

print(
    """
    Name: \(malcolm.name)
    Skills: \(malcolm.displaySkills())
    Occupation: \(malcolm.occupation)
    """
)
