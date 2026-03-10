#!/bin/bash
# Setup script for all MCP servers in the Control project

set -e

echo "========================================"
echo "Control MCP Servers Setup"
echo "========================================"
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if Claude Code CLI is available
if ! command -v claude &> /dev/null; then
    echo -e "${YELLOW}⚠️  Claude Code CLI not found. Skipping MCP configuration.${NC}"
    echo "Install Claude Code: https://claude.ai/code"
    SKIP_CLAUDE=true
fi

# Track which servers are already configured
already_configured=()

if [ "$SKIP_CLAUDE" != true ]; then
    echo "Checking current MCP configuration..."
    claude mcp list | grep -E '^\s+\S+' | awk '{print $1}' | while read server; do
        already_configured+=("$server")
    done
fi

# Function to check if server is already configured
is_configured() {
    local server_name=$1
    for config in "${already_configured[@]}"; do
        if [[ "$config" == "$server_name" ]]; then
            return 0  # true, it's configured
        fi
    done
    return 1  # false, not configured
}

echo ""
echo "Installing dependencies..."
echo ""

# 1. DuckDuckGo MCP (Python)
echo -e "${YELLOW}[1/4] Setting up DuckDuckGo MCP (requires Python 3.10+ and uv)...${NC}"
if [ -d "nodejs/mcp-servers/duckduckgo-mcp-server" ]; then
    if command -v uv &> /dev/null; then
        cd nodejs/mcp-servers/duckduckgo-mcp-server
        uv sync
        cd /home/sam/projects/Control
        echo -e "${GREEN}✓ DuckDuckGo MCP dependencies installed${NC}"

        # Add to Claude Code if not already configured
        if [ "$SKIP_CLAUDE" != true ]; then
            if ! is_configured "ddg-search"; then
                echo "Configuring DuckDuckGo MCP in Claude Code..."
                claude mcp add ddg-search -- uvx nodejs/mcp-servers/duckduckgo-mcp-server --skip-auth || echo -e "${YELLOW}⚠️  Could not add ddg-search (may already exist)${NC}"
            else
                echo -e "${YELLOW}⊘ DuckDuckGo MCP already configured${NC}"
            fi
        fi
    else
        echo -e "${RED}✗ uv not found. Install: https://github.com/astral-sh/uv${NC}"
        echo "  Then manually run: cd nodejs/mcp-servers/duckduckgo-mcp-server && uv sync"
    fi
else
    echo -e "${RED}✗ DuckDuckGo MCP not found in nodejs/mcp-servers/duckduckgo-mcp-server${NC}"
fi

# 2. Context7 HTTP (Go) - Use hosted version
echo ""
echo -e "${YELLOW}[2/4] Context7 HTTP MCP${NC}"
if [ "$SKIP_CLAUDE" != true ]; then
    if ! is_configured "context7"; then
        echo "Configuring Context7 MCP (using hosted service)..."
        claude mcp add context7 --type http https://context7.liam.sh/mcp || echo -e "${YELLOW}⚠️  Could not add context7 (may already exist)${NC}"
    else
        echo -e "${YELLOW}⊘ Context7 MCP already configured${NC}"
    fi
else
    echo "Manual configuration:"
    echo "  claude mcp add context7 --type http https://context7.liam.sh/mcp"
fi
echo -e "${GREEN}✓ Context7 MCP ready (hosted service)${NC}"

# 3. Microsoft Learn MCP (Remote HTTP)
echo ""
echo -e "${YELLOW}[3/4] Microsoft Learn MCP (Remote)${NC}"
if [ "$SKIP_CLAUDE" != true ]; then
    if ! is_configured "microsoft-learn"; then
        echo "Configuring Microsoft Learn MCP..."
        claude mcp add microsoft-learn --type http https://learn.microsoft.com/api/mcp || echo -e "${YELLOW}⚠️  Could not add microsoft-learn (may already exist)${NC}"
    else
        echo -e "${YELLOW}⊘ Microsoft Learn MCP already configured${NC}"
    fi
else
    echo "Manual configuration:"
    echo "  claude mcp add microsoft-learn --type http https://learn.microsoft.com/api/mcp"
fi
echo -e "${GREEN}✓ Microsoft Learn MCP ready (hosted service)${NC}"

# 4. Playwright MCP (Node.js)
echo ""
echo -e "${YELLOW}[4/4] Playwright MCP (Node.js)${NC}"
if [ -d "nodejs/mcp-servers/playwright-mcp" ]; then
    cd nodejs/mcp-servers/playwright-mcp
    if [ ! -d "node_modules" ]; then
        npm install
    fi
    cd /home/sam/projects/Control
    echo -e "${GREEN}✓ Playwright MCP dependencies installed${NC}"

    if [ "$SKIP_CLAUDE" != true ]; then
        if ! is_configured "playwright"; then
            echo "Configuring Playwright MCP (uses npx)..."
            claude mcp add playwright -- npx @playwright/mcp@latest || echo -e "${YELLOW}⚠️  Could not add playwright (may already exist)${NC}"
        else
            echo -e "${YELLOW}⊘ Playwright MCP already configured${NC}"
        fi
    else
        echo "Manual configuration:"
        echo "  claude mcp add playwright -- npx @playwright/mcp@latest"
    fi
else
    echo -e "${RED}✗ Playwright MCP not found in nodejs/mcp-servers/playwright-mcp${NC}"
fi

# Your custom MCP server
echo ""
echo -e "${YELLOW}[Custom] Your MCP Server${NC}"
if [ -d "nodejs/mcp-server" ]; then
    cd nodejs/mcp-server
    if [ ! -d "node_modules" ]; then
        npm install
    fi
    cd /home/sam/projects/Control
    echo -e "${GREEN}✓ Custom MCP server dependencies installed${NC}"

    if [ "$SKIP_CLAUDE" != true ]; then
        if ! is_configured "control"; then
            echo "Configuring your custom MCP server..."
            claude mcp add control -- node nodejs/mcp-server/index.js || echo -e "${YELLOW}⚠️  Could not add custom control server${NC}"
        else
            echo -e "${YELLOW}⊘ Custom MCP server already configured${NC}"
        fi
    else
        echo "To add your custom MCP server manually:"
        echo "  claude mcp add control -- node nodejs/mcp-server/index.js"
    fi
else
    echo -e "${RED}✗ Custom MCP server not found in nodejs/mcp-server${NC}"
fi

echo ""
echo "========================================"
echo "Setup Complete!"
echo "========================================"
echo ""
echo "Next steps:"
echo "1. Restart Claude Code to load the new MCP tools"
echo "2. Test with: claude mcp list"
echo "3. View available tools: Check the MCP tools panel in Claude Code"
echo ""
echo "Configured MCP Servers:"
echo "  - microsoft-learn (HTTP remote) - Microsoft documentation"
echo "  - playwright – Browser automation"
echo "  - ddg-search – DuckDuckGo web search"
echo "  - context7 – Documentation search"
echo "  - control – Your custom MCP server"
echo ""
echo "To remove an MCP server:"
echo "  claude mcp remove <server-name>"
echo ""
