// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

/// Parses and validates canonical Roman numeral strings.
///
/// `RomanNumeralParser` converts a string into `RomanSymbol` values, folds valid subtractive pairs such as `IV` and
/// `CM`, then validates the resulting symbols against Roman numeral ordering, recurrence, and subtractive notation
/// rules.
///
/// The parser accepts `N` only as a standalone zero. It rejects empty strings, non-Roman characters, noncanonical
/// repetitions, and invalid subtractive.
internal struct RomanNumeralParser {
    /// The underlying string to parse.
    private let string: String

    /// Creates a parser for the specified string.
    ///
    /// - Parameter string: The string to parse.
    internal init(_ string: String) {
        self.string = string
    }

    /// Parses this string into canonical Roman symbols and their numeric value.
    ///
    /// - Returns: The parsed symbols and value, or `nil` if the string is not a valid Roman numeral.
    internal func parse() -> (symbols: Array<RomanSymbol>, value: Roman.Value)? {
        guard let symbols: Array<RomanSymbol> = self.parseSymbols() else {
            return nil
        }

        var value: Roman.Value = 0

        for symbol in symbols {
            guard value <= Roman.max.value - symbol.value else {
                return nil
            }

            value += symbol.value
        }

        return (symbols, value)
    }

    /// Parses this string into canonical Roman symbols.
    ///
    /// This step validates the lexical form of the numeral, including the standalone `N` rule, valid symbols,
    /// descending order, recurrence limits, and subtractive notation.
    private func parseSymbols() -> Array<RomanSymbol>? {
        guard self.string.isEmpty == false else {
            return nil
        }

        guard self.string.contains(where: { String($0) == RomanSymbol.N.description }) == false else {
            return self.string == RomanSymbol.N.description ? [.N] : nil
        }

        guard let symbols: Array<RomanSymbol> = self.tokenizeSymbols() else {
            return nil
        }

        guard self.hasValidOrder(symbols) else {
            return nil
        }

        guard self.hasValidRecurrences(symbols) else {
            return nil
        }

        guard self.hasValidSubtractivePrefixes(symbols) else {
            return nil
        }

        guard self.hasValidSubtractiveSuffixes(symbols) else {
            return nil
        }

        return symbols
    }

    /// Converts each character into a Roman symbol and folds valid subtractive pairs into their compound symbols.
    private func tokenizeSymbols() -> Array<RomanSymbol>? {
        var symbols: Array<RomanSymbol> = []

        for character in self.string {
            let rawValue: String = .init(character)

            guard let symbol: RomanSymbol = .init(rawValue: rawValue) else {
                return nil
            }

            if let previousSymbol = symbols.last,
               previousSymbol.isSubtractable(from: symbol) == true {
                do {
                    let concatenatedSymbol: RomanSymbol = try previousSymbol.concatenate(with: symbol)
                    symbols.removeLast()
                    symbols.append(concatenatedSymbol)
                } catch {
                    return nil
                }
            } else {
                symbols.append(symbol)
            }
        }

        return symbols
    }

    /// Returns `true` if symbols appear in nonincreasing value order.
    private func hasValidOrder(_ symbols: Array<RomanSymbol>) -> Bool {
        for (lhs, rhs) in zip(
            symbols.dropLast(),
            symbols.dropFirst()
        ) where lhs < rhs {
            return false
        }

        return true
    }

    /// Returns `true` if the symbols obey Roman recurrence rules.
    ///
    /// Repeatable symbols may appear up to three times in succession. Nonrepeatable symbols may not be repeated.
    private func hasValidRecurrences(_ symbols: Array<RomanSymbol>) -> Bool {
        for (lhs, rhs) in zip(
            symbols.dropLast(),
            symbols.dropFirst()
        ) {
            if lhs == rhs, rhs.isRepeatable == false {
                return false
            }
        }

        for index in symbols.indices.dropFirst(3) {
            let sequence: ArraySlice<RomanSymbol> = symbols[index - 3 ... index]
            let repeatedSymbol: RomanSymbol = sequence[sequence.startIndex]

            if sequence.dropFirst().allSatisfy({ $0 == repeatedSymbol }) {
                return false
            }
        }

        return true
    }

    /// Returns `true` if a subtractive pair is not preceded by its subtracting symbol.
    ///
    /// For example, this rejects `IIV`, which would otherwise tokenize as `I` followed by `IV`.
    private func hasValidSubtractivePrefixes(_ symbols: Array<RomanSymbol>) -> Bool {
        for (lhs, rhs) in zip(
            symbols.dropLast(),
            symbols.dropFirst()
        ) {
            guard let separatedSymbols: Array<RomanSymbol> = try? rhs.separate(),
                let subtractingSymbol: RomanSymbol = separatedSymbols.first
            else {
                continue
            }

            if lhs == subtractingSymbol {
                return false
            }
        }

        return true
    }

    /// Returns `true` if a subtractive pair is not followed by its subtracting symbol.
    ///
    /// For example, this rejects `IXI`, which would otherwise tokenize as `IX` followed by `I`.
    private func hasValidSubtractiveSuffixes(_ symbols: Array<RomanSymbol>) -> Bool {
        for (lhs, rhs) in zip(
            symbols.dropLast(),
            symbols.dropFirst()
        ) {
            guard let separatedSymbols: Array<RomanSymbol> = try? lhs.separate(),
                let subtractingSymbol: RomanSymbol = separatedSymbols.first
            else {
                continue
            }

            if rhs == subtractingSymbol {
                return false
            }
        }

        return true
    }
}
