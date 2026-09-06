// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

/// A property wrapper that keeps its value in its canonical representation.
@propertyWrapper
public struct Canonicalized<Value>
where Value: Canonicalizable {
    /// The canonicalized stored value.
    private var value: Value

    /// Creates a wrapper containing the canonical representation of the specified value.
    ///
    /// - Parameter wrappedValue: The value to canonicalize and store.
    /// - Precondition: `wrappedValue.isCanonicalizable` is `true`.
    public init(wrappedValue: Value) {
        precondition(
            wrappedValue.isCanonicalizable,
            "The wrapped value must be canonicalizable."
        )

        self.value = wrappedValue.canonicalized()
    }

    /// The wrapped value, canonicalized whenever it is assigned.
    ///
    /// - Precondition: An assigned value is canonicalizable.
    public var wrappedValue: Value {
        get {
            return self.value
        }
        set (newValue) {
            precondition(
                newValue.isCanonicalizable,
                "The wrapped value must be canonicalizable."
            )

            self.value = newValue.canonicalized()
        }
    }
}

// MARK: - Comparable

extension Canonicalized: Comparable
where Value: Comparable {
    /// Returns a boolean value indicating whether the first canonicalized value precedes the second.
    ///
    /// - Parameter lhs: The first canonicalized value to compare.
    /// - Parameter rhs: The second canonicalized value to compare.
    /// - Returns: The result of comparing the wrapped canonical values.
    public static func < (
        _ lhs: Self,
        _ rhs: Self
    ) -> Bool {
        return lhs.wrappedValue < rhs.wrappedValue
    }

    /// Returns a boolean value indicating whether the first canonicalized value precedes or equals the second.
    ///
    /// - Parameter lhs: The first canonicalized value to compare.
    /// - Parameter rhs: The second canonicalized value to compare.
    /// - Returns: `true` when the first value precedes or equals the second, and `false` otherwise.
    public static func <= (
        _ lhs: Self,
        _ rhs: Self
    ) -> Bool {
        return lhs.wrappedValue <= rhs.wrappedValue
    }

    /// Returns a boolean value indicating whether the first canonicalized value follows the second.
    ///
    /// - Parameter lhs: The first canonicalized value to compare.
    /// - Parameter rhs: The second canonicalized value to compare.
    /// - Returns: `true` when the first value follows the second, and `false` otherwise.
    public static func > (
        _ lhs: Self,
        _ rhs: Self
    ) -> Bool {
        return lhs.wrappedValue > rhs.wrappedValue
    }

    /// Returns a boolean value indicating whether the first canonicalized value follows or equals the second.
    ///
    /// - Parameter lhs: The first canonicalized value to compare.
    /// - Parameter rhs: The second canonicalized value to compare.
    /// - Returns: `true` when the first value follows or equals the second, and `false` otherwise.
    public static func >= (
        _ lhs: Self,
        _ rhs: Self
    ) -> Bool {
        return lhs.wrappedValue >= rhs.wrappedValue
    }
}

// MARK: - Decodable

extension Canonicalized: Decodable
where Value: Decodable {
    /// Creates a wrapper by decoding and canonicalizing a value.
    ///
    /// - Parameter decoder: The decoder to read data from.
    /// - Throws: Any error thrown while decoding `Value`, or `DecodingError.dataCorrupted` when the decoded value is
    ///   not canonicalizable.
    public init(from decoder: any Decoder) throws {
        let value: Value = try .init(from: decoder)

        guard value.isCanonicalizable else {
            throw DecodingError.dataCorrupted(
                .init(
                    codingPath: decoder.codingPath,
                    debugDescription: "The decoded value must be canonicalizable."
                )
            )
        }

        self.init(wrappedValue: value)
    }
}

// MARK: - Encodable

extension Canonicalized: Encodable
where Value: Encodable {
    /// Encodes the canonicalized wrapped value.
    ///
    /// - Parameter encoder: The encoder to write data to.
    /// - Throws: Any error thrown while encoding `Value`.
    public func encode(to encoder: any Encoder) throws {
        try self.wrappedValue.encode(to: encoder)
    }
}

// MARK: - Equatable

extension Canonicalized: Equatable
where Value: Equatable {}

// MARK: - Hashable

extension Canonicalized: Hashable
where Value: Hashable {}

// MARK: - Sendable

extension Canonicalized: Sendable
where Value: Sendable {}
