#!/bin/bash
# RestartIncBasic.sh  - Set up for fresh incremental archiving of Basic.
# 	8/10/25.	wmk.
#
# Usage. bash   RestartIncBasic.sh -u <mount-name>
#
#	<year> = year to restart incremental dumps for
#	-u = dump to removable (USB) device
#	<mount-name> = mount name of flash drive
#
# Dependencies.
#	*SYSID = system ID of this system
#	~/Basic - base directory for Basic folders
#	~/Basic/.log - tar log subfolder for tracking incremental
#	  dumps
#
# Exit Results.
#	*SYSID/Basic/Basic.nnn.tar files all deleted after warning;
#	*SYSID/Basic/log/Basic.snar-0 deleted after warning;
#	/*SYSIDBasic/log/Basiclevel.txt deleted; this sets up next run of
#	 IncDumpBasic to start at level 0;
#
# Modification History.
# ---------------------
# 8/10/25.	wmk.	original shell; adapted from Tutoring.
#
# Notes. The entire incremental dump collection for Basic will be
# removed by this shell. The user will be given appropriate warnings
# before proceeding.
#
# P1=-u, P2=<mount-name>
P1=${1,,}
P2=$2
if [ -z "$P1" ] || [ -z "$P2" ];then
 printf "%s\n" "RestartIncBasic -u <mount-name> missing parameter(s) - abandoned."
 exit 1
fi
if [ "$P1" != "-u" ];then
  printf "%s\n" "RestartIncBasic -u <mount-name> unrecognized option - abandoned."
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 1
fi
if ! test -d $U_DISK/$P2;then
  printf "%s\n" "$P2 not mounted... Mount flash drive $P2"
  read -p "  Drive mounted and continue (y/n)? "
  yn=${REPLY^^}
  if [ "$yn" != "Y" ];then
   printf "%s\n" "RestartIncBasic abandoned at user request."
   read -p "Enter ctrl-c to remain in Terminal:"
   exit 1
  else
   if ! test -d $U_DISK/$P2;then
    printf "%s\n" "$P2 still not mounted - RestartIncBasic abandoned."
    read -p "Enter ctrl-c to remain in Terminal:"
    exit 1
   else
    printf "%s\n" "continuing with $P2 mounted..."
   fi	# end still not mounted
  fi  #end user confirmed
else
 printf "%s\n" "continuing with $P2 mounted..."
fi  #end drive not mounted
cd $pathbase
printf "%s\n" $PWD
printf "%s\n" " **WARNING - proceeding will remove all prior Basic incremental dump files!**"
read -p "OK to proceed (Y/N)? "
ynreply=${REPLY,,}
if [ "$ynreply" == "y" ];then
  printf "%s\n" "  Proceeding to remove prior incremental dump files..."
else
  ~/sysprocs/LOGMSG "  User halted RestartIncBasic."
  printf "%s\n" " Stopping RestartIncBasic - secure Basic incremental backups.."
  exit 0
fi
if [ -z "$SYSID" ];then
 printf "%s\n" "** RestartIncBasic - *SYSID not set - exiting **"
 exit 1
fi
#procbodyhere
pushd ./ > /dev/null
dump_path=$U_DISK/$P2/$SYSID/Basic
cd $U_DISK/$P2
if ! test -d $SYSID;then
 mkdir $SYSID
fi
cd $SYSID
if ! test -d Basic;then mkdir Basic;fi
cd $dump_path
if ! test -d log;then mkdir log;fi
tutor=Basic
dumpname=$tutor
level=level
nextlevel=nextlevel
if test -f ./log/$dumpname$level.txt;then
 rm ./log/$dumpname$level.txt
fi
printf "%s\n" "0" > $dump_path/log/$dumpname$nextlevel.txt
if test -f $dump_path/log/$dumpname.snar-0; then
# end RestartIncBasic
 rm $dump_path/log/$dumpname.snar-0
fi
if test -f $dumpname.0.tar; then
 rm $dumpname.*.tar
fi
popd > /dev/null
#endprocbody
~/sysprocs/LOGMSG "  RestartIncBasic $P1 $P2 complete."
printf "%s\n" "  RestartIncBasic $P1 $P2 complete."
# end RestartIncBasic
