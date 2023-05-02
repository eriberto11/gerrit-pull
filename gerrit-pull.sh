#!/bin/bash
REV=$(git log -n1 --format=%D)
REV=${REV#* }
CURRENTREVISION=${REV##*/}
REV=${REV%/*}
changeid=${REV##*/}

echo "currentrevision:  $CURRENTREVISION"

allrefs=$( git ls-remote $(git config --get remote.origin.pushurl) |  grep -Eo "refs/changes/[[:digit:]]+/${changeid}/[[:digit:]]+")
MAXREV=0
MAXPULLREF=""

for ref in $allrefs; do 
        REV=${ref##*/}
        if [[ $REV -gt $MAXREV ]] 
        then
                MAXREV=$REV
                MAXPULLREF=$ref
        fi
done
echo "maxrevision : $MAXREV"

if [[ $MAXREV -gt $CURRENTREVISION ]] 
then
        echo "pulling maxrevision"
        git fetch $(git config --get remote.origin.pushurl) ${MAXPULLREF} && git checkout FETCH_HEAD
fi
