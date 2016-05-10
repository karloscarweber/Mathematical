//
//  Enumerations.swift
//  Mathematical!
//
//  Created by Karl Weber on 4/27/16.
//  Copyright © 2016 Prologue. All rights reserved.
//

import UIKit

enum CalcValue {
    case Zero
    case One
    case Two
    case Three
    case Four
    case Five
    case Six
    case Seven
    case Eight
    case Nine
    case Decimal
}

enum CalcOperator {
    case Addition
    case Subtraction
    case Division
    case Multiplication
    case Equality
}

enum CalcActions {
    case PositiveNegative
    case Clear
    case Backspace
}