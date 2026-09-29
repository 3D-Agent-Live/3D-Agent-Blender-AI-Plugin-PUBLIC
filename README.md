# 3D-Agent: AI agent for Blender

**3D-Agent ([3d-agent.com](https://3d-agent.com))** is a paid desktop app for macOS and Windows that works on your open scene in Blender 4.2 or later. It installs and updates its own Blender extension automatically, so there is no add-on to install by hand and no API key to configure. Paid plans include prompts.

This repository holds public documentation for 3D-Agent: ready-to-copy MCP configurations for using 3D-Agent from Claude Code, Cursor, Codex and Claude Desktop, and example prompts. It does not contain the 3D-Agent app's source code. The full documentation is at [3d-agent.com/docs](https://3d-agent.com/docs).

_Updated: 2026-09-25_

## What does 3D-Agent do in Blender?

3D-Agent works inside your open Blender scene. It builds, edits and renders step by step, like an artist you brief; it is not a one-shot generator that turns a single prompt into a finished asset. According to [What 3D-Agent can and can't do](https://3d-agent.com/docs/what-it-can-do), 3D-Agent is strongest at:

- Hard-surface and product models: furniture, props, vehicles, tools, mechanical parts
- Architecture and interiors at real-world scale, including from exact measurements
- Low-poly and game assets, including Roblox assets
- Scene layout: arranging objects, cameras and lights, and dressing scenes with free assets from [plugins](https://3d-agent.com/docs/plugins)
- Editing what you already have: changing, fixing or re-texturing models in your scene
- Cleanup: reducing polygons, fixing UVs and tidying meshes from other AI tools
- Renders and simple animation: lighting, cameras, turntables, fly-throughs and keyframed motion
- Blender automation: repetitive or fiddly tasks, written and run as Blender Python for you

Results are editable Blender objects in your scene.

## What do I need to run 3D-Agent?

- macOS 12 or later, or Windows 10 or later
- Blender 4.2 or later, open, with the scene you want to work on
- A 3D-Agent account on a paid plan
- An internet connection while prompting

Download the app from [3d-agent.com/download](https://3d-agent.com/download). See [Connect to Blender](https://3d-agent.com/docs/connect-blender) for the first connection.

## How much does 3D-Agent cost?

3D-Agent has three paid plans. There is no free tier.

| Plan | Price | Prompts per month |
| --- | --- | --- |
| Basic | $19/month | 100 |
| Pro | $29/month | 200 |
| Ultra | $89/month | 800 |

Students and content creators can [request prompts](https://3d-agent.com/docs/student-and-creator-prompts). Current prices, annual billing and the full feature comparison are on the [pricing page](https://3d-agent.com/pricing).

## How do I use 3D-Agent from Claude Code, Cursor, Codex or Claude Desktop?

While the 3D-Agent desktop app is open, it runs a local MCP server. Claude Code, Claude Desktop, Cursor and Codex can connect to it and hand 3D-Agent a task in plain language; 3D-Agent does the work in your open Blender scene and sends its reply back. This feature is called **External agents** and needs the **Ultra** plan.

1. In 3D-Agent, open **Settings** → **External agents**.
2. Turn on **Allow connections**. This creates the connection token that apps use to reach 3D-Agent.
3. Next to the app, click **Set up**. Set up writes the right configuration for each app, so you don't have to type a port or a token.

The configurations below are what **Set up** writes, for checking it or doing it by hand. Find your port and token in **Settings** → **External agents** → **Advanced**. 3D-Agent uses port `1337` when it's free and picks a different port otherwise, so always copy the port from the panel. Replace `<port>` and `<token>` with yours.

> **Keep your token private.** Anyone with your connection token can spend your prompts. Never paste a real token into an issue.

### Claude Code

```bash
claude mcp add --scope user --transport http 3d-agent http://127.0.0.1:<port>/mcp --header "Authorization: Bearer <token>"
```

Start a new Claude Code session after setup, then run `/mcp` in Claude Code, or `claude mcp list` in a terminal, to check that `3d-agent` is connected. File: [`mcp-clients/claude-code.sh`](mcp-clients/claude-code.sh).

### Cursor

Put this in `~/.cursor/mcp.json` for all projects, or in `.cursor/mcp.json` for one project:

```json
{
  "mcpServers": {
    "3d-agent": {
      "url": "http://127.0.0.1:<port>/mcp",
      "headers": {
        "Authorization": "Bearer <token>"
      }
    }
  }
}
```

File: [`mcp-clients/cursor-mcp.json`](mcp-clients/cursor-mcp.json).

### Codex (and the ChatGPT desktop app)

Add this to `~/.codex/config.toml` on macOS or `%USERPROFILE%\.codex\config.toml` on Windows (or `config.toml` in `CODEX_HOME` if you set it):

```toml
[mcp_servers."3d-agent"]
url = "http://127.0.0.1:<port>/mcp"
http_headers = { Authorization = "Bearer <token>" }
tool_timeout_sec = 960
```

Codex stops a tool call after 60 seconds unless you raise this; 3D-Agent tasks can take up to 15 minutes, so keep the `tool_timeout_sec = 960` line. The Codex CLI, the Codex IDE extension and the ChatGPT desktop app share this file. Don't use `codex mcp add` for this: it only reads a token from an environment variable, not a header you type in. File: [`mcp-clients/codex-config.toml`](mcp-clients/codex-config.toml).

### Claude Desktop

Claude Desktop connects through a 3D-Agent extension (`.mcpb`) that **Set up** writes and opens; install it when Claude Desktop asks. You can't use `claude_desktop_config.json` or **Settings** → **Connectors** instead. Manual steps: [`mcp-clients/claude-desktop.md`](mcp-clients/claude-desktop.md).

### Then ask for 3D work

> Use 3D-Agent to model a low-poly wooden crate in Blender, then tell me its dimensions.

The connected app sees one tool, `3d_agent`, with one required field, `task`. Each task uses one prompt from your Ultra plan, the same as a message you type. Keep 3D-Agent open until the reply comes back. Full guide and troubleshooting: [3d-agent.com/docs/external-agents](https://3d-agent.com/docs/external-agents).

## Example prompts

[`prompts/`](prompts/) has 11 example prompts copied from [3d-agent.com/docs/example-prompts](https://3d-agent.com/docs/example-prompts): stylized characters, props, low-poly game buildings, Roblox avatars, architecture at real scale, scene dressing with free assets and an exploded-view animation.

## FAQ

### Is 3D-Agent a Blender MCP server?

No. A Blender MCP server gives an assistant low-level Blender commands, and that assistant does the 3D work itself. 3D-Agent is its own agent for Blender, with its own tools, checkpoints and step limits. 3D-Agent's MCP server exposes a single tool, `3d_agent`, that hands a whole task to that agent. You don't need a Blender MCP add-on to use 3D-Agent.

### Do I need an API key to use 3D-Agent?

No. 3D-Agent has no API key to configure. You can't pick the AI model or use your own API key: 3D-Agent runs its own agents on leading AI models, and paid plans include prompts. Local models aren't supported.

### Does 3D-Agent upload my .blend files?

No. We never receive or store your .blend files or 3D model files. Your prompts and the scene information 3D-Agent reads to do the work (such as object names, measurements and viewport captures) are sent to our API and AI model providers to generate results, and may be used to improve 3D-Agent, as described in our [Privacy Policy](https://3d-agent.com/privacy-policy). Summary: [Privacy and data](https://3d-agent.com/docs/privacy).

### Is 3D-Agent free?

No. 3D-Agent is a paid product with three plans: Basic, Pro and Ultra. Students and content creators can [request prompts](https://3d-agent.com/docs/student-and-creator-prompts).

### Which Blender version does 3D-Agent need?

3D-Agent needs Blender 4.2 or later, on macOS 12 or later or Windows 10 or later.

### Is the 3D-Agent source code in this repository?

No. This repository contains documentation, MCP client configurations and example prompts only. For help with the app, use the [3D-Agent Discord](https://discord.gg/NxKFCvHQpg) (see [Get help](https://3d-agent.com/docs/get-help)).

## Links

- Website: [3d-agent.com](https://3d-agent.com)
- Documentation: [3d-agent.com/docs](https://3d-agent.com/docs)
- Pricing: [3d-agent.com/pricing](https://3d-agent.com/pricing)
- Download: [3d-agent.com/download](https://3d-agent.com/download)
- Changelog: [3d-agent.com/changelog](https://3d-agent.com/changelog)
- External agents guide: [3d-agent.com/docs/external-agents](https://3d-agent.com/docs/external-agents)
- Support: [Get help](https://3d-agent.com/docs/get-help) (Discord tickets)

