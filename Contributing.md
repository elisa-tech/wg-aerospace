<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Contributing to Aerospace Working Group

Thank you for your interest in contributing! We appreciate your help in making this project better. Please follow the guidelines below to ensure a smooth contribution process.

- [Contributing to Aerospace Working Group](#contributing-to-aerospace-working-group)
  - [Code of Conduct](#code-of-conduct)
  - [How to Contribute](#how-to-contribute)
  - [Reporting Issues](#reporting-issues)
  - [Submitting Changes](#submitting-changes)
  - [Style Guide](#style-guide)
  - [License](#license)
    - [How to use the license checker](#how-to-use-the-license-checker)
  - [Copyright](#copyright)

## Code of Conduct

The ELISA Project involves participation by industry competitors, and it is the intention of the Linux Foundation to conduct all of its activities in accordance with applicable antitrust and competition laws. It is therefore extremely important that attendees adhere to agendas(e.g. topics), and be aware of, and not participate in, any activities that are prohibited under applicable US state, federal, or foreign antitrust and competition laws. [Linux Foundation Antitrust Policy](http://www.linuxfoundation.org/antitrust-policy)

The collaboration in this project is exploratory. The opinions expressed by participants are not necessarily the policy of the companies.

No recordings of working group meetings are permitted. Special provisions may be arranged for recording in advance with explicit consent of the participants.

The kernel and LF Code of Conduct applies to all communication with this project
  - [Linux Foundation Code of Conduct](https://www.linuxfoundation.org/code-of-conduct/)
  - Linux [Contributor Covenant Code of Conduct](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/code-of-conduct.rst)
  - Linux Kernel Contributor Covenant [Code of Conduct Interpretation](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/code-of-conduct-interpretation.rst)

## How to Contribute
1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Make your changes.
4. Write tests for your changes (if applicable).
5. Ensure all tests pass.
6. Attend a working group [meeting](/README.md#schedule) to discuss

## Reporting Issues

If you find a bug or have a feature request, please open an issue in the repository. Be sure to include as much detail as possible.

## Submitting Changes

When you're ready to submit your changes, please create a pull request. Include a description of your changes and reference any related issues.

## Style Guide

Please follow the project's coding style enforced by the lint checks on your pull request.  If an exception is needed, note that in the pull request details.

## License

By contributing, you agree that your contributions will be licensed under the [project's license.](./LICENSE). If approval for an alternate license or licenses for inbound or outbound contributions is required, note this in your pull request with the following details. A TSC call would need to consider this and provide feedback on an exception.  A two-thirds vote is required by the TSC, see the [charter](https://elisa.tech/wp-content/uploads/sites/19/2020/08/elisa_technical_charter_082620.pdf) for the official guidance on these exceptions.

For exceptions as part of your pull request:

1) Describe contribution in PR description
  - Any alternative open source license(s) options
  - The justification for using an alternative open source license
2) Add the SPDX tags to your files that need them.  (Checkout other files for examples.)
3) Add a license description file using the [`docker run --rm --volume $(pwd):/data fsfe/reuse download --all`](https://github.com/fsfe/reuse-tool?tab=readme-ov-file#usage) or manually under `./LICENSES/`
4) Add any specific exception clarification language to [LICENSE](./LICENSE) or the specific file(s) under the license header. (Or at least in the GIT commit description that makes the license change.)

For any approved cases, follow the [LICENSE](./LICENSE) guidance:

1) Noting the license used in the individual files
2) Verify the license [CI workflow](.github/workflows/license-check.yml) on the pull request passes.  The results should be listed towards the bottom of the specific pull request page under "Checks."

Email communication will be treated as documentation and be received and made available by the Project under the [Creative Commons Attribution 4.0 International License](http://creativecommons.org/licenses/by/4.0). Please refer to the [ELISA Technical Charter section 7 subsection iv.](https://elisa.tech/wp-content/uploads/sites/19/2020/08/elisa_technical_charter_082620.pdf).

### How to use the license checker

Here's an example of how to locally cleanup licensing on your contribution.

If you need to see what licenses are supported for use with the tool - `docker run --rm --volume $(pwd):/data fsfe/reuse supported-licenses`

1) Go to the root of this repository and run `docker run --rm --volume $(pwd):/data fsfe/reuse` to get a report.
2) Then if you are "not compliant", either manually add the SPDX headers or use the `reuse annotate` feature to help you.  `reuse` does have a `--recursive` option that can be used for folders, however it marks everything.
  - Updating individual markdown files - `docker run --rm --volume $(pwd):/data fsfe/reuse annotate --license CC-BY-SA-4.0 <filename>` 
  - Updating individual code files - `docker run --rm --volume $(pwd):/data fsfe/reuse annotate --license MIT <filename>` 
  - Add details for binary files and items like `json` - `docker run --rm --volume $(pwd):/data fsfe/reuse annotate --license CC-BY-SA-4.0 --fallback-dot-license <filename>`
    - This creates a file with a `.license` suffix that has the SPDX tag
3) Check again doing (1).

The tool has [various features](https://github.com/fsfe/reuse-tool?tab=readme-ov-file#usage) including automatically adding a license descriptions under `LICENSE/` if you had a new license type.

## Copyright

This project follows the [Developer Certificate of Origin](https://developercertificate.org/) approach for any contributions.  [How to add a contribution sign off.](https://tac.lfenergy.org/process/contribution_guidelines.html#contribution-sign-off)

All content is copyright as follows, unless noted in the individual file.  See [Linux Foundation copyright guidance](https://www.linuxfoundation.org/blog/blog/copyright-notices-in-open-source-software-projects) for guidance on this top level copyright claim that simplifies the developer workflow (i.e., it uses DCO to associate the claim.)

Copyright (c) The ELISA Aerospace Working Group Authors

Copyright (c) The ELISA Aerospace Working Group Contributors

Copyright (c) Contributors to the ELISA Aerospace Working Group

Note: Please refer to the [ELISA Technical Charter section 7](https://elisa.tech/wp-content/uploads/sites/19/2020/08/elisa_technical_charter_082620.pdf) for discussion on Intellectual Property roles related to Author vs Contributor.