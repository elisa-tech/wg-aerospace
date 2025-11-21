# Use case call Minutes

**Parking lot:**
  - Figure out distro / definition of environment and who owns / progress it (brought to the main AeroWG call)

  - Dec 5th call - suggesting we talk about the ELISA SystemWG Xen reference systems (docs, builds, testing)

**Holiday / Vacations**
- Matt out Nov 21st and 28th

## 20251121

**Attendance**

- Paul Mani (Collins)
- Rob Woolley (Wind River)
- Martin Halle (Hamburg University of Technology)
- Salim Jalaleddine (Boeing)
- Ivan Perez (KBR @ NASA Ames Research)
- Naga (Times / Lynx)

**Discussion topics**

- PRs
  - Merged: [Enhance Use-Case doc](https://github.com/elisa-tech/wg-aerospace/pull/106/)
  - On-going: [Split out product profiles](https://github.com/elisa-tech/wg-aerospace/pull/107)
    - shared product profiles
    - discussion around adding NASA "class" product examples
    - Suggestions: Merge and update later (and done by Ivan).
  - (Pending) Embedded demo updates (Martin), consider content of: https://github.com/elisa-tech/wg-aerospace/issues/33
  - cFS lights demo (Ivan)
    - refering to: demos/copilot, based on dev-newtemplate branch
    - Two apps: lights app, switch app
    - OGMA template to generate applications was updated
    - added elisa_use_case scripts
    - OGMA script generates application, generate apps, interfaces, test-cases and scitps etc.
    - Demoing to setup the CPU archictecture pending (hasn't been tried to run in the emulator yet)
    - Automated process based on the setup
    - lights app receives 2 commands now: Command to switch and to adjust the delay
    - Default 400 ms delay, can be increased by this new command (e.g. to change the behaviour)
    - time-stamps need to be communicated to the monitors
    - Task to all: Please try!
    - Re-issue in the next meeting (Matt):
      - Open issue: Sample app from cFS is Apache license - how to cope with it? Clarify before applying PR.
      - Auto-generate code based on a tmeplate w/o Apache content/license?
- Workshop report (to be continued)
  - Discussion on papers
  - Discussion on target platforms
  - Relation to SGL group discussions: https://hackmd.io/nx1iVbKxTB2f_0c05dbUxw

## 20251114

**Attendance**

- Paul Mani (Collins)
- Rob Woolley (Wind River)
- Martin Halle (Hamburg University of Technology)
- Salim Jalaleddine (Boeing)
- Ivan Perez (KBR @ NASA Ames Research)

**Discussion topics**

- PRs
  - [Enhance Use-Case doc](https://github.com/elisa-tech/wg-aerospace/pull/106/)
  - [Split out product profiles](https://github.com/elisa-tech/wg-aerospace/pull/107)
    - shared product profiles
    - discussion around adding NASA "class" product examples
  - (Pending) Embedded demo updates (Martin)
  - (Pending) cFS lights demo (Ivan)
  - (Pending) Workshop slides - Matt&Martin
- Ivan shared
  - cFS demo / Ogma
    - Integration of switch and light app (Lights on! w/ fixed delay)
  - release of copilot but no impact to demos (fpga backend changes)
  - ogma will be released ~wk that we'd want to pull in
- Discussed Workshop slides

## 20251107

**Attendance**

- Matt Weber (Boeing)
- Paul Mani (Collins)
- Martin Halle (Hamburg University of Technology)
- Ivan Perez (KBR @ NASA Ames Research)
- Salim Jalaleddine (Boeing)
- David Graziano (Collins Aero)
- Shefali Sharma

**Discussion topics**

Ivan
- talking through Ogma generated apps and message formats for demo
- switch app - "a physical switch"
  - sends a msg id + payload of on/off
  - a notion of time, either cFS header driven or added to the payload
- lights app - "changes physical device state"
  - publishes a state change - another msg id + payload of on/off
  - a notion of time, either cFS header driven or added to the payload

- Writing a paper around this - FSW - add a discussion item for another paper?
  - QEMU / environement / examples / concepts / current state / experience report and vision

Matt
- Action to add cFS demo to slides
- next week workshop slides

Martin
- Update Use-Case doc : See PR106
- Update Embedded Demo doc : Open
- next week workshop slides

---

## 20251031

The group met and progress was shared on previous actions.

## 20251024

**Attendance**

- Matt Weber (Boeing)
- Paul Mani (Collins)
- Martin Halle (Hamburg University of Technology)
- Ivan Perez (KBR @ NASA Ames Research)
- Salim Jalaleddine (Boeing)

**Actions**

- Martin
  - Embedded demo documentation updates

- Emulation test wrapper PR - https://github.com/elisa-tech/wg-aerospace/pull/95
  - Paul plans to cleanup prints and look at some restructuring before merge

- Ivan - continue on ogma example for monitoring simple app (manual example)

- Matt
  - [DONE](https://github.com/elisa-tech/wg-aerospace/commit/b1fbbc47b8fdfb67deedb5f024474e9e1e64d4a7) Get our license files checked in based on SGL
    - The specific license choice was entertained in a combined Aero+SGL call with no feedback specific to Aerospace.  SGL has already adopted.
    - Using https://github.com/elisa-tech/meta-sgl as the ref files to PR in
  - [DONE](https://github.com/elisa-tech/wg-aerospace/blob/main/demos/copilot/src/monitors/Dockerfile#L108) Container update for ogma-cli:ogma - https://github.com/nasa/ogma/?tab=readme-ov-file#compilation
    - **ANNOUNCEMENT** Image is pushed, update by doing a `make prep` and then `make dev` to get into the container to try the `ogma` command.  The container prompt after `make dev` should now provide some version info to help us troubleshoot when things aren't working.
  - Review notes and put updates to proposal for review next week - https://github.com/elisa-tech/wg-aerospace/pull/92

- Salim / Matt work on adjust compile patch approach so we don't check in the pre-built but have instructions in the docs to build after the patch step

**Discussion topics**

- Discuss having Systems WG create a reference system (Kate/Min suggested)
  - Kate proposed - a thought activity for ELISA to compare to Medical & Auto
  - This group suggested, "invite some of the Sys people to our call to talk about it"
    - **ACTION** Next AeroWG call, share what they are doing today / what is a System look like?
    - Draft talking points / questions
      - How would we transition the work if start a collaboration with this group?
      - Ownership of a definition shifts?
      - What would Sys produce that we could use?
      - How would we manage having another WG call?

- Ivan ran through an overview of ogma for Martin and Paul
  - https://github.com/nasa/ogma
  - Next step - going through the app, cleaning up ?tests?

- Martin shared feedback from Wanja - Sending email with more details

---

## 20251017

- Discussed OGMA template.  Ivan has captured the template [here](https://github.com/nasa/ogma/tree/develop-update-cfs-template/updated_template/%7B%7Bapp_name_lc%7D%7D).

- Calling Ogma with the following invocation generates an app that is the same as the sample app (under the directory output, the location can be adjusted), so it should just work in the emulator with the setup that Salim prepared.

```code
./.cabal-sandbox/bin/ogma cfs --condition-expr 'true'   --template-vars vars.json --app-template-dir updated_template --app-target-dir output


The contents of vars.json is:

$ cat vars.json  
{ "app_name_lc": "sample_app" 
, "app_name_uc": "SAMPLE_APP" 
, "app_name_cc": "SampleApp" 
}
```

- **Next step:**  Now we need to remove the specificity of that app (anything that we don't want, like the dependency on sample_lib, or perhaps the unit tests) and add the hook to the monitors.

---

## 20251010

- Matt Weber (Boeing)
- Ivan Perez (KBR @ NASA Ames Research)
- Salim Jalaleddine (Boeing)
- Brian Wood  (Boeing)
- Shefali Sharma

**Actions**

- Carry over actions
  - Martin
    - Embedded demo documentation updates
  - Paul
    - Debugging test execution wrapper - https://github.com/elisa-tech/wg-aerospace/pull/95
  - Matt
    - Review notes and put updates to proposal for review next week - https://github.com/elisa-tech/wg-aerospace/pull/92
  - Ivan - continue on ogma example for monitoring simple app (manual example)

- Matt - plans to review Paul's MR to see if there is anything needed to merge

**Discussion topics**

- Ivan updating ogma templates for copilot version updates (improvement to ogma project)
  - Flexibility in how ogma select the template to use
  - Did a walk through of the template approach

- Matt
  - Briefly touched on technology transition - distro vs requirements vs our own
    - Some conclusion that we can adapt how we do work but focus on transitioning a cFS example with minimal environment to meta-SGL

---

## 20251003

**Attendance**

- Matt Weber (Boeing)
- Ivan Perez (KBR @ NASA Ames Research)
- Salim Jalaleddine (Boeing)
- Brian Wood  (Boeing)

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

- Ivan looking at building a ogma example

**Discussion topics**

Next step with getting a monitored event to work - building on simple cFS app

- Ivan
  - NASA/ogma to generate CFS applications - https://github.com/nasa/ogma/blob/develop/.github/workflows/repo-ghc-8.6-cabal-2.4-cfs.yml#L49
  - Database to code generator
  - Picture to monitor generation
  - Merged Salim's PR and ready to add step to show Ogma example

Fuzzing tests for a cFS deployment this week

- Is this something we want to demo?  Random data injection / millions of test cases - could do a cabin lights cycle through states?  how do you get full coverage?
- Moon collaborative robots/equipment scenario (cFS/ROS/multi-platform)
- unit tests to start but evolved to seed a random testing of data structures e.g., cFS data structure to json, is it correct.
- Ogma can generate most of the content / comparison
- QuickCheck (Haskell checker)
  - https://dl.acm.org/doi/abs/10.1145/351240.351266
  - https://dl.acm.org/doi/abs/10.1145/3110246  (Could pre-record a trace of what we want to drive in the system.  Then add random behaviors/msg against that.)


--

## 20250926

**Attendance**

- Matt Weber (Boeing)
- Shefali Sharma
- Salim Jalaleddine (Boeing)
- Martin Halle (Hamburg University of Technology)

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

- Matt Weber (Boeing)
- Brian Wood  (Boeing)
- Rob Woolley (Wind River Systems, Inc.)
- Salim Jalaleddine (Boeing)

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

- Matt Weber (Boeing)
- Paul Mani (Collins)
- Martin Halle (Hamburg University of Technology)
- Brian Wood  (Boeing)
- Ivan Perez (KBR @ NASA Ames Research)
- Rob Woolley (Wind River Systems, Inc.)
- Salim Jalaleddine (Boeing)
- Shefali Sharma
- Wanja Zaeske (DLR)

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

