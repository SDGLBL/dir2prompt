# direnv Integration Guide

## Overview

This guide explains how to set up and use `direnv` with Dir2Prompt for efficient project management and clipboard integration. This workflow allows you to automatically set environment variables when entering the project directory and quickly copy project contents to your clipboard.

## Prerequisites

- direnv (`brew install direnv` or `apt-get install direnv`)
- Dir2Prompt installation
- One of the supported clipboard commands

## Setup Instructions

### 1. Install and Configure direnv

1. Install direnv:

```bash
# macOS
brew install direnv

# Ubuntu/Debian
sudo apt-get update
sudo apt-get install direnv
```

2. Add direnv hook to your shell:

```bash
# For bash, add to ~/.bashrc:
eval "$(direnv hook bash)"

# For zsh, add to ~/.zshrc:
eval "$(direnv hook zsh)"
```

### 2. Create .envrc File

Create a `.envrc` file in your project root with your environment variables:

```bash
# .envrc
export INCLUDE_TYPES="js:py:go"    # Customize file types to process
export EXCLUDE_DIRS="temp:logs"    # Additional directories to exclude
export PROCESS_PATHS="src:tests"   # Paths for automatic processing
```

After creating or modifying `.envrc`, allow it with:

```bash
direnv allow
```

## Usage

### Basic Workflow

1. Navigate to your project directory:

```bash
cd your-project
```

direnv will automatically load your environment variables.

2. Copy project contents to clipboard:

```bash
./dir2prompt.sh -g -a | ./clp.sh
```

This command:

- Processes your project files (`-a` for automatic mode)
- Includes git staged changes (`-g`)
- Pipes the output to your clipboard

### Example .envrc Configurations

For a typical JavaScript project:

```bash
export INCLUDE_TYPES="js:jsx:ts:tsx"
export EXCLUDE_DIRS="coverage:dist"
export PROCESS_PATHS="src:tests"
```

For a Python project:

```bash
export INCLUDE_TYPES="py:ipynb"
export EXCLUDE_DIRS="__pycache__:dist"
export PROCESS_PATHS="src:tests"
```

## Tips and Best Practices

1. Version Control:

   - Add `.envrc` to version control if it contains project-specific settings
   - Add `.envrc.example` for template settings
   - Add `.direnv` to `.gitignore`

2. Security:

   - Review `.envrc` content before allowing with `direnv allow`
   - Never store sensitive information in `.envrc`

3. Performance:
   - Be specific with `INCLUDE_TYPES` to improve processing speed
   - Use `EXCLUDE_DIRS` to skip unnecessary directories

## Troubleshooting

1. direnv not loading:

   - Ensure shell hook is properly configured
   - Run `direnv allow` after changes

2. Clipboard issues:
   - Verify clipboard command installation
   - Install appropriate clipboard utility for your system
   - Check script permissions
   - Try running clp.sh directly to test clipboard functionality

## Additional Resources

- [direnv documentation](https://direnv.net/)
- [Dir2Prompt User Guide](./USER_GUIDE.md)

Made with ❤️ for enhancing Claude interactions
