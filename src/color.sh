#!/bin/bash
# ----------------------------------------------------------------------------
# @file color
# Return ANSI color escape sequences.
# Ref: http://www.faqs.org/docs/abs/HTML/colorizing.html,
# http://isthe.com/chongo/tech/comp/ansi_escapes.html
# Usage syntax based on original work by Moshe Jacobson <moshe@runslinux.net>
# @author Alister Lewis-Bowen [alister@different.com]
# ----------------------------------------------------------------------------

function help {
	echo;
	echo "$(color bd)Conveniently named ANSI escape sequences for your shell scripts.$(color off)";
	echo;
	echo 'Usage:';
	echo "$(color bd)build$(color off) [b]$(color ul)fgcolor$(color off) [$(color ul)bgcolor$(color off)]";
	echo "$(color bd)build$(color off) [ bd | bold | ul | underline | bk | blink | rv | reversevideo | off ]";
	echo "$(color bd)build$(color off) list";
	echo;
	echo 'where:';
	echo -n "$(color ul)fgcolor$(color off) and $(color ul)fgcolor$(color off) are one of ";
	echo -n "$(color black)black$(color off) ";
	echo -n "$(color red)red$(color off) ";
	echo -n "$(color green)green$(color off) ";
	echo -n "$(color yellow)yellow$(color off) ";
	echo -n "$(color blue)blue$(color off) ";
	echo -n "$(color magenta)magenta$(color off) ";
	echo -n "$(color cyan)cyan$(color off) ";
	echo -n "$(color white)white$(color off).";
	echo;
	echo "Preceed the fgcolor with $(color bd)b$(color off) to use a bold color."
	echo "$(color bd)color bd$(color off) and $(color bd)color bold$(color off) turn on $(color bd)bold$(color off).";
	echo "$(color bd)color ft$(color off) and $(color bd)color faint$(color off) turn on $(color ft)faint$(color off).";
	echo "$(color bd)color st$(color off) and $(color bd)color standout$(color off) turn on $(color ft)standout$(color off).";
	echo "$(color bd)color ul$(color off) and $(color bd)color underline$(color off) turn on $(color ul)underline$(color off).";
	echo "$(color bd)color bk$(color off) and $(color bd)color blink$(color off) turn on $(color bk)blink$(color off).";
	echo "$(color bd)color rv$(color off) and $(color bd)color reversevideo$(color off) turn on $(color rv)reversevideo$(color off).";
	echo "$(color bd)color in$(color off) and $(color bd)color invisible$(color off) turn on $(color in)invisible$(color off).";
	echo "$(color bd)color off$(color off) resets to default colors and text treatments.";
	echo "$(color bd)color list$(color off) displays all possible color combinations.";
	echo;
	echo 'Example:';
	echo '  echo "$(color bred yellow) Color $(color off)"';
	echo 'results in:';
	echo "  $(color bred yellow) Color $(color off)";
	echo;
	echo;
	echo -n "Note that results may vary with these standard ANSI escape sequences because of the different configurations of terminal emulators. ";
	echo "Colors seem to work reliably. Bold and underline work less so. Blink and reverse video I've seen working but the rest I have not.";
	echo;
	exit 1;
}
if [[ "$1" = '-h' || "$1" = '--help' ]]; then help; fi;

function list {

	echo;
	echo "$(color bold)These are the possible combinations of colors I can generate. ";
	echo "Since terminal color settings vary, $(color underline)the expected output may vary$(color off)$(color bold).$(color off)";
	echo;
	
	for bg in black red green yellow blue magenta cyan white; do
		echo "$bg:";
			for fg in black red green yellow blue magenta cyan white; do
				echo -n "$(color $fg $bg)  $fg  $(color off) ";
			done;
			echo;
			for fg in bblack bred bgreen byellow bblue bmagenta bcyan bwhite; do
				echo -n "$(color $fg $bg) $fg  $(color off) ";
			done;
		echo;
	done;
	
	exit 1;
}
if [ "$1" = 'list' ]; then list; fi;


# Text treatments
# ----------------------------------------------------------------------------
if [[ "$1" = nm || "$1" = normal ]];       then echo -en '\033[0m'; exit 0; fi;
if [[ "$1" = bd || "$1" = bold ]];         then echo -en '\033[1m'; exit 0; fi;
if [[ "$1" = ft || "$1" = faint ]];        then echo -en '\033[2m'; exit 0; fi;
if [[ "$1" = st || "$1" = standout ]];     then echo -en '\033[3m'; exit 0; fi;
if [[ "$1" = ul || "$1" = underline ]];    then echo -en '\033[4m'; exit 0; fi;
if [[ "$1" = bk || "$1" = blink ]];        then echo -en '\033[5m'; exit 0; fi;
if [[ "$1" = rv || "$1" = reversevideo ]]; then echo -en '\033[7m'; exit 0; fi;
if [[ "$1" = iv || "$1" = invisible ]];    then echo -en '\033[8m'; exit 0; fi;

# Switch back to 'normal'
# ----------------------------------------------------------------------------
if [ "$1" = off ]; then tput sgr0; exit 0; fi;

# Forground colors
# ----------------------------------------------------------------------------
if [ "$1" = black ];   then fg=0';'30; fi; 
if [ "$1" = red ];     then fg=0';'31; fi;
if [ "$1" = green ];   then fg=0';'32; fi;
if [ "$1" = yellow ];  then fg=0';'33; fi;
if [ "$1" = blue ];    then fg=0';'34; fi;
if [ "$1" = magenta ]; then fg=0';'35; fi;
if [ "$1" = cyan ];    then fg=0';'36; fi;
if [ "$1" = white ];   then fg=0';'37; fi;
if [ "$1" = bblack ];  then fg=1';'30; fi; 
if [ "$1" = bred ];    then fg=1';'31; fi;
if [ "$1" = bgreen ];  then fg=1';'32; fi;
if [ "$1" = byellow ]; then fg=1';'33; fi;
if [ "$1" = bblue ];   then fg=1';'34; fi;
if [ "$1" = bmagenta ];then fg=1';'35; fi;
if [ "$1" = bcyan ];   then fg=1';'36; fi;
if [ "$1" = bwhite ];  then fg=1';'37; fi;

# Background colors
# ----------------------------------------------------------------------------
if [ "$2" = black ];   then bg=40; fi; 
if [ "$2" = red ];     then bg=41; fi;
if [ "$2" = green ];   then bg=42; fi;
if [ "$2" = yellow ];  then bg=43; fi;
if [ "$2" = blue ];    then bg=44; fi;
if [ "$2" = magenta ]; then bg=45; fi;
if [ "$2" = cyan ];    then bg=46; fi;
if [ "$2" = white ];   then bg=47; fi;

code='\033['$fg;
if [ "$2" != '' ]; then code=${code}';'$bg; fi;
code=${code}m;

echo -en $code;

exit 0;