//
//  Crossword.swift
//  Cruci
//
//  Created by Kevin Romero Peces-Barba on 23/3/22.
//

import Foundation

struct Crossword: Codable {
    struct Meta: Codable {
        enum CodingKeys: String, CodingKey {
            case title = "Title"
            case author = "Author"
            case editor = "Editor"
            case copyright = "Copyright"
            case number = "Number"
            case date = "Date"
        }

        let title: String?
        let author: String?
        let editor: String?
        let copyright: String?
        let number: String?
        let date: String?
    }

    struct Entry: Codable {
        let num: String
        let question: String
        let answer: String

        var actualNum: Int {
            Int(String(num.dropFirst()))!
        }
    }

    let meta: Meta
    let grid: [[String]]
    let across: [Entry]
    let down: [Entry]

    var numbersGrid: [[String]] {
        let nRows = grid.count
        let nColumns = grid[0].count

        var baseGrid: [[String]] = .init(
            repeating: .init(repeating: "", count: nColumns),
            count: nRows
        )

        // Stolen (kinda) from https://github.com/devottys/xdplayer/blob/aeba136ea44b262b250019700166db62fbe1b801/xdplayer/__init__.py#L235
        var clueNumber = 1
        for rowIndex in 0..<nRows {
            for columnIndex in 0..<nColumns {
                // Skip blacked out cells
                if cell(rowIndex: rowIndex, columnIndex: columnIndex) == "#" { continue }

                var isNewClue = false

                // New Across clue
                if cell(rowIndex: rowIndex, columnIndex: columnIndex - 1) == "#" {
                    // Get the appropriate entry
                    if let _ = across.first(where: { $0.actualNum == clueNumber }) {
                        baseGrid[rowIndex][columnIndex] = "\(clueNumber)"
                        isNewClue = true
                    }
                }
                // New Down clue
                if cell(rowIndex: rowIndex - 1, columnIndex: columnIndex) == "#" {
                    // Get the appropriate entry
                    if let _ = down.first(where: { $0.actualNum == clueNumber }) {
                        baseGrid[rowIndex][columnIndex] = "\(clueNumber)"
                        isNewClue = true
                    }
                }

                if isNewClue {
                    clueNumber += 1
                }
            }
        }

        return baseGrid
    }

    private func cell(rowIndex: Int, columnIndex: Int) -> String {
        if rowIndex < 0 || columnIndex < 0 || rowIndex >= grid.count || columnIndex >= grid[0].count {
            return "#"
        }

        return grid[rowIndex][columnIndex]
    }
}

extension Crossword {
    static let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()

        return decoder
    }()

    static func loadFromFile(named name: String) -> Crossword? {
        guard let url = Bundle.main.url(forResource: name, withExtension: "json"),
              let content =  try? String(contentsOf: url),
              let data = content.data(using: .utf8) else { return nil }

        do {
            let crossword = try jsonDecoder.decode(Crossword.self, from: data)

            return crossword
        } catch {
            print(error.localizedDescription)
        }

        return nil
    }
}
