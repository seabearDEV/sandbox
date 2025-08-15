//
//  ContentView.swift
//  Bento Layout
//
//  Main view coordinating the bento layout interface
//

import SwiftUI

struct ContentView: View {
    @StateObject private var rootNode = SplitNode(color: SplitNode.defaultColor)
    @State private var showDebug = false
    @State private var showingExportSheet = false
    @State private var showingImportSheet = false
    @State private var importJSON = ""
    @State private var showingImportAlert = false
    @State private var showingResetConfirmation = false
    @State private var showingDebugInfo = false
    private let padding: CGFloat = 8

    var body: some View {
        VStack(spacing: 0) {
            // Header bar
            HStack {
                // Title section
                VStack(alignment: .leading, spacing: 2) {
                    Text("Bento Layout")
                        .font(.headline)
                    Text("Tap any area to split or customize")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                // Action buttons
                HStack(spacing: 12) {
                    // Import/Export menu
                    Menu {
                        Button(action: { showingImportSheet = true }) {
                            Label("Import Layout", systemImage: "square.and.arrow.down")
                        }
                        Button(action: { showingExportSheet = true }) {
                            Label("Export Layout", systemImage: "square.and.arrow.up")
                        }
                    } label: {
                        Label("File", systemImage: "folder")
                            .labelStyle(.iconOnly)
                    }
                    .buttonStyle(.bordered)
                    
                    // View controls
                    Button(action: { 
                        showDebug.toggle()
                        if showDebug {
                            showingDebugInfo = true
                        }
                    }) {
                        Image(systemName: showDebug ? "eye.slash" : "eye")
                    }
                    .buttonStyle(.bordered)
                    
                    Button(action: { 
                        showingResetConfirmation = true
                    }) {
                        Image(systemName: "arrow.counterclockwise")
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                }
                .controlSize(.small)
            }
            .padding()
            .background(Color(uiColor: .systemBackground))
            .overlay(alignment: .bottom) {
                Divider()
            }
            
            // Main content
            SplitView(node: rootNode, showDebug: showDebug)
                .padding(padding)
        }
        .sheet(isPresented: $showingExportSheet) {
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
        .confirmationDialog("Reset Layout?", isPresented: $showingResetConfirmation, titleVisibility: .visible) {
            Button("Reset", role: .destructive) {
                rootNode.color = SplitNode.defaultColor
                rootNode.children = []
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This will clear your entire layout and start over. This action cannot be undone.")
        }
        .alert("Debug Information", isPresented: $showingDebugInfo) {
            Button("Got it!") { }
        } message: {
            Text("Debug mode shows detailed information about each area including:\n\n• Vertical and horizontal split depths\n• Color names and hex values\n• RGB color values\n\nThis helps you understand the layout structure and constraints.")
        }
    }
    
    private func generateJSON() -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        if let data = try? encoder.encode(rootNode),
           let jsonString = String(data: data, encoding: .utf8) {
            return jsonString
        }
        return "{}"
    }
    
    private func importLayout() {
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
        importJSON = ""
    }
}

#Preview {
    ContentView()
}
