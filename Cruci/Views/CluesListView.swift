//
//  CluesListView.swift
//  Cruci
//
//  Created by Kevin Romero Peces-Barba on 23/3/22.
//

import SwiftUI

extension Crossword.Entry {
    var regularLabel: String {
        "\(num). \(question)"
    }

    var attributedLabel: AttributedString? {
        try? AttributedString(markdown: "**\(num)**. \(question)")
    }
}

struct CluesListView: View {
    @Binding var crossword: Crossword?

    @Binding var acrossListDrawingData: Data?
    @Binding var downListDrawingData: Data?
    @Binding var tool: Tool

    var body: some View {
        List {
            if let crossword = crossword {
                Section {
                    ListElements(crossword.across)
                        .listRowInsets(.init())
                        .overlay(
                            PKCanvas(data: $acrossListDrawingData, tool: $tool)
                        )
                } header: { Text("Across") }

                Section {
                    ListElements(crossword.down)
                        .listRowInsets(.init())
                        .overlay(
                            PKCanvas(data: $downListDrawingData, tool: $tool)
                        )
                } header: { Text("Down") }
            } else {
                Text("Load a crossword")
            }
        }
    }

    private func ListElements(_ entries: [Crossword.Entry]) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(entries, id: \.num) { entry in
                HStack {
                    if let label = entry.attributedLabel {
                        Text(label)
                    } else {
                        Text(entry.regularLabel)
                    }
                }
                .listRowInsets(.init())
                .padding(.vertical, 6)
            }
        }
        .listRowInsets(.init())
    }
}
