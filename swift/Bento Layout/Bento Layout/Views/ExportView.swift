//
//  ExportView.swift
//  Bento Layout
//
//  View for exporting layout as JSON
//

import SwiftUI

struct ExportView: View {
    let jsonString: String
    @Environment(\.dismiss) private var dismiss
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