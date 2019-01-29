#!/bin/bash

repo=$PWD

dir=~/tmp/ece351-solns
if [ -e $dir ] ; then
    echo "$dir exists, exiting"
    exit 1
fi

# make the directory and continue
mkdir -p $dir
mkdir -p $dir/export
mkdir -p $dir/snipped
pushd $dir/export > /dev/null
git clone $repo

cd `basename $repo`

# remove external links
#rm -rf wave lib f vhdl

# process Java source files
dirs=`find src -type d`
for d in $dirs ; do mkdir -p $dir/snipped/solns/$d ; done
srcs=`find src -name '*.java'`
for f in $srcs ; do 
    cat src/ece351/header.txt > $dir/snipped/solns/$f
    gawk -f snip.awk $f >> $dir/snipped/solns/$f
    dos2unix $dir/snipped/solns/$f 
done

# process Eclipse settings files
efiles=".classpath .project Makefile build.xml"
for f in $efiles ; do
    cp $f $dir/snipped/solns/
done

# process assignment source files
dirs=`find assignments -type d | grep -v tmp`
for d in $dirs  
do 
    mkdir -p $dir/snipped/solns/$d
done
dirs=`find assignments -type d -name 'a[1-9]'`
for d in $dirs  
do 
    for f in Makefile .gitignore graphviz.sty
    do
        if [ -f $d/$f ] ; then
            cp $d/$f $dir/snipped/solns/$d/$f
            dos2unix $dir/snipped/solns/$d/$f
        fi
    done
    gawk -f snip.awk $d/main.tex \
        | sed -e 's/solution}%lstsolution/lstsolution}/' \
        > $dir/snipped/solns/$d/main.tex
    dos2unix $dir/snipped/solns/$d/main.tex
done


# done
popd > /dev/null
