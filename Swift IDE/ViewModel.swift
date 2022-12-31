//
//  ViewModel.swift
//  Swift IDE
//
//  Created by Murad Talibov on 10.12.22.
//

import SwiftUI
import RichTextKit
import Combine

class ViewModel: ObservableObject {
    struct Constants {
        static let ignoredOutputs: [CompilerOutput] = [
            .init(containing: "Too many levels of symbolic links")
        ]
    }
    
    @Published var text = NSAttributedString("")
    @Published var output: [String] = []
    
    @ObservedObject var context = RichTextContext()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $text
            .receive(on: RunLoop.main)
            .sink(receiveValue: { _ in
                self.colorKeywords()
            })
            .store(in: &cancellables)
    }
    
    func compile() {
        print("Code: \(text.string)")
        DispatchQueue.global(qos: .userInitiated).async {
            let output = SwiftCompiler.compile(code: self.text.string)
            
            DispatchQueue.main.async {
                self.output = output
            }
        }
    }
    
    private func colorKeywords() {
        let matches = text.string.matches(of: try! Regex("\\bpublic\\b"))
        
        for match in matches {
            colorRange(match.range)
        }
    }
    
    private func colorRange(_ range: Range<String.Index>) {
        let range = NSRange(range, in: text.string)
        
        let cursorState = context.selectedRange
        context.selectRange(range)
        context.foregroundColor = .red
        context.isBold = true
        context.selectRange(cursorState)
        context.foregroundColor = .black
        context.isBold = false
    }
}
