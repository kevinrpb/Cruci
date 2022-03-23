//
//  CrosswordEntity.swift
//  Cruci
//
//  Created by Kevin Romero Peces-Barba on 23/3/22.
//

import Foundation

struct CrosswordEntity {
    let id: UUID

    let fileData: CrosswordFile

    var acrossListDrawingData: Data? = nil
    var downListDrawingData: Data? = nil
    var crosswordDrawingData: Data? = nil
}
