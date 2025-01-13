# Project File Processor

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A powerful and flexible command-line tool for processing and analyzing project files. It provides both interactive and automatic modes for efficient file handling, with support for customizable filtering and structured output.

## Features

🔍 **Interactive File Selection**

- Fuzzy search with real-time preview
- Directory tree visualization
- Easy navigation and filtering

🚀 **Automatic Processing**

- Batch processing of multiple paths
- Configurable file type filtering
- Structured XML output

🛠️ **Advanced Capabilities**

- Git integration for staged changes
- Customizable exclusion patterns
- Flexible depth control for directory trees

## Quick Start

### Prerequisites

Ensure you have the following dependencies installed:

- fzf
- fd
- exa
- python3
- git

### Installation

1. Clone the repository:

```bash
git clone https://github.com/yourusername/project-file-processor.git
cd project-file-processor
```

2. Make the script executable:

```bash
chmod +x project-processor.sh
```

### Basic Usage

Interactive mode:

```bash
./project-processor.sh
```

Automatic mode:

```bash
PROCESS_PATHS="src:tests" ./project-processor.sh -a
```

For more detailed information, see the [User Guide](docs/USER_GUIDE.md).

## Use Cases

- 📁 **Project Analysis**: Quickly understand project structure and contents
- 🔄 **Code Review**: Review changes with git integration
- 📝 **Documentation**: Generate structured output for documentation
- 🔍 **Code Search**: Find and process specific file types efficiently

## Configuration

Customize behavior with environment variables:

```bash
INCLUDE_TYPES="js:py:go"    # Filter specific file types
EXCLUDE_DIRS="temp:logs"    # Additional exclusion patterns
PROCESS_PATHS="path1:path2" # Paths for automatic processing
```

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

If you encounter any issues or have questions, please:

1. Check the [User Guide](docs/USER_GUIDE.md)
2. Look through existing [Issues](https://github.com/yourusername/project-file-processor/issues)
3. Create a new issue if needed

---

Made with ❤️ by [Your Name]
