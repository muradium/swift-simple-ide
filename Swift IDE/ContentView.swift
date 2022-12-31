//
//  ContentView.swift
//  Swift IDE
//
//  Created by Murad Talibov on 05.12.22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Button(action: { viewModel.compile() }) {
                    Image(systemName: "play.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25)
                }
                Grid {
                    GridRow {
                        Text("Code")
                        Text("Output")
                    }
                    GridRow {
                        AttributedTextView(viewModel: viewModel)
                            .padding()
                            .frame(
                                            maxWidth: .infinity,
                                            maxHeight: .infinity,
                                            alignment: .topLeading)
                            .background {
                                RoundedRectangle(cornerRadius: 20)
                                    .foregroundColor(.gray.opacity(0.3))
                            }
                        ScrollView {
                            LazyVStack(alignment: .leading) {
                                ForEach(viewModel.output, id: \.self) { output in
                                    Text(output)
                                }
                            }
                            .padding()
                            .frame(
                                maxWidth: .infinity,
                                maxHeight: .infinity,
                                alignment: .topLeading)
                            .background {
                                RoundedRectangle(cornerRadius: 20)
                                    .foregroundColor(.gray.opacity(0.3))
                            }
                        }
                    }
                }
            }.padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ViewModel())
            .previewInterfaceOrientation(.landscapeRight)
    }
}
