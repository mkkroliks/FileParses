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
    //0 - the fastest 
    //1 - the slowest
    func giveWeightForModule(index: Int) -> Float {
        
        if modes.count == 1 { return 1 }
        
        let sortedModesByDurationGrowing = modes.sorted { $0.duration < $1.duration }
        var previousDuration = -1
        let removedModulesWithRepeatingDuration = sortedModesByDurationGrowing.filter { (mode) -> Bool in
            if mode.duration == previousDuration {
                previousDuration = mode.duration
                return false
            } else {
                previousDuration = mode.duration
                return true
            }
        }
        
        let multiplayer = 1.0 / Float(modes.count - 1)
        
        for (i, e) in removedModulesWithRepeatingDuration.enumerated() {
            if e.duration == modes[index].duration {
                return Float(i) * multiplayer
            }
        }
        return Float(-10000000.0)
    }
}

struct Mode {
    var duration: Int
    var r1: Int
    var r2: Int
    var n1: Int
    var n2: Int
}

let folder = "/Users/mk/FileParser/j20"

let fileManager = FileManager.default
let enumerator = fileManager.enumerator(atPath: folder)

var fileNames = [String]()

while let element = enumerator?.nextObject() as? String {
    if element.hasSuffix("mm") && element.hasPrefix("j") && element != "j20opt.mm" {
        fileNames.append(element)
    }
}

var textToFile = ""

for fileName in fileNames {
    textToFile += ("\(fileName)\n" + dataForFile(folderPath: folder, file: fileName) + "\n\n")
}

do {
    try textToFile.write(toFile: "/Users/mk/FileParser/results.txt", atomically: false, encoding: .utf8)
}
catch let error {
    print(error)
}
