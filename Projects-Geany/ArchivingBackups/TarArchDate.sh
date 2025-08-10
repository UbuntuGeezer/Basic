#!/bin/bash
echo " ** TarArchDate.sh out-of-date **";exit 1
# TarArchDate.sh - List archive file modified date from tar archive.
#	10/26/23.	wmk.
#
# Usage. bash  TarArchDate.sh <tarchive>|"<tarch-regex" <mount-name> [src-sysid]
#
#	<tarchive> = tar archive name (e.g. tarfile)
#	| "<tarch-regex>" = archive name regex matching expression (e.g. Acctng2023.*.tar)
#	<mount-name> = USB drive mount name
#	src-sysid = (optional) dump file source system ID;
#		default this *SYSID
#
# Modification History.
# ---------------------
# 10/26/23.	wmk.	original shell; adapted from TarFileDate.
# 10/26/23.	wmk.	path updates for HPPavilion (HP2).
# Legacy mods.
# 10/19/23.	wmk.	Accounting path updates.
# 10/19/23.	wmk.	*SYSID support.
# 10/26/23.	wmk.	paths checked for CB1.
# Legacy mods.
# 11/22/22.	wmk.	mod to support system-resident .tar files.
# 11/24/22.	wmk.	missing paramter(s) handled with improved message.
# 6/24/23.	wmk.	always use flashdrive.
# Legacy mods.
# 10/12/22.	wmk.	original code.
# 10/13/22.	wmk.	parameter checking; join templist.txt lines.
# 10/30/22.	wmk.	bug fix forgot -i in *sed* joining lines.
# 11/14/22.	wmk.	optional <mount-name> parameter support; Lexar default.
#tar -x -f /mnt/chromeos/removable/Lexar/FLSARA86777/CBTerr111.0.tar --to-command='date -d @$TAR_MTIME > #tdate; echo "$TAR_FILENAME" > tfile; cat tfile  tdate'  -- TerrData/Terr111/Terr111_PubTerr.pdf
#
# P1=<tarchive>, P2=<mount-name>, [P3=<src-sysid>]
P1=$1
P2=$2
P3=${3^^}
if [ -z "$P1" ] || [ -z "$P2" ];then
 echo "TarArchDate <tarchive> <mount-name> [<src-sysid>] missing parameter(s) - abandoned."
 read -p "Enter ctrl-c to remain in Terminal:"
 exit 1
fi
if [ -z "$P3" ];then
 D_SYSID=$SYSID
else
 D_SYSID=$P3
fi
export folderbase=/media/ubuntu/Windows
export pathbase=$folderbase/Accounting
export codebase=$folderbase/Accounting
TEMP_PATH=$HOME/temp
dump_path=$U_DISK/$P2/$D_SYSID/Accounting
#tar -x -f $dump_path/$P1 \
# --to-command='date -d @$TAR_MTIME > tdate; echo "$TAR_FILENAME  " > tfile;cat tfile  tdate'  \
# -- $P2 > templist.txt
ls -lh $dump_path/$P1 > $TEMP_PATH/templist.txt
mawk '{print $6 " " $7 "  " $8}' $TEMP_PATH/templist.txt
#sed -i '1{N;s/\n//;}' $TEMP_PATH/templist.txt
#cat templist.txt
# end TarArchDate.sh
