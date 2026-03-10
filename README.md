# Control

A hybrid Python and Node.js project utilizing Python for primary utilities and Node.js for MCP (Model Context Protocol) server setup.

## Structure

```
├── python/                     # Primary Python utilities
│   ├── src/                   # Source code
│   └── requirements.txt
├── nodejs/                    # Node.js components
│   ├── mcp-server/            # Custom MCP server implementation
│   ├── mcp-servers/           # Third-party MCP servers
│   │   ├── playwright-mcp/    # Playwright browser automation
│   │   ├── microsoft-learn-mcp/ # Microsoft Learn docs (source)
│   │   ├── duckduckgo-mcp-server/ # DuckDuckGo search (Python-based)
│   │   └── context7-http/     # Context7 docs (Go-based)
│   └── utilities/             # Additional Node.js utilities
├── scripts/                   # Setup and utility scripts
├── .gitignore
└── README.md
```

## Available MCP Servers

### 1. Microsoft Learn MCP (Remote - Recommended)
**No installation needed** - This is a hosted MCP server by Microsoft.
- URL: `https://learn.microsoft.com/api/mcp`
- Provides: Microsoft documentation, Azure SDKs, code samples
- Free, no authentication required
- Add via: `claude mcp add microsoft-learn --type http https://learn.microsoft.com/api/mcp`

### 2. Playwright MCP (Node.js)
Browser automation using Playwright.
- Install: `npm install` in `nodejs/mcp-servers/playwright-mcp/`
- Run: `claude mcp add playwright -- npx @playwright/mcp@latest`
- OR use local: `claude mcp add playwright -- node nodejs/mcp-servers/playwright-mcp/dist/index.js`
- Requires: Node.js 20+ (Node 18 works with warnings)

### 3. DuckDuckGo Search (Python)
Web search via DuckDuckGo.
- Requires: Python 3.10+, `uv` package manager
- Install: `uv sync` in `nodejs/mcp-servers/duckduckgo-mcp-server/`
- Run: `claude mcp add ddg-search -- uvx duckduckgo-mcp-server`
- Tools: `search`, `fetch_content`

### 4. Context7 HTTP (Go)
Documentation search via Context7.
- Requires: Go toolchain OR use prebuilt Docker image
- Build: `make build` in `nodejs/mcp-servers/context7-http/`
- OR run hosted: `https://context7.liam.sh/mcp`
- Run: `claude mcp add context7 --type http https://context7.liam.sh/mcp`

## Development

### Python Utilities
```bash
cd python
pip install -r requirements.txt
# or use uv
uv pip install -r requirements.txt
```

### Node.js MCP Servers
```bash
# Your custom MCP server
cd nodejs/mcp-server
npm install

# Playwright MCP (development)
cd nodejs/mcp-servers/playwright-mcp
npm install
```

### Setup All MCP Servers
```bash
# Run the setup script to configure all servers
./scripts/setup-all-mcp.sh
```

## Quick Start

1. **Configure MCP servers** (choose one or all):
   ```bash
   # Microsoft Learn (remote, recommended)
   claude mcp add microsoft-learn --type http https://learn.microsoft.com/api/mcp

   # DuckDuckGo Search (requires Python + uv)
   cd nodejs/mcp-servers/duckduckgo-mcp-server
   uv sync
   cd /home/sam/projects/Control
   claude mcp add ddg-search -- uvx nodejs/mcp-servers/duckduckgo-mcp-server

   # Playwright MCP (Node.js)
   cd nodejs/mcp-servers/playwright-mcp
   npm install
   cd /home/sam/projects/Control
   claude mcp add playwright -- npx @playwright/mcp@latest

   # Context7 (HTTP remote)
   claude mcp add context7 --type http https://context7.liam.sh/mcp
   ```

2. **Test your configuration**:
   ```bash
   claude mcp list
   ```

3. **Restart Claude Code** to load the MCP tools

## License

MIT
