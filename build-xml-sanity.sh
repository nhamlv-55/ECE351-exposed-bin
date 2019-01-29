#!/bin/bash
# check if the source files named in build.xml exist
# this check is necessary due to renaming

patterns=`gawk '/include name=/ { print $2; }' build.xml | sed -e 's/"//g' -e 's/name=/src\//' -e 's/.class/.java/'`

for p in $patterns
do
    ls $p 1>/dev/null
done
