//
//  ContentView.swift
//  Cruci
//
//  Created by Kevin Romero Peces-Barba on 23/3/22.
//

import SwiftUI
import PencilKit
import Introspect

enum Tool {
    case ink, eraser
}

struct ContentView: View {
    @Environment(\.undoManager) var undoManager

    @State var showSelectionSheet: Bool = false
    @State var showAnswerConfirmationAlert: Bool = false

    @State var showAnswers: Bool = false

    @State var selectedFile: CrosswordFile? = nil
    @State var crossword: Crossword? = nil

    @State var acrossListDrawingData: Data? = nil
    @State var downListDrawingData: Data? = nil
    @State var crosswordDrawingData: Data? = nil

    @State var tool: Tool = .ink

    var body: some View {
        NavigationView {
            CluesListView(crossword: $crossword, acrossListDrawingData: $acrossListDrawingData, downListDrawingData: $downListDrawingData, tool: $tool)
                .navigationTitle("Clues")
                .navigationBarTitleDisplayMode(.inline)
                // This toolbar needs to go here since this list is the one attached to the primary Navigation VC
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        ShowCrosswordListButton()
                    }
                }

            ZStack {
                if let crossword = crossword {
                    CrosswordGridView(crossword: crossword, showAnswer: $showAnswers)
                        .padding()
                    PKCanvas(data: $crosswordDrawingData, tool: $tool)
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    UndoButton()
                    RedoButton()
                    Spacer()
                    ShowAnswersButton()
                    Spacer()
                    SelectInkToolButton()
                    SelectEraserToolButton()
                }
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(.columns)
        .introspectSplitViewController { splitVC in
            splitVC.preferredDisplayMode = .oneBesideSecondary
            splitVC.presentsWithGesture = false
            splitVC.preferredSplitBehavior = .tile
        }
        .onAppear {
            if selectedFile == nil {
                showSelectionSheet = true
            }
        }
        .onChange(of: selectedFile, perform: { newFile in
            if let newFile = newFile {
                crossword = newFile.loadCrossword()
                print("Selected file \(newFile.filename)")
            }
        })
        .sheet(isPresented: $showSelectionSheet) {
            NavigationView {
                CrosswordListView { file in
                    selectedFile = file
                }
            }
        }
        .alert("Show answer", isPresented: $showAnswerConfirmationAlert) {
            Button("Cancel", role: .cancel) {
                showAnswerConfirmationAlert = false
            }
            Button("Confirm") {
                showAnswerConfirmationAlert = false

                withAnimation {
                    showAnswers = true
                }
            }
        } message: {
            Text("Are you sure you want to show the answers?")
        }
    }

    private func ShowCrosswordListButton() -> some View {
        Button {
            showSelectionSheet = true
        } label: {
            Label("Crosswords", systemImage: "list.dash")
                .padding(4)
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
                        .fill(tool == .ink ? Color.accentColor.opacity(0.2) : .clear)
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
                        .fill(tool == .eraser ? Color.accentColor.opacity(0.2) : .clear)
                )
        }
    }

    private func ShowAnswersButton() -> some View {
        Button {
            if showAnswers {
                withAnimation {
                    showAnswers = false
                }
            } else {
                showAnswerConfirmationAlert = true
            }
        } label: {
            Label("Answers", systemImage: showAnswers ? "lightbulb" : "lightbulb.fill")
                .padding(4)
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
