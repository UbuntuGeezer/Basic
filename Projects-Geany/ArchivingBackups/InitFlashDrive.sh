#!/bin/bash
# InitFlashDrive.sh - Initialize flash drive for archiving.
#	8/10/25.	wmk.
#
# Usage. bash  InitFlashDrive.sh -u <mount-name>
#
#	-u = initialize flash drive
#	<mount-name> = flash drive mount name
#
# Entry. 
#
# Dependencies.
#
# Modification History.
# ---------------------
# 12/10/23.	wmk.	original shell; adapted from Tutoring.
#
# P1=-u P2=<mount-name>
#
P1=${1,,}
P2=$2
if [ -z "$P1" ] || [ -z "$P2" ];then
 echo "InitFlashDrive -u <mount-name> missing parameter(s) - abandoned."
 read -p "Enter ctrl-c to remain in Terminal: "
 exit 1
fi
  ~/sysprocs/LOGMSG "  InitFlashDrive - initiated from Terminal"
  echo "  InitFlashDrive - initiated from Terminal"
 if [ "$P1" != "-u" ];then
  echo "InitFlashDrive <-u <mount-name> unrecognized option - abandoned."
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 1
 fi
 if ! test -d $U_DISK/$P2;then
  echo "$P2 not mounted... Mount flash drive $P2"
  read -p "  Drive mounted and continue (y/n)? "
  yn=${REPLY^^}
  if [ "$yn" != "Y" ];then
   echo "InitFlashDrive abandoned at user request."
   read -p "Enter ctrl-c to remain in Terminal:"
   exit 1
  else
   if ! test -d $U_DISK/$P2;then
    echo "$P2 still not mounted - InitFlashDrive abandoned."
    read -p "Enter ctrl-c to remain in Terminal:"
    exit 1
   else
    echo "continuing with $P2 mounted..."
   fi	# end still not mounted
  fi  #end user confirmed
 else
  echo "continuing with $P2 mounted..."
 fi  #end drive not mounted
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/sysprocs/SetToday.sh -v
fi
#procbodyhere
pushd ./ > /dev/null
cd $U_DISK/$P2/$SYSID
main_folder=Basic
if ! test -d $U_DISK/$P2/$SYSID/$main_folder;then
 mkdir $main_folder
fi
cd $U_DISK/$P2/$SYSID/$main_folder
if ! test -d log;then
 mkdir log
fi
popd > /dev/null
#endprocbody
echo "  InitFlashDrive $P1 $P2 complete."
~/sysprocs/LOGMSG "  InitFlashDrive $P1 $P2 complete."
# end InitFlashDrive.sh
