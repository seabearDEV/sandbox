//
//  ColorPickerView.swift
//  Bento Layout
//
//  Color selection interface for customizing area colors
//

import SwiftUI

struct ColorPickerView: View {
    @Binding var selectedColor: Color
    @ObservedObject var node: SplitNode
    @Environment(\.dismiss) private var dismiss
    
    private let columns = [GridItem(.adaptive(minimum: 60))]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(SplitNode.colorOptions, id: \.self) { color in
                        ColorCell(
                            color: color,
                            isSelected: node.color == color,
                            isHighlighted: selectedColor == color
                        ) {
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
            selectedColor = node.color ?? .blue
        }
    }
}

private struct ColorCell: View {
    let color: Color
    let isSelected: Bool
    let isHighlighted: Bool
    let action: () -> Void
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(color)
            .frame(height: 60)
            .overlay(
                isSelected ? 
                Image(systemName: "checkmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(.white)
                    .background(
                        Circle()
                            .fill(Color.black.opacity(0.6))
                            .padding(4)
                    ) : nil
            )
            .scaleEffect(isHighlighted ? 1.1 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isHighlighted)
            .onTapGesture(perform: action)
    }
}