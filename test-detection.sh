#!/usr/bin/env bash
#
# Test script for olen-less content detection
#

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/olen-less"

passed=0
failed=0

test_detection() {
    local description="$1"
    local expected="$2"
    local content="$3"

    local result
    result=$(detect_content_type "$content")

    if [[ "$result" == "$expected" ]]; then
        echo "PASS: $description"
        passed=$((passed + 1))
    else
        echo "FAIL: $description (expected: $expected, got: $result)"
        failed=$((failed + 1))
    fi
}

test_file_detection() {
    local file="$1"
    local expected="$2"

    local content
    content=$(head -c 4096 "$file")
    local result
    result=$(detect_content_type "$content")

    if [[ "$result" == "$expected" ]]; then
        echo "PASS: $file -> $expected"
        passed=$((passed + 1))
    else
        echo "FAIL: $file (expected: $expected, got: $result)"
        failed=$((failed + 1))
    fi
}

echo "=== JSON Detection ==="
test_detection "JSON object" "json" '{"key": "value"}'
test_detection "JSON array inline" "json" '[1, 2, 3]'
test_detection "JSON array multiline" "json" '[
  {"id": 1}
]'
test_detection "JSON empty array" "json" '[]'
test_detection "JSON empty object" "json" '{}'
test_detection "INI section (not JSON)" "ini" '[section]'
test_detection "INI with spaces (not JSON)" "unknown" '[Section Name]'

echo ""
echo "=== YAML Detection ==="
test_detection "YAML with ---" "yaml" '---
key: value'
test_detection "YAML key: value" "yaml" 'name: test'
test_detection "YAML nested" "yaml" 'config:
  debug: true'
test_detection "URL (not YAML)" "unknown" 'https://example.com'

echo ""
echo "=== XML/HTML Detection ==="
test_detection "XML declaration" "xml" '<?xml version="1.0"?>'
test_detection "HTML lowercase" "xml" '<html><body>Hi</body></html>'
test_detection "HTML uppercase" "xml" '<HTML><BODY>Hi</BODY></HTML>'
test_detection "DOCTYPE lowercase" "xml" '<!doctype html>'
test_detection "DOCTYPE uppercase" "xml" '<!DOCTYPE html>'
test_detection "SVG" "xml" '<svg xmlns="http://www.w3.org/2000/svg"></svg>'
test_detection "RSS" "xml" '<rss version="2.0"></rss>'

echo ""
echo "=== INI Detection ==="
test_detection "INI section header" "ini" '[mysqld]
datadir=/var/lib/mysql'
test_detection "INI key=value" "ini" 'key=value'
test_detection "INI key = value" "ini" 'key = value'
test_detection "INI comment" "ini" '; this is a comment'

echo ""
echo "=== Markdown Detection ==="
test_detection "Markdown header" "markdown" '# Hello World'
test_detection "Markdown code block" "markdown" 'Some text
```
code
```'

echo ""
echo "=== Sample Files ==="
for f in "$SCRIPT_DIR"/samples/*; do
    ext="${f##*.}"
    case "$ext" in
        json) expected="json" ;;
        yaml|yml) expected="yaml" ;;
        xml|html|svg) expected="xml" ;;
        md) expected="markdown" ;;
        ini) expected="ini" ;;
        *) expected="unknown" ;;
    esac
    test_file_detection "$f" "$expected"
done

echo ""
echo "=== Results ==="
echo "Passed: $passed"
echo "Failed: $failed"

if [[ $failed -gt 0 ]]; then
    exit 1
fi
