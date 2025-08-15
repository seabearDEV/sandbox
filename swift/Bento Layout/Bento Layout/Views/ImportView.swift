//
//  ImportView.swift
//  Bento Layout
//
//  View for importing layout from JSON
//

import SwiftUI

struct ImportView: View {
    @Binding var jsonString: String
    let onImport: () -> Void
    @Environment(\.dismiss) private var dismiss
    
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