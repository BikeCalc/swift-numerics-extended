# DecimalAnnex evaluation

Reproduce the integration spike and review the adoption recommendation for issue #48.

## Overview

DecimalAnnex can supply a decimal numeric value for Numerics Extended without implementing decimal arithmetic here.
This prototype adds 15 protocol conformances, tests them through generic functions, and keeps the released package
unchanged. It is an investigation, not a production integration or a compatibility fork.

Recommendation: pursue an optional integration using the upstream implementation and retain the OS 26 availability
boundary. Decide how to expose that integration to Swift 6.4 users before changing the released package. Investigate
older-OS support with the author before committing to maintain a backport.

| Snapshot | Value |
|---|---|
| Evaluation date | 22 November 2026 |
| Tracking issue | [Evaluate DecimalAnnex integration](https://github.com/BikeCalc/swift-numerics-extended/issues/48) |
| Parent proposal | [Add a decimal floating-point type](https://github.com/BikeCalc/swift-numerics-extended/issues/20) |
| Numerics Extended base | `7c881bd0c5cfbf14942cbafe18817d515241ad8b` |
| DecimalAnnex revision | `baef9ff4ad67f87082fa6aa8c5a1e154d1a284ac` |
| Swift Numerics | `1.1.1`, revision `0c0290ff6b24942dadb83a929ffaaa1481df04a2` |
| Macro probe SwiftSyntax | `604.0.0`, revision `050f1a346fbbac0ca2cfb15a95274f7bd1cf0ccf` |
| Successful test environment | Apple Silicon, macOS 27.0.1, Xcode 27.0, Apple Swift 6.4 |
| Swift driver/compiler | `1.168.6` / `swiftlang-6.4.0.34.1` |

## Requirements

- Swift 6.4 and Git for the evaluation packages.
- Apple OS 26 or later to execute the decimal tests; validation here used macOS 27.0.1.
- macOS, an installed Apple SDK, and Python 3.9 or later for the deployment compiler checks.
- Network access to resolve dependencies unless their source repositories are cached or mirrored locally.

Run commands below from the repository root. The main evaluation package deliberately declares macOS 13 while its
decimal conformances are guarded with `@available(anyAppleOS 26.0, *)`. The separate macro probe declares macOS 26.
The root `Package.swift`, its products, and its dependencies are unchanged.

## Continuous integration

The existing root workflows validate the released package. They do not run these nested packages automatically.
The commands in this document are the explicit validation entry points for the spike. A production integration needs
dedicated CI coverage for its supported compiler and deployment configurations.

## Integration tests

```shell
swift test --package-path Spikes/DecimalAnnex
```

The integration imports the existing `NumericsExtended` product and upstream `DecimalCore`. The DecimalAnnex dependency
disables its default traits with `traits: []`. In this configuration, resolution selected DecimalAnnex and Swift
Numerics only; SwiftSyntax and the root package's development-tool dependencies were pruned from this graph.

Twenty tests in three suites passed, including parameterized cases. The tests cover generic protocol dispatch,
decimal inputs, conversion factors, rounding limits, reciprocal policy, special values, representation, and Codable.

| Protocols | Prototype behavior |
|---|---|
| `Addable`, `Subtractable`, `Multipliable` | Existing decimal operators and protocol default named operations |
| `Divisible` | Existing division; `%` forwards to truncating remainder |
| `Negateable` | Existing decimal negation |
| `Invertible` | Existing `FloatingPoint` default policy in Numerics Extended |
| `Raisable` | Existing integer-exponent defaults; exponent type remains `Int` |
| `Increasable`, `Decreasable` | Existing generic floating-point percentage operations |
| `ApproximatelyEquatable` | Swift Numerics' generic approximate comparison with decimal tolerances |
| `RepresentableByZero`, `RepresentableByInfinity`, `RepresentableByNaN` | Existing decimal constants |
| `Roundable`, `Truncatable` | Decimal quantisation with an early return when no rounding is necessary |

The conformances are marked `@retroactive` because the evaluation is a separate package from both owners. A production
target in the package that owns the protocols should revisit that annotation. Do not import multiple competing
adapters defining these conformances.

### Numeric findings

- Decimal `0.1 + 0.2` equals decimal `0.3`.
- `9007199254740993` metres converts to `9007199254740.993` kilometres and back exactly using a decimal `0.001` factor.
  Passing the original integer through `Double` loses information before conversion.
- `1e30 + 0.001` retains the increment; `1e30 + 0.0001` rounds back to `1e30` and reports `.inexact`.
- `36 / 3.6` is exact; `1 / 3.6` and `1 / 3` require rounding.
- `init(nearest: Double(0.1))` retains the binary approximation. `init(shortest:)` chooses a short round-tripping decimal;
  it is a conversion policy, not recovery of arbitrary original decimal input.
- `1.0` and `1.00` compare and hash equally while retaining different quantum and string representations.
  The tested JSON Codable round trip preserves the bit pattern.
- Explicit status APIs report division by zero, invalid operations, overflow, underflow, and inexact arithmetic.
  The generic core protocols do not expose these flags or turn floating-point special results into thrown errors.

### Rounding findings

Directly quantising `1e6144` to a quantum of `1` returns NaN with `.invalid`: the requested coefficient cannot fit
34 digits, despite the numeric value already being an integer. The existing generic multiply-round-divide approach
also risks overflowing its intermediate value for sufficiently large magnitudes or precision requests.

The prototype returns an already representable value unchanged before quantising. Otherwise it coarsens the quantum,
using ties away from zero for `Roundable` and toward zero for `Truncatable`, matching the current binary-float policies.
Requests of 6,176 or more decimal places return finite values unchanged; checking the bound before converting to `Int`
also handles `UInt.max`. All finite decimal128 values are integer multiples of `1e-6176`.

These adapters adjust numeric precision rather than force a particular printed scale. They preserve nonfinite values
unchanged, including signaling NaN. Review that choice and status reporting before production adoption.

The existing reciprocal policy returns `nil` for finite inputs whose quotient is subnormal or overflows. Zero,
infinity, and NaN retain the current floating-point policy. The inherited exponentiation implementation is linear in
the exponent magnitude; this spike does not redesign it or attempt huge exponents.

## Literal macro probe

```shell
swift test --package-path Spikes/DecimalAnnex/MacroProbe
```

Two tests passed with upstream's default macro trait enabled. They verify decimal addition without a binary literal
intermediary, a large integer literal, distinct trailing-zero quantum, and negative zero. Resolution selects SwiftSyntax
604.0.0 in addition to DecimalAnnex. The macro expands on the build host, whose Apple OS must also satisfy the upstream
OS 26 requirement. This adds build tooling, not a runtime C arithmetic dependency.

The macro's diagnostic/fix-it behavior was inspected but is not tested by these two consumer tests. The upstream core
test command below disables macros and therefore does not validate the upstream macro diagnostic suite.

## Deployment probe

```shell
swift run --package-path Spikes/DecimalAnnex DecimalAnnexCompatibilityProbe
xcrun vtool -show-build Spikes/DecimalAnnex/.build/debug/DecimalAnnexCompatibilityProbe
```

The executable built and linked successfully. Its Mach-O `LC_BUILD_VERSION` records `minos 13.0`. On the validation
host it printed `Decimal128: 0.3`. Its older-OS branch uses ordinary `Double` functionality.

This establishes that an OS-26-gated decimal integration can coexist in a macOS-13-targeted executable on this toolchain.
It does not establish runtime behavior on an actual macOS 13 installation. No old macOS runtime or iOS simulator/device
was available for this evaluation. Actual decimal operations remain unavailable below OS 26.

## Deployment compiler checks

After resolving the evaluation dependency, locate its checkout under `Spikes/DecimalAnnex/.build/checkouts/` and run:

```shell
python3 Spikes/DecimalAnnex/CheckCompatibility.py --upstream /path/to/DecimalAnnex
```

The script requires the pinned upstream commit, copies its core into the ignored `.build/compatibility-checks`
directory, and invokes the compiler on the copies. It never edits the upstream checkout. Diagnostic logs and a JSON
summary are saved there. A successful script run means the expected success and rejection cases were observed.

| Case | Observation |
|---|---|
| Original OS 26 annotations; macOS 13 target | Type-check passed |
| Annotations lowered to macOS 15 | Rejected: `InlineArray`, `UTF8Span`, and related newer APIs |
| Annotations lowered to macOS 13 | Rejected for those APIs and standard-library `UInt128` availability |

The high deployment requirement is therefore not an arbitrary manifest setting. Inline arrays are used in arithmetic
lookup tables as well as conversion buffers. String formatting uses `UTF8Span` and newer span/string APIs. Some span
types have back-deployment support, so this finding should not be generalized to every use of `Span`.

### Backport scope

| Goal | Work to investigate |
|---|---|
| macOS 15 / iOS 18 baseline | Alternatives for inline tables/buffers and newer string APIs; revalidate performance and rounding |
| macOS 13 baseline | The above plus alternatives for standard `UInt128`/`Int128`, including their public representation APIs |
| Swift 6.3 compiler | Earlier manifest and SwiftSyntax versions plus audit of 6.4 source features such as `anyAppleOS` |

These are candidate work areas, not demonstrated backports or effort estimates. No arithmetic implementation was
rewritten, no performance benchmark was rerun, and no permanent fork was created.

## Compiler requirements

Swift 6.3.3 was installed alongside Xcode's Swift 6.4 toolchain. Running its `swift package dump-package` against the
spike rejected the manifest with: `using Swift tools version 6.4.0 but the installed version is 6.3.3`.

Attempting a separate baseline root build with that custom toolchain failed while compiling the existing swift-format
dependency manifest: the toolchain reported `unknown argument: '-target-arch-variant'` and a compiler crash when paired
with the installed Xcode 27 SDK. This did not reach the numeric library build. Consequently this spike does not claim
a successful Swift 6.3 baseline build; that check needs a compatible compiler/SDK environment.

Merely leaving the root manifest at tools version 6.3 cannot make a configuration that resolves DecimalAnnex usable
with Swift 6.3. Conversely, compiling the current root package using Swift 6.4 does not itself require editing its tools
version declaration. A separate target/product should not be assumed to isolate dependency resolution from older
toolchains; an optional trait configuration needs its own resolver check.

| Packaging option | Consequence |
|---|---|
| Separate integration package | Existing package avoids the new dependency; integration users require Swift 6.4 |
| Compiler-specific manifests | Can omit the dependency entirely from the older compiler's manifest; maintain and test both graphs |
| Ordinary root dependency | Integration configuration requires Swift 6.4 in practice; explicitly decide and document the support change |

Version-specific manifests and a trait-based root integration were researched as options, not implemented or validated
as alternative package graphs in this spike.

## Regression and upstream validation

```shell
swift test
swift test --package-path /path/to/DecimalAnnex --disable-default-traits
```

- Root Numerics Extended: 1,162 unit tests and 17 integration tests passed.
- Pinned upstream DecimalAnnex: 27 core tests passed using its own manifest and unmodified sources.
- New spike Swift sources passed strict lint using the repository's configured swift-format 603.0.0.

This environment could not resolve `github.com` through Git. Validation used local mirrors for cached dependencies.
The upstream snapshot was obtained through connected GitHub access: all 31 file blob hashes, the complete tree hash,
and the original commit hash were verified before using it as a Git mirror. Both nested packages were then resolved,
built, and tested using their committed manifests. No substitute arithmetic implementation was used.

Local validation also used writable temporary cache paths and SwiftPM's `--disable-sandbox`, because nested
`sandbox-exec` cannot run in this execution environment. Those environment-specific settings and mirror paths are not
committed and are not required on an ordinary developer machine. The lockfiles use canonical upstream identities.

The passing repository tests are not an independent IEEE conformance certification. The external Intel/IBM/Cairo
corpora and upstream benchmark claims have not been independently rerun. Linux, Windows, and physical older Apple
runtimes were not tested.

## Follow-up decision

1. Keep #20 open as the capability proposal and alternatives record.
2. Review the prototype's numeric policies and choose the integration's packaging and compiler-support contract.
3. If proceeding, create a production integration task with CI coverage, documentation, and an old-runtime smoke test.
4. Ask upstream whether optional older-OS fallback implementations fit DecimalAnnex's goals before maintaining a fork.

Suggested upstream discussion, prepared but not posted:

> I am evaluating DecimalAnnex for integration with Numerics Extended. At the pinned revision above, the OS 26
> requirement comes from inline-array lookup tables/buffers and newer string APIs; standard UInt128 also establishes
> an earlier baseline. Would you consider an optional implementation supporting older Apple releases, for example
> macOS 15 / iOS 18, if performance and correctness remain adequately tested? If not, would you prefer downstream
> adapters to retain the OS 26 boundary rather than maintain compatibility changes?

## References

- [DecimalAnnex snapshot](https://github.com/xwu/DecimalAnnex/tree/baef9ff4ad67f87082fa6aa8c5a1e154d1a284ac)
- [DecimalAnnex announcement](https://forums.swift.org/t/native-128-bit-decimal-floating-point-arithmetic/90827)
- [Generic values in Swift Measures](https://github.com/BikeCalc/swift-measures/issues/12)
- [Introducing anyAppleOS](https://forums.swift.org/t/introducing-anyappleos/85728)
- [InlineArray deployment discussion](https://forums.swift.org/t/inlinearray-is-only-available-in-macos-26-0-or-newer/84103)
- [Span deployment guidance](https://forums.swift.org/t/supporting-span-in-packages/81667)
- [Swift version-specific packaging](https://github.com/swiftlang/swift-package-manager/blob/main/Sources/PackageManagerDocs/Documentation.docc/SwiftVersionSpecificPackaging.md)
