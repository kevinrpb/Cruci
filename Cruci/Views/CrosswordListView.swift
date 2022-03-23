//
//  CrosswordListView.swift
//  Cruci
//
//  Created by Kevin Romero Peces-Barba on 23/3/22.
//

import SwiftUI

struct CrosswordListView: View {
    @Environment(\.dismiss) var dismiss

    private let files = CrosswordFile.all

    let onSelect: ((CrosswordFile) -> Void)?

    var body: some View {
        List(files, id: \.filename) { file in
            Button(action: { select(file) }) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(file.meta.title ?? file.filename)
                        Text(file.meta.author ?? "--")
                            .font(.caption)
                    }
                    .foregroundColor(.black)
                    Spacer()
                }
            }
        }
        .navigationTitle("Crosswords")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Close") {
                    dismiss()
                }
            }
        }
    }

    private func select(_ file: CrosswordFile) {
        onSelect?(file)
        dismiss()
    }
}
