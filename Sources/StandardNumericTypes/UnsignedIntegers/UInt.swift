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

extension UInt: Addable {
    public typealias Addend = Self
}

// MARK: - Divisible

extension UInt: Divisible {
    public typealias Divisor = Self
    public typealias RemainderDivisor = Self
}

// MARK: - Multipliable

extension UInt: Multipliable {
    public typealias Multiplier = Self
}

// MARK: - Raisable

extension UInt: Raisable {
    public typealias Exponent = Self
}

// MARK: - ReportableAsOverflow

extension UInt: ReportableAsOverflow {}

// MARK: - RepresentableByZero

extension UInt: RepresentableByZero {}

// MARK: - Subtractable

extension UInt: Subtractable {}
