//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

str

let numberA: Float = 123.456
let numberB: Float = 789.000

func displayNumber(number: Float) {
    if number - Float(Int(number)) == 0 {
        print("\(Int(number))")
    } else {
        print("\(number)")
    }
}

displayNumber(numberA) // console output: 123.456
displayNumber(numberB) // console output: 789