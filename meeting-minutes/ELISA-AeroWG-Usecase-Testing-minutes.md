<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Use case call Minutes

Zoom link for call - <https://zoom-lfx.platform.linuxfoundation.org/meeting/95688254268?password=d7353f64-663f-4b53-8a8f-1e7b2ab7aa05>

**Holiday / Vacations**

**Parking lot:**

- ELISA blog post - what do we want to do for this? demo? what content, what doc work do we need to finish first

- Present to ELISA SystemWG Xen reference system for Aerospace (docs, builds, testing)

- Is it worth building our stuff on RISC-v / polarfire for the demo? Could show a bridge to HPSC
  - <https://www.qemu.org/docs/master/system/riscv/microchip-icicle-kit.html>

## 20260227

**Attendance**

- Matt Weber (Boeing)
- Leonidas Kosmidis (Barcelona Supercomputing Center)
- Martin Halle (Hamburg University of Technology)
- Ivan Rodriguez (Coros Space)
- Ivan Perez (KBR @ NASA ARC)
- Brian Wood (Boeing)
- Wanja Zaeske

**Discussion topics**

Martin

- Tested Nix instructions - has feedback for Wanja's (merged) PR

AI/ML SGL email

- Minimal requirements? Are they really minimal?
- How would you have a qualified coexist with non (this would 100% that sort of case?)
- ACTION: Matt to respond with points around
  - Invite them to join the next SGL or Aerospace call
  - Mention Minimal features and discuss what the provide builds on it….
  - Where is your interest in participating in helping us define and mature the projects towards your goals?

Radiation testing

- <https://github.com/elisa-tech/wg-aerospace/issues/151>

QEMU based code coverage (Wanja mentioned)

- NQC²: A Non-Intrusive QEMU Code Coverage Plugin - <https://dl.acm.org/doi/10.1145/3642921.3642924>
- Couverture from adacore qemu (Ivan R)

Presentation on QEMU (Future call - Leonidas)

Doc update (Martin)

- Matt added CI check - <https://github.com/elisa-tech/wg-aerospace/blob/main/.github/workflows/register-check.yml>
- (Last call) Ivan had a reference for doc approach / structure
  - <https://github.com/nasa/ogma>
  - <https://github.com/ivanperez-keera/Yampa>
  - <https://github.com/ivanperez-keera/dunai/>
  - <https://github.com/Copilot-Language/copilot/>
  - Our landing pages in specific topics would follow a similar structures (suggested) ACTION: Martin said he'd take a look at example for next time

(Last call) cFS (Ivan)

- topic of platforms to support at TSC this week
- need to get minimal kernel work and minimal dependency pieces aligned with SGL
- could help with getting it to fly and further NASA support
- ACTION: Matt will reach out to Ramon and Rob to see how we best coordinate this as it has been discussed before and building confidence for all stakeholders will only help SGL success and further round out the definition of our industry needs.

(Last call) Discussion on python and Makefile

- organizing of python (follow python practice standard)
- split the Makefile so docker and build are split (layers that streamline but also allow advanced use)
  - allows inclusion of the build in nix and other use
  - allows us to still have a focus on demo
  - update the end user perspective, 1) maybe there are parts they need to focus on 2) or others may want to do part of the concept
  - for the advanced case - update the goals and outline how we handle docs + setup details where we expect "conventions to apply"
  - top level must be simple
    - individual components are made to be accessible
- (Matt) PR for the goal/design update
  - <https://github.com/elisa-tech/wg-aerospace/tree/main/demos>
  - <https://github.com/elisa-tech/wg-aerospace/blob/main/demos/Readme.md>

---

## 20260220

**Attendance**

- Matt Weber (Boeing)
- Wanja Zaeske
- Brian Wood (Boeing)
- Martin Halle (Hamburg University of Technology)
- Ivan Rodriguez (Coros Space)
- Leonidas Kosmidis (Barcelona Supercomputing Center)
- Ivan Perez (KBR @ NASA ARC)
- Nagamahesh Gamidi (Timesys / Lynx)

**Discussion topics**

Presentation on QEMU

- Leonidas will try for Feb 27th

Discussion on python and Makefile

- organizing of python (follow python practice standard)
- split the Makefile so docker and build are split (layers that streamline but also allow advanced use)
  - allows inclusion of the build in nix and other use
  - allows us to still have a focus on demo
  - update the end user perspective, 1) maybe there are parts they need to focus on 2) or others may want to do part of the concept
  - for the advanced case - update the goals and outline how we handle docs + setup details where we expect "conventions to apply"
  - top level must be simple
    - individual components are made to be accessible
- (Matt) PR for the goal/design update
  - <https://github.com/elisa-tech/wg-aerospace/tree/main/demos>
  - <https://github.com/elisa-tech/wg-aerospace/blob/main/demos/Readme.md>

Doc update (Martin) - <https://github.com/elisa-tech/wg-aerospace/pull/140>

- walked through register approach
- feed back was good
- solves the "where is the info problem" without grepping in a clone'd repo
- plan to merge current work and then we'll iterate on updates
  - ACTION: (weber plans a CI check for md update)
- Ivan had a reference for doc approach / structure
  - <https://github.com/nasa/ogma>
  - <https://github.com/ivanperez-keera/Yampa>
  - <https://github.com/ivanperez-keera/dunai/>
  - <https://github.com/Copilot-Language/copilot/>
  - Our landing pages in specific topics would follow a similar structures (suggested) ACTION: Martin said he'd take a look at example for next time

cFS (Ivan)

- topic of platforms to support at TSC this week
- need to get minimal kernel work and minimal dependency pieces aligned with SGL
- could help with getting it to fly and further NASA support
- ACTION: Matt will reach out to Ramon and Rob to see how we best coordinate this as it has been discussed before and building confidence for all stakeholders will only help SGL success and further round out the definition of our industry needs.

Nix PR - <https://github.com/elisa-tech/wg-aerospace/pull/115>

- `nix flake show` (outlines the system view of what all is assembled with versions)
- Is it worth building our stuff on RISC-v / polarfire for the demo? Could show a bridge to HPSC
  - <https://www.qemu.org/docs/master/system/riscv/microchip-icicle-kit.html>
- ACTION: merge after a couple minor fixes

---

## 20260213

**Attendance**

- Matt Weber (Boeing)
- Leonidas Kosmidis (Barcelona Supercomputing Center)
- Ivan Perez (KBR @ NASA ARC)
- Wanja Zaeske

**Discussion topics**

Testing ARM64 hosts

- [PR that automates host testing](https://github.com/elisa-tech/wg-aerospace/pull/137)
- [PR Docker only installs if not installed](https://github.com/elisa-tech/wg-aerospace/pull/136)
- Docs/tutorial step automation (keep docs relevant by executing the docs) - (Ivan shared a paper was written)
- Ivan R - ACTION Matt to check with him for retest

- Nix PR
  - ACTION: Matt to check his comments
  -

- Minimal kernel demos?
  - Last call
    - How minimal can we get and run parts of what we already did <<- Wanja has interest in this with the Nix work
    - Do we research beyond config?
    - Have a 5.15 now but would a newer be better?
    - Could lead to discussions on assurance of a configuration? (traditional methods / breaking subsets and parts to improve QA towards cert)
      - There are some efforts today upstream? Do those overlap?
    - Nvidia - where does their functional safety work fit? Do we try to fold in?

  - Do we start with minimizing and maintain basic demo?
    - Pick the specific architecture, targeted hardware, targeted IO
    - Find common components / IO?
    - Benefits of Linux: Clear user interface and suite of Drivers
    - Which direction do we start, super limited and work up or tiny down?
    - Where does this fit with ELISA Architecture / Linux Features for Safety WGs?
      - ELISA has a tool for safety config - <https://github.com/elisa-tech/kconfig-safety-check>
      - ACTION: find link to Features work on smaller then Tiny
    - Do we have users, do we run multicore, Ethernet in userspace,
      - Matt offered to share updated super minimal with research material
    - What is this if we minimalize to a point where it really isn't linux?
    - Leonidas will share a paper link to Metasat study on hypervisor+RTEMS for space (went through similar activity of what capability was needed)
      - paper is "Mixed-Criticality Flight Software Integration In a High Performance RISC-V Space Platform", but the proceedings of the SMC-IT 2025 is not yet published in ieeexplore
      - demo in RISC-V summit Europe 2025: <https://www.youtube.com/watch?v=0LleyXCZLjg&list=PL85jopFZCnbNG7C1gljj2JRocxwT3fNux&index=11>
  - Look for a platform (e.g. embedded sensor, something that flys) that others are advancing <-- we could contribute to the kernel side?
    - Is there a demo (at least for visibility) - Need to see how this ties into progress
  - User space items are not considered in the SLOC measurements (just limited by what Kernel can do)
  - Steps
    - Matt/Brian shares config + research on new ticket (minimal config ticket) and tag on Nix PR
      - Would be interested to recount the size of this with Wanja's tooling
    - Nix updated for a minimal config respectively from research or examples shared in minimal config ticket
    - Tailor - Disable multicore? Drivers enabled?
      - Networking - Raw Sockets / UDP (Look a size difference?)
      - Storage - MTD?
    - Nix cross toolchain build the copilot monitor C code (MUSL as libc for higher assurance, lower, GLIBC mostly for userspace compat reasons)
    - Package monitor C code into cpio for emulation
      - Prototype, could run monitor in background and echo strings to files it watches
    - Development
      - Run demo apps outside of emulation and talk to emulation with Raw sockets?
      - A version of the demo apps on target that isn't a interpreter (e.g., python)?

---

## 20260206

**Attendance**

- Matt Weber (Boeing)
- Brian Wood (Boeing)
- Martin Halle (Hamburg University of Technology)
- Ivan Perez (KBR @ NASA ARC)
- Ivan Rodriguez (Coros Space)

**Discussion topics**

Testing ARM64 hosts

- Ivan R tried the Basic demo on ARM64 and ran into a copilot import error
  - ACTION: Matt to open PR to help to drop xfs condition and fix to have the setup script only install docker if not present - <https://github.com/elisa-tech/wg-aerospace/blob/main/demos/env/setup-env.sh#L18>
  - ACTION: Ivan R checking on another machine as well. `docker run hello-world` similar error?
    - Looks like a docker.ce vs docker.io issue across ubuntu devices....

```
    Detected architecture: aarch64
    docker run --rm -it -e HOST_UID="1000" -e HOST_GID="1000" -v /home/irodrigu/wg-aerospace/demos/copilot/src/monitors/../:/demo registry.gitlab.com/elisa-tech/aero-wg/aero-wg-ci/copilot:2284164686 sh -c 'cat /.VERSION && bash'
    docker: Error response from daemon: failed to set up container networking: failed to create endpoint competent_black on network bridge: Unable to enable DIRECT ACCESS FILTERING - DROP rule:  (iptables failed: iptables --wait -t raw -A PREROUTING -d 172.17.0.2 ! -i docker0 -j DROP: iptables v1.8.7 (legacy): can't initialize iptables table `raw': Table does not exist (do you need to insmod?)
    Perhaps iptables or your kernel needs to be upgraded.
     (exit status 3))
    Run 'docker run --help' for more information
    make: *** [Makefile:68: dev] Error 125
```

Demo ideas

- (Ivan) Demos with FPGA doing monitoring of processor execution? Is this interesting as a demo?
  - primary processor doing work, secondary running monitoring pieces (could be logic, could be RT code)
  - <https://hacarus.com/wp-content/uploads/2021/05/Figure2_EN_Versal_Series_Overview_cropped_ano_%E9%BB%92%E6%9E%A0-1024x535.png>
    - Similar to this with processor doing workflow with firmware doing monitoring / checks on executing code with shared mem
    - There is a systemc TLM from AMD with A and R core ARMs could be used to simulate it - <https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/862421112/Co-simulation>
  - Martin - valid application within how Aerospace does IO / integrates devices
  - Matt - Suggested SGL topic? Maybe have hardware / others interested to build a scenario?
    - ACTION: Ask Manuel about cFS / copilot
  - Ivan - Intern did some work --> <https://github.com/Copilot-Language/copilot/tree/master/copilot/examples/fpga/HelloWorld>
    - <https://bluespec.com/> - language conversion to verilog (copilot->bluespec->verilog)
    - Thinking a cFS application that interfaces to FPGA

- Minimal kernel demos?
  - How minimal can we get and run parts of what we already did <<- Wanja has interest in this with the Nix work
  - Do we research beyond config?
  - Have a 5.15 now but would a newer be better?
  - Assurance of a configuration? (traditional methods / breaking subsets and parts to improve QA towards cert)
    - There are some efforts today upstream? Do those overlap?
  - Nvidia - where does their functional safety work fit? Do we try to fold in?

- Matt - interest in mixed functions and interference
  - interference study and tools
  - <https://www.manschula.dev/projects/seniord/>
  - <https://github.com/2Manchu/MOAT>

Docs are in progress (Martin)

- Move and clean/clarify material
- Registry/index of content to make it navigatable
- Make it easier for new users to navigate "Start"

- Testing of [WIP: cFS app demonstration](https://github.com/elisa-tech/wg-aerospace/pull/109)
  - Matt stopped and pulled Salim in to add the missing assumptions to docs / steps
  - Martin?
  - Salim?

**Next time**

- QEMU overview / examples (Martin)
  - Leonidas mentioned he could do some overview
  - ACTION: Leonidas, Feb 20th to present on Use case call(this call)
  - **Matt emailed Ramon** about March call to repeat presentation (no response so far)

- Matrix of apps vs env and what we want to show/support? (Martin)
  - How do we best document this with current work?
  - How do we breakout parts to make them usable?

PRs - <https://github.com/elisa-tech/wg-aerospace/pull/>

---

## 20260130

**Attendance**

- Matt Weber (Boeing)
- Brian Wood (Boeing)
- Martin Halle (Hamburg University of Technology)
- Ivan Perez (KBR @ NASA ARC)
- Ivan Rodriguez (Coros Space)
- Leonidas Kosmidis (Barcelona Supercomputing Center)

**Discussion topics**

- Copilot / ogma releases - mostly sequence diagram focused

- Contributing/license PR is merged and rebased [WIP: cFS app demonstration](https://github.com/elisa-tech/wg-aerospace/pull/109)
  - Other PRs are good for rebase
  - Wanja, you've been added to the project so if you want to branch on the project (vs fork) the workflows will run.

- Merged ARM64 Host support after testing with Martin
  - Wanja did you find that example of the binfmt approach for a CI runner build?

- Add notes to Contrib
  - Add a detail about blobs and formats that don't have commenting
  - e.g json? pdfs, etc
  - This command puts CC on the whole cfs folder, however you probably want to run a few commands at different subfolders to get most of the designations correct for Apache/ MIT . then fixup some manually where the files mix with different licenses.
  - docker run --rm --volume $(pwd):/data fsfe/reuse annotate --license CC-BY-SA-4.0 --recursive --fallback-dot-license demos/copilot/src/cfs/
  - docker run --rm --volume $(pwd):/data fsfe/reuse supported-licenses
  - Updates so all license descriptions are in the license folder.
  - docker run --rm --volume $(pwd):/data fsfe/reuse download

- QEMU overview / examples (Martin)
  - Leonidas mentioned he could do some overview
  - ACTION: Leonidas, Feb 20th to present on Use case call(this call)
  - ACTION: Matt mentioned to Ramon about March call to repeat presentation

- Docs ACTION: (Martin)
  - Move and clean/clarify material
  - Registry/index of content to make it navigatable
  - Make it easier for new users to navigate "Start"

- Testing of [WIP: cFS app demonstration](https://github.com/elisa-tech/wg-aerospace/pull/109)
  - Martin and Matt took an action
  - Bug in ubuntu PC 24.04 on setup.sh with needing containerd installed as well. Need to test on 22.04
  - Build-cfs.sh
    - fix step 5 to be clear about `cd /demo`
    - Needs a version reworked for the lights demo w/cfs
  - Spent remaining time walking steps
  - This needs fixed for the new lights demo apps and tables - <https://github.com/elisa-tech/wg-aerospace/blob/main/demos/copilot/src/cfs/scripts/load_cfs.sh#L27>
    - Something in 28-66 needs rework

**Next time**

- Matrix of apps vs env and what we want to show/support? (Martin)
  - How do we best document this with current work?
  - How do we breakout parts to make them usable?

- Like to go through next step for demos - (Ivan)

PRs - <https://github.com/elisa-tech/wg-aerospace/pull/>

---

## 20260123

**Attendance**

- Matt Weber (Boeing)
- Brian Wood (Boeing)
- Martin Halle (Hamburg University of Technology)
- Ivan Perez (KBR @ NASA ARC)
- Ivan Rodriguez (Coros Space)
- Wanja Zaeske (DLR)
- Leonidas Kosmidis (Barcelona Supercomputing Center)

**Discussion topics**

- License - <https://github.com/elisa-tech/wg-aerospace/pull/121>
  - Matt to rebase - [WIP: cFS app demonstration](https://github.com/elisa-tech/wg-aerospace/pull/109)
  - Work with Wanja after licensing is on main
  - ALL have action to review license PR for agreeing on file licenses

- cFS is working a new release (Ivan)

- Matt shared PR for HOST64 support
  - Wanja has an example of binfmt approach we could look at for the runner
  - [Cross platform tool env](https://github.com/elisa-tech/wg-aerospace/pull/117/files)
  - Matt and Martin testing after call

- FSW March 23-26th - Paper accepted for "Industry Safety Level(s) vs. Aerospace Use Cases"
  - Matt can't, but would others like to present?
    - Ivan offered, Matt will add him to the email thread
    - Will want to collaborate on the demo and the points we want this community to take away
  - Leonidas will be in person

- Annual slides
  - Contributors - 295 commits from 9 difference contributors
    - <https://github.com/elisa-tech/wg-aerospace/graphs/contributors?from=2%2F22%2F2024&to=1%2F17%2F2026>
  - Make a ref system line in 2026
    - target hw and define a use-case / system to work on
      - Example: RPi (easily available) and: <https://www.raspberrypi.com/for-industry/space/>
    - custom kernel and something we can benchmark against
    - hw what is relatable? Nvidia orin (Ivan R)?
    - solid emu target (qemu) that also covers peripherals (Wanja)
      - <https://qemu-project.gitlab.io/qemu/system/target-arm.html>

- <https://riscv-europe.org/summit/2026/> (Contact Leonidas if interested!)
  - RISC-V in space
  - Doesn't require full member (just registration)

**Next call**

- QEMU overview / examples (Martin)
  - Leonidas mentioned he could do some overview
  - Maybe a good general call topic? (call between SGL/Aero)
    - Feb 12 AeroWG or 19th SGL
    - ACTION: Matt to mention to Ramon. Leonidas to check on dates and update us at the next call

- Merged the cFS use case doc and re-organized the material
  - Move new cases to discussion ideas
  - Added landing page

PRs - <https://github.com/elisa-tech/wg-aerospace/pull/>

- [WIP: cFS app demonstration](https://github.com/elisa-tech/wg-aerospace/pull/109)
  - Work towards merge for next call?
- [feat: add Nix based ELISA demo framework](https://github.com/elisa-tech/wg-aerospace/pull/115)
  - Ivan had a follow on. Matt and Martin still to try it out
  - Work towards merge for next call?

---

## 20260116

**Attendance**

- Matt Weber (Boeing)
- Brian Wood (Boeing)
- Martin Halle (Hamburg University of Technology)
- Ivan Perez (KBR @ NASA ARC)
- Leonidas Kosmidis (Barcelona Supercomputing Center)
- Joshua Whitehead (Boeing)

**Discussion topics**

License - use of Apache is still ongoing with ELISA TSC (cFS and Nix work) - Wed Jan 21st agenda topic

FSW March 23-26th - Paper accepted for "Industry Safety Level(s) vs. Aerospace Use Cases"

- Matt will share a outline with some overview from ELISA annual call for review
- Will want to collaborate on the demo and the points we want this community to take away

QEMU overview / examples (Martin)

- Leonidas mentioned he could do some overview
- Maybe a good general call topic? (call between SGL/Aero)
  - Feb 12 AeroWG or 19th SGL
  - ACTION: Matt to mention to Ramon. Leonidas to check on dates and update us at the next call

PRs - <https://github.com/elisa-tech/wg-aerospace/pull/>

- [Cross platform tool env](https://github.com/elisa-tech/wg-aerospace/pull/117/files)
  - Added comments on upgrading parts which may remove source builds/shorten time
  - Doc source builds
- [feat: add Nix based ELISA demo framework](https://github.com/elisa-tech/wg-aerospace/pull/115)
  - Ivan had a follow on. Matt and Martin still to try it out
  - Pending licensing
- [WIP: cFS app demonstration](https://github.com/elisa-tech/wg-aerospace/pull/109)
  - Waiting on license
- [First step towards cFS-based use case](https://github.com/elisa-tech/wg-aerospace/pull/92)
  - ACTION: Ivan is rebase and rename
  - We did a cleanup in the call

Move new cases to discussion ideas (Matt)

- <https://github.com/elisa-tech/wg-aerospace/blob/main/docs/Aerospace-Uses-Cases.md#new-use-cases>
  - Created - <https://github.com/elisa-tech/wg-aerospace/discussions/119#discussioncomment-15519062>
  - TODO: update Landing doc - Point them at discussions instead of listing in the case
  - Make this update after PR92

---

## 20260109

**Attendance**

- Matt Weber (Boeing)
- Brian Wood (Boeing)
- Salim Jalaleddine (Boeing)
- Ivan Perez (KBR @ NASA ARC)
- Ivan Rodriguez (Coros Software)
- Joshua Whitehead (Boeing)
- Martin Halle (Hamburg University of Technology)
- Leonidas Kosmidis (Barcelona Supercomputing Center)
- Wanja Zaeske (DLR)

**Discussion topics**

NASA vs DO-178C standards comparison (older action)

- Ivan discussed internally - feedback was that they are overlapping and 1:1
- Leonidas shared minor differences that could be mapped out (Action, sharing a link)
  - <https://flightsoftware.org/workshop/FSW2024> Andoni Arregui, Enhancing Safety-Critical Class-A FSW through MC/DC and Object-to-Source Traceability Verification Guidelines, tools, and examples <https://drive.google.com/drive/folders/1SNGQFT-EEIl_uJ282Apv3MtwJkjrURpC>
- Ivan - NPR7150 says: "If a project has safety-critical software, the project manager shall ensure that there is 100 percent code test coverage using the Modified Condition/Decision Coverage (MC/DC) criterion for all identified safety-critical software components." I would not consider that you've achieved coverage of the safety-crticial component if you don't do it on the object code unless your compiler is certified.
  - Added this to: <https://github.com/elisa-tech/wg-aerospace/discussions/102>

cFS demo

- ACTION: Ivan will clean up and get ready for merge - <https://github.com/elisa-tech/wg-aerospace/pull/109>
- Testing is still welcomed!

Formal verification copilot

- Analysis of specification at compile time based on property definition
- Formal verification ref links
  - <https://github.com/Copilot-Language/copilot/>
  - <https://github.com/Copilot-Language/copilot/tree/master/copilot-theorem>
  - <https://github.com/Copilot-Language/copilot/blob/master/copilot/examples/what4/Arithmetic.hs>
  - <https://github.com/Copilot-Language/copilot/tree/master/copilot-verifier>
- Discussion/links on verifier - <https://github.com/elisa-tech/wg-aerospace/issues/114#issuecomment-3725070025>
- Ogma generates tests based on specification

System / Xen demo

- Starting from <https://github.com/elisa-tech/wg-systems/blob/main/Documentation/xen-demo-zcu102/Readme.md> and making it emulated
- Basic xen based on this proposal - <https://github.com/elisa-tech/wg-aerospace/pull/113/files>
- HPSC could be a follow on demo
  - Leonidas offered to make a model
  - Action: Matt poke at Microchip again on this
  - People are using other boards for RISC-V to work around access
- ACTION: Josh - plans to present in main call on Xen and how system wg applies in a different way to Aerospace
- Make a couple diagrams to draw safety levels on concepts? Does this help outline the next step?
- What level of safety certs were being done in the past on Linux? How would this play in?

Cleanup of use case ideas

- <https://github.com/elisa-tech/wg-aerospace/blob/main/docs/Aerospace-Uses-Cases.md#new-use-cases>
- Point them at discussions instead of listing in the case
- Rename the file

---

## 20251219

**Attendance**

- Matt Weber (Boeing)
- Salim Jalaleddine (Boeing)
- Martin Halle (Hamburg University of Technology)
- Rob Woolley (Wind River)
- Nagamahesh Gamidi (Timesys / Lynx)
- Leonida Kosmidis (Barcelona Supercomputing Center)
- Ivan Rodriguez (Coros Space)

**Discussion topics**

cFS demo work

- (Matt) Sent email to ELISA leadership about navigating demo licenses
- Action - sync license on main site

Checkout the PR of different environments

- What about Xen step one is emulated, but then on hw?????
  - How do we couple to hardware?(Martin)
  - low cost? what is enough to have HW that has the ISA hooks? RPI2/3 vs Ultrascale+ (Leonidas)
  - <https://www.amd.com/en/products/system-on-modules/kria/k26/kv260-vision-starter-kit.html>
- ACTION: (Matt talk with Peter) Static vs dynamic allocation - how do we align the common topics vs the items that are different

Developing on native ARM64

- [Section 9 has discussion](https://upcommons.upc.edu/entities/publication/f95e76b3-4571-48a4-b058-729cb5f50006) on targeting a native scenario
- Martin - starting a branch and we (Matt W) can start to look at the features
  - Possible team: Martin, Matt, Ivan Rodriguez (-> Experiences on ARM targets)

Fault injection / ARM reliabilty

- Ivan discussed concepts that could related to future use case demos
- (Matt) follow up on future call presentations

---

## 20251212

**Attendance**

- Matt Weber (Boeing)
- Salim Jalaleddine (Boeing)
- Leonida Kosmidis (Barcelona Supercomputing Center)
- Ivan Perez (KBR @ NASA Ames Research)
- Nagamahesh Gamidi
- Martin Halle (Hamburg University of Technology)
- Rob Woolley (Wind River)
- Michael Mahoney (Wind River)

**Discussion topics**

- [cFS app demo PR](https://github.com/elisa-tech/wg-aerospace/pull/109)
  - Live debug of Port to emulated
  - **ACTION:**(Matt) Ivan asked, how do we navigate Apache licensed code - cFS sample app and ogma code.

- Brainstormed on Xen deployment concepts
  - PR for comments on diagrams - <https://github.com/elisa-tech/wg-aerospace/pull/113/files>
    - [Rendered view](https://github.com/elisa-tech/wg-aerospace/blob/mlw/embedded-envs/demos/docs/embedded-environments/Readme.md)
  - I also tried to document our existing environment so we have pictures / text to support current demos.

---

## 20251205

**Attendance**

- Matt Weber (Boeing)
- Salim Jalaleddine (Boeing)
- Leonida Kosmidis (Barcelona Supercomputing Center)
- Shefali Sharma
- Ivan Perez (KBR @ NASA Ames Research)
- Martin Halle (Hamburg University of Technology)
- Rob Woolley (Wind River)

**Discussion topics**

- [cFS app demo PR](https://github.com/elisa-tech/wg-aerospace/pull/109)
  - (Native) Impl the diagram set of applications
  - Verified message flow and monitor behavior
  - Has example of adjusting the delay from switch app
  - Todo
    - Monitoring apps updated to use cpu clock to understand thresholds
      - Options of Global clock vs providing initial time
    - Port to emulated - ACTION: Salim's going to check it out
    - Switch application might be something ogma could generate
  - Need to consider QEMU time granularity and how we're measuring
    - e.g. time elapsing vs performance of main system
    - Ground station currently doesn't understand time
    - ACTION: <https://youtu.be/IuE99fzAC00?si=DOzjgl9kEQxHZSli>
      - Matt to ask around in our sim team
      - Rob willing to collaborate, Matt volunteered to help
  - ACTION:(Matt) Ivan asked, how do we navigate Apache licensed code - cFS sample app and ogma code.

- Workshop links
  - [Resource directory and YouTube channel link](https://elisa.tech/workshop-series/)
  - Similar mixed criticality with xen concepts kicking off in 2026 - <https://directory.elisa.tech/workshops/2025-11-Munich/2-4-Naoto_Yamaguchi_-_AGL_SDV_SoDeV_Insights.pdf>
  - [AeroWG talk on use cases](https://directory.elisa.tech/workshops/2025-11-Munich/2-9-Matt_Webber_-_Industry_Safety_Levels_vs_Aerospace_Use_Cases.pdf)

---

## 20251128

**Attendance**

No call.

**Discussion topics**

- Ivan shared via email the [cFS app demo PR](https://github.com/elisa-tech/wg-aerospace/pull/109)

---

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
  - (Pending) Embedded demo updates (Martin), consider content of: <https://github.com/elisa-tech/wg-aerospace/issues/33>
  - cFS lights demo (Ivan)
    - referring to: demos/copilot, based on dev-newtemplate branch
    - Two apps: lights app, switch app
    - OGMA template to generate applications was updated
    - added elisa_use_case scripts
    - OGMA script generates application, generate apps, interfaces, test-cases and scitps etc.
    - Demoing to setup the CPU architecture pending (hasn't been tried to run in the emulator yet)
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
  - Relation to SGL group discussions: <https://hackmd.io/nx1iVbKxTB2f_0c05dbUxw>

## 20251114

**Attendance**

- Matt Weber (Boeing)
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
  - QEMU / environment / examples / concepts / current state / experience report and vision

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

- Emulation test wrapper PR - <https://github.com/elisa-tech/wg-aerospace/pull/95>
  - Paul plans to cleanup prints and look at some restructuring before merge

- Ivan - continue on ogma example for monitoring simple app (manual example)

- Matt
  - [DONE](https://github.com/elisa-tech/wg-aerospace/commit/b1fbbc47b8fdfb67deedb5f024474e9e1e64d4a7) Get our license files checked in based on SGL
    - The specific license choice was entertained in a combined Aero+SGL call with no feedback specific to Aerospace. SGL has already adopted.
    - Using <https://github.com/elisa-tech/meta-sgl> as the ref files to PR in
  - [DONE](https://github.com/elisa-tech/wg-aerospace/blob/main/demos/copilot/src/monitors/Dockerfile#L108) Container update for ogma-cli:ogma - <https://github.com/nasa/ogma/?tab=readme-ov-file#compilation>
    - **ANNOUNCEMENT** Image is pushed, update by doing a `make prep` and then `make dev` to get into the container to try the `ogma` command. The container prompt after `make dev` should now provide some version info to help us troubleshoot when things aren't working.
  - Review notes and put updates to proposal for review next week - <https://github.com/elisa-tech/wg-aerospace/pull/92>

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
  - <https://github.com/nasa/ogma>
  - Next step - going through the app, cleaning up ?tests?

- Martin shared feedback from Wanja - Sending email with more details

---

## 20251017

- Discussed OGMA template. Ivan has captured the template [here](https://github.com/nasa/ogma/tree/develop-update-cfs-template/updated_template/%7B%7Bapp_name_lc%7D%7D).

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

- **Next step:** Now we need to remove the specificity of that app (anything that we don't want, like the dependency on sample_lib, or perhaps the unit tests) and add the hook to the monitors.

---

## 20251010

- Matt Weber (Boeing)
- Ivan Perez (KBR @ NASA Ames Research)
- Salim Jalaleddine (Boeing)
- Brian Wood (Boeing)
- Shefali Sharma

**Actions**

- Carry over actions
  - Martin
    - Embedded demo documentation updates
  - Paul
    - Debugging test execution wrapper - <https://github.com/elisa-tech/wg-aerospace/pull/95>
  - Matt
    - Review notes and put updates to proposal for review next week - <https://github.com/elisa-tech/wg-aerospace/pull/92>
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
- Brian Wood (Boeing)

**Actions**

- Carry over actions
  - Martin
    - Embedded demo documentation updates
  - Paul
    - Debugging test execution wrapper - <https://github.com/elisa-tech/wg-aerospace/pull/95>

- Matt
  - Review notes and put updates to proposal for review next week - <https://github.com/elisa-tech/wg-aerospace/pull/92>
  - Get example of qemu serial for Salim to use to drive example cmd msgs
  - Get example of qemu serial to Paul for capturing of test output vs current stdout for emulated test wrapper (may wait until we have some of the cfs example work already using serial)

- Ivan looking at building a ogma example

**Discussion topics**

Next step with getting a monitored event to work - building on simple cFS app

- Ivan
  - NASA/ogma to generate CFS applications - <https://github.com/nasa/ogma/blob/develop/.github/workflows/repo-ghc-8.6-cabal-2.4-cfs.yml#L49>
  - Database to code generator
  - Picture to monitor generation
  - Merged Salim's PR and ready to add step to show Ogma example

Fuzzing tests for a cFS deployment this week

- Is this something we want to demo? Random data injection / millions of test cases - could do a cabin lights cycle through states? how do you get full coverage?
- Moon collaborative robots/equipment scenario (cFS/ROS/multi-platform)
- unit tests to start but evolved to seed a random testing of data structures e.g., cFS data structure to json, is it correct.
- Ogma can generate most of the content / comparison
- QuickCheck (Haskell checker)
  - <https://dl.acm.org/doi/abs/10.1145/351240.351266>
  - <https://dl.acm.org/doi/abs/10.1145/3110246> (Could pre-record a trace of what we want to drive in the system. Then add random behaviors/msg against that.)

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
    - Debugging test execution wrapper - <https://github.com/elisa-tech/wg-aerospace/pull/95>

- Matt
  - Review notes and put updates to proposal for review next week - <https://github.com/elisa-tech/wg-aerospace/pull/92>
  - Get example of qemu serial for Salim to use to drive example cmd msgs
  - Get example of qemu serial to Paul for capturing of test output vs current stdout for emulated test wrapper (may wait until we have some of the cfs example work already using serial)

- Salim
  - Getting cFS demo doc/steps into a PR - <https://github.com/elisa-tech/wg-aerospace/pull/98>

**Discussion topics**

- Salim presented the simple cFS demo and PR feedback is pending (ready next week for testing) - <https://github.com/elisa-tech/wg-aerospace/pull/98>

- Matt
  - Figured out emulation failure and sent Paul notes on his PR.
  - Merged a emulation test PR that verifies our images boot correctly - <https://github.com/elisa-tech/wg-aerospace/pull/99>

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
- Brian Wood (Boeing)
- Rob Woolley (Wind River Systems, Inc.)
- Salim Jalaleddine (Boeing)

**Actions**

- Carry over actions
  - Martin
    - Embedded demo documentation updates
  - Paul
    - Debugging test execution wrapper - <https://github.com/elisa-tech/wg-aerospace/pull/95>

- Matt
  - Figure out emulation CI failure that Paul is seeing in - <https://github.com/elisa-tech/wg-aerospace/pull/95>
  - Review notes and put updates to proposal for review next week - <https://github.com/elisa-tech/wg-aerospace/pull/92>
  - Get example of qemu serial for Salim to use to drive example cmd msgs

Salim

- Getting cFS demo doc/steps into a PR - <https://github.com/elisa-tech/wg-aerospace/pull/98>

**Discussion topics**

- Test execution wrapper - <https://github.com/elisa-tech/wg-aerospace/pull/95>

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
- Brian Wood (Boeing)
- Ivan Perez (KBR @ NASA Ames Research)
- Rob Woolley (Wind River Systems, Inc.)
- Salim Jalaleddine (Boeing)
- Shefali Sharma
- Wanja Zaeske (DLR)

**Actions**

- Paul
  - Debugging test execution wrapper - <https://github.com/elisa-tech/wg-aerospace/pull/95>

- Salim
  - Get sample application working in emulation - cmd from gnd to sample app in emulation (network stack based)
    - Done criteria - manual sequence we could later make into a test case and example
  - Additional ACTION: Create cFS build document from <https://github.com/elisa-tech/wg-aerospace/issues/52>

- Martin
  - Embedded demo documentation updates

- Matt
  - Review notes and put updates to proposal for review next week - <https://github.com/elisa-tech/wg-aerospace/pull/92>

**Discussion topics**

- Paul / Ivan - what is the next step on the Raw socket - <https://github.com/elisa-tech/wg-aerospace/pull/68>?
  - At least a rebase after 72 merges
  - I think doc updates are being handled by Martin's action from a few weeks back on adding the Embedded demo material (doesn't look like we have a ticket for it - <https://github.com/elisa-tech/wg-aerospace/issues/33#issuecomment-2992113155>)

- Salim
  - Progressing towards a build and currently building and running on QEMU

- Wanja - feedback on getting started / trying instructions
  - vendor free list of dependencies
    - two layers
      - higher level using dockerfile based environment
      - No container, makefile based with all dependencies setup on host
  - sudo-less (both setup and container) (maybe rootless solves part of it - <https://github.com/elisa-tech/wg-aerospace/discussions/80>)
  - <https://github.com/pengutronix/genimage>
  - The wrapper may have a corner case with the emulation output having mixed kernel output and print of the test report
    - Suggested serial port to command and get data so it's dedicated
    - Initially could set log level to prevent console output
  - 3 topics ongoing - can we make these more distinct activities?
    - app on linux relevant to use cases
    - testing harness (unit / remote) - (Needs more attention? Existing work / projects that could more generically to it)
      - Can existing solutions handle this, large assumptions but makes our example simpler?
      - <https://labgrid.readthedocs.io/en/latest/index.html> - embedded board control python library with a focus on testing, development and general automation. It includes a remote control layer to control boards connected to other hosts.
      - Noted some interest in this
    - bring infra for configuration / system image generation
      - Can existing solutions handle this, large assumptions but makes our example simpler?
      - Interested in system generation / image creation portion

- Future conflicts
  - DASC Next week Sept 19th
  - Ivan out for Sept 19th, 26th
  - German holiday on Oct 3rd

## 20250905

**Actions**

We did not take any actions around finishing out the use case doc (yet) - <https://github.com/elisa-tech/wg-aerospace/pull/92>

- Matt
  - Merge <https://github.com/elisa-tech/wg-aerospace/pull/72>
  - Create cFS build document from <https://github.com/elisa-tech/wg-aerospace/issues/52> (Salim to review and use for sample app)
- Salim
  - Get sample application working in emulation - cmd from gnd to sample app in emulation (network stack based)
    - Done criteria - manual sequence we could later make into a test case and example
- Paul - has a PR waiting with emulation wrapper once 72 merges
- Paul / Ivan - what is the next step on the Raw socket - <https://github.com/elisa-tech/wg-aerospace/pull/68>?
  - At least a rebase after 72 merges
  - I think doc updates are being handled by Martin's action from a few weeks back on adding the Embedded demo material (doesn't look like we have a ticket for it - <https://github.com/elisa-tech/wg-aerospace/issues/33#issuecomment-2992113155>)

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

1. Get sample application working in emulation - cmd from gnd to sample app in emulation (network stack based)
2. Add Cabin Light instead of Sample App (driven by gnd command example)
3. Add Copilot to detect events, commands and monitor
4. Add Cabin Lights Application to drive Cabin Light by the Switch App
5. Move from networking to serial for gnd command
6. Update test cases

---

## 20250829

**Actions**

- Ivan
  - Opening a new PR marking up <https://github.com/elisa-tech/wg-aerospace/blob/main/docs/Aerospace-Uses-Cases.md> for a cFS light add use case
  - Trying the raw socket monitor PR with Paul’s raw update (<https://github.com/elisa-tech/wg-aerospace/pull/67>)
- Martin
  - PR for Embedded demo - <https://github.com/elisa-tech/wg-aerospace/blob/main/demos/copilot/EmbeddedDemo.md>
- Matt
  - Complete Dev notes PR - <https://github.com/elisa-tech/wg-aerospace/pull/72>
    - Debugging Paul's issue and see if we can resolve.
  - Convert some tickets to Github discussions
    - New discussions
      - We need docs updated for perspective of wsl vs linux for setup steps - <https://github.com/elisa-tech/wg-aerospace/blob/main/demos/docs/EnvSetup.md#start-here>
      - Makefile updated to understand when we're inside a container vs. uses Docker in the Make targets - could be part of rootkit work?
  - Create cFS build document from <https://github.com/elisa-tech/wg-aerospace/issues/52>
  - Add cFS use case discussion to next AeroWG call

**Discussion topics**

- Discuss how we organize work vs ticketing everything (a few ideas below)
  - Inbox doc we check-in where things are added to the list and could graduate when there is enough interest to an issue ticket.
  - Github feature to organize work with “team board” with priority backlog or filter by labels?
  - Other ideas? Github discussions (ACTION to try this)
- Continue cFS debug - <https://github.com/elisa-tech/wg-aerospace/issues/52>
  - Success!
  - Next step - add a new use case to show cFS plus lights app
    - [Command ingest and sample app](https://github.com/nasa/cFS/tree/main/apps)
    - (1) Ground station app would send the command into the cFS system. Then sample light app operates based on command request.
    - (2) cabin lights app and switch app - contained within cFS on SW bus. copilot as a 3rd app listens to the interactions. Ground station would still send the commands to control the state.
    - Talked about telemetry and copilot with respect to measurement - bus time vs processing

---

## 20250822

**Actions**

- Ivan
  - Trying the raw socket monitor PR with Paul’s raw update (<https://github.com/elisa-tech/wg-aerospace/pull/67>)
  - libexecinfo - tried new build with cFS - <https://github.com/elisa-tech/wg-aerospace/issues/52#issuecomment-3237123694>
- Martin
  - Trying the Dev notes PR - <https://github.com/elisa-tech/wg-aerospace/pull/72>
  - PR for Embedded demo - <https://github.com/elisa-tech/wg-aerospace/blob/main/demos/copilot/EmbeddedDemo.md>
- Matt
  - Share qemu launch wrapper script – tag @Mani, Paul (IND) in <https://github.com/elisa-tech/wg-aerospace/issues/48>
  - Add libexecinfo to build for cFS cross build
  - Complete Dev notes PR - <https://github.com/elisa-tech/wg-aerospace/pull/72>
    - Doc the bug from Paul and see if we can resolve.

**Next time**

- Discuss how we organize work vs ticketing everything (a few ideas below)
  - Inbox doc we check-in where things are added to the list and could graduate when there is enough interest to an issue ticket.
  - Github feature to organize work with “team board” with priority backlog or filter by labels?
  - Other ideas?
- Continue cFS debug - <https://github.com/elisa-tech/wg-aerospace/issues/52>
- New items
  - We need docs updated for perspective of wsl vs linux for setup steps - <https://github.com/elisa-tech/wg-aerospace/blob/main/demos/docs/EnvSetup.md#start-here>
  - Makefile updated to understand when we're inside a container vs. uses Docker in the Make targets
  - Wrap running emulation
    - pkt injection, parse output, (this is an area ivan wants to improve - if we do a PR to the tools, maybe easier on NASA process to get it open)
    - <https://github.com/nasa/CTF> - This is the tool (testing framework) we would use to read telemetry from the software bus. Not sure if we will be using this since were using copilot? (should we do a use case to get people's feedback?)
    - Could improve test to include a cFS test - monitor check plus the basics of cFS
