// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import NumericsExtended
import Testing

@Suite("UInt4 BitwiseCopyable Tests")
internal struct UInt4BitwiseCopyableTests {
    internal init() {}

    @Test(
        "Bitwise copying preserves values",
        arguments: [
            0,
            1,
            15
        ] as Array<UInt4>
    )
    internal func bitwiseCopyPreservesValue(value: UInt4) {
        let copy: UInt4 = withUnsafeBytes(of: value) { bytes in
            bytes.loadUnaligned(as: UInt4.self)
        }
        #expect(copy == value)
        #expect(copy.description == value.description)
    }
}
