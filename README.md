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
| minimal | `kjarosh/latex:2025.1-minimal` | ~40 MB  |
| basic   | `kjarosh/latex:2025.1-basic`   | ~90 MB  |
| small   | `kjarosh/latex:2025.1-small`   | ~180 MB |
| medium  | `kjarosh/latex:2025.1-medium`  | ~500 MB |
| full    | `kjarosh/latex:2025.1`         | ~2 GB   |

The images are made in such a way that they reuse layers.
For example `full` will add a layer to `medium` with packages that are
not present there.
This makes it easier to manage and saves space.

## Usage

If you're writing a CI/CD configuration, check out [CI/CD Examples](#cicd-examples)!

Assuming you want to quickly compile a file named `main.tex` in the current
directory to a PDF and place the output in `./out`:

```shell
docker run --rm -v "$PWD:/src" -w /src -u "$UID:$GID" kjarosh/latex:2025.1 latexmk -pdf -outdir=out -auxdir=out/aux main.tex
```

If you want to work on your LaTeX project and see your changes live,
add `-pvc` at the end.
This will recompile the project automatically each time a source file changes.

If you want to use a different engine, use e.g. `-xelatex` for XeLaTeX
or `-lualatex` for LuaLaTeX.

Other useful options you may want to check out include e.g. `-c`, `-g`, or `-silent`.

See [latexmk documentation](https://ctan.gust.org.pl/tex-archive/support/latexmk/latexmk.pdf)
for detailed usage and options.

If you don't want to use `latexmk` you are free to issue any command you want
(`latex`, `pdflatex`, `xelatex`, etc.) and it should just work.
For more complex building processes, using a building tool such as `make` is advised.
In that case you'll need to install it by issuing `apk add make` inside the container.

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
| 2025             | `2025.1`              |
| 2024             | `2024.5`              |
| 2023             | `2023.4`              |
| 2022             | `2022.3`              |
| 2021             | `2021.4`              |
| 2020             | `2020.2`              |
| 2019             | `2019.2`              |
| 2018             | `2018.2`              |

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

## CI/CD Examples

### GitHub Actions

Example using `latexmk`:

```yaml
name: Compile LaTeX
on: [ push ]
jobs:
  container:
    runs-on: ubuntu-latest
    container: kjarosh/latex:2024.4
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Build using latexmk
        run: latexmk -pdf -output-directory=out main.tex

      - name: Upload document
        uses: actions/upload-artifact@v4
        with:
          name: main-document
          path: out/index.pdf
```

### GitLab CI/CD

Example using `latexmk`:

```yaml
build:
  stage: build
  image: kjarosh/latex:2024.4
  script:
    - latexmk -pdf -output-directory=out main.tex
  artifacts:
    paths:
      - out/index.pdf
```
