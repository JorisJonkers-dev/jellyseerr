# jellyseerr

[Seerr](https://github.com/seerr-team/seerr), the request service in front of
jellyfin, sonarr and radarr, as the estate runs it: the upstream image, run as
`deploy` (1000:1000) under a read-only root filesystem. deploy-kit delivers it
as the Project `jellyseerr`.

## What the image changes

`jellyseerr/Dockerfile` names `USER 1000:1000` and starts `node dist/index.js`
directly, since `npm start` writes under a home directory the read-only root
does not allow.

## Versions

This repository releases its own semver, continuing from `v3.5.0`, the last tag
named after seerr. The seerr version the image ships is recorded separately, as
the images lock's `version` (JorisJonkers-dev/workspace#140), so a fix to our
configuration no longer waits for a seerr release. Renovate opens a pull
request for each update, as a `fix`, so release-please releases it. A minor or
patch update merges itself once `Pipeline Complete` passes; a major release
waits for approval on the Dependency Dashboard. Merging release-please's pull
request tags `vX.Y.Z`, which publishes the image and the Intent Fragment.

## Running it

`deploy/jellyseerr.project.yml` and `deploy/env/` declare the Project. Its
SQLite database is a claim on an NVMe or SSD disk that the platform's
`file-backup` copies nightly. It keeps its links to jellyfin, sonarr and radarr
in its own settings.

`scripts/smoke-test.sh` starts the image restricted and waits until it serves;
CI runs it on every change.

## Licence

This repository's own files are MIT: see [LICENSE](LICENSE). Seerr is MIT.
