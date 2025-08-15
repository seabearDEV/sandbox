//
//  ContentView.swift
//  Bento Layout
//
//  A study in SwiftUI compositional layouts using alternating stack directions
//

import SwiftUI
import Combine

// MARK: - Data Model

/// Represents a node in the split tree
class SplitNode: ObservableObject, Identifiable, Codable {
    let id: UUID
    @Published var children: [SplitNode] = []
    @Published var color: Color?
    @Published var axis: Axis = .vertical
    let verticalDepth: Int
    let horizontalDepth: Int
    
    static let maxVerticalDepth = 3
    static let maxHorizontalDepth = 2
    
    // Color palette for the color picker
    static let colorOptions: [Color] = [
            Color(red: 0.0, green: 0.478, blue: 1.0),      // Blue
            Color(red: 1.0, green: 0.231, blue: 0.188),    // Red
            Color(red: 0.204, green: 0.780, blue: 0.349),  // Green
            Color(red: 1.0, green: 0.8, blue: 0.0),        // Yellow (explicit, won't change)
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
        
        // Encode axis as a simple string
        let axisString = axis == .horizontal ? "horizontal" : "vertical"
        try container.encode(axisString, forKey: .axis)
        
        try container.encode(verticalDepth, forKey: .verticalDepth)
        try container.encode(horizontalDepth, forKey: .horizontalDepth)
        
        // Encode color as hex string
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
        children = try container.decode([SplitNode].self, forKey: .children)
        verticalDepth = try container.decode(Int.self, forKey: .verticalDepth)
        horizontalDepth = try container.decode(Int.self, forKey: .horizontalDepth)
        
        // Decode axis from string
        let axisString = try container.decode(String.self, forKey: .axis)
        axis = axisString == "horizontal" ? .horizontal : .vertical
        
        // Decode color from hex string
        if let hexString = try container.decodeIfPresent(String.self, forKey: .colorData) {
            color = Color(hex: hexString)
        }
    }
}

// MARK: - Color Extension for Hex

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Components

enum SplitDirection {
    case horizontal, vertical
}

struct SplitView: View {
    @ObservedObject var node: SplitNode
    var onDelete: (() -> Void)? = nil
    var showDebug: Bool = false
    @State private var showingMenu = false
    @State private var showingColorPicker = false
    @State private var selectedColor: Color = .blue
    
    let colors: [Color] = SplitNode.colorOptions
    
    var body: some View {
        if node.isLeaf, let color = node.color {
            RoundedRectangle(cornerRadius: 8)
                .fill(color)
                .contentShape(Rectangle())
                .overlay(alignment: .topLeading) {
                    if showDebug {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("V:\(node.verticalDepth)/\(SplitNode.maxVerticalDepth)")
                                .font(.caption2)
                            Text("H:\(node.horizontalDepth)/\(SplitNode.maxHorizontalDepth)")
                                .font(.caption2)
                            
                            Divider()
                                .background(Color.white.opacity(0.5))
                            
                            // Color information
                            Text(getColorName(color))
                                .font(.caption2)
                                .fontWeight(.bold)
                            
                            Text(getColorHex(color))
                                .font(.system(size: 10, design: .monospaced))
                            
                            // RGB values
                            let rgb = getRGBValues(color)
                            Text("R: \(rgb.r)")
                                .font(.system(size: 9))
                            Text("G: \(rgb.g)")
                                .font(.system(size: 9))
                            Text("B: \(rgb.b)")
                                .font(.system(size: 9))
                        }
                        .foregroundColor(.white)
                        .padding(6)
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(4)
                        .padding(4)
                    }
                }
                .onTapGesture {
                    selectedColor = color
                    showingMenu = true
                }
                .confirmationDialog(
                    node.canSplitAtAll ? "Modify Area" : "Modify Area (Max Depth)",
                    isPresented: $showingMenu,
                    titleVisibility: .visible
                ) {
                    if node.canSplit(.horizontal) {
                        Button("Split Horizontally ←→") {
                            splitArea(.horizontal)
                        }
                    }
                    
                    if node.canSplit(.vertical) {
                        Button("Split Vertically ↑↓") {
                            splitArea(.vertical)
                        }
                    }
                    
                    Button("Change Color 🎨") {
                        showingColorPicker = true
                    }
                    
                    if onDelete != nil {
                        Button("Delete", role: .destructive) {
                            onDelete?()
                        }
                    }
                    
                    Button("Cancel", role: .cancel) { }
                } message: {
                    let vRemaining = SplitNode.maxVerticalDepth - node.verticalDepth
                    let hRemaining = SplitNode.maxHorizontalDepth - node.horizontalDepth
                    
                    if !node.canSplitAtAll {
                        Text("Maximum depth reached in both directions")
                    } else if !node.canSplit(.vertical) {
                        Text("Can only split horizontally (\(hRemaining) remaining)")
                    } else if !node.canSplit(.horizontal) {
                        Text("Can only split vertically (\(vRemaining) remaining)")
                    } else {
                        Text("V: \(vRemaining) remaining | H: \(hRemaining) remaining")
                    }
                }
                .sheet(isPresented: $showingColorPicker) {
                    ColorPickerView(selectedColor: $selectedColor, node: node)
                }
        } else {
            let layout = node.axis == .vertical ?
                AnyLayout(VStackLayout(spacing: 8)) :
                AnyLayout(HStackLayout(spacing: 8))
            
            layout {
                ForEach(node.children) { child in
                    SplitView(
                        node: child,
                        onDelete: {
                            node.removeChild(withId: child.id)
                        },
                        showDebug: showDebug
                    )
                }
            }
        }
    }
    
    func splitArea(_ direction: SplitDirection) {
        guard node.canSplit(direction) else {
            return
        }
        
        let newColor = colors.randomElement() ?? .gray
        let newVerticalDepth = direction == .vertical ? node.verticalDepth + 1 : node.verticalDepth
        let newHorizontalDepth = direction == .horizontal ? node.horizontalDepth + 1 : node.horizontalDepth
        
        let currentColor = node.color
        node.color = nil
        node.axis = direction == .horizontal ? .horizontal : .vertical
        
        node.children = [
            SplitNode(color: currentColor ?? .blue, verticalDepth: newVerticalDepth, horizontalDepth: newHorizontalDepth),
            SplitNode(color: newColor, verticalDepth: newVerticalDepth, horizontalDepth: newHorizontalDepth)
        ]
    }
    
    // Helper functions for color information
    func getColorName(_ color: Color) -> String {
        // Since we're using custom colors now, we need to match by RGB values
        let rgb = getRGBValues(color)
        
        switch (rgb.r, rgb.g, rgb.b) {
            case (0, 122, 255): return "Blue"
            case (255, 59, 48): return "Red"
            case (52, 199, 89): return "Green"
            case (255, 204, 0): return "Yellow"  // This will now be consistent
            case (175, 82, 222): return "Purple"
            case (255, 149, 0): return "Orange"
            case (255, 45, 85): return "Pink"
            case (50, 215, 230): return "Cyan"
            case (0, 199, 190): return "Mint"
            case (88, 86, 214): return "Indigo"
            case (162, 132, 94): return "Brown"
            case (142, 142, 147): return "Gray"
            case (48, 176, 199): return "Teal"
            case (0, 0, 0): return "Black"
            default: return "Color"
        }
    }
    
    func getColorHex(_ color: Color) -> String {
        let uiColor = UIColor(color)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return String(format: "#%02X%02X%02X",
                     Int(red * 255),
                     Int(green * 255),
                     Int(blue * 255))
    }
    
    func getRGBValues(_ color: Color) -> (r: Int, g: Int, b: Int) {
        let uiColor = UIColor(color)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (
            r: Int(red * 255),
            g: Int(green * 255),
            b: Int(blue * 255)
        )
    }
}

// MARK: - Color Picker View

struct ColorPickerView: View {
    @Binding var selectedColor: Color
    @ObservedObject var node: SplitNode
    @Environment(\.dismiss) var dismiss
    
    let columns = [
        GridItem(.adaptive(minimum: 60))
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(SplitNode.colorOptions, id: \.self) { color in
                        RoundedRectangle(cornerRadius: 10)
                            .fill(color)
                            .frame(height: 60)
                            .overlay(
                                // Checkmark for current color
                                Group {
                                    if node.color == color {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.title2)
                                            .foregroundColor(.white)
                                            .background(
                                                Circle()
                                                    .fill(Color.black.opacity(0.6))
                                                    .padding(4)
                                            )
                                    }
                                }
                            )
                            .scaleEffect(selectedColor == color ? 1.1 : 1.0)
                            .animation(.easeInOut(duration: 0.1), value: selectedColor == color)
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.1)) {
                                    selectedColor = color
                                    node.color = color
                                }
                            }
                    }
                }
                .padding()
            }
            .navigationTitle("Choose Color")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            // Set selectedColor to the node's current color when the view appears
            selectedColor = node.color ?? .blue
        }
    }
}

// MARK: - Main View

struct ContentView: View {
    @StateObject private var rootNode = SplitNode(
        color: SplitNode.defaultColor,
        verticalDepth: 0,
        horizontalDepth: 0
    )
    @State private var showDebug = false
    @State private var showingExportSheet = false
    @State private var showingImportSheet = false
    @State private var exportedJSON = ""
    @State private var importJSON = ""
    @State private var showingImportAlert = false
    var padding: CGFloat = 8

    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Tap any colored area to modify")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("Max splits - V: \(SplitNode.maxVerticalDepth) | H: \(SplitNode.maxHorizontalDepth)")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }
                
                Spacer()
                
                // Export button
                Button(action: exportLayout) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.caption)
                }
                .buttonStyle(.bordered)
                .help("Export layout")
                
                // Import button
                Button(action: { showingImportSheet = true }) {
                    Image(systemName: "square.and.arrow.down")
                        .font(.caption)
                }
                .buttonStyle(.bordered)
                .help("Import layout")
                
                // Debug toggle
                Button(action: { showDebug.toggle() }) {
                    Image(systemName: showDebug ? "eye.fill" : "eye.slash.fill")
                        .font(.caption)
                }
                .buttonStyle(.bordered)
                .help("Toggle debug overlay")
                
                // Reset button
                Button("Reset") {
                    rootNode.color = SplitNode.defaultColor
                    rootNode.children = []
                }
                .font(.caption)
                .buttonStyle(.bordered)
            }
            .padding(.horizontal)
            .padding(.top)
            
            SplitView(node: rootNode, showDebug: showDebug)
                .padding(padding)
        }
        .sheet(isPresented: $showingExportSheet) {
            // Generate JSON when sheet is presented
            ExportView(jsonString: generateJSON())
        }
        .sheet(isPresented: $showingImportSheet) {
            ImportView(jsonString: $importJSON, onImport: importLayout)
        }
        .alert("Import Error", isPresented: $showingImportAlert) {
            Button("OK") { }
        } message: {
            Text("Failed to import layout. Please check the JSON format.")
        }
    }
    
    func generateJSON() -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        if let data = try? encoder.encode(rootNode),
           let jsonString = String(data: data, encoding: .utf8) {
            return jsonString
        }
        return "{}"
    }
    
    func exportLayout() {
        // Just show the sheet - JSON will be generated when sheet appears
        showingExportSheet = true
    }
    
    func importLayout() {
        let decoder = JSONDecoder()
        guard let data = importJSON.data(using: .utf8),
              let newNode = try? decoder.decode(SplitNode.self, from: data) else {
            showingImportAlert = true
            return
        }
        
        rootNode.children = newNode.children
        rootNode.color = newNode.color
        rootNode.axis = newNode.axis
        showingImportSheet = false
    }
}

// MARK: - Export/Import Views

struct ExportView: View {
    let jsonString: String
    @Environment(\.dismiss) var dismiss
    @State private var copied = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                Text(jsonString)
                    .font(.system(.caption, design: .monospaced))
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .padding()
                    .textSelection(.enabled)
            }
            .navigationTitle("Export Layout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(copied ? "Copied!" : "Copy") {
                        UIPasteboard.general.string = jsonString
                        copied = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            copied = false
                        }
                    }
                }
            }
        }
    }
}

struct ImportView: View {
    @Binding var jsonString: String
    let onImport: () -> Void
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Paste your JSON layout below:")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.top)
                
                TextEditor(text: $jsonString)
                    .font(.system(.caption, design: .monospaced))
                    .padding(4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .padding()
                
                Spacer()
            }
            .navigationTitle("Import Layout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Import") {
                        onImport()
                    }
                    .disabled(jsonString.isEmpty)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
