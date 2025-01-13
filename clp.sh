#!/bin/bash
# File: scripts/clp.sh

# Function to detect the operating system and available clipboard commands
detect_clipboard_command() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    if command -v pbcopy >/dev/null 2>&1; then
      echo "pbcopy"
      return 0
    fi
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    if command -v xclip >/dev/null 2>&1; then
      echo "xclip -selection clipboard"
      return 0
    elif command -v xsel >/dev/null 2>&1; then
      echo "xsel --clipboard --input"
      return 0
    elif command -v wl-copy >/dev/null 2>&1; then
      echo "wl-copy"
      return 0
    fi
  elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
    # Windows
    if command -v clip.exe >/dev/null 2>&1; then
      echo "clip.exe"
      return 0
    fi
  fi
  return 1
}

# Function to show usage
usage() {
  echo "Usage: clp <text>"
  echo "       echo 'text' | clp"
  echo "Copies text to clipboard"
  echo ""
  echo "Supported clipboard commands:"
  echo "- macOS: pbcopy"
  echo "- Linux: xclip, xsel, or wl-copy"
  echo "- Windows: clip.exe"
  exit 1
}

# Get the appropriate clipboard command
CLIP_CMD=$(detect_clipboard_command)
if [ $? -ne 0 ]; then
  echo "Error: No supported clipboard command found." >&2
  echo "Please install one of the following:" >&2
  echo "- macOS: pbcopy (pre-installed)" >&2
  echo "- Linux: xclip, xsel, or wl-copy" >&2
  echo "- Windows: clip.exe (pre-installed)" >&2
  exit 1
fi

# Check if we're receiving input from pipe
if [ ! -t 0 ]; then
  # Read from stdin (pipe)
  cat - | eval "$CLIP_CMD"
else
  # Check if argument is provided
  if [ $# -eq 0 ]; then
    usage
  fi
  # Read from argument
  echo "$@" | eval "$CLIP_CMD"
fi
