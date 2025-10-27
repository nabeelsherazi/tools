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
die() { printf "${RED}[fatal]${RST} %s\n" "$*" >&2; exit 1; }

require_cmd() {
    if ! command -v "$1" >/dev/null 2>&1; then
        if [ -n "$2" ]; then
            print_error "missing required command: $1"
            print_hint "$2"
        else
            print_error "missing required command: $1"
        fi
        return 1
    fi
}
