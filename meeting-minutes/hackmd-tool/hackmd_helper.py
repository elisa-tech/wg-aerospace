#!/usr/bin/env python3
# SPDX-License-Identifier: CC-BY-SA-4.0
"""
HackMD meeting minutes helper tool.

Pushes content to or clears the shared HackMD pad used for ELISA Aerospace WG meetings.
Uses the socket.io realtime protocol (no API token needed for freely-editable pads).

Requirements: pip install python-socketio[client] requests websocket-client

Usage:
    hackmd_helper.py push <file>    Push a local minutes file to the HackMD pad
    hackmd_helper.py clear          Clear the pad (leave only the footer)
    hackmd_helper.py pull [file]    Download current pad content (to stdout or file)

Configuration:
    Set HACKMD_NOTE_ID env var to override the default note ID.
"""

import os
import sys
import time
from urllib.parse import urlparse

import requests  # pylint: disable=import-error
import socketio  # pylint: disable=import-error

NOTE_ID = os.environ.get("HACKMD_NOTE_ID", "4-50o2_1Rce60mFJUNYnsQ")

FOOTER = (
    "---\n\nSee https://github.com/elisa-tech/wg-aerospace/blob/main/README.md"
    " for access to meeting minutes, events and other resources!**"
)


def connect_to_pad():
    """Establish socket.io connection to the HackMD pad's realtime server."""
    s = requests.Session()
    s.get(f"https://hackmd.io/{NOTE_ID}")
    cookies = dict(s.cookies)
    cookie_str = "; ".join(f"{k}={v}" for k, v in cookies.items())

    r = s.get(f"https://hackmd.io/realtime-reg/realtime?noteId={NOTE_ID}")
    r.raise_for_status()
    realtime_url = r.json()["url"]

    parsed = urlparse(realtime_url)
    socket_path = parsed.path + "/socket.io/"
    base_url = f"{parsed.scheme}://{parsed.hostname}"

    return base_url, socket_path, cookie_str


def replace_content(new_content):
    """Replace the entire pad content using operational transforms over socket.io."""
    base_url, socket_path, cookie_str = connect_to_pad()

    state = {"done": False, "error": None}
    sio = socketio.Client()

    @sio.on("doc")
    def on_doc(data):
        old = data["str"]
        rev = data["revision"]
        if old == new_content:
            state["done"] = True
            return
        op = [-len(old), new_content] if old else [new_content]
        sio.emit("operation", (rev, op, {"ranges": []}))

    @sio.on("ack")
    def on_ack(*_args):
        state["done"] = True

    try:
        sio.connect(
            f"{base_url}?noteId={NOTE_ID}",
            socketio_path=socket_path,
            transports=["websocket"],
            headers={"Cookie": cookie_str},
        )
        deadline = time.time() + 10
        while not state["done"] and time.time() < deadline:
            time.sleep(0.1)
        time.sleep(0.3)
        sio.disconnect()
    except (socketio.exceptions.ConnectionError, OSError) as e:
        state["error"] = str(e)

    if state["error"]:
        print(f"Error: {state['error']}", file=sys.stderr)
        sys.exit(1)
    if not state["done"]:
        print("Error: Timeout waiting for server", file=sys.stderr)
        sys.exit(1)


def pull(output_file=None):
    """Download current pad content."""
    content = requests.get(f"https://hackmd.io/{NOTE_ID}/download").text
    if output_file:
        with open(output_file, "w", encoding="utf-8") as f:
            f.write(content)
        print(f"Downloaded to {output_file}")
    else:
        print(content)


def push(filepath):
    """Push a local file to the pad, ensuring footer is present."""
    with open(filepath, encoding="utf-8") as f:
        new_content = f.read().rstrip()

    footer_marker = "See https://github.com/elisa-tech/wg-aerospace/blob/main/README.md"
    if footer_marker not in new_content:
        new_content = new_content + "\n\n" + FOOTER

    replace_content(new_content)
    print(f"Pushed {filepath} to HackMD pad")


def clear():
    """Clear the pad, leaving only the footer."""
    replace_content(FOOTER)
    print("Cleared HackMD pad (footer only)")


def main():
    """Parse arguments and run the requested command."""
    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(1)

    cmd = sys.argv[1]
    if cmd == "pull":
        pull(sys.argv[2] if len(sys.argv) > 2 else None)
    elif cmd == "push":
        if len(sys.argv) < 3:
            print("Usage: hackmd_helper.py push <file>", file=sys.stderr)
            sys.exit(1)
        push(sys.argv[2])
    elif cmd == "clear":
        clear()
    else:
        print(f"Unknown command: {cmd}", file=sys.stderr)
        print(__doc__)
        sys.exit(1)


if __name__ == "__main__":
    main()
