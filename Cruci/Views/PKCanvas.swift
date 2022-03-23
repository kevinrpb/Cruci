//
//  PKCanvas.swift
//  Cruci
//
//  Created by Kevin Romero Peces-Barba on 23/3/22.
//

import SwiftUI
import PencilKit

struct PKCanvas: UIViewRepresentable {
    @Binding var data: Data?
    @Binding var tool: Tool

    private var canvasView: PKCanvasView

    private let inkingTool: PKInkingTool = .init(.pen, color: .blue, width: 15)
    private let eraserTool: PKEraserTool = .init(.vector)

    public init(data: Binding<Data?>, tool: Binding<Tool>) {
        self._data = data
        self._tool = tool

        canvasView = .init()
    }

    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.tool = tool == .ink ? inkingTool : eraserTool
        canvasView.isOpaque = false
        canvasView.isScrollEnabled = false
        canvasView.drawingPolicy = .pencilOnly

        canvasView.becomeFirstResponder()
        canvasView.delegate = context.coordinator

        if let data = data, let drawing = try? PKDrawing(data: data) {
            canvasView.drawing = drawing
        }

        return canvasView
    }

    func updateUIView(_ canvasView: PKCanvasView, context: Context) {
        canvasView.tool = self.tool == .ink ? inkingTool : eraserTool
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PKCanvasViewDelegate {
        var canvas: PKCanvas

        init(_ canvas: PKCanvas) {
            self.canvas = canvas
        }

        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            canvas.data = canvasView.drawing.dataRepresentation()
        }
    }
}
