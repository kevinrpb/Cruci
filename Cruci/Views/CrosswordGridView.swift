//
//  CrosswordGridView.swift
//  Cruci
//
//  Created by Kevin Romero Peces-Barba on 23/3/22.
//

import SwiftUI

struct CrosswordGridView: View {
    let crossword: Crossword

    @Binding var showAnswer: Bool

    // 30 is just "safe"
    @State private var cellSize: Double = 30

    var body: some View {
        GeometryReader { proxy in
            VStack {
                Spacer()
                LazyVGrid(
                    columns: .init(repeating: .init(.fixed(cellSize), spacing: .zero, alignment: .center), count: crossword.grid.count),
                    alignment: .center,
                    spacing: .zero
                ) {
                    ForEach(0..<crossword.grid.count) { rowIndex in
                        ForEach(0..<crossword.grid[rowIndex].count) { columnIndex in
                            LetterCell(
                                letter: crossword.grid[rowIndex][columnIndex],
                                number: crossword.numbersGrid![rowIndex][columnIndex]
                            )
                                .tag("\(rowIndex)_\(columnIndex)")
                        }
                    }
                }
                Spacer()
            }
            .onAppear {
                // Height / nRows
                let maxVerticalCellSize = proxy.size.height / CGFloat(crossword.grid.count)
                // Width / nColumns
                let maxHorizontalCellSize = proxy.size.width / CGFloat(crossword.grid[0].count)

                cellSize = min(maxVerticalCellSize, maxHorizontalCellSize)
            }
        }
    }

    private func LetterCell(letter: String, number: String) -> some View {
        Rectangle()
            .stroke(.black)
            .frame(width: cellSize, height: cellSize, alignment: .center)
            .background(letter == "#" ? .black : .clear)
            .overlay(
                HStack {
                    VStack {
                        Text(number)
                            .font(.caption)
                            .padding(2)
                        Spacer()
                    }
                    Spacer()
                    VStack {
                        Spacer()
                        Text(letter)
                            .opacity(showAnswer ? 1 : 0)
                            .font(.caption)
                            .padding(2)
                    }
                }
            )
    }
}
