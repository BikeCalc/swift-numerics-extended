# Package Architecture

Understand how the targets in Numerics Extended are organized and how they depend on one another.

## Overview

Numerics Extended separates fundamental operators and protocols from standard-library conformances and experimental
APIs. Core operators and protocols form the foundation; the standard and experimental protocol layers build reusable
numeric behavior above them, and the type layers provide concrete conformances and implementations.

The package also contains command plugins, an executable benchmark target, and a test target. These targets support
development and validation without becoming part of the public library product.

## Package Tooling

The benchmarks plugin invokes the executable benchmark target, which depends on the public library. The linter plugin
invokes Swift Format, while the test target depends on the public library.

```text
NumericsExtendedBenchmarksPlugin
└─> invokes NumericsExtendedBenchmarks
    └─> depends on NumericsExtended

NumericsExtendedLinterPlugin
└─> invokes swift-format

NumericsExtendedTests
└─> depends on NumericsExtended
```

## Library Targets

`NumericsExtended` collects every source target into the package's public library, while the individual targets preserve
those architectural boundaries internally.

```text
                                  +-------------------------------+
                                  |        NumericsExtended       |
                                  +---------------+---------------+
                                                  |
                                 +----------------+----------------+
                                 |                                 |
                                 v                                 v
                 +-------------------------------+ +-------------------------------+
                 |   ExperimentalNumericTypes    | | ExperimentalNumericConstants  |
                 +---------------+---------------+ +-------------------------------+
                                 |
                +----------------+----------------+
                |                                 |
                v                                 v
+-------------------------------+ +-------------------------------+
|     StandardNumericTypes      | | ExperimentalNumericProtocols  |
+---------------+---------------+ +---------------+---------------+
                |                                 |
                v                                 |
+-------------------------------+                 |
|   StandardNumericProtocols    |                 |
+---------------+---------------+                 |
                |                                 |
                +--------------->+<---------------+
                                 |
                                 v
                 +-------------------------------+
                 |     CoreNumericProtocols      |
                 +---------------+---------------+
                                 |
                                 v
                 +-------------------------------+
                 |     CoreNumericOperators      |
                 +-------------------------------+
```

Read each arrow downward from a target to one of its direct dependencies. Some direct edges are omitted to keep the
routes readable, so the absence of an arrow does not prove that two targets are unrelated. Vertical placement keeps the
dependency flow clear rather than assigning targets to semantic tiers; consult the package manifest for the complete,
authoritative definitions.
