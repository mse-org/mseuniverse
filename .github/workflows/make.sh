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
    if [[ -f "${REPLY%.*}.pas" ]]; then
        if (fpc -Fuuse/mseide-msegui/lib/common/kernel/linux \
                -Fuuse/mseide-msegui/lib/common/* \
                -B "${REPLY%.*}.pas"); then
            printf 'exitCode:\tSUCCES\t\x1b[32m%s\x1b[0m\n' "${REPLY}"
        else
            printf 'exitCode:\tERROR\t\x1b[31m%s\x1b[0m\n'    "${REPLY}"
        fi |
            grep --extended-regexp '(Error:|Fatal:|Linking|exitCode)'
    fi
done < <(find '.' -type 'f' -name '*.prj')
