#!/usr/bin/env sh
# Helper script for Bitwarden MCP server.
# Required because `bunx @bitwarden/mcp-server` doesn't work yet:
# https://github.com/bitwarden/mcp-server/issues/158
node "$(mise where npm:@bitwarden/mcp-server)/lib/node_modules/@bitwarden/mcp-server/dist/index.js"
