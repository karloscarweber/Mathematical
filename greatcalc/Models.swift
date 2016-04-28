//
//  Models.swift
//  greatcalc
//
//  Created by Karl Weber on 4/28/16.
//  Copyright © 2016 Prologue. All rights reserved.
//
//  I know what your thinking! Why does a calculator need a model
//  So that we can store equations of course
//
//


import UIKit


struct equation {
    var operand1 = 0,
        operation = CalcOperator.Addition,
        operand2 = 0,
        result = 0
}


//enum CalcOperator {
//    case Addition
//    case Subtraction
//    case Division
//    case Multiplication
//    case Equality
//}



