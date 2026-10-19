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

This repository's version is seerr's: release `v3.5.0` runs seerr 3.5.0.
Renovate opens a pull request for each seerr release. A minor or patch release
merges itself once `Pipeline Complete` passes; a major release waits for
approval on the Dependency Dashboard. When the `FROM` tag changes on `main`,
`release.yml` releases that version and publishes the image and the Intent
Fragment. A change that keeps the `FROM` tag ships with the next seerr release.

## Running it

`deploy/jellyseerr.project.yml` and `deploy/env/` declare the Project. Its
SQLite database is a claim on an NVMe or SSD disk that the platform's
`file-backup` copies nightly. It keeps its links to jellyfin, sonarr and radarr
in its own settings.

`scripts/smoke-test.sh` starts the image restricted and waits until it serves;
CI runs it on every change.

## Licence

This repository's own files are MIT: see [LICENSE](LICENSE). Seerr is MIT.
