//
//  ContentView.swift
//  Bento Layout
//
//  A study in SwiftUI compositional layouts using alternating stack directions
//

import SwiftUI

// MARK: - Extensions

/// Extends Axis to provide a convenient way to alternate between horizontal and vertical
extension Axis {
    /// Returns the opposite axis - if horizontal returns vertical, if vertical returns horizontal
    var other: Self {
        self == .horizontal ? .vertical : .horizontal
    }
}

/// Custom environment value to track the current layout direction
/// This allows child views to know their parent's layout direction
extension EnvironmentValues {
    @Entry var direction: Axis = .vertical
}

// MARK: - Components

/// A composable container that alternates between HStack and VStack based on nesting depth
/// Each Split automatically uses the opposite direction of its parent Split
struct Split<Content: View>: View {
    /// Reads the current direction from the environment (set by parent Split)
    @Environment(\.direction) var axis
    
    /// The child views to layout
    @ViewBuilder var content: Content
    
    /// Space between child views
    var spacing: CGFloat = 8
    
    var body: some View {
        // Choose layout based on current axis
        // AnyLayout allows us to switch between layouts dynamically
        let layout = axis == .vertical ?
            AnyLayout(VStackLayout(spacing: spacing)) :
            AnyLayout(HStackLayout(spacing: spacing))
        
        layout {
            content
        }
        // CRITICAL: Pass the opposite direction to children
        // This creates the alternating horizontal/vertical pattern
        .environment(\.direction, axis.other)
    }
}

/// A simple rounded rectangle tile for visual content
struct Tile: View {
    let color: Color
    var cornerRadius: CGFloat = 8
    
    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(color)
    }
}

// MARK: - Main View

struct ContentView: View {
    var padding: CGFloat = 8

    var body: some View {
        // The layout tree structure directly maps to the visual layout:
        //
        // Split (vertical - root level)
        // ├── Split (horizontal - auto alternates)
        // │   ├── Split (vertical - auto alternates)
        // │   │   ├── Tile(.blue)
        // │   │   └── Tile(.yellow)
        // │   └── Tile(.red)
        // ├── Tile(.green)
        // └── Tile(.purple)
        //
        // Visual result:
        // ┌─────────────────┐
        // │ ┌────┬────┐     │
        // │ │Blue│Red │     │
        // │ ├────┤    │     │
        // │ │Yel │    │     │
        // │ └────┴────┘     │
        // │    Green        │
        // │    Purple       │
        // └─────────────────┘
        
        Split {                    // Vertical (default)
            Split {                // Horizontal (alternates)
                Split {            // Vertical (alternates again)
                    Tile(color: .blue)
                    Tile(color: .yellow)
                }
                Tile(color: .red)
            }
            Tile(color: .green)
            Tile(color: .purple)
        }
        .padding(padding)
    }
}

#Preview {
    ContentView()
}
