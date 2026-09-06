// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import CoreNumericOperators
import CoreNumericProtocols
import ExperimentalNumericProtocols
import StandardNumericProtocols
import StandardNumericTypes

/// A Roman numeral value from `0` through `3,999`.
///
/// Use `Roman` to represent whole numbers with Roman numeral notation. The type stores a numeric value internally, but
/// its textual representation is the canonical Roman numeral for that value.
///
/// For example:
///
/// ```swift
/// let value: Roman = 44
///
/// print(value)
/// // Prints "XLIV"
/// ```
///
/// Roman supports `N` for zero, the root symbols `I`, `V`, `X`, `L`, `C`, `D`, and `M`, and the canonical subtractive
/// forms `IV`, `IX`, `XL`, `XC`, `CD`, and `CM`.
///
/// Create Roman values from integer literals, exact integer conversion, decimal strings, or Roman numeral strings.
///
/// For example:
///
/// ```swift
/// let literal: Roman = 2_026
/// let exact = Roman(exactly: 3_999)
/// let decimal = Roman("44")
/// let numeral = Roman("XLIV")
/// let invalid = Roman("ABC")
///
/// print(literal)
/// // Prints "MMXXVI"
/// print(exact)
/// // Prints "Optional(MMMCMXCIX)"
/// print(decimal)
/// // Prints "Optional(XLIV)"
/// print(numeral)
/// // Prints "Optional(XLIV)"
/// print(invalid)
/// // Prints "nil"
/// ```
///
/// Roman values compare and hash by numeric value, not by the alphabetical order or length of their printed numerals.
///
/// For example:
///
/// ```swift
/// let nine = Roman("IX")!
/// let ten = Roman("X")!
///
/// print(nine < ten)
/// // Prints "true"
/// ```
///
/// They also support whole-number arithmetic through the package's numeric protocols.
///
/// For example:
///
/// ```swift
/// let two: Roman = 2
/// let three: Roman = 3
/// let seven: Roman = 7
///
/// print(two + three)
/// // Prints "V"
/// print(two * three)
/// // Prints "VI"
/// print(seven / two)
/// // Prints "III"
/// print(seven % two)
/// // Prints "I"
/// print(two ** three)
/// // Prints "VIII"
/// ```
///
/// Division and remainders use integer-style arithmetic because Roman numerals cannot represent fractions.
///
/// Use overflow-reporting operations near the edge of the representable range.
///
/// For example:
///
/// ```swift
/// let report = Roman.max.addingReportingOverflow(1)
///
/// print(report.partialValue)
/// // Prints "N"
/// print(report.overflow)
/// // Prints "true"
/// ```
///
/// Roman values encode as Roman numeral strings. Decoding accepts either a valid Roman numeral string or an integer in
/// the representable range.
///
/// For example:
///
/// ```swift
/// import Foundation
///
/// let value: Roman = 44
/// let encoder = JSONEncoder()
/// let data = try encoder.encode(value)
///
/// let description = String(
///     data: data,
///     encoding: .utf8
/// )!
///
/// print(description)
/// // Prints "\"XLIV\""
/// ```
///
/// The corresponding decoder accepts either representation.
///
/// For example:
///
/// ```swift
/// import Foundation
///
/// let stringData = Data(#""XLIV""#.utf8)
/// let integerData = Data(#"44"#.utf8)
/// let decoder = JSONDecoder()
///
/// let stringValue = try decoder.decode(
///     Roman.self,
///     from: stringData
/// )
/// let integerValue = try decoder.decode(
///     Roman.self,
///     from: integerData
/// )
///
/// print(stringValue)
/// // Prints "XLIV"
/// print(integerValue)
/// // Prints "XLIV"
/// ```
///
/// - Note: `Roman` is intentionally experimental. It is not a binary integer and does not model signed values, bitwise
///   operations, or fractional values.
public struct Roman {
    /// The underlying value.
    internal typealias Value = UInt16

    /// The underlying value.
    internal let value: Self.Value

    /// Creates a new instance with the specified value.
    ///
    /// - Parameter value: The value of this instance.
    /// - Precondition: `value` must be in the range `0...3_999`.
    private init(value: Self.Value) {
        precondition(
            0 ... 3_999 ~= value,
            "Roman value must be between \(Self.min) and \(Self.max)."
        )
        self.value = value
    }
}

extension Roman {
    /// A boolean value indicating whether this value is even.
    ///
    /// For example:
    ///
    /// ```swift
    /// print(0.isEven)
    /// // Prints "true"
    /// ```
    public var isEven: Bool {
        let remainder: Self = self % 2
        return remainder == 0
    }

    /// A boolean value indicating whether this value is odd.
    ///
    /// For example:
    ///
    /// ```swift
    /// print(0.isOdd)
    /// // Prints "false"
    /// ```
    public var isOdd: Bool {
        let remainder: Self = self % 2
        return remainder != 0
    }
}

// MARK: - Addable

extension Roman: Addable {
    public static func + (
        _ lhs: Self,
        _ rhs: Self
    ) -> Self {
        let newValue: Self.Value = lhs.value + rhs.value
        return .init(value: newValue)
    }
}

// MARK: - AdditiveArithmetic

extension Roman: AdditiveArithmetic {}

// MARK: - Comparable

extension Roman: Comparable {
    public static func < (
        _ lhs: Self,
        _ rhs: Self
    ) -> Bool {
        return lhs.value < rhs.value
    }
}

// MARK: - CustomDebugStringConvertible

extension Roman: CustomDebugStringConvertible {
    /// A textual representation of this value suitable for debugging.
    public var debugDescription: String {
        return "Roman(\(self.value))"
    }
}

// MARK: - CustomStringConvertible

extension Roman: CustomStringConvertible {
    public var description: String {
        guard self.value != 0 else {
            return RomanSymbol.n.description
        }

        let symbols: Array<RomanSymbol> = RomanSymbol.allCases.reversed()

        var number: Self.Value = self.value
        var result: String = ""

        while number > 0 {
            for symbol in symbols {
                let report: Self.Value.OverflowReport = number.subtractingReportingOverflow(symbol.value)

                if report.overflow == false && report.partialValue >= 0 {
                    number -= symbol.value
                    result += symbol.description
                    break
                }
            }
        }

        return result
    }
}

// MARK: - Decodable

extension Roman: Decodable {
    /// Creates a Roman value by decoding a Roman numeral string or integer.
    ///
    /// Roman values decode from canonical Roman numeral strings such as `"N"` and from integers in the range
    /// `0...3_999`.
    ///
    /// - Parameter decoder: The decoder to read data from.
    /// - Throws: A decoding error if the encoded value is neither a valid Roman numeral string nor an integer in range.
    public init(from decoder: any Decoder) throws {
        let container: SingleValueDecodingContainer = try decoder.singleValueContainer()

        if let description = try? container.decode(String.self), let value: Self = .init(description) {
            self = value
        } else if let value = try? container.decode(Self.Value.self), Self.min.value ... Self.max.value ~= value {
            self.init(value: value)
        } else {
            let range: String = "\(Self.min) and \(Self.max)"
            let debugDescription: String =
                "Roman numeral value must be a valid Roman numeral string or an integer between \(range)."
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: debugDescription
            )
        }
    }
}

// MARK: - Divisible

extension Roman: Divisible {
    public var reciprocal: Self? {
        guard self.isInvertible == true else {
            return nil
        }

        return self
    }

    public var isInvertible: Bool {
        return self == 1
    }

    public func isDivisible(by other: Self) -> Bool {
        guard other.isZero == false else {
            return false
        }

        return (self % other).isZero == true
    }

    /// Returns the quotient of dividing the first specified value by the second.
    ///
    /// Division discards any fractional remainder because `Roman` represents only whole numbers.
    ///
    /// For example:
    ///
    /// ```swift
    /// let dividend: Roman = 7
    /// let divisor: Roman = 2
    ///
    /// print(dividend / divisor)
    /// // Prints "III"
    /// ```
    ///
    /// - Parameters:
    ///   - lhs: The dividend.
    ///   - rhs: The divisor.
    /// - Returns: The quotient.
    /// - Precondition: `rhs` must not be zero.
    public static func / (
        _ lhs: Self,
        _ rhs: Self
    ) -> Self {
        let newValue: Self.Value = lhs.value / rhs.value
        return .init(value: newValue)
    }

    /// Returns the remainder of dividing the first specified value by the second.
    ///
    /// For example:
    ///
    /// ```swift
    /// let dividend: Roman = 7
    /// let divisor: Roman = 2
    ///
    /// print(dividend % divisor)
    /// // Prints "I"
    /// ```
    ///
    /// - Parameters:
    ///   - lhs: The dividend.
    ///   - rhs: The divisor.
    /// - Returns: The remainder.
    /// - Precondition: `rhs` must not be zero.
    public static func % (
        _ lhs: Self,
        _ rhs: Self
    ) -> Self {
        let newValue: Self.Value = lhs.value % rhs.value
        return .init(value: newValue)
    }
}

// MARK: - Encodable

extension Roman: Encodable {
    /// Encodes this value as its canonical Roman numeral string.
    ///
    /// `Roman.zero` encodes as `"N"`.
    ///
    /// - Parameter encoder: The encoder to write data to.
    /// - Throws: Any error thrown while encoding the canonical Roman numeral string.
    public func encode(to encoder: any Encoder) throws {
        try self.description.encode(to: encoder)
    }
}

// MARK: - Equatable

extension Roman: Equatable {
    public static func == (
        _ lhs: Self,
        _ rhs: Self
    ) -> Bool {
        return lhs.value == rhs.value
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension Roman: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = Int

    /// Creates a Roman value from an integer literal.
    ///
    /// - Parameter value: The integer literal used to create the value.
    /// - Precondition: `value` must be in the range `0...3_999`.
    public init(integerLiteral value: Self.IntegerLiteralType) {
        precondition(
            0 ... 3_999 ~= value,
            "Roman integer literal must be between \(Self.min) and \(Self.max)."
        )

        let newValue: Self.Value = .init(value)

        self.init(value: newValue)
    }
}

// MARK: - Hashable

extension Roman: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.value.hashValue)
    }
}

// MARK: - LosslessStringConvertible

extension Roman: LosslessStringConvertible {
    /// Creates a Roman value from a decimal string or canonical Roman numeral.
    ///
    /// This initializer accepts decimal strings in the range `0...3_999` and canonical Roman numerals such as `"N"`.
    ///
    /// - Parameter description: The string representation to convert.
    public init?(_ description: String) {
        guard description.isEmpty == false else {
            return nil
        }

        if let value: Self.Value = .init(description) {
            guard value <= Self.max.value else {
                return nil
            }

            self.init(value: value)
        } else if let result = RomanNumeralParser(description).parse() {
            self.init(value: result.value)
        } else {
            return nil
        }
    }
}

// MARK: - Multipliable

extension Roman: Multipliable {
    public func isMultiple(of other: Roman) -> Bool {
        if self == 0 && other == 0 {
            return true
        }

        guard other != 0 else {
            return false
        }

        return (self % other) == 0
    }

    public static func * (
        _ lhs: Self,
        _ rhs: Self
    ) -> Self {
        let newValue: Self.Value = lhs.value * rhs.value
        return .init(value: newValue)
    }
}

// MARK: - Numeric

extension Roman: Numeric {
    public typealias Magnitude = Self

    public init?<Source>(exactly source: Source)
    where Source: BinaryInteger {
        guard let value: Self.Value = .init(exactly: source),
            Self.min.value ... Self.max.value ~= value
        else {
            return nil
        }

        self.init(value: value)
    }

    public var magnitude: Roman {
        return self
    }
}

// MARK: - Raisable

extension Roman: Raisable {
    public typealias Exponent = Self

    public func isPower(of other: Self) -> Bool {
        switch other {
        case 0:
            return self == 0 || self == 1
        case 1:
            return self == 1
        default:
            var number: Self = self

            while number > 1 && number.isDivisible(by: other) == true {
                let quotient: Self = number / other

                guard quotient != number else {
                    return false
                }

                number = quotient
            }

            return number == 1
        }
    }

    public static func ** (
        _ lhs: Self,
        _ rhs: Self.Exponent
    ) -> Self {
        switch rhs {
        case 0:
            return 1
        case 1:
            return lhs
        default:
            var result: Self = lhs
            var exponent: Self = 2

            while exponent <= rhs {
                result *= lhs
                exponent += 1
            }

            return result
        }
    }
}

// MARK: - ReportableAsOverflow

extension Roman: ReportableAsOverflow {
    public func addingReportingOverflow(_ rhs: Self) -> Self.OverflowReport {
        let sum: Self.Value = self.value + rhs.value
        let modulus: Self.Value = Self.max.value + 1
        let partialValue: Self = .init(value: sum % modulus)

        guard sum <= Self.max.value else {
            return (
                partialValue: partialValue,
                overflow: true
            )
        }

        return (
            partialValue: partialValue,
            overflow: false
        )
    }

    public func subtractingReportingOverflow(_ rhs: Self) -> Self.OverflowReport {
        if self.value >= rhs.value {
            let difference: Self.Value = self.value - rhs.value
            let partialValue: Self = .init(value: difference)

            return (partialValue: partialValue, overflow: false)
        } else {
            let modulus: Self.Value = Self.max.value + 1
            let distance: Self.Value = rhs.value - self.value
            let partialValue: Self = .init(value: modulus - distance)

            return (
                partialValue: partialValue,
                overflow: true
            )
        }
    }

    public func multipliedReportingOverflow(by rhs: Self) -> Self.OverflowReport {
        let overflow: Bool = rhs.value != 0 && self.value > Self.max.value / rhs.value
        let modulus: Self.Value = Self.max.value + 1

        var product: Self.Value = 0
        var addend: Self.Value = self.value
        var multiplier: Self.Value = rhs.value

        while multiplier > 0 {
            if multiplier % 2 == 1 {
                product = (product + addend) % modulus
            }

            multiplier /= 2
            addend = (addend + addend) % modulus
        }

        let partialValue: Self = .init(value: product)

        return (
            partialValue: partialValue,
            overflow: overflow
        )
    }

    public func dividedReportingOverflow(by rhs: Self) -> Self.OverflowReport {
        guard rhs.value != 0 else {
            return (partialValue: self, overflow: true)
        }

        let quotient: Self.Value = self.value / rhs.value
        let partialValue: Self = .init(value: quotient)

        return (
            partialValue: partialValue,
            overflow: false
        )
    }

    public func remainderReportingOverflow(dividingBy rhs: Self) -> Self.OverflowReport {
        guard rhs.value != 0 else {
            return (partialValue: self, overflow: true)
        }

        let remainder: Self.Value = self.value % rhs.value
        let partialValue: Self = .init(value: remainder)

        return (
            partialValue: partialValue,
            overflow: false
        )
    }

    public func raisedReportingOverflow(to rhs: Self.Exponent) -> Self.OverflowReport {
        switch rhs {
        case ..<2:
            let result: Self = self ** rhs
            return (partialValue: result, overflow: false)
        default:
            var result: Self = self
            var exponent: Self.Exponent = 2

            while exponent <= rhs {
                let report: Self.OverflowReport = result.multipliedReportingOverflow(by: self)

                guard report.overflow == false else {
                    return report
                }

                result = report.partialValue
                exponent += 1
            }

            return (
                partialValue: result,
                overflow: false
            )
        }
    }
}

// MARK: - RepresentableByMax

extension Roman: RepresentableByMax {
    public static var max: Self {
        return 3_999
    }
}

// MARK: - RepresentableByMin

extension Roman: RepresentableByMin {
    public static var min: Self {
        return 0
    }
}

// MARK: - RepresentableByZero

extension Roman: RepresentableByZero {
    public static var zero: Self {
        .init(value: 0)
    }
}

// MARK: - Sendable

extension Roman: Sendable {}

// MARK: - Strideable

extension Roman: Strideable {
    public typealias Stride = Int

    public func advanced(by amount: Self.Stride) -> Self {
        let newValue: Self.Stride = .init(self.value) + amount
        return .init(integerLiteral: newValue)
    }

    public func distance(to other: Self) -> Self.Stride {
        return .init(other.value) - .init(self.value)
    }
}

// MARK: - Subtractable

extension Roman: Subtractable {
    public static func - (
        _ lhs: Self,
        _ rhs: Self
    ) -> Self {
        let newValue: Self.Value = lhs.value - rhs.value
        return .init(value: newValue)
    }
}

// MARK: - SymbolicInteger

extension Roman: SymbolicInteger {}
