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
    private let padding: CGFloat = 8

    var body: some View {
        VStack {
            headerView
            
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
    }
    
    private var headerView: some View {
        HStack {
            Spacer()
            headerButtons
        }
        .padding([.horizontal, .top])
    }
    
    private var headerButtons: some View {
        HStack(spacing: 8) {
            Button(action: { showingExportSheet = true }) {
                Image(systemName: "square.and.arrow.up")
                    .font(.caption)
            }
            .buttonStyle(.bordered)
            .help("Export layout")
            
            Button(action: { showingImportSheet = true }) {
                Image(systemName: "square.and.arrow.down")
                    .font(.caption)
            }
            .buttonStyle(.bordered)
            .help("Import layout")
            
            Button(action: { showDebug.toggle() }) {
                Image(systemName: showDebug ? "eye.fill" : "eye.slash.fill")
                    .font(.caption)
            }
            .buttonStyle(.bordered)
            .help("Toggle debug overlay")
            
            Button("Reset") {
                rootNode.color = SplitNode.defaultColor
                rootNode.children = []
            }
            .font(.caption)
            .buttonStyle(.bordered)
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
