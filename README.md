# BEAST2.4.5 XML Fixer

## USAGE

Here is an example of usage and output echoed to screen during a run on Jimmy McGuire's 
Draco dataset:

```
$ ./BEAST2.4.5XMLFixer.sh 

##########################################################################################
#                             BEAST2.4.5XMLFixer, March 2017                             #
##########################################################################################

INFO      | Sun Mar 26 20:05:43 CDT 2017 |          Setting working directory to: /Users/justinbagley/Downloads/Draco2 
INFO      | Sun Mar 26 20:05:43 CDT 2017 |          Currently analyzing the following files: 
INFO      | Sun Mar 26 20:05:43 CDT 2017 |               ./Draco167_50locus_set1.xml 
INFO      | Sun Mar 26 20:05:43 CDT 2017 |          Current basename is Draco167_50locus_set1 
INFO      | Sun Mar 26 20:05:44 CDT 2017 |          Correct speciation rate parameter name is cySpeciationRate 
WARNING!  | Sun Mar 26 20:05:44 CDT 2017 |          State check FAILED: more than one state element encountered!
INFO      | Sun Mar 26 20:05:45 CDT 2017 |          Removing second state section located from lines 7288 to 7292 
INFO      | Sun Mar 26 20:05:46 CDT 2017 | Done fixing your BEAUti v2.4.5-generated BEAST XML file using BEAST2.4.5XMLFixer.
INFO      | Sun Mar 26 20:05:46 CDT 2017 | Bye.
```
