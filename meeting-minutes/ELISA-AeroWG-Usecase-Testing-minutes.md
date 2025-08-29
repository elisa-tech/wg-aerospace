# Use case call Minutes

## 20250829

**Actions**

- Ivan
  - Opening a new PR marking up https://github.com/elisa-tech/wg-aerospace/blob/main/Aerospace-Uses-Cases.md for a cFS light add use case
  -	Trying the raw socket monitor PR with Paul’s raw update (https://github.com/elisa-tech/wg-aerospace/pull/67)
- Martin
  -	PR for Embedded demo - https://github.com/elisa-tech/wg-aerospace/blob/main/demos/copilot/EmbeddedDemo.md
- Matt
  -	Complete Dev notes PR - https://github.com/elisa-tech/wg-aerospace/pull/72
    - Debugging Paul's issue and see if we can resolve.
  - Convert some tickets to Github discussions
    - New discussions
      - We need docs updated for perspective of wsl vs linux for setup steps - https://github.com/elisa-tech/wg-aerospace/blob/main/demos/docs/EnvSetup.md#start-here
      - Makefile updated to understand when we're inside a container vs. uses Docker in the Make targets - could be part of rootkit work?
  - Create cFS build document from https://github.com/elisa-tech/wg-aerospace/issues/52
  - Add cFS use case discussion to next AeroWG call

**Discussion topics**

- Discuss how we organize work vs ticketing everything (a few ideas below)
  - Inbox doc we check-in where things are added to the list and could graduate when there is enough interest to an issue ticket.
  - Github feature to organize work with “team board” with priority backlog or filter by labels?
  - Other ideas? Github discussions (ACTION to try this)
- Continue cFS debug - https://github.com/elisa-tech/wg-aerospace/issues/52
  - Success!
  - Next step - add a new use case to show cFS plus lights app
    - [Command ingest and sample app](https://github.com/nasa/cFS/tree/main/apps)
    - (1) Ground station app would send the command into the cFS system.  Then sample light app operates based on command request.
    - (2) cabin lights app and switch app - contained within cFS on SW bus.  copilot as a 3rd app listens to the interactions.  Ground station would still send the commands to control the state.
    - Talked about telemetry and copilot with respect to measurement - bus time vs processing

---

## 20250822

**Actions**
- Ivan
  -	Trying the raw socket monitor PR with Paul’s raw update (https://github.com/elisa-tech/wg-aerospace/pull/67)
  -	libexecinfo - tried new build with cFS - https://github.com/elisa-tech/wg-aerospace/issues/52#issuecomment-3237123694
- Martin
  -	Trying the Dev notes PR - https://github.com/elisa-tech/wg-aerospace/pull/72
  -	PR for Embedded demo - https://github.com/elisa-tech/wg-aerospace/blob/main/demos/copilot/EmbeddedDemo.md
- Matt
  - Share qemu launch wrapper script – tag @Mani, Paul (IND) in https://github.com/elisa-tech/wg-aerospace/issues/48
  -	Add libexecinfo to build for cFS cross build
  -	Complete Dev notes PR - https://github.com/elisa-tech/wg-aerospace/pull/72
    -	Doc the bug from Paul and see if we can resolve.

**Next time**
- Discuss how we organize work vs ticketing everything (a few ideas below)
  - Inbox doc we check-in where things are added to the list and could graduate when there is enough interest to an issue ticket.
  - Github feature to organize work with “team board” with priority backlog or filter by labels?
  - Other ideas?
- Continue cFS debug - https://github.com/elisa-tech/wg-aerospace/issues/52
- New items
  - We need docs updated for perspective of wsl vs linux for setup steps - https://github.com/elisa-tech/wg-aerospace/blob/main/demos/docs/EnvSetup.md#start-here
  - Makefile updated to understand when we're inside a container vs. uses Docker in the Make targets
  - Wrap running emulation
    - pkt injection, parse output, (this is an area ivan wants to improve - if we do a PR to the tools, maybe easier on NASA process to get it open)
    - https://github.com/nasa/CTF - This is the tool (testing framework) we would use to read telemetry from the software bus. Not sure if we will be using this since were using copilot? (should we do a use case to get people's feedback?)
    - Could improve test to include a cFS test - monitor check plus the basics of cFS

