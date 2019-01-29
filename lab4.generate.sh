#!/bin/bash

simplify(){
	src=$1
	trg=$2
	pushd $src
	fileArray=($(find *.f -prune -o -type f))
	popd
	mkdir $trg
	for f in ${fileArray[@]} 
	do
	java -cp "bin:lib/junit4-4.8.2.jar:lib/asm-all-3.3.1.jar:lib/parboiled-1.0.2-all.jar:" ece351/f/Simplifier -p $src/${f} > $trg/${f}
	echo ${f} has been simplified
	done
}

COLS=../../shared/tests/f/soln.out/collected
COLSIM=${COLS}_simplified
DIST=../../shared/tests/f/soln.out/distributed
DISTSIM=${DIST}_simplified


simplify $COLS $COLSIM
simplify $DIST $DISTSIM

exit 0



