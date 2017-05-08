//
//  function.swift
//  FileParser
//
//  Created by Maciej Krolikowski on 22/04/2017.
//  Copyright © 2017 Maciej Krolikowski. All rights reserved.
//

import Foundation


func dataForFile(folderPath: String, file: String) -> String {
    
    do {
        
        let endIndex = file.index(file.endIndex, offsetBy: -3)
        let fileNameTruncated = file.substring(to: endIndex)
        
        var jobs = [Job]()
        
        let data = try String(contentsOfFile: "\(folderPath)/\(fileNameTruncated).mm", encoding: .utf8)
        let lines = data.components(separatedBy: .newlines)
        
        var readyToRead = false
        var endOfData = false
        
        let dataLines = lines.filter({ (line) -> Bool in
            
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
        
        let dataInts = dataLines
            .map { $0.components(separatedBy: " ") }
            .map { $0.flatMap { Int( $0.trimmingCharacters(in: .whitespaces)) } }
        
        for dataInt in dataInts {
            
            if dataInt.count == 6 {
                let mode = Mode(duration: dataInt[1], r1: dataInt[2], r2: dataInt[3], n1: dataInt[4], n2: dataInt[5])
                jobs.last!.modes.append(mode)
            } else {
                let mode = Mode(duration: dataInt[2], r1: dataInt[3], r2: dataInt[4], n1: dataInt[5], n2: dataInt[6])
                let job = Job()
                job.modes.append(mode)
                jobs.append(job)
            }
        }
        
        let resultData = try String(contentsOfFile: "\(folderPath)/\(fileNameTruncated).sa", encoding: .utf8)
        let resultLines = resultData.components(separatedBy: .newlines)
        
        var dataResultInts = resultLines
            .map { $0.components(separatedBy: " ") }
            .map { $0.flatMap { Int( $0.trimmingCharacters(in: .whitespaces)) } }
            .filter { $0.count > 2 }
        
        var jobsNumbers = dataResultInts[0]
        var jobsModules = dataResultInts[1]
        
        jobsNumbers.removeFirst()
        jobsNumbers.append(jobsNumbers.count + 1)
        
        jobsModules.removeFirst()
        jobsModules.append(1)
        
        var jobsText =      "JOBS:       "
        var modesText =     "MODES:      "
        var durationsText = "DURATIONS:  "
        var weightText =    "WEIGHT:     "
        
        
        //JOB NUMBERS
        for jobsNumber in jobsNumbers {
            jobsText += "\(jobsNumber)     "
        }
        jobsText += "\n"
        
        //MODES
        for (i, jobsModule) in jobsModules.enumerated() {
            modesText += String(repeating: " ", count: String(describing: jobsNumbers[i]).characters.count - 1) + "\(jobsModule)     "
        }
        modesText += "\n"
        
        //DURATIONS
        for (i, _) in jobsNumbers.enumerated() {
            let job = jobs[jobsNumbers[i] - 1]
            let duration = job.modes[jobsModules[i] - 1].duration
            durationsText += String(repeating: " ", count: String(describing: jobsNumbers[i]).characters.count - 1) + "\(duration)     "
        }
        durationsText += "\n"
        
        //WEIGHT
        for (i, _) in jobsNumbers.enumerated() {
            let job = jobs[jobsNumbers[i] - 1]
            //job.modes[jobsModules[i] - 1].duration
            let weight = job.giveWeightForModule(index:jobsModules[i] - 1)
            weightText += String(repeating: " ", count: String(describing: jobsNumbers[i]).characters.count - 1) + "\(weight)   "
        }
        
        let resultText = jobsText + modesText + durationsText + weightText
        return resultText
        
    } catch {
        return "ERROR!!!"
    }
}
