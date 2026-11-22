// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import CoreNumericProtocols
import Numerics

// MARK: - Addable

extension Complex: Addable {
    public typealias Addend = Self

    public typealias Sum = Self
}

// MARK: - ApproximatelyEquatable

extension Complex: ApproximatelyEquatable {
    public typealias AbsoluteTolerance = Self.Magnitude

    public typealias RelativeTolerance = Self.Magnitude
}

// MARK: - Invertible

extension Complex: Invertible {
    public typealias Reciprocal = Self

    public var isInvertible: Bool {
        return self.reciprocal != nil
    }
}

// MARK: - Negateable

extension Complex: Negateable {}

// MARK: - RepresentableByZero

extension Complex: RepresentableByZero {}

// MARK: - Subtractable

extension Complex: Subtractable {
    public typealias Subtrahend = Self

    public typealias Difference = Self
}
