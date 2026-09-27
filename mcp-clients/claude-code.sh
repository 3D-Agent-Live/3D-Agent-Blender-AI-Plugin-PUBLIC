#!/usr/bin/env bash
# Connect Claude Code to 3D-Agent (https://3d-agent.com).
# Source: https://3d-agent.com/docs/external-agents#claude-code (copied 2026-09-25)
#
# Requires the 3D-Agent Ultra plan, the 3D-Agent desktop app open and signed in,
# and Settings -> External agents -> Allow connections turned on.
# The Set up button in that panel runs these commands for you; use this file to
# check what it does or to do it by hand.
#
# Replace <port> and <token> with the values in
# Settings -> External agents -> Advanced. Always copy the port from the panel:
# 3D-Agent uses 1337 only when that port is free.
# Anyone with your token can spend your prompts. Keep it private.

# Set up first removes any old 3d-agent entry:
claude mcp remove 3d-agent --scope user

# Then adds 3D-Agent for all your projects (--scope user):
claude mcp add --scope user --transport http 3d-agent http://127.0.0.1:<port>/mcp --header "Authorization: Bearer <token>"

# Start a new Claude Code session, then check the connection with /mcp in
# Claude Code, or in a terminal:
#   claude mcp list
