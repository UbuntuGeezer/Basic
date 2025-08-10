#!/bin/bash
echo " ** RestartIncGeany.sh not supported with Tutoring subsystem. **";exit 1
# 2023-12-09.	wmk.	(automated) Version 3.0.6 paths eliminated (HPPavilion).
# RestartIncGeany.sh  - Set up for fresh incremental archiving of Geany.
# 	12/9/23.	wmk.
#
# Usage. bash RestartIncGeany.sh  -u <mount-name>
#
#	-u = restart on removable media
#	<mount-name> = mount name of removable media
#
# Dependencies. *SYSID - 3 char system ID (CB2)
#	~/Tutoring/Projects-GEany - base directory for Geany project folders
#	~/Tutoring/.log - tar log subfolder for tracking incremental
#	  dumps
#
# Exit Results.
#	/Tutoring/Geany.nnn.tar files all deleted after warning;
#	/Tutoring/log/Geany.snar-0 deleted after warning;
#	/Tutoring/log/Geanylevel.txt deleted; this sets up next run of
#	IncDumpGeany to start at level 0;
#
# Modification History.
# ---------------------
# 12/9/23.	wmk.	original shell; adapted from Accounting.
# 12/9/23.	wmk.	(automated) echo,s to printf,s throughout
# 12/9/23.	wmk.	(automated) Version 3.0.6 Make old paths removed.
# Legacy mods.
# 10/16/23.	wmk.	ver2.0 path updates; *SYSID support;
# Legacy mods.
# 7/23/23.	wmk.	parameters mandatory; eliminate junpto references.
# Legacy mods.
# 3/28/22.	wmk.	original shell; adapted from Territories pathbase.
# 8/18/22.	wmk.	-u, <mount-name> support.
#
# Notes. The entire incremental dump collection for Tutoring/Geany will be
# removed by this shell. The user will be given appropriate warnings
# before proceeding.
#
# P1=-u, P2=<mount-name>
P1=${1^^}
P2=$2
if [ -z "$P1" ] || [ -z "$P2" ];then
 printf "%s\n" "RestartIncGeany -u <mount-name> missing parameter(s) - abandoned."
 read -p "Enter ctrl-c to remain in Terminal: "
 exit 1
fi
if [ -z "$folderbase" ];then
fi
# handle case where called from Make.
if [ -z "$system_log" ]; then
  export system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "   RestartIncGeany $P1 $P2 initiated from Make."
  printf "%s\n" "   RestartIncGeany initiated."
else
  ~/sysprocs/LOGMSG "   RestartIncGeany $P1 $P2 initiated from Terminal."
  printf "%s\n" "   RestartIncGeany initiated."
fi
TEMP_PATH=$HOME/temp
if [ "$P1" != "-U" ];then
  printf "%s\n" "** RestartIncGeany [-u <mount-name>] unrecognized option $P1 - abandoned. **"
  exit 1
fi
if ! test -d $U_DISK/$P2;then
  printf "%s\n" "$P2 not mounted... Mount flash drive $P2"
  read -p "  Drive mounted and continue (y/n)? "
  yn=${REPLY^^}
  if [ "$yn" != "Y" ];then
   printf "%s\n" "RestartIncGeany abandoned at user request."
   exit 1
  else
   if ! test -d $U_DISK/$P2;then
    printf "%s\n" "$P2 still not mounted - RestartIncGeany abandoned."
    exit 1
   else
   printf "%s\n" "continuing with $P2 mounted..."
   fi
  fi
else
   printf "%s\n" "continuing with $P2 mounted..."
fi
printf "%s\n" "P1 = : '$P1'"
printf "%s\n" "P2 = : '$P2'"
printf "%s\n" "parameter tests complete."
#exit
printf "%s\n" " **WARNING - proceeding will remove all prior Geany incremental dump files!**"
read -p "OK to proceed (Y/N)? "
ynreply=${REPLY,,}
if [ "$ynreply" == "y" ];then
  printf "%s\n" "  Proceeding to remove prior incremental dump files..."
else
  ~/sysprocs/LOGMSG "  User halted RestartIncGeany."
  printf "%s\n" " Stopping RestartIncGeany - secure Geany incremental backups.."
  read -p "Enter ctrl-c to remain in Terminal: "
  exit 0
fi
#
#procbodyhere
pushd ./ > /dev/null
dump_path=$U_DISK/$P2/$SYSID/Tutoring
cd $U_DISK/$P2
if ! test -d $SYSID;then
 mkdir $SYSID
fi
cd $SYSID
if ! test -d Tutoring;then
 mkdir Tutoring
fi
cd Tutoring
if ! test -d log;then
 mkdir log
fi
#cd $dump_path
if test -f $dump_path/log/Geanylevel.txt;then
 rm $dump_path/log/Geanylevel.txt
fi
printf "%s\n" "0" > $dump_path/log/Geanynextlevel.txt
if test -f $dump_path/log/Geany.snar-0; then
 rm $dump_path/log/Geany.snar-0
fi
if test -f $dump_path/Geany.0.tar; then
 rm $dump_path/Geany*.tar
fi
popd > /dev/null
#endprocbody
~/sysprocs/LOGMSG "  RestartIncGeany $P1 $P2 complete."
printf "%s\n" "  RestartIncGeany $P1 $P2 complete."
# end RestartIncGeany
