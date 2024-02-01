FROM alpine:3.17.3

# installation settings
ARG TL_MIRROR="https://texlive.info/CTAN/systems/texlive/tlnet"
ARG TL_YEAR="2024"

RUN apk add --no-cache perl curl fontconfig libgcc gnupg && \
    mkdir "/tmp/texlive" && cd "/tmp/texlive" && \
    wget "$TL_MIRROR/install-tl-unx.tar.gz" && \
    tar xzvf ./install-tl-unx.tar.gz && \
    ( \
        echo "selected_scheme scheme-minimal" && \
        echo "instopt_adjustpath 0" && \
        echo "tlpdbopt_install_docfiles 0" && \
        echo "tlpdbopt_install_srcfiles 0" && \
        echo "TEXDIR /opt/texlive/${TL_YEAR}" && \
        echo "TEXMFLOCAL /opt/texlive/texmf-local" && \
        echo "TEXMFSYSCONFIG /opt/texlive/${TL_YEAR}/texmf-config" && \
        echo "TEXMFSYSVAR /opt/texlive/${TL_YEAR}/texmf-var" && \
        echo "TEXMFHOME ~/.texmf" \
    ) > "/tmp/texlive.profile" && \
    "./install-tl-${TL_YEAR}"*"/install-tl" --location "$TL_MIRROR" -profile "/tmp/texlive.profile" && \
    rm -vf "/opt/texlive/${TL_YEAR}/install-tl" && \
    rm -vf "/opt/texlive/${TL_YEAR}/install-tl.log" && \
    rm -vrf /tmp/*

ENV PATH="${PATH}:/opt/texlive/${TL_YEAR}/bin/x86_64-linuxmusl"

ARG TL_SCHEME_BASIC="y"
RUN if [ "$TL_SCHEME_BASIC" = "y" ]; then tlmgr install scheme-basic; fi

ARG TL_SCHEME_SMALL="y"
RUN if [ "$TL_SCHEME_SMALL" = "y" ]; then tlmgr install scheme-small; fi

ARG TL_SCHEME_MEDIUM="y"
RUN if [ "$TL_SCHEME_MEDIUM" = "y" ]; then tlmgr install scheme-medium; fi

ARG TL_SCHEME_FULL=""
RUN if [ "$TL_SCHEME_FULL" = "y" ]; then tlmgr install scheme-full; fi
