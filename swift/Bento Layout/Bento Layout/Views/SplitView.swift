//
//  SplitView.swift
//  Bento Layout
//
//  Composable container view that handles splitting and layout
//

import SwiftUI

struct SplitView: View {
    @ObservedObject var node: SplitNode
    let onDelete: (() -> Void)?
    let showDebug: Bool
    @State private var showingMenu = false
    @State private var showingColorPicker = false
    @State private var selectedColor: Color = .blue
    
    init(node: SplitNode, onDelete: (() -> Void)? = nil, showDebug: Bool = false) {
        self.node = node
        self.onDelete = onDelete
        self.showDebug = showDebug
    }
    
    var body: some View {
        if node.isLeaf, let color = node.color {
            RoundedRectangle(cornerRadius: 8)
                .fill(color)
                .contentShape(Rectangle())
                .overlay(alignment: .topLeading) {
                    if showDebug {
                        debugOverlay(for: color)
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
                    splitButtons()
                    
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
                    depthMessage()
                }
                .sheet(isPresented: $showingColorPicker) {
                    ColorPickerView(selectedColor: $selectedColor, node: node)
                }
        } else {
            containerView()
        }
    }
    
    @ViewBuilder
    private func debugOverlay(for color: Color) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("V:\(node.verticalDepth)/\(SplitNode.maxVerticalDepth)")
                .font(.caption2)
            Text("H:\(node.horizontalDepth)/\(SplitNode.maxHorizontalDepth)")
                .font(.caption2)
            
            Divider()
                .background(Color.white.opacity(0.5))
            
            Text(ColorHelper.getColorName(color))
                .font(.caption2)
                .fontWeight(.bold)
            
            Text(ColorHelper.getColorHex(color))
                .font(.system(size: 10, design: .monospaced))
            
            let rgb = ColorHelper.getRGBValues(color)
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
    
    @ViewBuilder
    private func splitButtons() -> some View {
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
    }
    
    @ViewBuilder
    private func depthMessage() -> some View {
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
    
    @ViewBuilder
    private func containerView() -> some View {
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
    
    private func splitArea(_ direction: SplitDirection) {
        guard node.canSplit(direction) else { return }
        
        let newColor = SplitNode.colorOptions.randomElement() ?? .gray
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
}