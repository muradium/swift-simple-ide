//
//  AttributedTextField.swift
//  Swift IDE
//
//  Created by Murad Talibov on 12.12.22.
//

import SwiftUI
import AppKit

struct AttributedTextView: NSViewRepresentable {
    typealias NSViewType = NSScrollView
    
    @ObservedObject var viewModel: ViewModel
    
    let isSelectable: Bool = true
    var insetSize: CGSize = .zero
    
    let scrollView = NSTextView.scrollableTextView()
    
    func makeNSView(context: Context) -> NSViewType {
        let textView = scrollView.documentView as! NSTextView
        
        textView.drawsBackground = false
        textView.textColor = .controlTextColor
        textView.font = NSFont(name: "Helvetica Neue", size: 15)!
        textView.textContainerInset = insetSize
        
        textView.isAutomaticQuoteSubstitutionEnabled = false
        textView.isAutomaticDashSubstitutionEnabled = false
        textView.isAutomaticSpellingCorrectionEnabled = false
        textView.isAutomaticTextCompletionEnabled = false
        textView.isAutomaticTextReplacementEnabled = false
        
        return scrollView
    }
    
    func updateNSView(_ nsView: NSViewType, context: Context) {
        let textView = (nsView.documentView as! NSTextView)
        textView.isSelectable = isSelectable
        
        if let lineLimit = context.environment.lineLimit {
            textView.textContainer?.maximumNumberOfLines = lineLimit
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    internal class Coordinator: NSObject, NSTextViewDelegate {
        var parent: AttributedTextView
        
        init(parent: AttributedTextView) {
            self.parent = parent
            
            super.init()
            
            let textView = parent.scrollView.documentView as! NSTextView
            textView.delegate = self
        }
        
        func textDidChange(_ notification: Notification) {
            let textView = parent.scrollView.documentView as! NSTextView
            
            if let text = textView.textStorage?.mutableAttributedString {
                SyntaxHighlighter.highlightKeywords(text: text)
                parent.viewModel.text = text
            }
        }
    }
}

struct AttributedTextField_Previews: PreviewProvider {
    static var previews: some View {
        AttributedTextView(viewModel: ViewModel())
    }
}
