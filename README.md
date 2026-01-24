# olen-less

A smarter `less` that automatically uses specialized tools for different file types.

## Features

- Automatically detects file types by extension or content
- Uses the best available tool for each file type
- Falls back gracefully when tools aren't installed
- Works with both files and piped stdin

## Supported File Types

| Type | Extensions | Preferred Tool | Fallback |
|------|------------|----------------|----------|
| Markdown | `.md`, `.markdown`, `.mdown`, `.mkd` | `glow` | `bat` → `less` |
| JSON | `.json`, `.jsonl` | `jq` (colorized) | `less` |
| XML/HTML | `.xml`, `.svg`, `.xhtml`, `.xsl` | `xmllint` + `bat` | `less` |
| YAML | `.yaml`, `.yml` | `yq` | `bat` → `less` |
| CSV | `.csv` | `column` (table format) | `less` |
| Python | `.py` | `bat` | `less` |
| Shell | `.sh`, `.bash`, `.zsh` | `bat` | `less` |
| Other | * | `bat` | `less` |

## Installation

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/olen-less.git
cd olen-less

# Make executable (if not already)
chmod +x olen-less

# Option 1: Symlink to your PATH
ln -s "$(pwd)/olen-less" ~/.local/bin/lless

# Option 2: Add alias to your shell config
echo "alias lless='$(pwd)/olen-less'" >> ~/.bashrc
```

## Optional Dependencies

Install these tools to get enhanced viewing for specific file types:

```bash
# Debian/Ubuntu
sudo apt install jq glow bat xmllint

# Fedora
sudo dnf install jq glow bat libxml2

# macOS
brew install jq glow bat yq

# Arch
sudo pacman -S jq glow bat yq
```

## Usage

```bash
# View a file
lless document.md
lless data.json
lless config.yaml

# Pipe content (auto-detects type)
curl -s https://api.github.com/users/octocat | lless
cat README.md | lless

# Falls back to regular less for unknown types
lless somefile.txt
```

## How Content Detection Works

When reading from stdin (piped content), olen-less examines the content to detect the type:

- **JSON**: Starts with `{` or `[`
- **Markdown**: Starts with `#` header, contains code fences, or YAML front matter
- **XML**: Starts with `<?xml` or `<!DOCTYPE`
- **YAML**: Starts with `---`

## Examples

```bash
# Pretty-print JSON from an API
curl -s https://api.github.com/zen | lless

# View markdown with rendering
lless README.md

# Format and view XML
lless pom.xml

# View CSV as a table
lless data.csv
```

## License

MIT
