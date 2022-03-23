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
            case copyright = "Copyright"
            case number = "Number"
            case date = "Date"
        }

        let copyright: String?
        let number: String?
        let date: String?
    }

    struct Entry: Codable {
        let num: String
        let question: String
        let answer: String
    }

    let meta: Meta
    let grid: [[String]]
    let across: [Entry]
    let down: [Entry]
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
