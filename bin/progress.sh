#!/bin/bash
# ----------------------------------------------------------------------------

function bar_return() {
	local i;
	for ((i=0;i<55;i++)); do
	  printf "\b";
  done;
}

function bar_clear() {
	bar_return;
	local i;
	for ((i=0;i<55;i++)); do
	  printf " ";
  done;
}
	
function progress_return() {
	local i;
	for ((i=0;i<50;i++)); do
	  printf "\b";
  done;
}

BAR=' %2d%% '"$(color white white)"'                                                  '"$(color)";
printf "$BAR" "0";

for ((i=0;i<100;i++)); do

  bar_return;
  
  printf "$BAR" $i;
  	
  progress_return;
  
  printf "$(color white green)";
  for ((j=0;j<($i/2);j++)); do
		printf " ";
	done;
	printf "$(color)";
	
	sleep 0.05;
done;

bar_clear;
