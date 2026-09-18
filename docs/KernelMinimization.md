# Kernel Minimization

This document describes how we can minimize a Linux Kernel to run a flight
application on it. Minimizing the kernel can help reduce the footprint needed
in deployment and reduce the amount of code that needs to be verified before a
flight.

To demonstrate our proposal, we illustrate first with a minimal example, and
then show the same techniques applied to a demonstration flight application
written using NASA Core Flight System.

# Hello Serial

Let us imagine the scenario where we want to the computer to run a minimal
program upon start that writes Hello World to the serial console, and we want
to run it on Linux. If we don't need multiple processes, or networking, running
a full Linux kernel with the same options we'd need for a desktop environment
would be overbloated.

## Customizing a kernel

### Technique

### Feature considerations

## Evaluating an executable

## Metrics

## Further reduction opportunities

glibc vs non-glibc

# Hello cFS

## Kernel options

We need to evaluate userspace impact.

## Evaluation

## Metrics
