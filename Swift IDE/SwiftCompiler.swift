//
//  SwiftCompiler.swift
//  Swift IDE
//
//  Created by Murad Talibov on 20.12.22.
//

import SwiftUI
import Combine

class SwiftCompiler {
    struct Constants {
        static let ignoredOutputs: [CompilerOutput] = [
            .init(containing: "Too many levels of symbolic links")
        ]
    }
    
    static func compile(code: String) -> [String] {
        let directory = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appending(path: "sourceCode", directoryHint: .isDirectory)
        
        if !FileManager.default.fileExists(atPath: directory.path()) {
            do {
                try FileManager.default.createDirectory(
                    atPath: directory.path(),
                    withIntermediateDirectories: true,
                    attributes: nil
                )
            } catch {
                print("Error in dir creation: \(error)")
            }
        }
        
        let path = directory.appendingPathComponent("source.swift")
        
        do {
            try code.write(to: path, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("Error in file write: \(error)")
        }
        
        let script = "swift \(path.path())"
        print(script)
        
        do {
            let result = try runScript(script: script)
            return result
        } catch {
            print("Error in script execution: \(error)")
        }
        
        return []
    }
    
    private static func runScript(script: String) throws -> [String] {
        let task = Process()
        let pipe = Pipe()
        
        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c", script]
        task.executableURL = URL(fileURLWithPath: "/bin/zsh")
        task.standardInput = nil
        
        try task.run()
        task.waitUntilExit()
        
        let data = try pipe.fileHandleForReading.readToEnd()
        let output = String(data: data!, encoding: .utf8)!
        
        return filterOutput(output)
    }
    
    private static func filterOutput(_ output: String) -> [String] {
        var filteredOutput: [String] = []
        
        output.enumerateLines(invoking: { line, stop in
            var isIgnored = false
            
            for ignoredOutput in Constants.ignoredOutputs {
                if let regex = try? Regex(ignoredOutput.value), line.contains(regex) {
                    isIgnored = true
                    break
                }
            }
            
            if !isIgnored {
                filteredOutput.append("\(line)\n")
            }
        })
        
        return filteredOutput
    }
}
