//
//  main.swift
//  FileParser
//
//  Created by Maciej Krolikowski on 22/04/2017.
//  Copyright © 2017 Maciej Krolikowski. All rights reserved.
//

import Foundation

print("Hello, World!")


    do {
        let data = try String(contentsOfFile: "/Users/mk/FileParser/j10/j102_2.mm", encoding: .utf8)
        let lines = data.components(separatedBy: .newlines)
        
        var readyToRead = false
        var endOfData = false
        
        var dataLines = lines.filter({ (line) -> Bool in
            
            if readyToRead {
                
                if endOfData {
                    return false
                } else {
                    if line.hasPrefix("*") {
                        endOfData = true
                        return false
                    } else {
                        return true
                    }
                }
                
            } else {
                if line.hasPrefix("-") {
                    readyToRead = true
                }
                return false
            }
        })
        
        var dataInts = dataLines
            .map { $0.components(separatedBy: " ") }
            .map({ (array) -> [Int] in
                return array.flatMap{ Int( $0.trimmingCharacters(in: .whitespaces)) }
            })
        
    } catch {
        print(error)
    }

