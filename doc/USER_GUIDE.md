# User Guide

## Overview

Dir2Prompt is a command-line tool designed to help developers efficiently process and analyze project files. It provides an interactive interface for file selection and supports automatic processing mode for batch operations.

## Prerequisites

The tool requires the following dependencies:

- `fzf`: For interactive file selection
- `fd`: For file searching
- `exa`: For directory tree visualization
- `python3`: For path processing
- `git`: For git integration
- A clipboard command (one of the following):
  - macOS: `pbcopy` (pre-installed)
  - Linux: `xclip`, `xsel`, or `wl-copy`
  - Windows: `clip.exe` (pre-installed)

### Installing Dependencies

```bash
# For macOS (using Homebrew)
brew install fzf fd exa git
# pbcopy is pre-installed

# For Ubuntu/Debian
sudo apt update
sudo apt install fzf fd-find exa git python3
# Install one of these clipboard utilities:
sudo apt install xclip
# or
sudo apt install xsel
# or
sudo apt install wl-clipboard  # For Wayland

# For Windows
# Install dependencies through package manager
scoop install fzf fd exa git
# clip.exe is pre-installed
```

## Installation

1. Clone and set up the repository:

```bash
git clone https://github.com/SDGLBL/dir2prompt.git
cd dir2prompt
chmod +x dir2prompt.sh
chmod +x clp.sh
```

2. Optionally, add the scripts to your PATH for system-wide access:

```bash
# Add to ~/.bashrc or ~/.zshrc:
export PATH="$PATH:/path/to/dir2prompt"
```

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
PROCESS_PATHS="path1:path2:path3" ./dir2prompt.sh -a | ./clp.sh
```

This processes specified paths automatically and copies the output to clipboard.

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
INCLUDE_TYPES="js:py" PROCESS_PATHS="src:tests" ./dir2prompt.sh -a | ./clp.sh
```

3. Custom depth with git diff:

```bash
./dir2prompt.sh -d 3 -g | ./clp.sh
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

Solution: Make the scripts executable with `chmod +x dir2prompt.sh clp.sh`

3. Clipboard Issues

- Verify clipboard command installation:

```bash
# Check if you have any of these installed
command -v pbcopy    # macOS
command -v xclip     # Linux
command -v xsel      # Linux
command -v wl-copy   # Linux (Wayland)
command -v clip.exe  # Windows
```

- Install appropriate clipboard command
- Check script permissions
- Run `./clp.sh -h` for usage information

### Tips

- Use `INCLUDE_TYPES` to filter specific file types and improve performance
- Adjust tree depth for better visibility in large projects
- Use git diff option only when needed to avoid unnecessary processing
