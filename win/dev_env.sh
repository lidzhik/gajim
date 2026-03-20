#!/usr/bin/env bash

set -e

DIR="$( cd "$( dirname "$0" )" && pwd )"
source "$DIR"/_base.sh

function main {
    pacman --noconfirm -S --needed \
        git \
        intltool \
        p7zip \
        wget \
        ${MINGW_PACKAGE_PREFIX}-python \
        ${MINGW_PACKAGE_PREFIX}-toolchain \
        ${MINGW_DEPS}

    pip3 install --break-system-packages --index-url https://mirrors.sustech.edu.cn/pypi/web/simple precis-i18n
    pip3 install --upgrade --break-system-packages --index-url https://mirrors.sustech.edu.cn/pypi/web/simple $(echo "$PYTHON_REQUIREMENTS" | tr ["\\n"] [" "])
    pip3 install --break-system-packages --index-url https://mirrors.sustech.edu.cn/pypi/web/simple pygobject-stubs --no-cache-dir
}

main;
