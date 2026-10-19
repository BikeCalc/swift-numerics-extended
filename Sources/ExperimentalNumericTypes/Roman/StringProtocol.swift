// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

extension StringProtocol {
    /// A boolean value indicating whether this instance is a single Roman symbol.
    ///
    /// This property recognizes both root symbols, such as `I`, `V`, and `X`, and compound subtractive symbols, such as
    /// `IV`, `IX`, and `CM`.
    ///
    /// For example:
    ///
    /// ```swift
    /// print("X".isRomanSymbol)
    /// // Prints "true"
    /// print("IV".isRomanSymbol)
    /// // Prints "true"
    /// print("IIII".isRomanSymbol)
    /// // Prints "false"
    /// ```
    public var isRomanSymbol: Bool {
        guard self.isEmpty == false else {
            return false
        }

        return RomanSymbol.allCases.contains(where: { $0.rawValue == self })
    }

    /// A boolean value indicating whether this instance is a canonical Roman numeral.
    ///
    /// This property accepts `N` as zero and canonical Roman numerals from `I` through `MMMCMXCIX`.
    ///
    /// For example:
    ///
    /// ```swift
    /// print("MMXXVI".isRomanNumeral)
    /// // Prints "true"
    /// print("IIV".isRomanNumeral)
    /// // Prints "false"
    /// ```
    public var isRomanNumeral: Bool {
        return RomanNumeralParser(String(self)).parse() != nil
    }
}
