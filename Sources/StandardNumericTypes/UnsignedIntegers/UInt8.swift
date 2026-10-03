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

extension UInt8: Addable {
    public typealias Addend = Self
}

// MARK: - Divisible

extension UInt8: Divisible {}

// MARK: - Multipliable

extension UInt8: Multipliable {}

// MARK: - Raisable

extension UInt8: Raisable {
    public typealias Exponent = Self
}

// MARK: - ReportableAsOverflow

extension UInt8: ReportableAsOverflow {}

// MARK: - RepresentableByZero

extension UInt8: RepresentableByZero {}

// MARK: - Subtractable

extension UInt8: Subtractable {}
