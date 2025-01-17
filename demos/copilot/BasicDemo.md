# Basic


## Build

Clone use case codebase

```
git clone https://github.com/elisa-tech/wg-aerospace.git
```

Build Copilot compile monitor

```
cd wg-aerospace/demos/copilot
... do work....
```

## Launch

Logical steps
- Basic setup, run example
- Example modifying app behavior (run for consistent results)
- Tailor copilot spec (run for consistent results)
- Modify system to prove spec/monitor tailoring captures intended behavior

Launch sequence (raw frames)
  1) Start copilot log and Ethernet monitor (bound to localhost)
  2) Bind light app to localhost
  3) Bind light server to localhost
  4) Run client with arg to change state (run x3 to cycle through all transitions - on off on)

```
call sequence....
```

## Observations

How to extend / using it for your own cases.

Do we want to draw a mermaid diagram and have copilot auto gen the monitor?

?
