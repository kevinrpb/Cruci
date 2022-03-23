//
//  ContentView.swift
//  Cruci
//
//  Created by Kevin Romero Peces-Barba on 23/3/22.
//

import SwiftUI
import PencilKit

enum Tool {
    case ink, eraser
}

struct ContentView: View {
    @Environment(\.undoManager) var undoManager

    @State var listItemDrawing: Data? = nil
    @State var drawingData: Data? = nil

    @State var tool: Tool = .ink

    var body: some View {
        NavigationView {
            List {
                Section {
                    ZStack {
                        Text("1. This is some long text that could simulate a clue (4)")
                        PKCanvas(data: $listItemDrawing, tool: $tool)
                    }
                } header: {
                    Text("Across")
                }
            }
            .navigationTitle("Clues")
            .navigationBarTitleDisplayMode(.inline)

            ZStack {
                PKCanvas(data: $drawingData, tool: $tool)
            }
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    UndoButton()
                    RedoButton()
                }
                ToolbarItemGroup(placement: .status) {
                    SelectInkToolButton()
                    SelectEraserToolButton()
                }
            }
            .navigationTitle("Drawing")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
        }
    }

    private func SelectInkToolButton() -> some View {
        Button {
            tool = .ink
        } label: {
            Label("Ink", systemImage: "pencil")
                .padding(4)
                .background(
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .fill(tool == .ink ? .blue.opacity(0.2) : .clear)
                )
        }
    }

    private func SelectEraserToolButton() -> some View {
        Button {
            tool = .eraser
        } label: {
            Label("Eraser", systemImage: "square.dashed")
                .padding(4)
                .background(
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .fill(tool == .eraser ? .blue.opacity(0.2) : .clear)
                )
        }
    }

    private func UndoButton() -> some View {
        Button {
            undoManager?.undo()
        } label: {
            Label("Undo", systemImage: "arrow.uturn.backward")
        }
//        .disabled(!(undoManager?.canUndo ?? false))
    }

    private func RedoButton() -> some View {
        Button {
            undoManager?.redo()
        } label: {
            Label("Undo", systemImage: "arrow.uturn.forward")
        }
//        .disabled(!(undoManager?.canRedo ?? false))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
