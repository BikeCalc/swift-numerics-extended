// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import NumericsExtended
import Testing

@Suite("Int4 BitwiseCopyable Tests")
internal struct Int4BitwiseCopyableTests {
    internal init() {}

    @Test(
        "Bitwise copying preserves values",
        arguments: [
            -8,
            -1,
            0,
            1,
            7
        ] as Array<Int4>
    )
    internal func bitwiseCopyPreservesValue(value: Int4) {
        let copy: Int4 = withUnsafeBytes(of: value) { bytes in
            bytes.loadUnaligned(as: Int4.self)
        }
        #expect(copy == value)
        #expect(copy.description == value.description)
    }
}
