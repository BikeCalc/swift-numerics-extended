// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

extension Comparable {
    /// Returns a boolean value indicating whether this value is less than the specified value.
    ///
    /// - Parameter rhs: Another value to compare.
    /// - Returns: A boolean indicating whether this value is less than the specified value.
    public func isLess(than rhs: Self) -> Bool {
        return self < rhs
    }

    /// Returns a boolean value indicating whether this value is less than or equal to the specified value.
    ///
    /// - Parameter rhs: Another value to compare.
    /// - Returns: A boolean indicating whether this value is less than or equal to the specified value.
    public func isLessThanOrEqual(to rhs: Self) -> Bool {
        return self <= rhs
    }

    /// Returns a boolean value indicating whether this value is greater than the specified value.
    ///
    /// - Parameter rhs: Another value to compare.
    /// - Returns: A boolean indicating whether this value is greater than the specified value.
    public func isGreater(than rhs: Self) -> Bool {
        return self > rhs
    }

    /// Returns a boolean value indicating whether this value is greater than or equal to the specified value.
    ///
    /// - Parameter rhs: Another value to compare.
    /// - Returns: A boolean indicating whether this value is greater than or equal to the specified value.
    public func isGreaterThanOrEqual(to rhs: Self) -> Bool {
        return self >= rhs
    }

    /// Returns a boolean value indicating whether this value is within a specified closed range.
    ///
    /// - Parameter closedRange: An interval from a lower bound up to, and including, an upper bound.
    /// - Returns: A boolean value.
    public func isWithin(_ closedRange: ClosedRange<Self>) -> Bool {
        return closedRange ~= self
    }

    /// Returns a boolean value indicating whether this value is within two specified values.
    ///
    /// - Parameters:
    ///   - lowerBound: The lower bound value.
    ///   - upperBound: The upper bound value.
    /// - Returns: A boolean value.
    /// - Precondition: `lowerBound` must be less than `upperBound`.
    public func isWithin(
        _ lowerBound: Self,
        _ upperBound: Self
    ) -> Bool {
        precondition(
            lowerBound < upperBound,
            "Lower bound must be less than upper bound."
        )

        let closedRange: ClosedRange<Self> = lowerBound ... upperBound

        return self.isWithin(closedRange) == true
    }

    /// Returns a boolean value indicating whether this value is between two specified values.
    ///
    /// - Parameters:
    ///   - lowerBound: The lower bound value.
    ///   - upperBound: The upper bound value.
    /// - Returns: A boolean value.
    /// - Precondition: `lowerBound` must be less than `upperBound`.
    public func isBetween(
        _ lowerBound: Self,
        _ upperBound: Self
    ) -> Bool {
        precondition(
            lowerBound < upperBound,
            "Lower bound must be less than upper bound."
        )

        return lowerBound < self && self < upperBound
    }
}
