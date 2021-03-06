#!/usr/bin/env bash
#
# This script assumes a linux environment

set -e #-x

TEMPFILE=(mktemp)

echo "*** uAssets: updating remote assets..."

declare -A assets
assets=(
    ['thirdparties/Yuki2718/ublock-anti-whitelist.txt']='https://raw.githubusercontent.com/Yuki2718/adblock/master/medium_mode/anti-allowlist.txt'
)

for i in "${!assets[@]}"; do
    localURL="$i"
    remoteURL="${assets[$i]}"
    echo "*** Downloading ${remoteURL}"
    if wget -q -T 30 -O "$TEMPFILE" -- "$remoteURL"; then
        if [ -s "$TEMPFILE" ]; then
            if ! cmp -s "$TEMPFILE" "$localURL"; then
                echo -e "\tNew version found: ${localURL}"
                if [ "$1" != "dry" ]; then
                    mv "$TEMPFILE" "$localURL"
                fi
            fi
        fi
    fi
done
