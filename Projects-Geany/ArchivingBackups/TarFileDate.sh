#!/bin/bash
# TarFileDate.sh - List file modified date from tar archive.
#	8/10/25.	wmk.
#
# Usage. bash  TarFileDate.sh <tarchive> <filespec> <mount-name>
#
#	<tarchive> = tar archive name (e.g. *congterr/tarfile)
#	<filespec> = filespec to list dates for
#	<mount-name> = optional USB drive mount name
#	<src-sysid> = (optional) *SYSID of dump source
#
# Modification History.
# ---------------------
# 8/10/25.	wmk.	original shell; adapted from Tutoring.
#tar -x -f /mnt/chromeos/removable/Lexar/FLSARA86777/CBTerr111.0.tar --to-command='date -d @$TAR_MTIME > #tdate; printf "%s\n" "$TAR_FILENAME" > tfile; cat tfile  tdate'  -- TerrData/Terr111/Terr111_PubTerr.pdf
#
# P1=<tarchive>, P2=<filespec>, P3=<mount-name>, [P4=<src-sysid>]
#
P1=$1
P2=$2
P3=$3
P4=${4^^}
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ];then
 printf "%s\n" "TarFileDate <tarchive> <filespec> <mount-name> missing parameter(s) - abandoned."
 read -p "Enter ctrl-c to remain in Terminal:"
 exit 1
fi
D_SYSID=$SYSID
if [ ! -z "$P4" ];then
 D_SYSID=$P4
fi
dump_path=$U_DISK/$P3/$D_SYSID/Basic
tar -x -f $dump_path/$P1 --to-command='date -d @$TAR_MTIME > tdate; printf "%s\n" "$TAR_FILENAME  " > tfile;cat tfile  tdate'  -- $P2 > templist.txt
sed -i '1{N;s/\n//;}' templist.txt
cat templist.txt
# end TarFileDate.sh
