#!/bin/bash
# Setup script for additional MCP servers

set -e

echo "Setting up MCP servers..."

# Create mcp-servers directory if it doesn't exist
mkdir -p nodejs/mcp-servers

# 1. DuckDuckGo MCP Server
echo "Installing DuckDuckGo MCP Server..."
cd nodejs/mcp-servers
if [ ! -d "duckduckgo-mcp-server" ]; then
    npm init -y
    npm install @duckduckgo/mcp-server
else
    echo "DuckDuckGo MCP Server already exists, skipping..."
fi

# 2. Context7 MCP Server
echo "Installing Context7 MCP Server..."
if [ ! -d "context7-mcp-server" ]; then
    npm init -y
    npm install @context7/mcp-server
else
    echo "Context7 MCP Server already exists, skipping..."
fi

cd ../..

echo "✓ MCP servers setup complete!"
echo ""
echo "To use these servers, add them to your Claude Code MCP configuration:"
echo "1. Open Claude Code settings"
echo "2. Go to MCP Servers section"
echo "3. Add the following commands:"
echo ""
echo "DuckDuckGo:"
echo "  node nodejs/mcp-servers/duckduckgo-mcp-server"
echo ""
echo "Context7:"
echo "  node nodejs/mcp-servers/context7-mcp-server"
