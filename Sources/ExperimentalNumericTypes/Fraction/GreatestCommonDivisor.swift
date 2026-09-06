// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

/// Returns the greatest common divisor of the specified values.
///
/// Either operand may be zero. The greatest common divisor of zero and a nonzero value has the magnitude of the nonzero
/// value, while the greatest common divisor of two zero values is zero. The unsigned result represents the
/// mathematically nonnegative divisor even when that value cannot be represented by `Value`, such as the magnitude of a
/// signed minimum value.
///
/// - Parameters:
///   - lhs: The first value.
///   - rhs: The second value.
/// - Returns: The nonnegative greatest common divisor.
internal func gcd<Value>(
    _ lhs: Value,
    _ rhs: Value
) -> Value.Magnitude
where Value: BinaryInteger {
    var dividend: Value.Magnitude = lhs.magnitude
    var divisor: Value.Magnitude = rhs.magnitude

    while divisor != 0 {
        let remainder: Value.Magnitude = dividend % divisor
        dividend = divisor
        divisor = remainder
    }

    return dividend
}
