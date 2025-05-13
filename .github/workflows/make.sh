#!/usr/bin/env bash
set -euo pipefail
if [[ -f '/etc/os-release' ]]; then
    source '/etc/os-release'
fi
case ${ID:?} in
    debian | ubuntu) sudo bash -c '
        apt-get update; apt-get -y install lazarus
    ' >/dev/null ;;
esac
while read -r; do
    declare -i exitCode=0
    mapfile -t < <(
        if ! [[ ${REPLY} =~ /use/ ]] && [[ -f "${REPLY%.*}.pas" ]]; then
            if (fpc -Fuuse/mseide-msegui/lib/common/kernel/linux \
                    -Fuuse/mseide-msegui/lib/common/* \
                    -B "${REPLY%.*}.pas"); then
                printf 'SUCCES\t\x1b[32m%s\x1b[0m\n' "${REPLY}" >&2
                printf 'exitCode:0\n'
            else
                printf 'ERROR\t\x1b[31m%s\x1b[0m\n'  "${REPLY}" >&2
                printf 'exitCode:1\n'
            fi |
                grep --extended-regexp '(Error:|Fatal:|Linking|exitCode)'
        fi
    )
    if ((${MAPFILE[-1]##*:})); then
        exitCode+=${MAPFILE[-1]##*:}
        printf '%s\n' "${MAPFILE[@]}"
    fi
done < <(find '.' -type 'f' -name '*.prj')
