# Skopeo Copy Github Action

This repo builds a GitHub action that would execute `skopeo copy`.

At the time of this writing, this repository is incomplete.

## TODO

- resolve Dockerfile locations. one is built separately from the action definition itself, intentionally to avoid slow action execution. But there are weird behaviors being caused as a result.
- resolve `$HOME` issues. Actions do not want you to set WORKDIR, but we set WORKDIR because we built the container image outside of the actions environment.  The result is that we need to cd into the WORKDIR in our script in order to make sure we have access to files on the filesystem based on that directory.
- resolve issues authenticating using podman-login or similar actions.