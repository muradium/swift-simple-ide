//
//  AttributedTextViewModel.swift
//  Swift IDE
//
//  Created by Murad Talibov on 12.12.22.
//

import SwiftUI

class SyntaxHighlighter {
    static func highlightKeywords(text: NSMutableAttributedString) {
        let keywords = ["public", "static", "var", "let", "var", "int", "override", "string", "func", "private", "for", "in", "print"]
        
        resetStyle(text: text)
        
        for keyword in keywords {
            let matches = text.string.matches(of: try! Regex("\\b\(keyword)\\b"))
            
            for match in matches {
                colorRange(match.range, text: text)
            }
        }
    }
    
    private static func resetStyle(text: NSMutableAttributedString) {
        let defaults: [NSAttributedString.Key : Any] = [
            .font: NSFont(name: "Helvetica Neue", size: 15)!,
            .foregroundColor: NSColor.controlTextColor
        ]
        text.setAttributes(defaults, range: NSRange(location: 0, length: text.string.count))
    }
    
    private static func colorRange(_ range: Range<String.Index>, text: NSMutableAttributedString) {
        let range = NSRange(range, in: text.string)
        let attributes: [NSAttributedString.Key : Any] = [
            .foregroundColor: NSColor(Color("CustomColor"))
        ]
        text.removeAttribute(attributes.first!.key, range: range)
        text.addAttributes(attributes, range: range)
    }
}
