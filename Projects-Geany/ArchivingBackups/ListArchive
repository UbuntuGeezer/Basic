#!/bin/bash
# ListArchive.sh - List flash drive archive files.
#	2/28/24.	wmk.
#
# Usage. bash  ListArchive.sh <mountname> [index] [<src_sysid>]
#
#	<mountname> = flashdrive mount name ($U_DISK)/ prefix assumed)
#	index	= (optional) A/B index where duplicate mount names are possible
#	<src-sysid> = (optional) archive source system ID;
#			  default = *SYSID
# Exit. ls of all folders/files on <mountname>
#			> *U_DISK/<mountname>/LibFL86777/<mountname><index>FullList
#			> /ArchivingBackups/<mountname><index>FullList
#
# Modification History.
# ---------------------
# 12/9/23.	wmk.	original shell; adapted from Accounting.
# 12/9/23.	wmk.	(automated) echo,s to printf,s throughout.
# 12/9/23.	wmk.	(automated) Version 3.0.6 Make old paths removed.
# 2/28/24.	wmk.	bug fix, D_SYSID not set correctly to P3; date/time stamps
#			 added to list.
# Legacy mods.
# 10/26/23.	wmk.	Tutoring path updates (HP2).
# Legacy mods.
# 10/26/23.	wmk.	Tutoring path updates (Lenovo).
# 10/26/23.	wmk.	*SYSID support enforced.
# Legacy mods.
# 5/5/22.	wmk.	original code.
# 6/24/23.	wmk.	updated for Libraries-Project/FLsara86777.
#
# P1=<mount-name>, [P2=<index>|" ", [P3=<src_sysid>]
P1=$1
P2=$2
P3=${3^^}
if [ -z "$P1" ];then
 printf "%s\n" "ListArchive <mountname> [index] [<src-sysid>] missing parameter(s) - abandoned."
 read -p "Enter ctrl-c to remain in Terminal: "
 exit 1
fi
if [[ "$P2" =~ ^\ * ]];then
 P2=
fi
if [ -z "$P3" ];then
 D_SYSID=$SYSID
else
 D_SYSID=$P3
fi
if ! test -d $U_DISK/$P1;then
 printf "%s\n" "Flash drive $P1 not mounted..."
 read -p "Mount then enter 'Y' to continue: "
 yn=${REPLY^^}
 if [ "$yn" != "Y" ];then
  printf "%s\n" "ListArchive abandoned at user request."
  exit 0
 fi
 if ! test -d $U_DISK/$P1;then
  printf "%s\n" "  $P1 still not mounted - ListArchive exiting."
  read -p "Enter ctrl-c to remain in Terminal: "
  exit 1
 fi
 printf "%s\n" " continuing with $P1 mounted..."
else 
 printf "%s\n" " continuing with $P1 mounted..."
fi
if [ "$P1" == "Lexar" ];then
 read -p "Lexar name not unique - specify which one (A/B): "
 abspec=${REPLY^^}
 if [ "$abspec" != "A" ] && [ "$abspec" != "B" ];then
   printf "%s\n" "** WARNING Lexar $abspec not a known drive... **"
 fi
 P2=$abspec
fi
listname0=$P1$P2
fulllist=FullList
listname=$listname0$fulllist
# do it twice to pick up the full list file in the list..
#ls -R $U_DISK/$P1/$D_SYSID/Tutoring/*.tar > $pathbase/Projects-Geany/ArchivingBackups/$listname
ls -lh -R $U_DISK/$P1/$D_SYSID/Tutoring/*.tar > $TEMP_PATH/$listname
mawk '{print $6 " " $7 " " $8}' $TEMP_PATH/$listname > $pathbase/Projects-Geany/ArchivingBackups/$listname
cp -p $pathbase/Projects-Geany/ArchivingBackups/$listname $U_DISK/$P1/$D_SYSID/Tutoring
#ls -R $U_DISK/$P1/$D_SYSID/Tutoring/*.tar > $pathbase/Projects-Geany/ArchivingBackups/$listname
ls -lh -R $U_DISK/$P1/$D_SYSID/Tutoring/*.tar > $TEMP_PATH/$listname
mawk '{print $6 " " $7 " " $8}' $TEMP_PATH/$listname > $pathbase/Projects-Geany/ArchivingBackups/$listname
cp -pv $pathbase/Projects-Geany/ArchivingBackups/$listname $U_DISK/$P1/$D_SYSID/Tutoring
less $pathbase/Projects-Geany/ArchivingBackups/$listname
printf "%s\n" "$P1/$D_SYSID/Tutoring/$listname has archive list."
printf "%s\n" "ListArchive $P1 $P2 complete."
#end ListArchive
