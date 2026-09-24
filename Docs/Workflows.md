# Workflows

Run workflow logic locally using the Swift scripts in `Scripts/`.

## Overview

Workflows define triggers, permissions, runners, checkout, and publishing. Swift scripts handle validation rules,
benchmark setup, unit test execution, and report and documentation generation. Simple build commands and the formatting
plugin remain directly in the workflows.

Run scripts from the repository root with Swift installed. Scripts accept command-line arguments rather than requiring
GitHub Actions environment variables. They return a nonzero exit status when validation or a subprocess fails.

## Benchmarks

### RunBenchmarks.swift

Run benchmarks and print the plugin's Markdown report:

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

Use either `--baseline` or `--event`; the two modes cannot be combined. The workflow redirects the report to the GitHub
Actions summary. See [Benchmarking](Benchmarking.md) for the plugin's options and baseline compatibility behavior.

### GenerateBenchmarkReport.swift

The benchmark runner uses the command plugin, which invokes this report generator. You can also run it independently.

Print a Markdown report from existing benchmark JSON files:

```shell
swift Scripts/GenerateBenchmarkReport.swift --current current.json
swift Scripts/GenerateBenchmarkReport.swift --baseline baseline.json --current current.json
```

Replace the example filenames with the paths of your benchmark reports. The current report is required; providing a
baseline adds a performance comparison. The script reads reports without running benchmarks and rejects unsupported
report versions, duplicate benchmark names, and incompatible measurement configurations.

See [Benchmarking](Benchmarking.md) for the report format and how benchmark results are generated.

## Documentation

### BuildDocumentation.swift

Build the combined DocC website:

```shell
swift Scripts/BuildDocumentation.swift
```

This generates the site in `.build/github-pages/` inside the repository and adds its landing-page redirect after a
successful build. GitHub Pages setup, artifact upload, and deployment remain in the documentation workflow.

## Unit Tests

### RunUnitTests.swift

Run the unit tests and generate coverage reports:

```shell
swift Scripts/RunUnitTests.swift
```

The runner executes `swift test --enable-code-coverage`, locates the exported coverage JSON, and invokes
`GenerateCodeCoverageReport.swift`. It saves `code-coverage.json` and `code-coverage.md` in `.build/code-coverage/`.
Test output goes to standard error; standard output contains only the Markdown coverage report, so it can be redirected
without including test logs. Test or report-generation failures fail the script.

The workflow appends the report to the GitHub Actions summary and uploads the coverage artifacts.

### GenerateCodeCoverageReport.swift

Use the report generator independently to regenerate a report from existing coverage data without rerunning tests:

```shell
swift Scripts/GenerateCodeCoverageReport.swift \
    --report "$(swift test --show-codecov-path)" \
    --sources Sources
```

First run `RunUnitTests.swift`, or collect coverage with `swift test --enable-code-coverage`. The generator reads the
JSON export and reports coverage by target and source file, including package-wide totals. Only files beneath the
supplied source directory are included. It does not run tests or collect coverage itself.

## Validation

### ValidateBranchRoute.swift

Check whether a source branch is allowed to target a destination branch:

```shell
swift Scripts/ValidateBranchRoute.swift release/1.0.0 feature/example
```

The first argument is the destination branch; the second is the source branch. Any branch may target `main`.
Release branches accept source branches beginning with `feature/`, `bugfix/`, `chore/`, `docs/`, or `test/`.

### ValidateContributors.swift

Check the contributor file against Git history:

```shell
swift Scripts/ValidateContributors.swift
swift Scripts/ValidateContributors.swift main
```

The script compares `CONTRIBUTORS.txt` against history at `HEAD`, or at the optional revision argument. It honors Git's
mailmap, excludes GitHub bot addresses, and prints a diff when the file needs updating. Use a checkout with complete
history, as the workflow does. Validation does not modify the contributor file.

### ValidatePullRequestTitle.swift

Check a title against the repository's Conventional Commit rules:

```shell
swift Scripts/ValidatePullRequestTitle.swift "feat: Add an example"
```

The title is supplied as one quoted argument. It must contain an allowed type, an optional parenthesized scope and
breaking-change marker, and a description after `: `. Invalid titles produce a diagnostic describing the accepted
format and types.

### ValidateTag.swift

Check a release tag:

```shell
swift Scripts/ValidateTag.swift 1.0.0
```

Tags must use three dot-separated ASCII decimal components, with no leading zeros except for a component equal to
zero. Prefixes, prerelease identifiers, and build metadata are not accepted.
