# Topic

<!-- Replace the title with the developer task and write a short, action-oriented subtitle below. -->

Describe the task in one sentence.

<!--
Use this template for developer guides in Docs/.
Start repository file and image links with `/`, relative to the repository root.
Use readable, title-case link labels without file paths or extensions.
Keep external URLs and same-page anchors unchanged.
Keep the title, subtitle, Overview, and Requirements before Continuous Integration.
After Continuous Integration, follow the actual invocation order from the workflow down through its tools.
Move, repeat, or omit tool sections as needed; do not invent a plugin, script, or executable to fill a section.
For example: workflow → plugin → script, or workflow → script → plugin → executable → report script.
The two Script sections are intentional: one can coordinate CI, while another can be invoked by a plugin or executable.
Rename them for their roles, such as Snapshot Test Runner, Recording Script, or Comparison Script.
Nest supporting scripts beneath their caller. Describe a shared helper once and link to it from its other callers.
Separate alternative paths, such as CI comparison and local recording; do not imply that every tool calls the next one.
Keep every line within 120 characters, including authoring comments and command examples.
Document local commands with the tool they invoke, rather than repeating them in a separate local-usage section.
Keep each behavior or option in one place and link to it elsewhere. Link to related guides rather than copying them.
Remove unused sections and replace these authoring instructions when writing a guide.
-->

## Overview

<!--
Explain the task's purpose, scope, and expected result.
Briefly identify the tools involved and how they connect, including any alternative local entry points.
Distinguish operations that check existing files from operations that generate or modify them where relevant.
-->

## Requirements

<!--
List the prerequisites needed to reproduce the task: Swift or Xcode version, platform, simulator, or other tools.
State the working directory and any permissions required. Explain constraints shared by CI and local use here.
Omit this section if there are no task-specific requirements worth documenting.
-->

## Continuous Integration

<!--
Name and link to the GitHub Actions workflow in .github/workflows/.
Describe its triggers, relevant branches, jobs, and the plugin, script, executable, or command it invokes first.
Explain what runs independently, what depends on earlier results, and what causes failure or only produces a warning.
Describe the reports, artifacts, or published output and where the developer can inspect them.
Mention rerun behavior, manual dispatch, or concurrency only when it affects how the task is used.
If the workflow invokes commands directly, explain them here; a separate script section is not required.
-->

## Script

<!--
Optional: use this section for a script invoked directly by CI, before the tools it coordinates.
Move or omit it to match the actual invocation order.
-->

<!--
Name and link to the script in Scripts/, using a section title that describes its role when helpful.
Explain what it coordinates, which lower-level tools it invokes, and when running it directly is useful.
Show its terminal command, supported arguments, and important defaults.
Describe its inputs, output locations, file changes, and failure behavior without repeating the caller's explanation.
Include Xcode instructions here or in a named subsection when they provide an alternative entry point.
-->

### Supporting Script

<!-- Optional: repeat for helpers used by the parent script, or use a top-level section if called by another tool. -->

<!--
Name and link to the helper and explain its specific role, such as host generation or report generation.
Document direct invocation only when useful to a developer, including the required inputs and generated output.
Keep implementation details in source comments unless they help someone use or troubleshoot the task.
-->

## Command Plugin

<!-- Optional: place this section where the plugin occurs in the invocation order. -->

<!--
Name the plugin and describe its responsibility and the next tool it invokes, if any.
Show the recommended terminal command and the options developers commonly use.
Explain required permissions, defaults, output, and failure behavior specific to the plugin.
Explain whether the command is available from Xcode, including any verified limitations.
-->

## Executable Target

<!-- Optional: place this section where the executable occurs in the invocation order. -->

<!--
Name the executable target and explain which plugin or script invokes it.
Show how to run it directly when useful, including the appropriate build configuration.
Describe its arguments, input and output formats, and any constraints needed to interpret the results correctly.
Place any tools invoked by the executable after this section.
-->

## Script

<!--
Optional: use this section for a script invoked by a command plugin or executable, or through another local entry point.
Move or omit it to match the actual invocation order. Give it a distinct, descriptive heading in the completed guide.
-->

<!--
Name and link to the script in Scripts/, using a section title that describes its role when helpful.
Explain what it coordinates, which lower-level tools it invokes, and when running it directly is useful.
Show its terminal command, supported arguments, and important defaults.
Describe its inputs, output locations, file changes, and failure behavior without repeating the caller's explanation.
Include Xcode instructions here or in a named subsection when they provide an alternative entry point.
-->

### Supporting Script

<!-- Optional: repeat for helpers used by the parent script, or use a top-level section if called by another tool. -->

<!--
Name and link to the helper and explain its specific role, such as host generation or report generation.
Document direct invocation only when useful to a developer, including the required inputs and generated output.
Keep implementation details in source comments unless they help someone use or troubleshoot the task.
-->

<!-- Keep any task-specific reference material after the execution sections. -->
