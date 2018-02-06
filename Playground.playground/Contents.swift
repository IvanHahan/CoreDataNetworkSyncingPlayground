//: Playground - noun: a place where people can play

import UIKit
import Promise
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

enum PlaygroundError: Error {
    case invalidNumber
}

func reverse(string: String) -> Promise<String> {
    return Promise { fulfill, _ in
        Thread.sleep(forTimeInterval: 0.1)
        fulfill(String(string.reversed()))
    }
}

func number(from string: String) -> Promise<Int> {
    return Promise { fulfill, catcher  in
        Thread.sleep(forTimeInterval: 0.1)
        guard let number = Int(string) else { throw PlaygroundError.invalidNumber }
        fulfill(number)
    }
}

func square(number: Int) -> Int {
    return number * number
}

reverse(string: "01").then(number(from:)).then(square(number:)).then {
    print($0) // 100
}

number(from: "hello").then {
    print("dffsf", $0)
    }.catch { _ in
        print("catcher")
    }

