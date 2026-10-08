// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import CoreNumericProtocols
import StandardNumericProtocols

// MARK: - Addable

extension Int64: Addable {
    public typealias Addend = Self
    public typealias Sum = Self
}

// MARK: - Divisible

extension Int64: Divisible {
    public typealias Divisor = Self
    public typealias RemainderDivisor = Self
}

// MARK: - Multipliable

extension Int64: Multipliable {
    public typealias Multiplier = Self
}

// MARK: - Negateable

extension Int64: Negateable {}

// MARK: - Raisable

extension Int64: Raisable {
    public typealias Exponent = Self
}

// MARK: - ReportableAsOverflow

extension Int64: ReportableAsOverflow {}

// MARK: - RepresentableByZero

extension Int64: RepresentableByZero {}

// MARK: - Subtractable

extension Int64: Subtractable {
    public typealias Subtrahend = Self
}
