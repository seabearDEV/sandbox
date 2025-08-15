//
//  SplitNode.swift
//  Bento Layout
//
//  Data model for the split tree structure
//

import SwiftUI
import Combine

class SplitNode: ObservableObject, Identifiable, Codable {
    let id: UUID
    @Published var children: [SplitNode] = []
    @Published var color: Color?
    @Published var axis: Axis = .vertical
    let verticalDepth: Int
    let horizontalDepth: Int
    
    static let maxVerticalDepth = 3
    static let maxHorizontalDepth = 2
    
    static let colorOptions: [Color] = [
        Color(red: 0.0, green: 0.478, blue: 1.0),      // Blue
        Color(red: 1.0, green: 0.231, blue: 0.188),    // Red
        Color(red: 0.204, green: 0.780, blue: 0.349),  // Green
        Color(red: 1.0, green: 0.8, blue: 0.0),        // Yellow
        Color(red: 0.686, green: 0.321, blue: 0.871),  // Purple
        Color(red: 1.0, green: 0.584, blue: 0.0),      // Orange
        Color(red: 1.0, green: 0.176, blue: 0.333),    // Pink
        Color(red: 0.196, green: 0.843, blue: 0.902),  // Cyan
        Color(red: 0.0, green: 0.780, blue: 0.746),    // Mint
        Color(red: 0.345, green: 0.337, blue: 0.839),  // Indigo
        Color(red: 0.635, green: 0.518, blue: 0.368),  // Brown
        Color(red: 0.557, green: 0.557, blue: 0.576),  // Gray
        Color(red: 0.188, green: 0.690, blue: 0.780),  // Teal
        Color(red: 0.0, green: 0.0, blue: 0.0),        // Black
    ]
    static let defaultColor = colorOptions[0]
    
    init(color: Color, verticalDepth: Int = 0, horizontalDepth: Int = 0, id: UUID = UUID()) {
        self.id = id
        self.color = color
        self.verticalDepth = verticalDepth
        self.horizontalDepth = horizontalDepth
    }
    
    init(children: [SplitNode], axis: Axis = .vertical, verticalDepth: Int = 0, horizontalDepth: Int = 0, id: UUID = UUID()) {
        self.id = id
        self.children = children
        self.axis = axis
        self.verticalDepth = verticalDepth
        self.horizontalDepth = horizontalDepth
    }
    
    var isLeaf: Bool {
        children.isEmpty
    }
    
    func canSplit(_ direction: SplitDirection) -> Bool {
        switch direction {
        case .horizontal:
            return horizontalDepth < Self.maxHorizontalDepth
        case .vertical:
            return verticalDepth < Self.maxVerticalDepth
        }
    }
    
    var canSplitAtAll: Bool {
        canSplit(.horizontal) || canSplit(.vertical)
    }
    
    func removeChild(withId id: UUID) {
        children.removeAll { $0.id == id }
        
        if children.count == 1, let remainingChild = children.first {
            if remainingChild.isLeaf {
                self.color = remainingChild.color
                self.children = []
            } else {
                self.children = remainingChild.children
                self.axis = remainingChild.axis
            }
        }
    }
    
    // MARK: - Codable
    
    enum CodingKeys: String, CodingKey {
        case id, children, colorData, axis, verticalDepth, horizontalDepth
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(children, forKey: .children)
        try container.encode(axis == .horizontal ? "horizontal" : "vertical", forKey: .axis)
        try container.encode(verticalDepth, forKey: .verticalDepth)
        try container.encode(horizontalDepth, forKey: .horizontalDepth)
        
        if let color = color {
            let uiColor = UIColor(color)
            var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
            uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            let hex = String(format: "#%02X%02X%02X", Int(red * 255), Int(green * 255), Int(blue * 255))
            try container.encode(hex, forKey: .colorData)
        }
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        verticalDepth = try container.decode(Int.self, forKey: .verticalDepth)
        horizontalDepth = try container.decode(Int.self, forKey: .horizontalDepth)
        
        let axisString = try container.decode(String.self, forKey: .axis)
        axis = axisString == "horizontal" ? .horizontal : .vertical
        
        children = try container.decode([SplitNode].self, forKey: .children)
        color = try container.decodeIfPresent(String.self, forKey: .colorData).map { Color(hex: $0) }
    }
}

enum SplitDirection {
    case horizontal, vertical
}