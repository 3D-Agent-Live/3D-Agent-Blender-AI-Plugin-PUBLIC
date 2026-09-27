# Connect Claude Desktop to 3D-Agent

Source: [3d-agent.com/docs/external-agents#claude-desktop](https://3d-agent.com/docs/external-agents#claude-desktop) (copied 2026-09-25).

Claude Desktop connects to 3D-Agent ([3d-agent.com](https://3d-agent.com)) through a 3D-Agent extension. It needs the 3D-Agent Ultra plan and the 3D-Agent desktop app open and signed in.

## Automatic setup

1. In 3D-Agent, open **Settings** → **External agents**.
2. Turn on **Allow connections**.
3. Next to Claude Desktop, click **Set up**. 3D-Agent writes the extension file and opens it.
4. Install it when Claude Desktop asks, and it connects on its own.

## Install the extension by hand

The extension file is here:

- **macOS:** `~/Library/Application Support/com.3d-agent.app/claude-desktop/3d-agent.mcpb`
- **Windows:** `%APPDATA%\com.3d-agent.app\claude-desktop\3d-agent.mcpb`

In Claude Desktop, open **Settings** → **Extensions**, click **Advanced settings**, click **Install Extension…** and pick that file.

## Why there is no config snippet for Claude Desktop

The extension holds a small relay that runs on Claude Desktop's built-in Node.js and carries your port and token. You can't use `claude_desktop_config.json` or **Settings** → **Connectors** instead:

- `claude_desktop_config.json` starts local command-line (stdio) servers. It can't reach 3D-Agent's HTTP server.
- Custom connectors connect from Anthropic's cloud, not from your computer, so they can't reach a server on `127.0.0.1`.
