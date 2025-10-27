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
