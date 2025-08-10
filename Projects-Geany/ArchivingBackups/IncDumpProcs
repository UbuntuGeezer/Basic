#!/bin/bash
echo " ** IncDumpProcs.sh not supported with Tutoring subsystem. **";exit 1
# 2023-12-09.	wmk.	(automated) Version 3.0.6 paths eliminated (HPPavilion).
# IncDumpProc.sh  - Incremental archive of {Tutoring}Procs-Dev subdirectories.
#	12/9/23.	wmk.
#
# Usage. bash   IncDumpProc  -u <mount-name>
#
#	-u = dump to removable device
#	 <mount-name> = removable device mount name
#
# Dependencies. *SYSID = 3 char system id (HP2)
#	~/Tutoring/Procs-Dev - base directory for Procs-Dev
#	~/Tutoring/.log - tar log subfolder for tracking incremental
#	  dumps
#
# Exit Results.
#	/Tutoring/Proc.n.tar - incremental dump of ./Projects-Proc folders
#	  where "n" is the incremental dump child level; if 0 is level-0 dump.
#	/Tutoring/log/Proc.snar-n - snapshot "listed-incremental"
#	  supplementary information for targeting changed files for dump. This
#	  same file (usually n=0) is the "listed-incremental" file supplied for
#	  all incremental dumps based on this level-0 dump.
#	/Tutoring/log/Proclevel.txt - current level of incremental Proc 
#	  archive files.
#
# Modification History.
# ---------------------
# 12/9/23.	wmk.	original shell; adapated from Accounting.
# 12/9/23.	wmk.	(automated) echo,s to printf,s throughout.
# 12/9/23.	wmk.	(automated) Version 3.0.6 Make old paths removed.
# Legacy mods.
# 10/17/23.	wmk.	original shell; adapted from IncDumpGeany.
# 10/17/23.	wmk.	comments localized for HP2.
# 10/27/23.	wmk.	bug fix *HOME/Tutoring > *folderbase/Tutoring; fix Proc
#			 to Procs in filenames.
# Legacy mods.
# 10/17/23.	wmk.	ver2.0 path updates; *SYSID support.
# Legacy mods.
# 10/13/22.	wmk.	Chromebooks support; jumpto references removed.
# 5/15/23.	wmk.	dump verification; verify complete message added.
# 7/23/23.	wmk.	parameters mandatory; bullet-proof popd.
# Legacy mods.
# 3/28/22.	wmk.	original shell; adapted from Territories.
# 8/18/22.	wmk.	updated with -u, <mount-name> support.
# 8/25/22.	wmk.	bug fix; logic detecting <mount-name> not mounted.
#
# Notes. IncDumpProc.sh performs an incremental archive (tar) of the
# Projects-Proc subdirectories. If the folder ./log does not exist under
# Tutoring, it is created and a level-0 incremental dump is performed.
# A shell utility RestartProc.sh is provided to reset the Proc dump
# information so that the next IncDumpProc run will produce the level-0
# (full) dump.
# The file ./log/Proc.snar is created as the listed-incremental archive
# information. The file ./log/level.txt is intialized with "0". This file
# will keep track of the incremental dump level by being advanced with
# subsequent IncDumpProc calls. The initial archive file is named
# Proc.0.tar.
# If the ./log folder exists under Proc a level-1 incremental dump
# will be performed. The previous level listed-incremental file will be
# copied to the next level file named Proc.snar-n, where n is the
# next level # obtained by incrementing ./log/Proclevel.txt. tar will be
# invoked with this new Proc.snar-n file as the "listed-incremental"
# parameter, flagging a level-1 tar archive. The archive file for a given
# level "n" is named archive.n.tar.
# function definition
P1=${1^^}		# -u
P2=$2			# mount name
if [ -z "$P1" ] || [ -z "$P2" ];then
 printf "%s\n" "IncDumpProc -u <mount-name> missing parameter(s) - abandoned."
 read -p "Enter ctrl-c to remain in Terminal: "
 exit 1
fi
  ~/sysprocs/LOGMSG "   IncDumpProcs initiated from Terminal."
  printf "%s\n" "   IncDumpProcs initiated."
#
 if [ "$P1" != "-U" ];then
  printf "%s\n" "** IncDumpProc  [-u <mount-name>] unrecognized option $P1 - abandoned. **"
  read -p "Enter ctrl-c to remain in Terminal: "
  exit 1
 fi
 if ! test -d $U_DISK/$P2;then
  printf "%s\n" "$P2 not mounted... Mount flash drive $P2"
  read -p "  Drive mounted and continue (y/n)? "
  yn=${REPLY^^}
  if [ "$yn" != "Y" ];then
   printf "%s\n" "IncDumpProcs abandoned at user request."
   exit 1
  else
   if ! test -d $U_DISK/$P2;then
    printf "%s\n" "$P2 still not mounted - IncDumpProcs abandoned."
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
#procbodyhere
pushd ./ > /dev/null
dump_path=$U_DISK/$P2/$SYSID/Tutoring
if ! test -d $U_DISK/$P2/$SYSID/Tutoring;then
 printf "%s\n" " ** 	missing $P2/Tutoring on flashdrive - run RestartIncProc.sh **"
 exit 1
fi
cd $dump_path
if ! test -d $dump_path/log;then
  printf "%s\n" " ** missing $P2/Tutoring/log on flashdrive - run RestartIncGean.sh **"
  exit 1
fi
export dumpfile=Procs
export dumpname=$dumpfile
export level=level
export nextlevel=nextlevel
export newlevel=newlevel
# if $dump_path/log/Proc.snar-0 does not exist, initialize and perform level 0 tar.
if ! test -f $dump_path/log/$dumpname.snar-0;then
  # initial archive
  printf "%s\n" "0" > $dump_path/log/$dumpname$level.txt
  printf "%s\n" "1" > $dump_path/log/$dumpname$nextlevel.txt
  archname=$dumpname.0.tar
  printf "%s\n" $archname
  pushd ./ > /dev/null
  cd $pathbase
  tar --create \
	  --listed-incremental=$dump_path/log/$dumpname.snar-0 \
	  --file=$dump_path/$archname \
	  Procs-Dev
  popd > /dev/null
  ~/sysprocs/LOGMSG "  IncDumpProc complete."
  printf "%s\n" "  IncDumpProc complete"
  read -p "Verify dump (y/n): "
  yn=${REPLY^^}
  if [ "$yn" == "Y" ];then
   tar --list --file $dump_path/$archname
   printf "%s\n" "  $archname Verify complete."
  fi
  read -p "Enter ctrl-c to remain in Terminal: "
  exit 0
fi
# this is a level-1 tar incremental.
 printf "%s\n" "Level-1 archive."
 file=$dump_path/log/$dumpname$nextlevel.txt
 oldsnar=$dumpname.snar-0
 awk '{$1++; print $0}' $dump_path/log/$dumpname$nextlevel.txt > $dump_path/log/$dumpname$newlevel.txt
 while read -e;do
  archname=$dumpname.$REPLY.tar
  printf "%s\n" $archname
  snarname=$oldsnar
  pushd ./ > /dev/null
  cd $pathbase
  tar --create \
	--listed-incremental=$dump_path/log/$snarname \
	--file=$dump_path/$archname \
	Procs-Dev
  popd > /dev/null
done < $file
cp $dump_path/log/$dumpname$newlevel.txt   $dump_path/log/$dumpname$nextlevel.txt
#
if [ ! -z "${DIRSTACK[1]}" ];then popd > /dev/null;fi
#endprocbody
~/sysprocs/LOGMSG "  IncDumpProc $P1 $P2 complete."
printf "%s\n" "  IncDumpProc $P1 $P2 complete."
  read -p "Verify dump (y/n): "
  yn=${REPLY^^}
  if [ "$yn" == "Y" ];then
   tar --list --file $dump_path/$archname
   printf "%s\n" "  $archname Verify complete."
  fi
# end IncDumpProc
