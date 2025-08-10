#!/bin/bash
# ListArchiveFiles.sh - List contents of .tar archive.
# 3/1/24.	wmk.
#
# Usage. bash  ListArchiveFiles.sh <short-name> -u <mount-name> [src-sysid]
#
#	<short-name> = archive short name (e.g. Geany.0)
#	-u = .tar resident on removable device
#	<mount-name> = removable device mount name (e.g. Sandisk5)
#	<src-sysid> = (optional) dump source system id
#
# Entry. 
#
# Dependencies.
#
# Modification History.
# ---------------------
# 3/1/24.	wmk.	original; adapted from Navigation.
# Legacy mods.
# 9/8/23.	wmk.	original shell.
# 9/11/23.	wmk.	TODAY setting code updated with *codebase path.
# 2/29/24.	wmk.	name change to ListArchiveFiles.
# Notes. 
#
# P1=<short-name>, P2=-u, P3=<mount-name>, [P4=<sysid>]
#
P1=$1
shortname=$P1
P2=${2,,}
P3=$3
P4=${4^^}
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ];then
 echo "ListArchiveFiles <short-name> -u <mount-name> [<congterr>] missing parameter(s) - abandoned."
 read -p "Enter ctrl-c to remain in Terminal: "
 exit 1
fi
if [ "$P2" != "-u" ];then
 echo "ListArchiveFiles <monthname> <day> [-u <mount-name>] [<congterr>] bad option $2 - abandoned."
 read -p "Enter ctrl-c to remain in Terminal: "
 exit 1
fi
if ! test -d $U_DISK/$P3;then
   echo "** $P3 not mounted - mount $P3..."
   read -p "  then press {enter} or 'q' to quit: "
   yq=${REPLY^^}
   if [ "$yq" == "Q" ];then
    echo "  ListArchiveFiles abandoned, drive not mounted."
    exit 0
   fi
   if ! test -d $U_DISK/$P3;then
    echo "** $P4 still not mounted - ListArchiveFiles abandoned."
    read -p "Enter ctrl-c to remain in Terminal: "
    exit 0
   fi
   echo "continuing with $P3 mounted..."
else
 echo "continuing with $P3 mounted..."
fi
  ~/sysprocs/LOGMSG "  ListArchiveFiles - initiated from Terminal"
  echo "  ListArchive - initiated from Terminal"
#	Environment vars:
if [ -z "$TODAY" ];then
 . $codebase/Procs-Dev/SetToday.sh -v
fi
P1=$shortname
#procbodyhere
if [ ! -z "$P4" ];then	# have specified [sysid]
 D_SYSID=$P4
else
 D_SYSID=$SYSID
fi
dump_path=$U_DISK/$P3/$SYSID/Tutoring
archname=$congterr$P1
if [ ! -z "$P4" ];then
 cd $P4
fi
tar --list --file $dump_path/$archname
#endprocbody
echo "  ListArchiveFiles $P1 $P2 $P3 $P4 complete."
~/sysprocs/LOGMSG "  ListArchiveFiles $P1 $P2 $P3 $P4 complete."
# end ListArchive.sh
