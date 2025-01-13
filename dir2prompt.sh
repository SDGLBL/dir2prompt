#!/usr/bin/env bash

# Color constants
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Default configuration
DEFAULT_TREE_DEPTH=4
INCLUDE_GIT_DIFF=false

# Default exclude patterns - these will be used with fd's -E option
DEFAULT_EXCLUDES=(
  "__pycache__"
  "node_modules"
  ".git"
  ".idea"
  ".vscode"
  "build"
  "dist"
  ".pytest_cache"
  ".mypy_cache"
  ".tox"
  "venv"
  "env"
)

get_relative_path() {
  python3 -c "import os.path; print(os.path.relpath('$2', '$1'))"
}

build_type_params() {
  local type_params=""
  if [[ -n "${INCLUDE_TYPES}" ]]; then
    IFS=':' read -ra types <<<"${INCLUDE_TYPES}"
    for type in "${types[@]}"; do
      type_params="$type_params -e $type"
    done
  fi
  echo "$type_params"
}

check_dependencies() {
  local deps=(fzf fd exa python3 git)
  local missing=()

  for cmd in "${deps[@]}"; do
    command -v "$cmd" >/dev/null 2>&1 || missing+=("$cmd")
  done

  if ((${#missing[@]})); then
    echo -e "${RED}Missing required commands: ${missing[*]}${NC}" >&2
    exit 1
  fi
}

format_output() {
  local type=$1
  shift
  local content="$@"

  echo -e "\n---\n$type:\n<$type>\n$content\n</$type>\n"
}

generate_project_structure() {
  format_output "project_structure" "$(exa -T --git-ignore -L "$1")"
}

get_git_diff_staged() {
  if [[ "$INCLUDE_GIT_DIFF" = true ]] && git rev-parse --git-dir >/dev/null 2>&1; then
    local diff_content=$(git diff --staged --color=never)
    [[ -n "$diff_content" ]] && format_output "git_diff_staged" "$diff_content"
  fi
}

process_file() {
  local file_path=$1
  local rel_path=$(get_relative_path "$(pwd)" "$file_path")

  local content
  if content=$(cat "$file_path" 2>/dev/null); then
    echo -e "<code path=\"$rel_path\">\n$content\n</code>\n"
  else
    echo -e "<code path=\"$rel_path\">\n$(cat "$file_path")\n</code>\n"
  fi
}

process_selection() {
  local selected=$2
  [[ -z "$selected" ]] && return 1
  [[ "$selected" = ":q" ]] && return 2

  echo -e "${GREEN}Processing: $selected${NC}" >&2

  if [[ -d "$selected" ]]; then
    echo -e "\n<code_base>"
    # 构建排除参数
    local exclude_params=""
    for pattern in "${DEFAULT_EXCLUDES[@]}" "${EXCLUDE_DIRS[@]}"; do
      exclude_params="$exclude_params -E $pattern"
    done

    # 构建类型过滤参数
    local type_params=$(build_type_params)

    # 使用所有参数运行 fd
    fd . "$selected" --type f $exclude_params $type_params |
      while read -r file; do
        process_file "$file"
      done
    echo -e "</code_base>"
  else
    echo -e "\n<code_base>"
    process_file "$selected"
    echo -e "</code_base>"
  fi

  return 0
}

show_help() {
  cat >&2 <<EOF
${GREEN}Dir2Prompt${NC}

${BLUE}Usage:${NC}
  $0 [-h|--help]         Show help
  $0 [-a|--auto]         Auto mode (uses PROCESS_PATHS)
  $0 [-d|--depth <n>]    Set tree depth (default: $DEFAULT_TREE_DEPTH)
  $0 [-g|--git-diff]     Include git diff staged
  $0                     Interactive mode

${BLUE}Environment Variables:${NC}
  PROCESS_PATHS    Colon-separated paths to process
  EXCLUDE_DIRS     Additional directories to exclude
  INCLUDE_TYPES    Colon-separated file extensions to include (e.g. "js:py:go")
                   If not set, all file types will be included

${BLUE}Interactive Controls:${NC}
  ↑↓    Navigate
  Type   Filter
  Enter  Select
  Esc    Skip
  :q     Exit
EOF
}

interactive_mode() {
  echo "Debug: Starting interactive mode" >&2
  local tree_depth=$1
  local count=0

  # 构建排除参数
  local exclude_params=""
  for pattern in "${DEFAULT_EXCLUDES[@]}" "${EXCLUDE_DIRS[@]}"; do
    exclude_params="$exclude_params -E $pattern"
  done

  # 构建类型过滤参数
  local type_params=$(build_type_params)

  # Debug: 显示过滤参数
  echo "Debug: Exclude params: $exclude_params" >&2
  echo "Debug: Type filters: $type_params" >&2

  while true; do
    ((count++))
    echo -e "${BLUE}Selection #$count${NC} (Type ':q' to exit)" >&2

    local fzf_exit_code
    local selected

    selected=$(
      {
        echo ":q"
        fd . --strip-cwd-prefix --type f --type d $exclude_params $type_params
      } |
        fzf --preview '
          if [[ "{}" = ":q" ]]; then
            echo "Press enter to exit"
          elif [[ -d "{}" ]]; then
            exa -la "{}"
          else
            rg --no-line-number --no-heading --color=always -p "" "{}" 2>/dev/null || cat "{}"
          fi
        ' \
          --header "Select file/directory (Esc: skip, :q: exit)${INCLUDE_TYPES:+ | Filtering: $INCLUDE_TYPES}" \
          --bind "ctrl-r:reload(fd . --strip-cwd-prefix --type f --type d $exclude_params $type_params)" \
          --exit-0
    )
    fzf_exit_code=$?

    echo "Debug: Selected: $selected" >&2
    echo "Debug: fzf exit code: $fzf_exit_code" >&2

    if [[ $fzf_exit_code -eq 130 ]]; then
      echo -e "${GREEN}Skipped #$count${NC}" >&2
      continue
    fi

    if [[ $fzf_exit_code -eq 1 ]]; then
      echo -e "${GREEN}No selection #$count${NC}" >&2
      continue
    fi

    if [[ "$selected" = ":q" ]]; then
      echo "Debug: Exit requested via :q" >&2
      break
    fi

    if [[ -z "$selected" ]]; then
      continue
    fi

    process_selection "$(pwd)" "$selected" "$tree_depth"
    local ret=$?
    echo "Debug: process_selection return: $ret" >&2
    [[ $ret -eq 2 ]] && break
  done

  return $count
}

process_auto_mode() {
  local tree_depth=$1

  if [[ -z "${PROCESS_PATHS+x}" ]]; then
    echo -e "${RED}Error: PROCESS_PATHS not set${NC}" >&2
    return 1
  fi

  generate_project_structure "$tree_depth"
  get_git_diff_staged

  local count=0
  IFS=':' read -ra paths <<<"$PROCESS_PATHS"

  for path in "${paths[@]}"; do
    ((count++))
    process_selection "$(pwd)" "$(pwd)/$path" "$tree_depth"
  done

  return $count
}

main() {
  # 添加调试信息

  check_dependencies

  local tree_depth=$DEFAULT_TREE_DEPTH
  local total=0

  # 如果没有参数，直接进入交互模式
  if [[ $# -eq 0 ]]; then
    interactive_mode "$tree_depth"
    total=$?
  else
    while [[ $# -gt 0 ]]; do
      case "$1" in
      -h | --help)
        show_help
        exit 0
        ;;
      -a | --auto)
        shift
        process_auto_mode "$tree_depth"
        total=$?
        break
        ;;
      -d | --depth)
        if [[ $2 =~ ^[0-9]+$ ]]; then
          tree_depth=$2
          shift 2
        else
          echo -e "${RED}Error: --depth requires a number${NC}" >&2
          exit 1
        fi
        ;;
      -g | --git-diff)
        INCLUDE_GIT_DIFF=true
        shift
        ;;
      *)
        echo -e "${RED}Unknown option: $1${NC}" >&2
        show_help
        exit 1
        ;;
      esac
    done
  fi

  if [[ -z "$total" ]]; then
    interactive_mode "$tree_depth"
    total=$?
  fi

  if ((total > 0)); then
    echo -e "${GREEN}Completed. Processed: $total items${NC}" >&2
  else
    echo -e "${RED}No items processed${NC}" >&2
    exit 1
  fi
}

main "$@"
