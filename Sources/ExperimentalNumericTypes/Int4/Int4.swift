// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import CoreNumericOperators
import CoreNumericProtocols
import StandardNumericProtocols
import StandardNumericTypes

/// A four-bit signed integer value from `-8` through `7`.
///
/// Use `Int4` to experiment with signed fixed-width integer behavior in a range small enough to inspect by hand. The
/// type uses `Int8` storage internally, but only the low four bits define its integer behavior. Those four bits are
/// interpreted with two's-complement signed integer rules.
///
/// For example:
///
/// ```swift
/// let value: Int4 = -8
///
/// print(value)
/// // Prints "-8"
/// ```
///
/// Create `Int4` values from integer literals, exact integer conversion, or decimal strings.
///
/// For example:
///
/// ```swift
/// let literal: Int4 = -8
/// let exact = Int4(exactly: 7)
/// let string = Int4("-8")
/// let invalid = Int4(exactly: 8)
///
/// print(literal)
/// // Prints "-8"
/// print(exact)
/// // Prints "Optional(7)"
/// print(string)
/// // Prints "Optional(-8)"
/// print(invalid)
/// // Prints "nil"
/// ```
///
/// Use truncating initialization to keep only the low four bits of a source value and interpret them as a signed value.
///
/// For example:
///
/// ```swift
/// print(Int4(truncatingIfNeeded: 7))
/// // Prints "7"
/// print(Int4(truncatingIfNeeded: 8))
/// // Prints "-8"
/// print(Int4(truncatingIfNeeded: 15))
/// // Prints "-1"
/// ```
///
/// `Int4` supports whole-number arithmetic, comparison, bitwise operations, and fixed-width integer APIs.
///
/// For example:
///
/// ```swift
/// let value: Int4 = -1 // 1111
/// let mask: Int4 = 3   // 0011
///
/// print(value & mask)
/// // Prints "3"
/// ```
///
/// Normal arithmetic expects representable results. Use overflow-reporting operations when you want to inspect wrapped
/// partial values.
///
/// For example:
///
/// ```swift
/// let report = Int4.max.addingReportingOverflow(1)
///
/// print(report.partialValue)
/// // Prints "-8"
/// print(report.overflow)
/// // Prints "true"
/// ```
///
/// `Int4.Magnitude` is `UInt4`, so the magnitude of `Int4.min` can still be represented.
///
/// For example:
///
/// ```swift
/// print(Int4.min.magnitude)
/// // Prints "8"
/// ```
///
/// `Int4` values encode and decode as JSON numbers.
///
/// For example:
///
/// ```swift
/// import Foundation
///
/// let value: Int4 = -8
/// let encoder = JSONEncoder()
/// let data = try encoder.encode(value)
///
/// let description = String(
///     data: data,
///     encoding: .utf8
/// )!
///
/// print(description)
/// // Prints "-8"
/// ```
///
/// The encoded value can be decoded from the same representation.
///
/// For example:
///
/// ```swift
/// import Foundation
///
/// let data = Data(#"-8"#.utf8)
/// let decoder = JSONDecoder()
///
/// let value = try decoder.decode(
///     Int4.self,
///     from: data
/// )
///
/// print(value)
/// // Prints "-8"
/// ```
///
/// - Note: `Int4` is intentionally experimental. It is useful for learning, tests, and documentation, but it is not
///   intended to replace Swift's standard signed integer types in application code.
public struct Int4 {
    /// The storage type used to hold the 4-bit value.
    internal typealias Value = Int8

    /// The underlying storage value.
    ///
    /// This value is always constrained to `-8...7`.
    internal let value: Self.Value

    /// Creates a new instance with the specified value.
    ///
    /// - Parameter value: The value of this instance.
    /// - Precondition: `value` must be in the range `-8...7`.
    internal init(value: Self.Value) {
        precondition(
            -8 ... 7 ~= value,
            "Int4 value must be between -8 and 7."
        )
        self.value = value
    }

    /// Creates a value by interpreting the low four bits as two's-complement.
    ///
    /// - Parameter bits: The bits to interpret.
    private init(bitPattern bits: UInt8) {
        let nibble: UInt8 = bits & 0b1111
        let modulus: Self.Value = 16
        let value: Self.Value =
            if nibble >= 0b1000 {
                .init(nibble) - .init(modulus)
            } else {
                .init(nibble)
            }

        self.init(value: value)
    }

    /// The unsigned low four bits of this value.
    private var bitPattern: UInt8 {
        return .init(bitPattern: self.value) & 0b1111
    }
}

// MARK: - Addable

extension Int4: Addable {
    public static func + (
        _ lhs: Self,
        _ rhs: Self
    ) -> Self {
        let newValue: Self.Value = lhs.value + rhs.value
        return .init(value: newValue)
    }
}

// MARK: - AdditiveArithmetic

extension Int4: AdditiveArithmetic {}

// MARK: - BinaryInteger

extension Int4: BinaryInteger {
    /// A one-word collection containing the machine-word representation of an `Int4` value.
    ///
    /// `Int4` always fits in a single machine word.
    public struct Words: RandomAccessCollection, Sendable {
        /// The type of each machine word in the collection.
        public typealias Element = UInt

        /// The type used to index the collection.
        public typealias Index = Int

        /// The single machine word containing this value.
        private let value: UInt

        /// Creates a one-word collection with the specified value.
        ///
        /// - Parameter value: The value stored by the collection.
        internal init(_ value: UInt) {
            self.value = value
        }

        /// The position of the first word.
        public var startIndex: Int {
            return 0
        }

        /// The position after the last word.
        public var endIndex: Int {
            return 1
        }

        /// Accesses the word at the specified position.
        ///
        /// - Parameter position: The position of the word to access.
        /// - Returns: The word at the specified position.
        /// - Precondition: `position` must equal `startIndex`.
        public subscript(position: Int) -> UInt {
            precondition(
                position == self.startIndex,
                "Int4 words index must be zero."
            )

            return self.value
        }

        /// Returns the position immediately after the specified index.
        ///
        /// - Parameter index: A valid index of the collection.
        /// - Returns: The index immediately after `index`.
        /// - Precondition: `index` must equal `startIndex`.
        public func index(after index: Int) -> Int {
            precondition(
                index == self.startIndex,
                "Int4 words index must be the start index."
            )

            return index + 1
        }

        /// Returns the position immediately before the specified index.
        ///
        /// - Parameter index: A valid index of the collection.
        /// - Returns: The index immediately before `index`.
        /// - Precondition: `index` must equal `endIndex`.
        public func index(before index: Int) -> Int {
            precondition(
                index == self.endIndex,
                "Int4 words index must be the end index."
            )

            return index - 1
        }

        /// Returns an index offset from the specified index.
        ///
        /// - Parameters:
        ///   - index: The index to offset.
        ///   - distance: The distance to offset `index` by.
        /// - Returns: An index offset by `distance`.
        /// - Precondition: The resulting index must be between `startIndex` and `endIndex`, inclusive.
        public func index(
            _ index: Int,
            offsetBy distance: Int
        ) -> Int {
            let newIndex: Int = index + distance
            precondition(
                self.startIndex ... self.endIndex ~= newIndex,
                "Int4 words index must be within bounds."
            )

            return newIndex
        }

        /// Returns the distance between two indices.
        ///
        /// - Parameters:
        ///   - start: The starting index.
        ///   - end: The ending index.
        /// - Returns: The distance from `start` to `end`.
        public func distance(
            from start: Int,
            to end: Int
        ) -> Int {
            return end - start
        }
    }

    /// Creates a new instance from the specified integer.
    ///
    /// - Parameter source: The value to use for the new instance.
    /// - Precondition: `source` must be representable in the range `-8...7`.
    public init<T>(_ source: T)
    where T: BinaryInteger {
        guard let value: Self.Value = .init(exactly: source),
            Self.min.value ... Self.max.value ~= value
        else {
            preconditionFailure("Int4 value must be between \(Self.min) and \(Self.max).")
        }

        self.init(value: value)
    }

    /// The machine-word representation of this value.
    public var words: Self.Words {
        return .init(.init(bitPattern: .init(self.value)))
    }

    /// The number of trailing zeros in this value's 4-bit binary representation.
    public var trailingZeroBitCount: Int {
        guard self != 0 else {
            return Self.bitWidth
        }

        return self.bitPattern.trailingZeroBitCount
    }

    /// Stores the bitwise AND of the two specified values in the left-hand-side variable.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand-side value.
    ///   - rhs: The right-hand-side value.
    public static func &= (
        _ lhs: inout Self,
        _ rhs: Self
    ) {
        lhs = .init(bitPattern: lhs.bitPattern & rhs.bitPattern)
    }

    /// Stores the bitwise OR of the two specified values in the left-hand-side variable.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand-side value.
    ///   - rhs: The right-hand-side value.
    public static func |= (
        _ lhs: inout Self,
        _ rhs: Self
    ) {
        lhs = .init(bitPattern: lhs.bitPattern | rhs.bitPattern)
    }

    /// Stores the bitwise XOR of the two specified values in the left-hand-side variable.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand-side value.
    ///   - rhs: The right-hand-side value.
    public static func ^= (
        _ lhs: inout Self,
        _ rhs: Self
    ) {
        lhs = .init(bitPattern: lhs.bitPattern ^ rhs.bitPattern)
    }
}

// MARK: - Comparable

extension Int4: Comparable {
    public static func < (
        _ lhs: Self,
        _ rhs: Self
    ) -> Bool {
        return lhs.value < rhs.value
    }
}

// MARK: - CustomDebugStringConvertible

extension Int4: CustomDebugStringConvertible {
    /// A textual representation of this value suitable for debugging.
    public var debugDescription: String {
        return "Int4(\(self.value))"
    }
}

// MARK: - CustomStringConvertible

extension Int4: CustomStringConvertible {
    public var description: String {
        return self.value.description
    }
}

// MARK: - Decodable

extension Int4: Decodable {
    /// Creates a 4-bit signed integer by decoding a single integer value.
    ///
    /// The decoded value must be in the range `-8...7`.
    ///
    /// - Parameter decoder: The decoder to read data from.
    /// - Throws: A decoding error if the encoded value is not an integer in range.
    public init(from decoder: any Decoder) throws {
        let container: SingleValueDecodingContainer = try decoder.singleValueContainer()
        let value: Self.Value = try container.decode(Self.Value.self)

        guard Self.min.value ... Self.max.value ~= value else {
            let debugDescription: String = "Int4 value must be between \(Self.min) and \(Self.max)."
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: debugDescription
            )
        }

        self.init(value: value)
    }
}

// MARK: - Divisible

extension Int4: Divisible {
    /// Returns the quotient of dividing the first specified value by the second.
    ///
    /// For example:
    ///
    /// ```swift
    /// let dividend: Int4 = 7
    /// let divisor: Int4 = 2
    ///
    /// print(dividend / divisor)
    /// // Prints "3"
    /// ```
    ///
    /// - Parameters:
    ///   - lhs: The dividend.
    ///   - rhs: The divisor.
    /// - Returns: The quotient.
    /// - Precondition: `rhs` must not be zero and the quotient must be representable as `Int4`.
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
    /// let dividend: Int4 = 7
    /// let divisor: Int4 = 2
    ///
    /// print(dividend % divisor)
    /// // Prints "1"
    /// ```
    ///
    /// - Parameters:
    ///   - lhs: The dividend.
    ///   - rhs: The divisor.
    /// - Returns: The remainder.
    /// - Precondition: `rhs` must not be zero and the operation must not overflow.
    public static func % (
        _ lhs: Self,
        _ rhs: Self
    ) -> Self {
        let newValue: Self.Value = lhs.value % rhs.value
        return .init(value: newValue)
    }
}

// MARK: - Encodable

extension Int4: Encodable {
    /// Encodes this value as a single signed integer.
    ///
    /// - Parameter encoder: The encoder to write data to.
    /// - Throws: Any error thrown while encoding the underlying integer value.
    public func encode(to encoder: any Encoder) throws {
        try self.value.encode(to: encoder)
    }
}

// MARK: - Equatable

extension Int4: Equatable {
    public static func == (
        _ lhs: Self,
        _ rhs: Self
    ) -> Bool {
        return lhs.value == rhs.value
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension Int4: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = Int

    /// Creates a value from an integer literal.
    ///
    /// - Parameter value: The integer literal used to create the value.
    /// - Precondition: `value` must be in the range `-8...7`.
    public init(integerLiteral value: Self.IntegerLiteralType) {
        precondition(
            -8 ... 7 ~= value,
            "Int4 integer literal must be between \(Self.min) and \(Self.max)."
        )

        let newValue: Self.Value = .init(value)

        self.init(value: newValue)
    }
}

// MARK: - FixedWidthInteger

extension Int4: FixedWidthInteger {
    public init<T>(truncatingIfNeeded source: T)
    where T: BinaryInteger {
        let bits: UInt8 = .init(truncatingIfNeeded: source)
        self.init(bitPattern: bits)
    }

    public init(_truncatingBits bits: UInt) {
        self.init(truncatingIfNeeded: bits)
    }

    public init<T>(clamping source: T)
    where T: BinaryInteger {
        guard let value: Self.Value = .init(exactly: source) else {
            self = source < 0 ? Self.min : Self.max
            return
        }

        if value < Self.min.value {
            self = Self.min
        } else if value > Self.max.value {
            self = Self.max
        } else {
            self.init(value: value)
        }
    }

    public var nonzeroBitCount: Int {
        return self.bitPattern.nonzeroBitCount
    }

    public var leadingZeroBitCount: Int {
        guard self.value >= 0 else {
            return 0
        }

        guard self != 0 else {
            return Self.bitWidth
        }

        return Self.bitWidth - self.bitPattern.bitWidth + self.bitPattern.leadingZeroBitCount
    }

    public var byteSwapped: Self {
        return self
    }

    public static var bitWidth: Int {
        return 4
    }

    public static var isSigned: Bool {
        return true
    }

    /// Returns the full-width product of this value and another value.
    ///
    /// The result is split into two 4-bit halves. `high` stores the upper four bits as an `Int4` bit pattern, and `low`
    /// stores the lower four bits as a `UInt4` magnitude.
    ///
    /// - Parameter other: The value to multiply by.
    /// - Returns: The high and low halves of the full-width product.
    public func multipliedFullWidth(by other: Self) -> Self.FullWidthProduct {
        let product: Self.Value = self.value * other.value
        let bits: UInt8 = .init(truncatingIfNeeded: product)
        let high: Self = .init(bitPattern: bits >> Self.bitWidth)
        let low: Self.Magnitude = .init(truncatingIfNeeded: bits)

        return (
            high: high,
            low: low
        )
    }

    /// Divides a full-width dividend by this value.
    ///
    /// The dividend is interpreted as two 4-bit halves, where `high` contains the upper bits and `low` contains the
    /// lower bits. The combined 8-bit pattern is then interpreted with signed integer rules before division.
    ///
    /// - Parameter dividend: The high and low halves of the dividend.
    /// - Returns: The quotient and remainder of the division.
    /// - Precondition: This value must not be zero.
    public func dividingFullWidth(_ dividend: Self.FullWidthDividend) -> Self.QuotientAndRemainder {
        precondition(
            self != 0,
            "Divisor must not be zero."
        )

        let raw: UInt8 = (dividend.high.bitPattern << Self.bitWidth) | dividend.low.value
        let signedDividend: Self.Value = .init(bitPattern: raw)
        let result: Self.Value.QuotientAndRemainder = signedDividend.quotientAndRemainder(dividingBy: self.value)
        let quotient: Self = .init(truncatingIfNeeded: result.quotient)
        let remainder: Self = .init(truncatingIfNeeded: result.remainder)

        return (
            quotient: quotient,
            remainder: remainder
        )
    }
}

// MARK: - Hashable

extension Int4: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.value.hashValue)
    }
}

// MARK: - LosslessStringConvertible

extension Int4: LosslessStringConvertible {
    public init?(_ description: String) {
        guard let value: Self.Value = .init(description),
            Self.min.value ... Self.max.value ~= value
        else {
            return nil
        }

        self.init(value: value)
    }
}

// MARK: - Multipliable

extension Int4: Multipliable {
    public static func * (
        _ lhs: Self,
        _ rhs: Self
    ) -> Self {
        let newValue: Self.Value = lhs.value * rhs.value
        return .init(value: newValue)
    }
}

// MARK: - Negateable

extension Int4: Negateable {
    public static prefix func - (_ operand: Self) -> Self {
        let newValue: Self.Value = -operand.value
        return .init(value: newValue)
    }
}

// MARK: - Numeric

extension Int4: Numeric {
    public typealias Magnitude = UInt4

    public init?<Source>(exactly source: Source)
    where Source: BinaryInteger {
        guard let value: Self.Value = .init(exactly: source),
            Self.min.value ... Self.max.value ~= value
        else {
            return nil
        }

        self.init(value: value)
    }

    public var magnitude: Self.Magnitude {
        if self.value == Self.min.value {
            return 8
        }

        let absoluteValue: Self.Value = abs(self.value)
        return .init(value: .init(absoluteValue))
    }
}

// MARK: - Raisable

extension Int4: Raisable {
    public typealias Exponent = Self
}

// MARK: - ReportableAsOverflow

extension Int4: ReportableAsOverflow {
    public func addingReportingOverflow(_ rhs: Self) -> Self.OverflowReport {
        let sum: Self.Value = self.value &+ rhs.value
        let partialValue: Self = .init(truncatingIfNeeded: sum)

        let overflow: Bool =
            if rhs.value > 0 {
                self.value > Self.max.value - rhs.value
            } else if rhs.value < 0 {
                self.value < Self.min.value - rhs.value
            } else {
                false
            }

        return (
            partialValue: partialValue,
            overflow: overflow
        )
    }

    public func subtractingReportingOverflow(_ rhs: Self) -> Self.OverflowReport {
        let difference: Self.Value = self.value &- rhs.value
        let partialValue: Self = .init(truncatingIfNeeded: difference)

        let overflow: Bool =
            if rhs.value > 0 {
                self.value < Self.min.value + rhs.value
            } else if rhs.value < 0 {
                self.value > Self.max.value + rhs.value
            } else {
                false
            }

        return (
            partialValue: partialValue,
            overflow: overflow
        )
    }

    public func multipliedReportingOverflow(by rhs: Self) -> Self.OverflowReport {
        let product: Self.Value = self.value &* rhs.value
        let partialValue: Self = .init(truncatingIfNeeded: product)

        let overflow: Bool =
            if self.value == 0 || rhs.value == 0 {
                false
            } else if self.value > 0 && rhs.value > 0 {
                self.value > Self.max.value / rhs.value
            } else if self.value > 0 && rhs.value < 0 {
                rhs.value < Self.min.value / self.value
            } else if self.value < 0 && rhs.value > 0 {
                self.value < Self.min.value / rhs.value
            } else {
                self.value < Self.max.value / rhs.value
            }

        return (
            partialValue: partialValue,
            overflow: overflow
        )
    }

    public func dividedReportingOverflow(by rhs: Self) -> Self.OverflowReport {
        guard rhs.value != 0 else {
            return (partialValue: self, overflow: true)
        }

        guard self.value != Self.min.value || rhs.value != -1 else {
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

        guard self.value != Self.min.value || rhs.value != -1 else {
            return (partialValue: 0, overflow: true)
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
        case ..<0:
            return (partialValue: 0, overflow: false)
        case 0:
            return (partialValue: 1, overflow: false)
        case 1:
            return (partialValue: self, overflow: false)
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

            return (partialValue: result, overflow: false)
        }
    }
}

// MARK: - RepresentableByMax

extension Int4: RepresentableByMax {
    public static var max: Self {
        return .init(value: 7)
    }
}

// MARK: - RepresentableByMin

extension Int4: RepresentableByMin {
    public static var min: Self {
        return .init(value: -8)
    }
}

// MARK: - RepresentableByZero

extension Int4: RepresentableByZero {
    public static var zero: Self {
        return .init(value: 0)
    }
}

// MARK: - Sendable

extension Int4: Sendable {}

// MARK: - SignedInteger

extension Int4: SignedInteger {}

// MARK: - SignedNumeric

extension Int4: SignedNumeric {}

// MARK: - Strideable

extension Int4: Strideable {}

// MARK: - Subtractable

extension Int4: Subtractable {
    public static func - (
        _ lhs: Self,
        _ rhs: Self
    ) -> Self {
        let newValue: Self.Value = lhs.value - rhs.value
        return .init(value: newValue)
    }
}
