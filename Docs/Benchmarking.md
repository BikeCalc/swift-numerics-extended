# Benchmarking

Learn how to measure and compare `Fraction` performance with and without automatic canonicalization.

## Overview

Numerics Extended provides three ways to work with its benchmarks. The `NumericsExtendedBenchmarksPlugin` command
plugin is the convenient interface for developers, the `NumericsExtendedBenchmarks` executable target is the
lower-level measurement engine, and `Scripts/CompareBenchmarkResults.swift` compares previously generated reports.
Performance measurements run only when one of these tools is invoked.

Each benchmark performs 10,000 operations per sample after one warm-up sample. The reported value is the median
duration per operation across ten measured samples. Always use a release build when measuring performance; debug builds
are not representative of optimized package performance. In comparisons, positive percentage changes indicate slower
performance, while negative percentage changes indicate faster performance.

Shared Fraction and Canonicalized Fraction benchmarks use equivalent preconstructed operands. Canonicalized arithmetic
copies a preconstructed wrapper before each operation and includes the canonicalization performed when the result is
assigned back to `wrappedValue`. Initial operand construction is not included in either measurement.

## Command Plugin

The `NumericsExtendedBenchmarksPlugin` command plugin runs the benchmarks in a release build and prints a Markdown
performance comparison to the terminal or Xcode report navigator.

Run the plugin from the repository root:

```shell
swift package plugin --allow-network-connections all benchmark
```

By default, the plugin compares the current working copy with `main`. Override that baseline with another branch, tag,
or commit:

```shell
swift package plugin --allow-network-connections all benchmark --baseline 2.1.0
```

The plugin extracts the baseline into its work directory and builds both revisions independently. It uses the current
benchmark definitions for both revisions so their measurements remain comparable. If the selected baseline predates
the benchmark target, the comparison contains only the current measurements.

Redirect the standard output when a persistent copy of the Markdown comparison is useful:

```shell
swift package plugin --allow-network-connections all benchmark > benchmark-summary.md
```

Network access lets the isolated builds resolve their package dependencies. The builds share a dependency cache while
keeping their compiled artifacts in separate scratch directories, which SwiftPM can reuse while the plugin work
directory remains available.

## Executable Target

The `NumericsExtendedBenchmarks` executable target is the lower-level measurement engine used by the plugin. Invoke it
directly to print its JSON report:

```shell
swift run --configuration release NumericsExtendedBenchmarks
```

Write the machine-readable report to the ignored package build directory with:

```shell
swift run --configuration release NumericsExtendedBenchmarks \
    --output .build/benchmark-results.json
```

An output path is resolved relative to the directory where the command is run. After a successful run, the executable
prints the resolved path of the generated report.

## Comparison Script

`Scripts/CompareBenchmarkResults.swift` compares two previously generated JSON reports and prints the resulting
Markdown table:

```shell
swift Scripts/CompareBenchmarkResults.swift \
    --baseline baseline-results.json \
    --current current-results.json
```

The baseline report is optional. Without one, the script prints only the current measurements:

```shell
swift Scripts/CompareBenchmarkResults.swift \
    --current current-results.json
```

## Continuous Integration

The `Benchmark` workflow invokes the command plugin on the same GitHub Actions runner for both measurements. Pull
requests use their base branch as the baseline, direct pushes to a release branch use `main`, direct pushes to `main`
use the preceding revision, and manual runs use the plugin's default `main` baseline.

If the baseline revision predates the executable target, the workflow reports only the current measurements. Once the
executable target exists in the baseline, both revisions use the current benchmark definitions so that their
measurements remain comparable.

The workflow is informational: performance differences do not fail the job. Build failures, execution failures, and
invalid reports do fail it.
