# Dir2Prompt - User Guide

## Overview

Dir2Prompt is a command-line tool designed to help developers efficiently process and analyze project files. It provides an interactive interface for file selection and supports automatic processing mode for batch operations.

## Prerequisites

The tool requires the following dependencies:

- `fzf`: For interactive file selection
- `fd`: For file searching
- `exa`: For directory tree visualization
- `python3`: For path processing
- `git`: For git integration

## Installation

1. Ensure all dependencies are installed:

   ```bash
   # For macOS (using Homebrew)
   brew install fzf fd exa git

   # For Ubuntu/Debian
   sudo apt update
   sudo apt install fzf fd-find exa git python3
   ```

2. Download the script and make it executable:

   ```bash
   chmod +x dir2prompt.sh
   ```

3. Optionally, add it to your PATH for system-wide access.

## Usage

### Interactive Mode

```bash
./dir2prompt.sh
```

This launches the interactive mode where you can:

- Navigate through files using arrow keys
- Filter files by typing
- Select files/directories with Enter
- Skip current selection with Esc
- Exit with ':q'

### Automatic Mode

```bash
PROCESS_PATHS="path1:path2:path3" ./dir2prompt.sh -a
```

This processes specified paths automatically without interaction.

### Command Line Options

- `-h, --help`: Show help information
- `-a, --auto`: Run in automatic mode (requires PROCESS_PATHS environment variable)
- `-d, --depth <n>`: Set tree depth (default: 4)
- `-g, --git-diff`: Include git staged differences in output

### Environment Variables

- `PROCESS_PATHS`: Colon-separated paths to process (required for auto mode)
- `EXCLUDE_DIRS`: Additional directories to exclude from processing
- `INCLUDE_TYPES`: Colon-separated file extensions to include (e.g., "js:py:go")

## Default Exclusions

The tool automatically excludes common directories:

- `__pycache__`
- `node_modules`
- `.git`
- `.idea`
- `.vscode`
- `build`
- `dist`
- Various cache directories

## Output Format

The tool generates structured output in XML format:

```xml
<code_base>
    <code path="relative/path/to/file">
        file content
    </code>
</code_base>

<project_structure>
    directory tree structure
</project_structure>

<git_diff_staged>
    staged git differences (if enabled)
</git_diff_staged>
```

## Examples

1. Basic interactive usage:

   ```bash
   ./dir2prompt.sh
   ```

2. Process specific file types in auto mode:

   ```bash
   INCLUDE_TYPES="js:py" PROCESS_PATHS="src:tests" ./dir2prompt.sh -a
   ```

3. Custom depth with git diff:

   ```bash
   ./dir2prompt.sh -d 3 -g
   ```

## Troubleshooting

### Common Issues

1. Missing Dependencies

   ```
   Error: Missing required commands: [command names]
   ```

   Solution: Install the missing dependencies using your package manager.

2. Permission Denied

   ```
   Permission denied: ./dir2prompt.sh
   ```

   Solution: Make the script executable with `chmod +x dir2prompt.sh`

### Tips

- Use `INCLUDE_TYPES` to filter specific file types and improve performance
- Adjust tree depth for better visibility in large projects
- Use git diff option only when needed to avoid unnecessary processing

## Advanced Usage

### Custom Exclude Patterns

You can exclude additional directories by setting the EXCLUDE_DIRS environment variable:

```bash
EXCLUDE_DIRS="temp:logs:cache" ./dir2prompt.sh
```

### Integration with Other Tools

The XML output format makes it easy to pipe the results to other tools:

```bash
./dir2prompt.sh | grep -A 1 "<code path="
```
