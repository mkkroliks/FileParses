//
//  main.swift
//  FileParser
//
//  Created by Maciej Krolikowski on 22/04/2017.
//  Copyright © 2017 Maciej Krolikowski. All rights reserved.
//

import Foundation

class Job {
    var modes: [Mode] = []
}

struct Mode {
    var duration: Int
    var r1: Int
    var r2: Int
    var n1: Int
    var n2: Int
}

    do {
        
        var jobs = [Job]()
        
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
            .map { $0.flatMap { Int( $0.trimmingCharacters(in: .whitespaces)) } }
        
        for dataInt in dataInts {
            
            if dataInt.count == 6 {
                let mode = Mode(duration: dataInt[1], r1: dataInt[2], r2: dataInt[3], n1: dataInt[4], n2: dataInt[5])
                jobs.last!.modes.append(mode)
            } else {
                let mode = Mode(duration: dataInt[2], r1: dataInt[3], r2: dataInt[4], n1: dataInt[5], n2: dataInt[6])
                var job = Job()
                job.modes.append(mode)
                jobs.append(job)
            }
        }
        
        let resultData = try String(contentsOfFile: "/Users/mk/FileParser/j10/j102_2.sa", encoding: .utf8)
        let resultLines = resultData.components(separatedBy: .newlines)
        
        var dataResultInts = resultLines
            .map { $0.components(separatedBy: " ") }
            .map { $0.flatMap { Int( $0.trimmingCharacters(in: .whitespaces)) } }
            .filter { $0.count > 2 }
        
        var jobsNumbers = dataResultInts[0]
        var jobsModules = dataResultInts[1]
        
        for (i, _) in jobsNumbers.enumerated() {
            var job = jobs[jobsNumbers[i]]
            if jobsModules[i] == 0 {
                print("0 ")
            } else {
                print("\(job.modes[jobsModules[i] - 1].duration) ")
            }
        }
        
    } catch {
        print(error)
        print(error)
    }

