//
//  DrawingCommand.swift
//  FigmaProject
//
//  Created by Roman Gorbenko on 19/03/23.
//

import Foundation

enum DrawingCommand {
    case move(CGPoint)
    case curve(CGPoint, CGPoint, CGPoint)
    case line(CGPoint)
    case close
    
    private static func prepareString(str: String) -> String {
        var array = Array(str)
        var i = 1
        while i < array.count {
            if array[i].isLetter && array[i].isUppercase {
                array.insert(" ", at: i)
                i += 1
            }
            if array[i - 1].isLetter && array[i-1].isUppercase {
                array.insert(" ", at: i)
                i += 1
            }
            i += 1
        }
        return String(array)
    }
    
    static func parse(_ string: String) -> [DrawingCommand]? {
        let string = prepareString(str: string)
        let commands = string.components(separatedBy: CharacterSet(charactersIn: " ,"))
        var index = 0
        var points = [CGPoint]()
        var result = [DrawingCommand]()
        
        while index < commands.count {
            let command = commands[index]
            index += 1
            switch command {
            case "M":
                if let point = parsePoint(commands, index: &index) {
                    result.append(.move(point))
                    points.append(point)
                } else {
                    fatalError()
                }
            case "C":
                if let fControl = parsePoint(commands, index: &index) {
                    if let sControl = parsePoint(commands, index: &index) {
                        if let endPoint = parsePoint(commands, index: &index) {
                            result.append(.curve(fControl, sControl, endPoint))
                        }
                    }
                } else {
                    fatalError()
                }
            case "L":
                if let point = parsePoint(commands, index: &index) {
                    result.append(.line(point))
                    points.append(point)
                } else {
                    fatalError()
                }
            case "Z":
                result.append(.close)
            default:
                fatalError()
            }
        }
        return result
    }
    
    private static func parsePoint(_ commands: [String], index: inout Int) -> CGPoint? {
        guard index + 1 < commands.count else {
            return nil
        }
        if let x = Double(commands[index]), let y = Double(commands[index + 1]) {
            index += 2
            return CGPoint(x: x, y: y)
        } else {
            return nil
        }
    }
}
