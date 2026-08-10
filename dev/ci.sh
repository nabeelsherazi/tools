#!/bin/bash

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

source "${SCRIPT_DIR}/../common/common.sh"

DOCKER=$(require_cmd docker)
SHELLCHECK=$(require_cmd shellcheck hint:pkg)

TARGET_DIR=$(cd -- "${1:-$SCRIPT_DIR/../}" &>/dev/null && pwd)
[[ -d $TARGET_DIR ]] || die "target directory '$TARGET_DIR' does not exist"

# Find files to format and lint

files=()
while IFS= read -r -d '' file; do
    filename=$(basename "$file")
    if [[ $filename == *.sh ]] || { [[ $filename != *.* ]] && head -n1 "$TARGET_DIR/$file" | grep -qE '^#!/(usr/)?bin/(env +)?(ba)?sh'; }; then
        files+=("$file")
    fi
done < <(cd "$TARGET_DIR" && find . -type f -print0)

if [[ ${#files[@]} -eq 0 ]]; then
    print_warn "no matching shell scripts found."
    exit 0
fi

# Run formatter
$DOCKER run --rm -v "$TARGET_DIR:/work" -w /work tmknom/shfmt -i 4 -w -s "${files[@]}"

# Run linter
FAILED=0
for file in "${files[@]}"; do
    $SHELLCHECK -x -P "$TARGET_DIR" -P "$TARGET_DIR/common" "$TARGET_DIR/$file" || FAILED=1
done

exit "$FAILED"
