#!/bin/sh

echo "
##########################################################################################
#                             BEAST2.4.5XMLFixer, March 2017                             #
##########################################################################################
"
######################################## START ###########################################
###### SETUP WORKSPACE.
	MY_PATH=`pwd -P`
	echo "INFO      | $(date) |          Setting working directory to: $MY_PATH "
	CR=$(printf '\r');
	calc () {
		bc -l <<< "$@" 
	}

###### READ IN XML FILE(S) TO BE FIXED.
MY_XML_FILES="$(find . -name "*.xml" -type f)"
echo "INFO      | $(date) |          Currently analyzing the following files: "
echo "INFO      | $(date) |               $MY_XML_FILES "

###### FIX XML(S).
###### FIX XML(S).
### ISSUE #1. Incorrect specification of clock 'speciationRate.t' parameter idref:		###
##--grep out .*<parameter\ id\=\"\(.*ciationRate\)\.t\:Species   ...   and save \1, which will
##--be the name of the correct, single ucln clock speciationRate parameter basename (minus .t).
##--You can then use this basename during grep/sed search and replace on the xml file for
##--the first issue. 
#
### ISSUES #2-4. User perl sed calls to automate fixing these issues in the XML.
	(
		for i in $MY_XML_FILES; do
			CURR_XML_BASENAME="$(basename "$i" | sed 's/\.xml//g')"
			echo "INFO      | $(date) |          Current basename is $CURR_XML_BASENAME "
			CORRECT_SPECRATE_NAME="$(grep -n '.*<parameter\ id\=\".*ciationRate\.t\:Species' "$i" | head -n1 | sed 's/.*<parameter\ id\=\"\(.*ciationRate\)\.t\:Species.*/\1/g')"
			echo "INFO      | $(date) |          Correct speciation rate parameter name is $CORRECT_SPECRATE_NAME "

			##--Create environmental variable used to test for additional state element.
			NUM_STATE_LINES="$(grep -n '.*\<state\>' "$i" | wc -l)"

			##--If additional state element present, cut the lines, then fix the xml and exit.
			##--This was written to fix Jimmy McGuire's extra state element; it will fail to
			##--fix the problem 100% if more than one extra state element is present (in that
			##--case, it will only fix the last two; you would need a loop to fix multiple
			##--instances of extra states).
			if [[ "$NUM_STATE_LINES" -gt "2" ]]; then
			echo "WARNING!  | $(date) |          State check FAILED: more than one state element encountered!"

				##--Identify range of lines to cut:
				WEIRDSTATE_LINES="$(grep -n '.*\<state\>' "$i" | tail -n2 | sed 's/[^0-9\ ].*//g')"
				## echo $WEIRDSTATE_LINES
				STARTCUT_LINE="$(calc $(echo $WEIRDSTATE_LINES | sed 's/\ [0-9]*$//g')-1)"
				## echo $STARTCUT_LINE
				ENDCUT_LINE="$( calc $(echo $WEIRDSTATE_LINES | sed 's/[0-9]*\ //g')+1)"
				## echo $ENDCUT_LINE

				echo "INFO      | $(date) |          Removing second state section located from lines $STARTCUT_LINE to $ENDCUT_LINE "
				##--Use sed to cut the bad lines out.
				sed "$STARTCUT_LINE","$ENDCUT_LINE"d "$i" > tmp1.xml
				
				##--Fix the xml and save to new file given the name of the original XML, except closing 
				##--with '_fixed.xml' instead of just '.xml'.
				perl -pe 's/(up\ idref\=\")speciationRate(\.t\:Species)/$1'$CORRECT_SPECRATE_NAME'$2/g' ./tmp1.xml | \
				perl -pe 's/up\ idref\=\"clockRate\.c\:/up\ idref\=\"uclnClockRate\.c\:/g' | \
				perl -pe 's/\<parameter\ id\=\"speciationRate\.t\:Species\"\ /\<parameter\ idref\=\"'$CORRECT_SPECRATE_NAME'\.t\:Species\"\ /g' | \
				perl -pe 's/\<parameter\ id\=\"clockRate\.c\:/\<parameter\ idref\=\"uclnClockRate\.c\:/g' > ./"${CURR_XML_BASENAME}"_fixed.xml
				rm ./tmp1.xml
				
				
			##--If NO additional state element present, then fix the xml and exit.
			elif [[ "$NUM_STATE_LINES" -eq "2" ]]; then
			echo "INFO      | $(date) |          State check PASSED: only one state element encountered."
				perl -pe 's/(up\ idref\=\")speciationRate(\.t\:Species)/$1'$CORRECT_SPECRATE_NAME'$2/g' "$i" | \
				perl -pe 's/up\ idref\=\"clockRate\.c\:/up\ idref\=\"uclnClockRate\.c\:/g' | \
				perl -pe 's/\<parameter\ id\=\"speciationRate\.t\:Species\"\ /\<parameter\ idref\=\"'$CORRECT_SPECRATE_NAME'\.t\:Species\"\ /g' | \
				perl -pe 's/\<parameter\ id\=\"clockRate\.c\:/\<parameter\ idref\=\"uclnClockRate\.c\:/g' > ./"${CURR_XML_BASENAME}"_fixed.xml
				
								
			fi
			
		done
	)



echo "INFO      | $(date) | Done fixing your BEAUti v2.4.5-generated BEAST XML file using BEAST2.4.5XMLFixer."
echo "INFO      | $(date) | Bye.
"
#
#
#
######################################### END ############################################

exit 0
