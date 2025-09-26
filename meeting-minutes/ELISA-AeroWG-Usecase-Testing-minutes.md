# Use case call Minutes

- Future call, record the demos with zoom? Next time.

## 20250926

**Attendance**

Matt Weber (Boeing)
Shefali Sharma
Salim Jalaleddine (Boeing)
Martin Halle (Hamburg University of Technology)

**Actions**

- Carry over actions
  - Martin
    - Embedded demo documentation updates
  - Paul
    - Debugging test execution wrapper - https://github.com/elisa-tech/wg-aerospace/pull/95

- Matt
  - Review notes and put updates to proposal for review next week - https://github.com/elisa-tech/wg-aerospace/pull/92
  - Get example of qemu serial for Salim to use to drive example cmd msgs
  - Get example of qemu serial to Paul for capturing of test output vs current stdout for emulated test wrapper (may wait until we have some of the cfs example work already using serial)

- Salim
  - Getting cFS demo doc/steps into a PR - https://github.com/elisa-tech/wg-aerospace/pull/98

**Discussion topics**

- Salim presented the simple cFS demo and PR feedback is pending (ready next week for testing) - https://github.com/elisa-tech/wg-aerospace/pull/98

- Matt
  - Figured out emulation failure and sent Paul notes on his PR.
  - Merged a emulation test PR that verfies our images boot correctly - https://github.com/elisa-tech/wg-aerospace/pull/99

- Wanja feedback from Martin at DASC
  - Wants to target hardware and moving from wrapped emulation in our current environment makes this transition hard
  - Making our composition simiplier may fit better into his research (e.g., support a mixed based environment)
  - Matt suggested to Martin to mention to him that we should make this a agenda topic for the next AeroWG call
    - It may drive a new use case we could capture to drive the demo/dev work
    - It might also be a collaboration with SGL as maybe the workflows and automation they're establishing can provide this type of environment.

- Propsal for workshop
  - Research questions and papers - please join or upvote the ideas (Martin submitting)
    - slide on overview
    - break each out with qrcode
  - Walk through our use cases and general sense of rigor/level (Matt submitting)
  - Recorded use case demos video (Matt submitting)

- DASC (Martin) - More general call conversation
  - AI use case
    - validaing AI with AI talk
  - Maybe first spot to publish papers

---

## 20250919

**Attendance**

Matt Weber (Boeing)
Brian Wood  (Boeing)
Rob Woolley (Wind River Systems, Inc.)
Salim Jalaleddine (Boeing)

**Actions**

- Carry over actions
  - Martin
    - Embedded demo documentation updates
  - Paul
    - Debugging test execution wrapper - https://github.com/elisa-tech/wg-aerospace/pull/95

- Matt
  - Figure out emulation CI failure that Paul is seeing in - https://github.com/elisa-tech/wg-aerospace/pull/95
  - Review notes and put updates to proposal for review next week - https://github.com/elisa-tech/wg-aerospace/pull/92
  - Get example of qemu serial for Salim to use to drive example cmd msgs

Salim
- Getting cFS demo doc/steps into a PR - https://github.com/elisa-tech/wg-aerospace/pull/98

**Discussion topics**

- Test execution wrapper - https://github.com/elisa-tech/wg-aerospace/pull/95

- Demo simple cFS app

- Rob
  - Described approaches to Yocto inclusion of cFS - Multi receipe vs.?????
  - Current meta-sgl work
    - 1. BSPs building with Kas
    - 2. Getting automated CI setup
    - 3. Starting to fold in spaceros, cfs, fprime
  - Use case testing of simple app could be a pattern used for a sgl CI test case (Matt suggested)

- Maybe could leverage test framework approaches meta-sgl takes if it's more streamlined then ours?

---

## 20250912

**Attendance**

Matt Weber (Boeing)
Paul Mani (Collins)
Martin Halle (Hamburg University of Technology)
Brian Wood  (Boeing)
Ivan Perez (KBR @ NASA Ames Research)
Rob Woolley (Wind River Systems, Inc.)
Salim Jalaleddine (Boeing)
Shefali Sharma
Wanja Zaeske (DLR)

**Actions**

- Paul
  - Debugging test execution wrapper - https://github.com/elisa-tech/wg-aerospace/pull/95

- Salim
  - Get sample application working in emulation  - cmd from gnd to sample app in emulation (network stack based)
    - Done criteria - manual sequence we could later make into a test case and example
  - Additional ACTION: Create cFS build document from https://github.com/elisa-tech/wg-aerospace/issues/52

- Martin
  - Embedded demo documentation updates

- Matt
  - Review notes and put updates to proposal for review next week - https://github.com/elisa-tech/wg-aerospace/pull/92

**Discussion topics**

- Paul / Ivan - what is the next step on the Raw socket - https://github.com/elisa-tech/wg-aerospace/pull/68?
  - At least a rebase after 72 merges
  - I think doc updates are being handled by Martin's action from a few weeks back on adding the Embedded demo material (doesn't look like we have a ticket for it - https://github.com/elisa-tech/wg-aerospace/issues/33#issuecomment-2992113155)

- Salim
  - Progressing towards a build and currently building and running on QEMU

- Wanja - feedback on getting started / trying instructions
  - vendor free list of dependencies
    - two layers
      - higher level using dockerfile based environment
      - No container, makefile based with all dependencies setup on host
  - sudo-less (both setup and container) (maybe rootless solves part of it - https://github.com/elisa-tech/wg-aerospace/discussions/80)
  - https://github.com/pengutronix/genimage
  - The wrapper may have a corner case with the emulation output having mixed kernel output and print of the test report
    - Suggested serial port to command and get data so it's dedicated
    - Initially could set log level to prevent console output
  - 3 topics ongoing - can we make these more distinct activities?
    - app on linux relevant to use cases
    - testing harness (unit / remote) - (Needs more attention?  Existing work / projects that could more generically to it)
      - Can existing solutions handle this, large assumptions but makes our example simplier?
      - https://labgrid.readthedocs.io/en/latest/index.html - embedded board control python library with a focus on testing, development and general automation. It includes a remote control layer to control boards connected to other hosts.
      - Noted some interest in this
    - bring infra for configuration / system image generation
      - Can existing solutions handle this, large assumptions but makes our example simplier?
      - Interested in system generation / image creation portion

- Future conflicts
  - DASC Next week Sept 19th
  - Ivan out for Sept 19th,  26th
  - German holiday on Oct 3rd


## 20250905

**Actions**

We did not take any actions around finishing out the use case doc (yet) - https://github.com/elisa-tech/wg-aerospace/pull/92

- Matt
  - Merge https://github.com/elisa-tech/wg-aerospace/pull/72
  - Create cFS build document from https://github.com/elisa-tech/wg-aerospace/issues/52  (Salim to review and use for sample app)
- Salim
  - Get sample application working in emulation  - cmd from gnd to sample app in emulation (network stack based)
    - Done criteria - manual sequence we could later make into a test case and example
- Paul - has a PR waiting with emulation wrapper once 72 merges
- Paul / Ivan - what is the next step on the Raw socket - https://github.com/elisa-tech/wg-aerospace/pull/68?
  - At least a rebase after 72 merges
  - I think doc updates are being handled by Martin's action from a few weeks back on adding the Embedded demo material (doesn't look like we have a ticket for it - https://github.com/elisa-tech/wg-aerospace/issues/33#issuecomment-2992113155)

**Discussion topics**

Goals of cFS demo
- Understand the minimal system components required
  - Ivan mentioned, cFS depends on <stdint.h>,<stdbool.h>,<string.h>,<stdlib.h>,<math.h>
  - Progress towards a Minimal kernel and libc from current emulation build
- Demo Apps 2.0
  - Converstion to C as part of cFS (copilot can generate part of the outline of the apps)
  - Switch app (e.g. how we control and configure what is observed)
    - Still want to support configuration input values
    - Get configuration from a virtual serial from outside emulation to drive config to switchapp (mimic's a comm link)
    - Switch app is a cFS app and uses serial info to drive cFS controls
  - Copilot runs as app monitoring commands/telemetry instead of logs
- Tests
  - Trying to mimic the output/inputs so testing approach doesn't change much

Steps
1) Get sample application working in emulation  - cmd from gnd to sample app in emulation (network stack based)
2) Add Cabin Light instead of Sample App (driven by gnd command example)
3) Add Copilot to detect events, commands and monitor
4) Add Cabin Lights Application to drive Cabin Light by the Switch App
5) Move from networking to serial for gnd command
6) Update test cases


---

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

