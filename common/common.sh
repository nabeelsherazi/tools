#!/bin/bash

suppress_error() {
    "$@" 2>/dev/null || true
}

RED="$(suppress_error tput setaf 1)"
YLW="$(suppress_error tput setaf 3)"
BLU="$(suppress_error tput setaf 4)"
GRN="$(suppress_error tput setaf 2)"
MAG="$(suppress_error tput setaf 5)"
RST="$(suppress_error tput sgr0)"

BOLD="$(suppress_error tput bold)"
UL="$(suppress_error tput smul)"
ITALIC="$(suppress_error tput sitm)"

print_info()  { printf "${BLU}[info]${RST} %s\n" "$*"; }
print_warn()  { printf "${YLW}[warn]${RST} %s\n" "$*"; }
print_log()   { printf "${MAG}[log]${RST} %s\n" "$*"; }
print_hint()  { printf "${GRN}[hint]${RST} %s\n" "$*"; }
print_error() { printf "${RED}[error]${RST} %s\n" "$*" >&2; }
die()         { print_error "$*"; exit 1; }

#!/bin/bash

is_macos() {
    case "$(uname -s)" in
        Darwin*) return 0 ;;
        *)       return 1 ;;
    esac
}

is_linux() {
    case "$(uname -s)" in
        Linux*) return 0 ;;
        *)      return 1 ;;
    esac
}

detect_os() {
    if is_macos; then
        echo macos
    elif is_linux; then
        echo linux
    else
        echo unknown
    fi
}

require_cmd() {
    if path="$(command -v "$1" 2>/dev/null)"; then
        printf "%s\n" "$path"
        return 0
    fi

    print_error "missing required command: $1"

    case "$2" in
        hint:pkg)
            if is_macos; then
                print_hint "try \`brew install $1\`"
            else
                print_hint "try \`apt install $1\`"
            fi
            ;;
        hint:pip)
            print_hint "try \`python -m pip install $1\`"
            ;;
        "")
            ;;
        *)
            print_hint "$2"
            ;;
    esac

    return 1
}

require_oneof_cmd() {
    for cmd in "$@"; do
        if path="$(command -v "$cmd" 2>/dev/null)"; then
            printf "%s\n" "$path"
            return 0
        fi
    done
    die "missing command, require one of: $*"
    return 1
}

