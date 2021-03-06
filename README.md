# LaTeX in Docker

![GitHub license](https://img.shields.io/github/license/kjarosh/latex-docker)
![GitHub build status](https://img.shields.io/github/workflow/status/kjarosh/latex-docker/Docker)
[![GitHub release](https://img.shields.io/github/v/release/kjarosh/latex-docker)](https://github.com/kjarosh/latex-docker/releases)
[![DockerHub](https://img.shields.io/badge/docker.io-kjarosh%2Flatex-blue)](https://hub.docker.com/r/kjarosh/latex)
[![GitHub Container Registry](https://img.shields.io/badge/ghcr.io-kjarosh%2Flatex-blue)](https://github.com/users/kjarosh/packages/container/package/latex)

[![Docker Image Size (minimal)](https://img.shields.io/docker/image-size/kjarosh/latex/latest-minimal?label=minimal)](https://hub.docker.com/r/kjarosh/latex)
[![Docker Image Size (basic)](https://img.shields.io/docker/image-size/kjarosh/latex/latest-basic?label=basic)](https://hub.docker.com/r/kjarosh/latex)
[![Docker Image Size (small)](https://img.shields.io/docker/image-size/kjarosh/latex/latest-small?label=small)](https://hub.docker.com/r/kjarosh/latex)
[![Docker Image Size (medium)](https://img.shields.io/docker/image-size/kjarosh/latex/latest-medium?label=medium)](https://hub.docker.com/r/kjarosh/latex)
[![Docker Image Size (full)](https://img.shields.io/docker/image-size/kjarosh/latex/latest-full?label=full)](https://hub.docker.com/r/kjarosh/latex)

This repository defines a set of images which may be used
to run LaTeX in a container, for example in CI/CD.
They come in several flavors, which correspond to TeX Live schemes
(see the table below).
The default scheme is `full` which contains all packages.

If some package is missing you can always use `tlmgr` to install it.
The image is based on [`alpine`](https://alpinelinux.org/), so system packages
may be installed using `apk`.

| Scheme  | Image                          | Size    |
| ------- | ------------------------------ | ------- |
| minimal | `kjarosh/latex:2021.2-minimal` | ~40 MB  |
| basic   | `kjarosh/latex:2021.2-basic`   | ~70 MB  |
| small   | `kjarosh/latex:2021.2-small`   | ~130 MB |
| medium  | `kjarosh/latex:2021.2-medium`  | ~400 MB |
| full    | `kjarosh/latex:2021.2`         | ~1.8 GB |

The images are made in such a way that they reuse layers.
For example `full` will add a layer to `medium` with packages that are
not present there.
This makes it easier to manage and saves space.

Versions are in the format of `<major>.<minor>`.
The major version relates to TeX Live version (which is the year),
the minor version is the version of the image within the given year.
In order for `tlmgr` to work, the year must be current.
