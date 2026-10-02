<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Certification Progression

A **separate track** from the [Kernel Minimization](../KernelMinimization.md)
build/measure/boot workflow: once a minimized kernel exists, moving it toward
higher assurance levels is a distinct effort. This page is a short set of
references for that progression rather than a procedure.

## Assurance level progression

Moving up software levels adds verification obligations. In DO-178C terms:

- **DAL B beyond DAL C** — decision coverage, independence of verification,
  requirements-based testing at integration levels, full traceability.
- **DAL A beyond DAL B** — MC/DC coverage, source-to-object-code traceability,
  more stringent independence.

## References

- RTCA DO-178C — software considerations in airborne systems (structural
  coverage, MC/DC, deactivated code); DO-278A for ground systems.
- RTEMS as a reference pattern — [ESA RTEMS Qualification](https://rtems-qual.io.esa.int/).
- ESA [Category B (ECSS-Q-ST-80C)](https://ecss.nl/standard/ecss-q-st-80c-rev-1-software-product-assurance-15-february-2017/)
  — mission-critical software; roughly equivalent to DO-178C DAL B.
- [Technology Readiness Levels (TRL)](https://www.nasa.gov/directorates/somd/space-communications-navigation-program/technology-readiness-levels/)
  and [Technology Readiness Assessment (TRA)](https://acqnotes.com/acqnote/careerfields/technology-readiness-assessment).
- [Capability Maturity Model (CMM)](https://en.wikipedia.org/wiki/Capability_Maturity_Model).
- [Kernel Minimization](../KernelMinimization.md) — the workflow this track builds on.
