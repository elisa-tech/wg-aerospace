<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

# HackMD Helper Tool

A command-line tool for managing the shared HackMD pad used during ELISA Aerospace WG meetings. It uses the socket.io realtime protocol — no API token or login required (works with freely-editable pads).

## Setup

Requires Python 3.6+ and these packages:

```bash
pip install python-socketio[client] requests websocket-client
```

## Usage

```bash
# Push a meeting minutes file to the pad (before the call)
python3 meeting-minutes/hackmd-tool/hackmd_helper.py push meeting-minutes/ELISA-AeroWG-Meeting-YYYYMMDD.md

# Pull current pad content (after the call)
python3 meeting-minutes/hackmd-tool/hackmd_helper.py pull meeting-minutes/ELISA-AeroWG-Meeting-YYYYMMDD.md

# Clear the pad back to footer only (after pulling notes)
python3 meeting-minutes/hackmd-tool/hackmd_helper.py clear
```

## How it works

The tool connects to HackMD's realtime collaboration server via socket.io (the same protocol used by the browser editor) and applies operational transform operations to replace the pad content.

A 3-line footer is always preserved on the pad:

```text
---

See https://github.com/elisa-tech/wg-aerospace/blob/main/README.md for access to meeting minutes, events and other resources!**
```

- `push` places file content above the footer (appends footer if missing)
- `clear` removes everything except the footer
- `pull` downloads the current pad content via the `/download` endpoint

## Configuration

By default the tool targets the AeroWG meeting minutes pad. Override with:

```bash
export HACKMD_NOTE_ID="your-note-id-here"
```

The note ID is the string after `hackmd.io/` in the pad URL (e.g., `4-50o2_1Rce60mFJUNYnsQ`).
