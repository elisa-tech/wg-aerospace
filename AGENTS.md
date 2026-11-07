<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

# AGENTS.md — ELISA Aerospace Working Group

Guidance for AI agents working in this repository.

## Repository purpose

This repository contains documentation, analysis, and guidance for the
ELISA Aerospace Working Group — focused on applying Linux and open source
in safety-critical aerospace systems (DO-178C, DO-297, AMC 20-193).

Content is primarily Markdown documentation, not executable code.

## Meeting minutes workflow

- Recurring meeting-minutes tasks follow a defined checklist:
  [meeting-minutes/meeting-minutes-checklist.txt](./meeting-minutes/meeting-minutes-checklist.txt).
  It covers the pre- and post-meeting steps for the General Call (2nd
  week), Paper Call (4th week), and weekly Use Case Call. Read it before
  running any pre-call or post-call meeting task.
- Live minutes are drafted on a shared HackMD pad. Use the helper tool
  and its usage notes at
  [meeting-minutes/hackmd-tool/README.md](./meeting-minutes/hackmd-tool/README.md)
  to push, pull, and clear the pad.
- Canonical sources: events live in [docs/events.md](./docs/events.md)
  and the recurring attendee list lives in the meeting template
  (`meeting-minutes/ELISA-AeroWG-Meeting-DATE_template.md`). Sync updates
  back into these, not just the per-meeting file.

## Making changes

- Use **GitHub Pull Requests** for all contributions.
- One commit per logical change.
- Commit message format: short summary line (imperative mood), blank
  line, body explaining what/why. Check `git log --oneline <path>` for
  prefix conventions already in use.
- All content is licensed CC-BY-SA-4.0. Do not introduce incompatible
  material.

## AI-generated contributions

- **Mandatory**: add an `Assisted-by` trailer in the commit message
  before `Signed-off-by`, naming the tool and model version:

  ```text
  Assisted-by: Claude:claude-sonnet-4-20250514
  ```

- **Do NOT** add `Signed-off-by` tags. Only the human contributor may
  certify the DCO. The human must review, validate, and take
  responsibility for all AI-generated content.
- Do not autonomously commit, push, or create pull requests without
  explicit human review and direction.
- For substantial AI-generated content, include a summary of prompts or
  session context in the commit message or PR description.
- Trivial completions (spelling, boilerplate) do not require the
  `Assisted-by` trailer.

See [Contributing.md](./Contributing.md#ai-assisted-contributions) for
the full policy, including license compliance, review expectations, and
scope definitions.

## Style and content conventions

- Use present tense, imperative mood in commit messages.
- Markdown files: follow markdownlint defaults. No trailing whitespace.
- When referencing standards, use the full name on first use with
  abbreviation in parentheses, then abbreviation thereafter.
- Aerospace standards references: DO-178C, DO-297, DO-330, AMC 20-193,
  ARINC 653, ARP4754A, ARP4761.
