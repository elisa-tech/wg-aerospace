<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Embedded

The embedded cabin lights demo runs the client, server and Copilot monitor
inside an AArch64 Linux system emulated by QEMU. Copilot is the runtime
verification framework used to generate the monitor.

See the [standalone environment](../docs/embedded-environments/Standalone.md)
for the deployment diagrams and operating system image source.
This page describes the ordinary cabin lights demo, without cFS.

## Build

Assume the repository was cloned during
[Environment Setup](../docs/EnvSetup.md) and opened in its devcontainer,
as for the [Basic Demo](BasicDemo.md).

Run the following commands inside the devcontainer. The workspace path
below is the container path, not a path on the host.

```bash
cd /workspaces/wg-aerospace/demos/copilot/src/monitors
make prep
make
make prep_cross
make main_syslog_time_cross
```

- `make prep` prepares the development environment when invoked from the
  host; inside the devcontainer it reports that no preparation is needed.
- `make` generates the Copilot monitors and builds the native applications.
- `make prep_cross` removes existing cross inputs and generated files,
  then downloads and extracts the prebuilt kernel, root filesystem and
  cross-compilation SDK, and relocates the SDK. Run it for initial setup;
  skip it when reusing an already prepared environment.
- `make main_syslog_time_cross` builds the AArch64 monitor and packages it,
  the Python applications and the tests into `rootfs.cpio.gz_new`.

Check the generated executable:

```bash
cd /workspaces/wg-aerospace/demos/copilot/src/monitors
file main_syslog_time_cross
```

On the validated x86_64 host, the output identified a 64-bit ARM AArch64
ELF executable. This executable runs in the guest.

## Run automated tests

Run the following commands from the same monitor directory inside the
devcontainer. The wrapper starts QEMU and runs the guest applications;
no guest login or manual process management is needed.

### Run guest application tests

```bash
make main_syslog_time_cross_test
```

This invokes [wrap-qemu.py](src/tests/wrap-qemu.py), which starts QEMU,
sends commands to the guest and writes the captured report to
`demos/test-results/test-results-system-cross.xml`.

Inspect the report from the current directory:

```bash
cat ../../../test-results/test-results-system-cross.xml
```

The validated run produced four tests, with zero failures and errors.
Check that tests actually ran and that the number of `testcase` elements
matches the reported test count. Do not rely only on the wrapper exit
status or the `Tests Completed Successfully.` message:
[runtests.sh](src/tests/runtests.sh) also prints that message when tests fail.

### Optional boot smoke test

```bash
make main_syslog_time_cross_run_ci
```

This invokes [test-qemu-launch.py](src/tests/test-qemu-launch.py) and checks
for `Welcome to Buildroot`. It verifies a boot milestone, rather than
application behavior.

### Run all test groups

```bash
make test
```

This combines the monitor tests, native system tests and QEMU guest system
tests. The monitor test script uses `column`; if it is missing from the
development container, install its package:

```bash
sudo apt-get update
sudo apt-get install -y bsdextrautils
```

Reports are written under `demos/test-results`:

| Report | Validated test count | Failures |
| --- | --- | --- |
| `test_results.xml` | 2 | 0 |
| `test-results-system.xml` | 4 | 0 |
| `test-results-system-cross.xml` | 4 | 0 |

These groups were validated separately using `make test_monitors`,
`make systemtest` and `make main_syslog_time_cross_test`. The combined
`make test` command is the repository's existing aggregate target.

## Observations

- The switch sends UDP commands to `127.0.0.1:10000` inside the guest.
- The server applies the configured delay, logs `lights: on/off` and sends
  light-control messages to `127.0.0.1:10001`.
- The monitor reads `syslog_file` and checks the 500 ms response limit in
  [MainSyslogClock.hs](src/monitors/MainSyslogClock.hs).
- The tests use 400 ms for normal responses and 600 ms for delayed
  responses. A monitor violation is expected in the delayed cases.
- The test suite covers both UDP and raw-socket implementations.

See [application configuration](src/python/appConfiguration.py) for the
network settings. The `lights` events describe server actions, rather
than measurements from a physical lamp.

## Modify the monitor

Use a separate source copy for this example. Run commands in the same
monitor directory inside the devcontainer.

1. Save the original specification and normal-response tests:

   ```bash
   cp MainSyslogClock.hs MainSyslogClock.hs.baseline
   cp ../tests/test2.sh ../tests/test2.sh.baseline
   cp ../tests/testRawSock2.sh ../tests/testRawSock2.sh.baseline
   ```

2. Reduce the response limit from 500 ms to 300 ms and rerun the tests:

   ```bash
   sed -i 's/limit = 500/limit = 300/' MainSyslogClock.hs
   make main_syslog_time_cross
   make main_syslog_time_cross_test
   ```

   Expect two failures: the original 400 ms normal responses now exceed
   the limit. Both 600 ms fault-detection cases should still pass.

3. Change the normal-response delay to 200 ms and rerun:

   ```bash
   sed -i 's/fixed 400/fixed 200/g' ../tests/test2.sh ../tests/testRawSock2.sh
   make -B main_syslog_time_cross
   make main_syslog_time_cross_test
   cat ../../../test-results/test-results-system-cross.xml
   ```

   Expect four tests with zero failures. Use `-B` after changing guest
   test scripts: they are not Makefile prerequisites, so a normal build
   may leave the previous scripts in the root filesystem.

4. Restore the original files and verify the baseline:

   ```bash
   mv MainSyslogClock.hs.baseline MainSyslogClock.hs
   mv ../tests/test2.sh.baseline ../tests/test2.sh
   mv ../tests/testRawSock2.sh.baseline ../tests/testRawSock2.sh
   make -B main_syslog_time_cross
   make main_syslog_time_cross_test
   ```

   Expect four tests with zero failures.

## Further work

- Build the operating system or change its kernel configuration through
  [demo-cert-linux](https://gitlab.com/elisa-tech/aero-wg/demo-cert-linux),
  which produces the prebuilt inputs. Its local build notes are marked
  archived; a full OS rebuild is not validated here.
- For a separate kernel configuration example, see the
  [AvioNix walkthrough](../AvioNix-demo/NixBasedKernelConfig.md).
  This uses a different build environment from the Buildroot inputs above.
- Adapt another use case by updating the application events, monitor
  specification and matching normal/fault tests together.
- Explore diagram-based monitor generation. The current Makefile generates
  C from Haskell; it does not use Mermaid as an input.
