#!/bin/bash
# FindFileInTars.sh - Search for file in subsytem .tar files.
#	8/10/25.	wmk.
#
# Usage. bash   FindFileInTars <filespec> -u mountname [<src-sysid>]
#
#		<filespec> = file to or pattern to search for
#						(e.g. Projects-Geany/ArchivingBackups/ReloadSubsys.sh)
#		-u = reload from unloadable device (flashdrive)
#		mountname = mount name for flashdrive
#		<src-sysid> = (optional) tar dump source system ID
#							 default *SYSID
# Note: <statecountycongo> specifies a subfolder on the *mountname* drive
# in which the .tar exists to reload from.
#
# Dependencies.
#	*pathbase* - base directory in which all reloads will be placed.
#	*congterr* - congregation territory name (sscccccn format).
#	*pathbase*/*congterr*/.log - tar log subfolder of incremental dump tracking
#
# Exit Results. *TEMP_PATH/foundlist.txt lists incremental dumps containing <filespec>.
#
# Modification History.
# ---------------------
# 8/10/25.	wmk.	original shell; adapted from Tutoring.
#
# P1=<filespec>, P2=<-u>, P3=<mount-name>, [P4=<src-sysid>]
#
P1=$1	
P2=${2,,}
P3=$3	
P4=${4^^}
if [ -z "$P4" ];then
 P4=$SYSID
fi
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ];then
 printf "%s\n" "FindFileInTars <filespec> [-u <mountname>] [<src-sysid>] missing parameter(s) - abandoned."
 read -p "Enter ctrl-c to keep Terminal active:"
 exit 1
fi
 P2=${2,,}
 if [ "$P2" != "-u" ];then
  printf "%s\n" "FindFileInTars <filespec> [-u <mountname>] [<scope>] [<state><county><congo>] unrecognized '-' option - abandoned."
 fi
 if ! test -d $U_DISK/$P3;then
  printf "%s\n" "** $P3 not mounted - mount $P3..."
  read -p "  then press {enter} or 'q' to quit: "
  yq=${REPLY^^}
  if [ "$yq" == "Q" ];then
   printf "%s\n" "  FindFileInTars abandoned, drive not mounted."
   ~/sysprocs/LOGMSG "  FindFileInTars abandoned, drive not mounted."
   read -p "Enter ctrl-c to keep Terminal active:"
   exit 0
  fi
  if ! test -d $U_DISK/$P3;then
   printf "%s\n" "  FindFileInTars abandoned, $P3 drive still not mounted."
   read -p "Enter ctrl-c to keep Terminal active:"
   exit 1
  fi
 fi
# debugging code...
printf "%s\n" "P1 = : $P1"	# filespec
printf "%s\n" "P2 = : $P2"	# -u
printf "%s\n" "P3 = : $P3"	# mount-name
printf "%s\n" "P4 = : $P4"  # <src_sysid>
printf "%s\n" "FindFileInTars parameter tests complete"
#read -p "Enter ctrl-c to keep Terminal active:"
#exit 0
# handle case where called from Make.
~/sysprocs/LOGMSG "   FindFileInTars $P1 $P2 $P3 $P4 initiated from Terminal."
printf "%s\n" "   FindFileInTars initiated."
#procbodyhere
pushd ./ > /dev/null
dump_path=$U_DISK/$P3/$P4/Basic
cd $dump_path
projpath=$codebase/Projects-Geany/ArchivingBackups
 # list all .tar files to temp/ArchList.txt.
if test -f $TEMP_PATH/taroutput.txt;then
 rm $TEMP_PATH/taroutput.txt
fi
printf "%s\n" "dump_path = '$dump_path'"
cd $dump_path
ls *.tar > $TEMP_PATH/ArchList.txt
#gawk -F "." '{BEGIN{cnt=0}{names[cnt] = $0}END{n=asort(names,names,"@val_str_asc");for(i=0;i <= cnt;i++)print names[i]}}' ArchList.txt > ArchSortedList.txt
gawk -F "." -f $projpath/awksortarch2.txt $TEMP_PATH/ArchList.txt > $TEMP_PATH/ArchSortedList.txt
 printf "%s\n" "ArchSortedList.txt follows..."
 cat $TEMP_PATH/ArchSortedList.txt
  file=$TEMP_PATH/ArchSortedList.txt
  cb=CB
  printf "%s\n" $P1 | sed 's?!?*?g'	#if ! substitute * 
   printf "%s\n" "Finding from *.tar dumps..."
   if [ -f $TEMP_PATH/taroutput.txt ];then
    rm $TEMP_PATH/taroutput.txt
   fi
   while read -e;do
    archname=$REPLY
    printf "%s\n" " Scanning $archname."
    printf "%s\n" "  $archname" >> $TEMP_PATH/taroutput.txt
    tar --list --wildcards \
    --file $dump_path/$archname \
    -- */$P1  1>>$TEMP_PATH/taroutput.txt 2>>$TEMP_PATH/taroutput.txt
   done < $file
backslash='//"'
# at this point taroutput.txt contains 2-line outputs, 1) archive name,
# 2) if found, line has $P1 or if not found, 2 lines beginning with 'tar:'
#mawk  '{if(substr($1,1,4) != "tar:") print;}' $TEMP_PATH/taroutput.txt
mawk -v srch_name="$P1" 'BEGIN {prevline = ""}{currline = $0;if(substr($1,1,4) != "tar:" && index($0,srch_name)>0){print prevline "\n" currline;prevline=currline}prevline=currline}' $TEMP_PATH/taroutput.txt
wc $TEMP_PATH/taroutput.txt > $TEMP_PATH/scratchfile.txt
if [ $? -ne 0 ];then
 printf "%s\n" "  File $P1 not found in tar dumps..."
fi
popd > /dev/null
#endprocbody
read -p "Enter ctrl-c to keep Terminal active:"
exit 0
# end FindFileInTars.sh
