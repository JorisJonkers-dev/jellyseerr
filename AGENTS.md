# Agents

Guidance for any coding agent working in this repository.

- Agent contract: [CLAUDE.md](CLAUDE.md), which points at [the estate contract](https://github.com/JorisJonkers-dev/workspace/blob/main/CLAUDE.md).
- What this repository holds: the Seerr image as the estate runs it (`jellyseerr/Dockerfile`) and its deploy-kit Project declaration (`deploy/jellyseerr.project.yml`). See [README.md](README.md).

## Build and test

```bash
shellcheck scripts/*.sh
docker build -t jellyseerr:ci jellyseerr
scripts/smoke-test.sh jellyseerr:ci
```

CI (`.github/workflows/ci.yml`) runs the same lint, image build and restricted smoke test; the `Pipeline Complete` check gates merges.
