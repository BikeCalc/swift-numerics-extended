// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

/// A type that can report whether arithmetic operations overflow.
public protocol ReportableAsOverflow: Operatable, Raisable {
    /// Returns the sum after adding the specified value to this instance, along with a boolean value indicating whether
    /// overflow occurred in the operation.
    ///
    /// - Parameter rhs: The value to add to this instance.
    /// - Returns: A tuple containing the result of the addition along with a boolean value indicating whether overflow
    ///   occurred.
    func addingReportingOverflow(_ rhs: Self) -> Self.OverflowReport

    /// Returns the difference after subtracting the specified value from this instance, along with a boolean value
    /// indicating whether overflow occurred in the operation.
    ///
    /// - Parameter rhs: The value to subtract from this instance.
    /// - Returns: A tuple containing the result of the subtraction along with a boolean value indicating whether
    ///   overflow occurred.
    func subtractingReportingOverflow(_ rhs: Self) -> Self.OverflowReport

    /// Returns the product after multiplying this instance by the specified value, along with a boolean value
    /// indicating whether overflow occurred in the operation.
    ///
    /// - Parameter rhs: The value to multiply this instance by.
    /// - Returns: A tuple containing the result of the multiplication along with a boolean value indicating whether
    ///   overflow occurred.
    func multipliedReportingOverflow(by rhs: Self) -> Self.OverflowReport

    /// Returns the quotient after dividing this instance by the specified value, along with a boolean value indicating
    /// whether overflow occurred in the operation.
    ///
    /// - Parameter rhs: The value to divide this instance by.
    /// - Returns: A tuple containing the result of the division along with a boolean value indicating whether overflow
    ///   occurred.
    func dividedReportingOverflow(by rhs: Self) -> Self.OverflowReport

    /// Returns the remainder after dividing this instance by the specified value, along with a boolean value indicating
    /// whether overflow occurred in the operation.
    ///
    /// - Parameter rhs: The value to divide this instance by.
    /// - Returns: A tuple containing the result of the division along with a boolean value indicating whether overflow
    ///   occurred.
    func remainderReportingOverflow(dividingBy rhs: Self) -> Self.OverflowReport

    /// Returns the partial value of raising this instance to the specified exponent, along with a boolean value
    /// indicating whether the operation overflowed or was invalid.
    ///
    /// For integer arithmetic with signed exponents, negative powers follow integer division: powers of `1` and `-1`
    /// remain exact, while other nonzero bases produce zero. A zero base with a negative exponent returns a partial
    /// value of zero and reports overflow. An exponent of zero returns one, including when the base is zero.
    ///
    /// When overflow is reported, the partial value is not guaranteed to represent the final mathematical power.
    ///
    /// - Parameter rhs: The exponent.
    /// - Returns: The partial value and a boolean indicating whether the operation overflowed or was invalid.
    func raisedReportingOverflow(to rhs: Self.Exponent) -> Self.OverflowReport
}

extension ReportableAsOverflow {
    /// The partial value and overflow status produced by an overflow-reporting operation.
    public typealias OverflowReport = (
        partialValue: Self,
        overflow: Bool
    )
}
