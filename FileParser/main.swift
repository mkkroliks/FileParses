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

let fileManager = FileManager.default
let enumerator = fileManager.enumerator(atPath: "/Users/mk/FileParser/j10")

var fileNames = [String]()

while let element = enumerator?.nextObject() as? String {
    if element.hasSuffix("mm") && element.hasPrefix("j") && element != "j10opt.mm" {
        fileNames.append(element)
    }
}

var textToFile = ""

for fileName in fileNames {
    textToFile += ("\(fileName)\n" + dataForFile(file: fileName) + "\n\n")
}

do {
    try textToFile.write(toFile: "/Users/mk/FileParser/results.txt", atomically: false, encoding: .utf8)
}
catch let error {
    print(error)
}
