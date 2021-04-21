FROM alpine

# TeXlive scheme
ARG TL_SCHEME="basic"

# installation settings
ARG TL_INSTALL_DEST="/opt/texlive"
ARG TL_INSTALL_SRC="/tmp/texlive"
ARG TL_INSTALL_PROFILE="/tmp/texlive.profile"

RUN apk add --no-cache perl curl && \
    mkdir "${TL_INSTALL_SRC}" && \
    cd "${TL_INSTALL_SRC}" && \
    TL_YEAR="$(date +%Y)" TL_VERSION="$(date +%Y%m%d)" && \
    wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz && \
    tar xzvf ./install-tl-unx.tar.gz && \
    echo "selected_scheme scheme-${TL_SCHEME}" > "${TL_INSTALL_PROFILE}" && \
    echo "TEXDIR ${TL_INSTALL_DEST}/${TL_YEAR}" >> "${TL_INSTALL_PROFILE}" && \
    echo "TEXMFLOCAL ${TL_INSTALL_DEST}/texmf-local" >> "${TL_INSTALL_PROFILE}" && \
    echo "TEXMFSYSCONFIG ${TL_INSTALL_DEST}/${TL_YEAR}/texmf-config" >> "${TL_INSTALL_PROFILE}" && \
    echo "TEXMFSYSVAR ${TL_INSTALL_DEST}/${TL_YEAR}/texmf-var" >> "${TL_INSTALL_PROFILE}" && \
    echo "TEXMFHOME ~/.texmf" >> "${TL_INSTALL_PROFILE}" && \
    "./install-tl-${TL_VERSION}/install-tl" -profile "${TL_INSTALL_PROFILE}" && \
    rm -vf "/opt/texlive/${TL_YEAR}/install-tl" && \
    rm -vf "/opt/texlive/${TL_YEAR}/install-tl.log" && \
    rm -vf "/opt/texlive/${TL_YEAR}/doc.html" && \
    rm -vrf "/opt/texlive/${TL_YEAR}/texmf-dist/doc" && \
    rm -vrf /tmp/*

ENV PATH="${PATH}:/opt/texlive/${TL_YEAR}/bin/x86_64-linuxmusl"
