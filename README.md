# Dir2Prompt

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A powerful command-line tool designed to streamline project file processing for Claude AI interactions. It helps developers efficiently capture and format their project structure and code for optimal collaboration with Claude, supporting both interactive and automatic modes.

## Why This Tool?

When working with Claude, providing clear project context is crucial for effective assistance. This tool automatically:

- Formats your project files in Claude's preferred XML structure
- Captures git changes for context-aware discussions
- Filters relevant files to maintain focused conversations
- Integrates with your clipboard for seamless Claude interactions

## Features

🤖 **Optimized for Claude**

- Generates XML-formatted output that Claude can efficiently process
- Includes project structure visualization
- Captures git changes for better context

🔍 **Smart File Selection**

- Interactive fuzzy search with preview
- Automatic processing of specified paths
- Configurable file type filtering

🚀 **Efficient Workflow**

- Direct clipboard integration
- direnv support for environment management
- Customizable exclusion patterns

## Quick Start

### Prerequisites

Ensure you have these dependencies installed:

- [fzf](https://github.com/junegunn/fzf)
- [fd](https://github.com/sharkdp/fd)
- [exa](https://github.com/ogham/exa)
- python3
- git

### Installation

1. Clone the repository:

```bash
git clone https://github.com/SDGLBL/dir2prompt.git
cd dir2prompt
```

2. Make the script executable:

```bash
chmod +x dir2prompt.sh
```

### Basic Usage with Claude

1. Process project and copy to clipboard:

```bash
./dir2prompt.sh -g -a | clp
```

2. Paste the output directly into your Claude conversation.

3. Claude will have access to:
   - Your project's file structure
   - Relevant code files
   - Current git changes
   - Directory hierarchy

For interactive selection:

```bash
./dir2prompt.sh
```

## Configuration

Customize behavior with environment variables:

```bash
INCLUDE_TYPES="js:py:go"    # Filter specific file types
EXCLUDE_DIRS="temp:logs"    # Additional exclusion patterns
PROCESS_PATHS="path1:path2" # Paths for automatic processing
```

## Documentation

- [User Guide](doc/USER_GUIDE.md) - Detailed usage instructions
- [direnv Integration Guide](doc/DIRENV_GUIDE.md) - Automated environment setup and clipboard integration

## Use Cases with Claude

- 🔄 **Code Review**: Share code changes and get detailed feedback
- 🛠️ **Refactoring**: Get suggestions for code improvements
- 📝 **Documentation**: Generate documentation with Claude's assistance
- 🐛 **Debugging**: Share relevant code context for problem-solving
- 🎨 **Architecture Discussions**: Discuss project structure and design

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

### Development Setup

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [fzf](https://github.com/junegunn/fzf) for fuzzy finding capabilities
- [fd](https://github.com/sharkdp/fd) for file searching
- [exa](https://github.com/ogham/exa) for tree visualization

## Support

If you encounter any issues or have questions:

1. Check the [User Guide](doc/USER_GUIDE.md)
2. Look through existing [Issues](https://github.com/SDGLBL/dir2prompt/issues)
3. Create a new issue if needed

---

Made with ❤️ for enhancing Claude interactions
