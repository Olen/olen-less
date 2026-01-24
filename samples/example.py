#!/usr/bin/env python3
"""
Sample Python file for olen-less demonstration.
"""

from typing import Optional


class FileViewer:
    """A class that represents a file viewer."""

    def __init__(self, name: str, extensions: list[str]):
        self.name = name
        self.extensions = extensions
        self._tools: dict[str, str] = {}

    def register_tool(self, extension: str, tool: str) -> None:
        """Register a tool for a specific extension."""
        self._tools[extension] = tool

    def get_tool(self, extension: str) -> Optional[str]:
        """Get the tool for a given extension."""
        return self._tools.get(extension)


def main():
    """Main entry point."""
    viewer = FileViewer("olen-less", [".md", ".json", ".yaml"])

    viewer.register_tool(".md", "glow")
    viewer.register_tool(".json", "jq")
    viewer.register_tool(".yaml", "yq")

    # Demo
    for ext in [".md", ".json", ".txt"]:
        tool = viewer.get_tool(ext)
        if tool:
            print(f"{ext} -> {tool}")
        else:
            print(f"{ext} -> less (fallback)")


if __name__ == "__main__":
    main()
