# Deprecate legacy requirements-python.txt in favor of base/extras

Labels: cleanup, docs

## Summary

Transition away from `requirements-python.txt` to the base/extras model for reliability and clarity.

## Why

Heavy and geo stacks are better installed as opt-in extras; a single large file increases installation failure rates.

## Scope

- Update CI to prefer `requirements-python.base.txt` and selective extras.
- Mark `requirements-python.txt` as deprecated in README and plan removal timeline.

## Acceptance Criteria

- CI jobs use base/extras and pass.
- README reflects base/extras as the primary install path.
- A deprecation note exists and a follow-up item tracks removal after a grace period.
