# Documentation

Build and publish the package documentation.

## Overview

The documentation build produces a DocC website for GitHub Pages. The same build script can generate the site locally
without publishing it. Generated files stay under `.build/` and are not committed.

## Requirements

Use Swift 6.3 or later with DocC available; CI builds on `macos-latest`. Run commands from the repository root.

Package resolution needs network access when dependencies are not cached. Publishing requires GitHub Pages configured
for GitHub Actions; local generation does not require deployment permissions.

## Continuous Integration

The [Documentation workflow](/.github/workflows/documentation.yml) runs on pushes to `main` and manual dispatch. Its
`Build Documentation` job builds the site, configures GitHub Pages, and uploads `.build/github-pages/`. The dependent
`Deploy Documentation` job publishes that artifact on `ubuntu-latest` after the build job succeeds. Separating upload
and deployment avoids looking up the artifact immediately after upload in the same job.

The deployment URL appears in the `github-pages` environment. A failed build or upload prevents deployment. A newer
Pages run cancels an older run in progress. If deployment fails, rerun only the failed deployment job while its artifact
is still available; this reuses the upload instead of creating another artifact with the same name.

## Build Script

[BuildDocumentation.swift](/Scripts/BuildDocumentation.swift) generates the website:

```shell
swift Scripts/BuildDocumentation.swift
```

The script takes no arguments. It writes the site to `.build/github-pages/` and adds a landing-page redirect after a
successful build. Build or file-writing failures return a nonzero exit status. The script does not publish the site.

The script invokes the package's Swift-DocC command plugin with combined documentation enabled, the selected module
targets, and static hosting configured for this repository. The site root redirects to `documentation/`.

## Command Plugin

The `generate-documentation` command comes from the `swift-docc-plugin` dependency in [Package
Manifest](/Package.swift). The build script supplies the module list, output path, hosting base path, and permission to
write the generated site. Use the build script to reproduce the published configuration; building documentation directly
in Xcode may use a different target selection and hosting configuration.