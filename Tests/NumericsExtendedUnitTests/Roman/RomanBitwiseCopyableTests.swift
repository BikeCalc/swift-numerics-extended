// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import NumericsExtended
import Testing

@Suite("Roman BitwiseCopyable Tests")
internal struct RomanBitwiseCopyableTests {
    internal init() {}

    @Test(
        "Bitwise copying preserves values",
        arguments: [
            0,
            1,
            4,
            16,
            3_999
        ] as Array<Roman>
    )
    internal func bitwiseCopyPreservesValue(value: Roman) {
        let copy: Roman = withUnsafeBytes(of: value) { bytes in
            bytes.loadUnaligned(as: Roman.self)
        }
        #expect(copy == value)
        #expect(copy.description == value.description)
    }
}
