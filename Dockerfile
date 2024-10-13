FROM alpine:3.20.3 AS build

# installation settings
ARG TL_MIRROR="https://texlive.info/CTAN/systems/texlive/tlnet"

RUN apk add --no-cache perl curl fontconfig libgcc gnupg xz && \
    mkdir "/tmp/texlive" && cd "/tmp/texlive" && \
    wget "$TL_MIRROR/install-tl-unx.tar.gz" && \
    tar xzvf ./install-tl-unx.tar.gz && \
    ( \
        echo "selected_scheme scheme-minimal" && \
        echo "instopt_adjustpath 0" && \
        echo "tlpdbopt_install_docfiles 0" && \
        echo "tlpdbopt_install_srcfiles 0" && \
        echo "TEXDIR /opt/texlive/" && \
        echo "TEXMFLOCAL /opt/texlive/texmf-local" && \
        echo "TEXMFSYSCONFIG /opt/texlive/texmf-config" && \
        echo "TEXMFSYSVAR /opt/texlive/texmf-var" && \
        echo "TEXMFHOME ~/.texmf" \
    ) > "/tmp/texlive.profile" && \
    set -eux; cd "/tmp/texlive" && arch=$(uname -m); \
	case $arch in \
		x86_64) ARCHITECTURE='amd64' ;; \
		aarch64) ARCHITECTURE='arm64' ;; \
		*) echo >&2 "error: unsupported architecture ($arch)"; exit 1 ;;\
	esac; \
    echo "Architecture: $ARCHITECTURE"; \
    if [ "$ARCHITECTURE" = "amd64" ]; then \
      "./install-tl-"*"/install-tl" --location "$TL_MIRROR" -profile "/tmp/texlive.profile" && \
      ln -s /opt/texlive/bin/x86_64-linuxmusl /opt/texlive/bin/current; \
    fi;  \
    if [ "$ARCHITECTURE" = "arm64" ]; then \
      wget https://ftp.math.utah.edu/pub/texlive-utah/bin/aarch64-alpine319.tar.xz && \
      tar xvf aarch64-alpine319.tar.xz && \
      "./install-tl-"*"/install-tl" --location "$TL_MIRROR" -profile "/tmp/texlive.profile" --custom-bin=/tmp/texlive/aarch64-alpine319 && \
      ln -s /opt/texlive/bin/custom /opt/texlive/bin/current; \
    fi;

FROM alpine:3.20.3 AS final

RUN apk add --no-cache perl fontconfig curl gnupg xz

COPY --from=build /opt/texlive /opt/texlive

ENV PATH="${PATH}:/opt/texlive/bin/current"

ARG TL_SCHEME_BASIC="y"
RUN if [ "$TL_SCHEME_BASIC" = "y" ]; then tlmgr install scheme-basic; fi

ARG TL_SCHEME_SMALL="y"
RUN if [ "$TL_SCHEME_SMALL" = "y" ]; then tlmgr install scheme-small; fi

ARG TL_SCHEME_MEDIUM="y"
RUN if [ "$TL_SCHEME_MEDIUM" = "y" ]; then tlmgr install scheme-medium; fi

ARG TL_SCHEME_FULL="y"
RUN if [ "$TL_SCHEME_FULL" = "y" ]; then tlmgr install scheme-full; fi
