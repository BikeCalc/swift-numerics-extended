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

/// A four-bit unsigned integer value from `0` through `15`.
///
/// Use `UInt4` to experiment with unsigned fixed-width integer behavior in a range small enough to inspect by hand. The
/// type uses `UInt8` storage internally, but only the low four bits define its integer behavior.
///
/// For example:
///
/// ```swift
/// let value: UInt4 = 15
///
/// print(value)
/// // Prints "15"
/// ```
///
/// Create `UInt4` values from integer literals, exact integer conversion, or decimal strings.
///
/// For example:
///
/// ```swift
/// let literal: UInt4 = 15
/// let exact = UInt4(exactly: 15)
/// let string = UInt4("15")
/// let invalid = UInt4(exactly: 16)
///
/// print(literal)
/// // Prints "15"
/// print(exact)
/// // Prints "Optional(15)"
/// print(string)
/// // Prints "Optional(15)"
/// print(invalid)
/// // Prints "nil"
/// ```
///
/// Use truncating initialization to keep only the low four bits of a source value.
///
/// For example:
///
/// ```swift
/// print(UInt4(truncatingIfNeeded: 15))
/// // Prints "15"
/// print(UInt4(truncatingIfNeeded: 16))
/// // Prints "0"
/// print(UInt4(truncatingIfNeeded: 17))
/// // Prints "1"
/// ```
///
/// `UInt4` supports whole-number arithmetic, comparison, bitwise operations, and fixed-width integer APIs.
///
/// For example:
///
/// ```swift
/// let twelve: UInt4 = 12 // 1100
/// let ten: UInt4 = 10    // 1010
///
/// print(twelve & ten)
/// // Prints "8"
/// print(twelve | ten)
/// // Prints "14"
/// print(twelve ^ ten)
/// // Prints "6"
/// ```
///
/// Normal arithmetic expects representable results. Use overflow-reporting operations when you want to inspect wrapped
/// partial values.
///
/// For example:
///
/// ```swift
/// let report = UInt4.max.addingReportingOverflow(1)
///
/// print(report.partialValue)
/// // Prints "0"
/// print(report.overflow)
/// // Prints "true"
/// ```
///
/// `UInt4` values encode and decode as JSON numbers.
///
/// For example:
///
/// ```swift
/// import Foundation
///
/// let value: UInt4 = 15
/// let encoder = JSONEncoder()
/// let data = try encoder.encode(value)
///
/// let description = String(
///     data: data,
///     encoding: .utf8
/// )!
///
/// print(description)
/// // Prints "15"
/// ```
///
/// The encoded value can be decoded from the same representation.
///
/// For example:
///
/// ```swift
/// import Foundation
///
/// let data = Data(#"15"#.utf8)
/// let decoder = JSONDecoder()
///
/// let value = try decoder.decode(
///     UInt4.self,
///     from: data
/// )
///
/// print(value)
/// // Prints "15"
/// ```
///
/// - Note: `UInt4` is intentionally experimental. It is useful for learning, tests, and documentation, but it is not
///   intended to replace Swift's standard unsigned integer types in application code.
public struct UInt4 {
    /// The storage type used to hold the 4-bit value.
    internal typealias Value = UInt8

    /// The underlying storage value.
    ///
    /// This value is always constrained to `0...15`.
    internal let value: Self.Value

    /// Creates a new instance with the specified value.
    ///
    /// - Parameter value: The value of this instance.
    /// - Precondition: `value` must be in the range `0...15`.
    internal init(value: Self.Value) {
        precondition(
            0 ... 15 ~= value,
            "UInt4 value must be between \(Self.min) and \(Self.max)."
        )
        self.value = value
    }
}

// MARK: - Addable

extension UInt4: Addable {
    public static func + (
        _ lhs: Self,
        _ rhs: Self
    ) -> Self {
        let newValue: Self.Value = lhs.value + rhs.value
        return .init(value: newValue)
    }
}

// MARK: - AdditiveArithmetic

extension UInt4: AdditiveArithmetic {}

// MARK: - BinaryInteger

extension UInt4: BinaryInteger {
    /// A one-word collection containing the machine-word representation of a `UInt4` value.
    ///
    /// `UInt4` always fits in a single machine word.
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
                "UInt4 words index must be zero."
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
                "UInt4 words index must be the start index."
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
                "UInt4 words index must be the end index."
            )

            return index - 1
        }

        /// Returns an index offset from the specified index.
        ///
        /// - Parameter index: The index to offset.
        /// - Parameter distance: The distance to offset `index` by.
        /// - Returns: An index offset by `distance`.
        /// - Precondition: The resulting index must be between `startIndex` and `endIndex`, inclusive.
        public func index(
            _ index: Int,
            offsetBy distance: Int
        ) -> Int {
            let newIndex: Int = index + distance
            precondition(
                self.startIndex ... self.endIndex ~= newIndex,
                "UInt4 words index must be within bounds."
            )

            return newIndex
        }

        /// Returns the distance between two indices.
        ///
        /// - Parameter start: The starting index.
        /// - Parameter end: The ending index.
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
    /// - Precondition: `source` must be representable in the range `0...15`.
    public init<T>(_ source: T)
    where T: BinaryInteger {
        guard let value: Self.Value = .init(exactly: source),
            Self.min.value ... Self.max.value ~= value
            preconditionFailure("UInt4 value must be between \(Self.min) and \(Self.max).")
        }

        self.init(value: value)
    }

    /// The machine-word representation of this value.
    public var words: Self.Words {
        return .init(.init(self.value))
    }

    /// The number of trailing zeros in this value's 4-bit binary representation.
    public var trailingZeroBitCount: Int {
        guard self != 0 else {
            return Self.bitWidth
        }

        return self.value.trailingZeroBitCount
    }

    /// Stores the bitwise AND of the two specified values in the left-hand-side variable.
    ///
    /// - Parameter lhs: The left-hand-side value.
    /// - Parameter rhs: The right-hand-side value.
    public static func &= (
        _ lhs: inout Self,
        _ rhs: Self
    ) {
        lhs = .init(value: lhs.value & rhs.value)
    }

    /// Stores the bitwise OR of the two specified values in the left-hand-side variable.
    ///
    /// - Parameter lhs: The left-hand-side value.
    /// - Parameter rhs: The right-hand-side value.
    public static func |= (
        _ lhs: inout Self,
        _ rhs: Self
    ) {
        lhs = .init(value: lhs.value | rhs.value)
    }

    /// Stores the bitwise XOR of the two specified values in the left-hand-side variable.
    ///
    /// - Parameter lhs: The left-hand-side value.
    /// - Parameter rhs: The right-hand-side value.
    public static func ^= (
        _ lhs: inout Self,
        _ rhs: Self
    ) {
        lhs = .init(value: lhs.value ^ rhs.value)
    }
}

// MARK: - Comparable

extension UInt4: Comparable {
    public static func < (
        _ lhs: Self,
        _ rhs: Self
    ) -> Bool {
        return lhs.value < rhs.value
    }
}

// MARK: - CustomDebugStringConvertible

extension UInt4: CustomDebugStringConvertible {
    /// A textual representation of this value suitable for debugging.
    public var debugDescription: String {
        return "UInt4(\(self.value))"
    }
}

// MARK: - CustomStringConvertible

extension UInt4: CustomStringConvertible {
    public var description: String {
        return self.value.description
    }
}

// MARK: - Decodable

extension UInt4: Decodable {
    /// Creates a 4-bit unsigned integer by decoding a single integer value.
    ///
    /// The decoded value must be in the range `0...15`.
    ///
    /// - Parameter decoder: The decoder to read data from.
    /// - Throws: A decoding error if the encoded value is not an integer in range.
    public init(from decoder: any Decoder) throws {
        let container: SingleValueDecodingContainer = try decoder.singleValueContainer()
        let value: Self.Value = try container.decode(Self.Value.self)

        guard Self.min.value ... Self.max.value ~= value else {
            let debugDescription: String = "UInt4 value must be between \(Self.min) and \(Self.max)."
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: debugDescription
            )
        }

        self.init(value: value)
    }
}

// MARK: - Divisible

extension UInt4: Divisible {
    /// Returns the quotient of dividing the first specified value by the second.
    ///
    /// For example:
    ///
    /// ```swift
    /// let dividend: UInt4 = 7
    /// let divisor: UInt4 = 2
    ///
    /// print(dividend / divisor)
    /// // Prints "3"
    /// ```
    ///
    /// - Parameter lhs: The dividend.
    /// - Parameter rhs: The divisor.
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
    /// let dividend: UInt4 = 7
    /// let divisor: UInt4 = 2
    ///
    /// print(dividend % divisor)
    /// // Prints "1"
    /// ```
    ///
    /// - Parameter lhs: The dividend.
    /// - Parameter rhs: The divisor.
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

extension UInt4: Encodable {
    /// Encodes this value as a single unsigned integer.
    ///
    /// - Parameter encoder: The encoder to write data to.
    /// - Throws: Any error thrown while encoding the underlying integer value.
    public func encode(to encoder: any Encoder) throws {
        try self.value.encode(to: encoder)
    }
}

// MARK: - Equatable

extension UInt4: Equatable {
    public static func == (
        _ lhs: Self,
        _ rhs: Self
    ) -> Bool {
        return lhs.value == rhs.value
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension UInt4: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = Int

    /// Creates a value from an integer literal.
    ///
    /// - Parameter value: The integer literal used to create the value.
    /// - Precondition: `value` must be in the range `0...15`.
    public init(integerLiteral value: Self.IntegerLiteralType) {
        precondition(
            0 ... 15 ~= value,
            "UInt4 integer literal must be between \(Self.min) and \(Self.max)."
        )

        let newValue: Self.Value = .init(value)

        self.init(value: newValue)
    }
}

// MARK: - FixedWidthInteger

extension UInt4: FixedWidthInteger {
    /// Creates a new instance by keeping the low four bits of the specified value.
    ///
    /// - Parameter source: The value whose low four bits are used.
    public init<T>(truncatingIfNeeded source: T)
    where T: BinaryInteger {
        let value: Self.Value = .init(truncatingIfNeeded: source) & 0b1111

        self.init(value: value)
    }

    /// Creates a new instance from raw truncating bits.
    ///
    /// - Parameter bits: The raw bits used to create the value.
    public init(_truncatingBits bits: UInt) {
        self.init(truncatingIfNeeded: bits)
    }

    /// Creates a new instance by clamping the specified value.
    ///
    /// - Parameter source: The value to clamp.
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

    /// The number of nonzero bits in this value's 4-bit binary representation.
    public var nonzeroBitCount: Int {
        return (self.value & 0b1111).nonzeroBitCount
    }

    /// The number of leading zeros in this value's 4-bit binary representation.
    public var leadingZeroBitCount: Int {
        guard self != 0 else {
            return Self.bitWidth
        }

        return Self.bitWidth - self.value.bitWidth + self.value.leadingZeroBitCount
    }

    /// The byte-swapped representation of this value.
    ///
    /// Byte swapping is a no-op because `UInt4` is smaller than one byte.
    public var byteSwapped: Self {
        return self
    }

    /// The number of bits used to represent a `UInt4` value.
    public static var bitWidth: Int {
        return 4
    }

    /// A boolean value indicating whether this type is signed.
    public static var isSigned: Bool {
        return false
    }

    /// Returns the full-width product of this value and another value.
    ///
    /// The result is split into two 4-bit halves. For example, `15 * 15` produces the 8-bit value `225`, represented as
    /// high `14` and low `1`.
    ///
    /// - Parameter other: The value to multiply by.
    /// - Returns: The high and low halves of the full-width product.
    public func multipliedFullWidth(by other: Self) -> Self.FullWidthProduct {
        let product: Self.Value = self.value * other.value
        let high: Self = .init(truncatingIfNeeded: product >> Self.bitWidth)
        let low: Self.Magnitude = .init(truncatingIfNeeded: product)

        return (
            high: high,
            low: low
        )
    }

    /// Divides a full-width dividend by this value.
    ///
    /// The dividend is interpreted as two 4-bit halves, where `high` contains the upper bits and `low` contains the
    /// lower bits.
    ///
    /// - Parameter dividend: The high and low halves of the dividend.
    /// - Returns: The quotient and remainder of the division.
    /// - Precondition: This value must not be zero.
    public func dividingFullWidth(_ dividend: Self.FullWidthDividend) -> Self.QuotientAndRemainder {
        precondition(
            self != 0,
            "Divisor must not be zero."
        )

        let value: Self.Value = (dividend.high.value << Self.bitWidth) | dividend.low.value
        let result: Self.Value.QuotientAndRemainder = value.quotientAndRemainder(dividingBy: self.value)
        let quotient: Self = .init(truncatingIfNeeded: result.quotient)
        let remainder: Self = .init(truncatingIfNeeded: result.remainder)

        return (
            quotient: quotient,
            remainder: remainder
        )
    }
}

// MARK: - Hashable

extension UInt4: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.value.hashValue)
    }
}

// MARK: - LosslessStringConvertible

extension UInt4: LosslessStringConvertible {
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

extension UInt4: Multipliable {
    public static func * (
        _ lhs: Self,
        _ rhs: Self
    ) -> Self {
        let newValue: Self.Value = lhs.value * rhs.value
        return .init(value: newValue)
    }
}

// MARK: - Numeric

extension UInt4: Numeric {
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

    public var magnitude: Self {
        return self
    }
}

// MARK: - Raisable

extension UInt4: Raisable {
    public typealias Exponent = Self
}

// MARK: - ReportableAsOverflow

extension UInt4: ReportableAsOverflow {
    public func addingReportingOverflow(_ rhs: Self) -> Self.OverflowReport {
        let sum: Self.Value = self.value + rhs.value
        let partialValue: Self = .init(truncatingIfNeeded: sum)

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
        let difference: Self.Value = self.value &- rhs.value
        let partialValue: Self = .init(truncatingIfNeeded: difference)

        guard self.value >= rhs.value else {
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

    public func multipliedReportingOverflow(by rhs: Self) -> Self.OverflowReport {
        let product: Self.Value = self.value * rhs.value
        let partialValue: Self = .init(truncatingIfNeeded: product)

        guard product <= Self.max.value else {
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

            return (
                partialValue: result,
                overflow: false
            )
        }
    }
}

// MARK: - RepresentableByMax

extension UInt4: RepresentableByMax {
    public static var max: Self {
        return .init(value: 15)
    }
}

// MARK: - RepresentableByMin

extension UInt4: RepresentableByMin {
    public static var min: Self {
        return .init(value: 0)
    }
}

// MARK: - RepresentableByZero

extension UInt4: RepresentableByZero {
    public static var zero: Self {
        return .init(value: 0)
    }
}

// MARK: - Sendable

extension UInt4: Sendable {}

// MARK: - Strideable

extension UInt4: Strideable {}

// MARK: - Subtractable

extension UInt4: Subtractable {
    public static func - (
        _ lhs: Self,
        _ rhs: Self
    ) -> Self {
        let newValue: Self.Value = lhs.value - rhs.value
        return .init(value: newValue)
    }
}

// MARK: - UnsignedInteger

extension UInt4: UnsignedInteger {}
