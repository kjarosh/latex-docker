# LaTeX in Docker

[![GitHub license](https://img.shields.io/github/license/kjarosh/latex-docker)](https://github.com/kjarosh/latex-docker/blob/main/LICENSE)
[![GitHub build status](https://img.shields.io/github/actions/workflow/status/kjarosh/latex-docker/docker.yaml?branch=main)](https://github.com/kjarosh/latex-docker/actions)
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
|---------|--------------------------------|---------|
| minimal | `kjarosh/latex:2024.2-minimal` | ~40 MB  |
| basic   | `kjarosh/latex:2024.2-basic`   | ~90 MB  |
| small   | `kjarosh/latex:2024.2-small`   | ~180 MB |
| medium  | `kjarosh/latex:2024.2-medium`  | ~500 MB |
| full    | `kjarosh/latex:2024.2`         | ~2 GB   |

The images are made in such a way that they reuse layers.
For example `full` will add a layer to `medium` with packages that are
not present there.
This makes it easier to manage and saves space.

## Versions

There are several types of versions described below.

*If you're unsure which version to use, use the latest stable version.*

### Stable Versions

Stable versions are in the format of `<major>.<minor>` (e.g. `2022.1`).
The major version relates to TeX Live version (which is the year),
the minor version is the version of the image within the given year.

Stable versions offer image updates & fixes and include the
set of packages for the given TeX Live version at the time of release.

| TeX Live version | Latest stable version |
| ---------------- | --------------------- |
| 2024             | `2024.2`              |
| 2023             | `2023.1`              |
| 2022             | `2022.1`              |
| 2021             | `2021.2`              |
| 2020             | `2020.1`              |
| 2019             | `2019.1`              |
| 2018             | `2018.1`              |
| 2017             | `2017.1`              |
| 2016             | `2016.1`              |
| 2015             | `2015.1`              |
| 2014             | `2014.1`              |
| 2013             | `2013.1`              |
| 2012             | `2012.1`              |
| 2011             | `2011.1`              |
| 2010             | `2010.1`              |
| 2009             | `2009.1`              |

All stable versions are available on the [releases page](https://github.com/kjarosh/latex-docker/releases).

### Development Versions

If you want to use the newest TeX Live or visit an old release
from the past, you can use development versions.

Development versions are released automatically
every day and come in several formats:

1. `devel` &mdash; The lastest development build which uses the main TL mirror.
  Using this version is **highly discouraged**, especially in CI/CD,
  as in case a newer TeX Live release appears, `tlmgr` will not work.

2. `devel-<TL_VERSION>-<DATE>` &mdash; A development version containing TeX Live
  in version `<TL_VERSION>`, based on a historic mirror from `<DATE>` (so that `tlmgr` will work).
  Usually these images are created once and not updated in the future.

3. `devel-<TL_VERSION>` &mdash; The newest development build for the given TeX Live release.
  When `<TL_VERSION>` is the current TeX Live version, this image will
  usually be newer than the latest stable release of `<TL_VERSION>`.
  However, when `<TL_VERSION>` is not the current TeX Live version, the latest
  stable release usually will contain maintenance fixes and base image updates.

4. `devel-any-<DATE>` &mdash; A development version containing TeX Live from `<DATE>`.
  This is the same as `devel-<TL_VERSION>-<DATE>`, but without `<TL_VERSION>` in case
  someone wants to use the TeX Live from `<DATE>` without knowing `<TL_VERSION>`.

## GitHub Actions

Example using `make`:

```yaml
name: Compile LaTeX
on: [ push ]
jobs:
  container:
    runs-on: ubuntu-latest
    container: kjarosh/latex:2024.2
    steps:
      - name: Install make
        run: apk add make
      - name: Checkout
        uses: actions/checkout@v2
      - name: Build
        run: make
      - name: Upload document
        uses: actions/upload-artifact@v2
        with:
          name: main-document
          path: out/index.pdf
```

## GitLab CI/CD

Example using `make`:

```yaml
image: kjarosh/latex:2024.2

build:
  stage: build
  before_script:
    - apk add make
  script:
    - make build
  artifacts:
    paths:
      - out/index.pdf

```
