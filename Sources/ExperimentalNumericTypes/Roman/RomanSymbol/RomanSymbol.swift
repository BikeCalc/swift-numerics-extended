// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import CoreNumericProtocols
import StandardNumericProtocols

/// A representation of a Roman symbol.
internal enum RomanSymbol: String, RawRepresentable, CaseIterable {
    /// The symbol representing the Arabic numeral zero, or nulla.
    case n = "N"

    /// The symbol representing the Arabic numeral one.
    case i = "I"

    /// The symbol representing the Arabic numeral four.
    case iv = "IV"

    /// The symbol representing the Arabic numeral five.
    case v = "V"

    /// The symbol representing the Arabic numeral nine.
    case ix = "IX"

    /// The symbol representing the Arabic numeral ten.
    case x = "X"

    /// The symbol representing the Arabic numeral forty.
    case xl = "XL"

    /// The symbol representing the Arabic numeral fifty.
    case l = "L"

    /// The symbol representing the Arabic numeral ninety.
    case xc = "XC"

    /// The symbol representing the Arabic numeral one hundred.
    case c = "C"

    /// The symbol representing the Arabic numeral four hundred.
    case cd = "CD"

    /// The symbol representing the Arabic numeral five hundred.
    case d = "D"

    /// The symbol representing the Arabic numeral nine hundred.
    case cm = "CM"

    /// The symbol representing the Arabic numeral one thousand.
    case m = "M"

    /// The underlying value of this type.
    internal var value: Roman.Value {
        switch self {
        case .n:
            return 0
        case .i:
            return 1
        case .iv:
            let five: Roman.Value = Self.v.value
            let one: Roman.Value = Self.i.value
            return five - one
        case .v:
            return 5
        case .ix:
            let ten: Roman.Value = Self.x.value
            let one: Roman.Value = Self.i.value
            return ten - one
        case .x:
            return 10
        case .xl:
            let fifty: Roman.Value = Self.l.value
            let ten: Roman.Value = Self.x.value
            return fifty - ten
        case .l:
            return 50
        case .xc:
            let oneHundred: Roman.Value = Self.c.value
            let ten: Roman.Value = Self.x.value
            return oneHundred - ten
        case .c:
            return 100
        case .cd:
            let fiveHundred: Roman.Value = Self.d.value
            let oneHundred: Roman.Value = Self.c.value
            return fiveHundred - oneHundred
        case .d:
            return 500
        case .cm:
            let oneThousand: Roman.Value = Self.m.value
            let oneHundred: Roman.Value = Self.c.value
            return oneThousand - oneHundred
        case .m:
            return 1_000
        }
    }

    /// A boolean value indicating whether this case is repeatable.
    internal var isRepeatable: Bool {
        switch self {
        case .i, .x, .c, .m:
            return true
        default:
            return false
        }
    }

    /// Concatenates this case with the specified value.
    ///
    /// - Parameter rhs: The value on the right hand side.
    /// - Throws: A Roman symbol error if is unconcatenable.
    /// - Returns: A concatenated value.
    internal func concatenate(with rhs: Self) throws -> Self {
        switch (self, rhs) {
        case (.i, .v):
            return .iv
        case (.i, .x):
            return .ix
        case (.x, .l):
            return .xl
        case (.x, .c):
            return .xc
        case (.c, .d):
            return .cd
        case (.c, .m):
            return .cm
        default:
            throw RomanSymbolError.isUnconcatenable
        }
    }

    /// Separates this case into an array of cases.
    ///
    /// - Throws: A Roman symbol error if is inseparable.
    /// - Returns: An array of separated values.
    internal func separate() throws -> Array<Self> {
        switch self {
        case .iv:
            return [.i, .v]
        case .ix:
            return [.i, .x]
        case .xl:
            return [.x, .l]
        case .xc:
            return [.x, .c]
        case .cd:
            return [.c, .d]
        case .cm:
            return [.c, .m]
        default:
            throw RomanSymbolError.isInseparable
        }
    }

    /// Returns a boolean value indicating whether this case is subtractable from the specified value.
    ///
    /// If a lower value digit is written to the left of a higher value digit, it is subtracted. Only I, X, and C can be
    /// used as subtractive numerals.
    ///
    /// - Parameter rhs: The value on the right hand side.
    /// - Returns: A boolean value.
    internal func isSubtractable(from rhs: Self) -> Bool {
        switch self {
        case .i:
            return rhs == .v || rhs == .x
        case .x:
            return rhs == .l || rhs == .c
        case .c:
            return rhs == .d || rhs == .m
        default:
            return false
        }
    }
}

// MARK: - Comparable

extension RomanSymbol: Comparable {
    /// Returns a boolean value indicating whether the value of the first argument is less than that of the second
    /// argument.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    /// - Returns: `true` if lhs is smaller, and `false` otherwise.
    internal static func < (
        _ lhs: Self,
        _ rhs: Self
    ) -> Bool {
        return lhs.value < rhs.value
    }
}

// MARK: - CustomStringConvertible

extension RomanSymbol: CustomStringConvertible {
    internal var description: String {
        return self.rawValue
    }
}
