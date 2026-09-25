# Benchmarking

Measure and compare performance across revisions.

## Overview

Numerics Extended provides a CI runner and tools for measuring and comparing benchmarks. The
`NumericsExtendedBenchmarksPlugin` command plugin is the convenient interface for developers, the
`NumericsExtendedBenchmarks` executable target is the lower-level measurement engine, and
`Scripts/GenerateBenchmarkReport.swift` compares previously generated reports. Performance measurements run only when
one of these tools is invoked.

Each benchmark performs 10,000 operations per sample after ten warm-up samples. The reported value is the median
duration per operation across ten measured samples. Always use a release build when measuring performance; debug builds
are not representative of optimized package performance. In comparisons, positive percentage changes indicate slower
performance, while negative percentage changes indicate faster performance.

Shared Fraction and Canonicalized Fraction benchmarks use equivalent preconstructed operands. Canonicalized arithmetic
copies a preconstructed wrapper before each operation and includes the canonicalization performed when the result is
assigned back to `wrappedValue`. Initial operand construction is not included in either measurement.

## Requirements

Use Swift 6.3 or later and run commands from the repository root in a Git checkout. CI uses macOS 26. Comparisons need
an available baseline revision and network access for uncached dependencies. Measure both revisions on the same machine
with a release build to reduce environmental differences.

## Continuous Integration

The [Benchmark workflow](/.github/workflows/benchmark.yml) runs on pushes to `main`, pull requests targeting `main` or
`release/**` when opened, reopened, or updated, and manual dispatch. Its `Compare Benchmarks` job checks out full
history and invokes the runner below. Pull requests use their base SHA; pushes to `main` use the preceding SHA; manual
runs use the plugin's default `main` baseline. Both revisions are measured on the same runner.

The workflow appends the comparison to the GitHub Actions summary. Performance differences do not fail the job; build
failures, execution failures, invalid reports, and unavailable selected baselines do. The job has a 20-minute timeout,
and superseded runs for the same branch or pull request are cancelled.

## Benchmark Runner

[RunBenchmarks.swift](/Scripts/RunBenchmarks.swift) selects and prepares the baseline before invoking the plugin:

```shell
swift Scripts/RunBenchmarks.swift
swift Scripts/RunBenchmarks.swift --baseline main
```

Use `--baseline <revision>` to select a comparison revision explicitly. Without an explicit baseline, the benchmark
plugin currently defaults to `main`.

For automatic selection, use `RunBenchmarks.swift --event <event> <base-sha> <before-sha> <ref-name>`, as the workflow
does. Pull requests select their base SHA; pushes to `main` select the previous SHA unless it is all zeros;
release-branch pushes select `origin/main`. When no revision is selected, the script omits the plugin's baseline
argument, leaving its default in effect. The workflow's configured triggers determine which events actually run.

For a selected baseline, the script checks that the commit exists locally before invoking the plugin. If missing, it
fetches the revision from `origin` and checks again. This supports previous commits replaced by an amended or
force-pushed history while the remote still makes them available. An unavailable baseline fails the run with a clear
diagnostic; it does not silently skip the comparison.

Use either `--baseline` or `--event`; the two modes cannot be combined. See the command plugin below for its options and
baseline compatibility behavior.

## Command Plugin

The [NumericsExtendedBenchmarksPlugin](/Plugins/NumericsExtendedBenchmarksPlugin/NumericsExtendedBenchmarksPlugin.swift)
command plugin runs the benchmarks in a release build and prints a Markdown performance comparison to the terminal or
Xcode report navigator.

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
benchmark definitions for both revisions so their measurements remain comparable. If the selected baseline predates the
benchmark target, the comparison contains only the current measurements.

Redirect the standard output when a persistent copy of the Markdown comparison is useful:

```shell
swift package plugin --allow-network-connections all benchmark > benchmark-summary.md
```

Network access lets the isolated builds resolve their package dependencies. The builds share a dependency cache while
keeping their compiled artifacts in separate scratch directories, which SwiftPM can reuse while the plugin work
directory remains available.

The plugin invokes the executable for measurements, then the comparison script to format the report.

## Executable Target

The [NumericsExtendedBenchmarks](/Tools/NumericsExtendedBenchmarks) executable target is the lower-level measurement
engine used by the plugin. Invoke it directly to print its JSON report:

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

## Benchmark Report Script

[GenerateBenchmarkReport.swift](/Scripts/GenerateBenchmarkReport.swift) compares two previously generated JSON reports
and prints the resulting Markdown table:

```shell
swift Scripts/GenerateBenchmarkReport.swift \
    --baseline baseline-results.json \
    --current current-results.json
```

The baseline report is optional. Without one, the script prints only the current measurements:

```shell
swift Scripts/GenerateBenchmarkReport.swift \
    --current current-results.json
```

The script rejects unsupported report versions, duplicate benchmark names, and incompatible measurement configurations.
It reads existing reports without running benchmarks.
