#!/bin/bash
echo " ** IncDumpGeany.sh not supported with Tutoring subsystem. **";exit 1
# IncDumpGeany.sh  - Incremental archive of {Accounting}Geany subdirectories.
#	10/23/23.	wmk.
#
# Usage. bash   IncDumpGeany  -u <mount-name>
#
#	-u = dump to removable device
#	 <mount-name> = removable device mount name
#
# Dependencies. *SYSID = 3 char system id (HP2)
#	~/Accounting/Projects-Geany - base directory for Geany projects
#	~/Accounting/.log - tar log subfolder for tracking incremental
#	  dumps
#
# Exit Results.
#	/Accounting/Geany.n.tar - incremental dump of ./Projects-Geany folders
#	  where "n" is the incremental dump child level; if 0 is level-0 dump.
#	/Accounting/log/Geany.snar-n - snapshot "listed-incremental"
#	  supplementary information for targeting changed files for dump. This
#	  same file (usually n=0) is the "listed-incremental" file supplied for
#	  all incremental dumps based on this level-0 dump.
#	/Accounting/log/Geanylevel.txt - current level of incremental Geany 
#	  archive files.
#
# Modification History.
# ---------------------
# 10/17/23.	wmk.	ver2.0 path updates; *SYSID support.
# 10/23/23.	wmk.	bug fixes.
# Legacy mods.
# 10/13/22.	wmk.	Chromebooks support; jumpto references removed.
# 5/15/23.	wmk.	dump verification; verify complete message added.
# 7/23/23.	wmk.	parameters mandatory; bullet-proof popd.
# Legacy mods.
# 3/28/22.	wmk.	original shell; adapted from Territories.
# 8/18/22.	wmk.	updated with -u, <mount-name> support.
# 8/25/22.	wmk.	bug fix; logic detecting <mount-name> not mounted.
#
# Notes. IncDumpGeany.sh performs an incremental archive (tar) of the
# Projects-Geany subdirectories. If the folder ./log does not exist under
# Accounting, it is created and a level-0 incremental dump is performed.
# A shell utility RestartGeany.sh is provided to reset the Geany dump
# information so that the next IncDumpGeany run will produce the level-0
# (full) dump.
# The file ./log/Geany.snar is created as the listed-incremental archive
# information. The file ./log/level.txt is intialized with "0". This file
# will keep track of the incremental dump level by being advanced with
# subsequent IncDumpGeany calls. The initial archive file is named
# Geany.0.tar.
# If the ./log folder exists under Geany a level-1 incremental dump
# will be performed. The previous level listed-incremental file will be
# copied to the next level file named Geany.snar-n, where n is the
# next level # obtained by incrementing ./log/Geanylevel.txt. tar will be
# invoked with this new Geany.snar-n file as the "listed-incremental"
# parameter, flagging a level-1 tar archive. The archive file for a given
# level "n" is named archive.n.tar.
# function definition
P1=${1^^}		# -u
P2=$2			# mount name
if [ -z "$P1" ] || [ -z "$P2" ];then
 echo "IncDumpGeany -u <mount-name> missing parameter(s) - abandoned."
 read -p "Enter ctrl-c to remain in Terminal: "
 exit 1
fi
if [ -z "$folderbase" ];then
 if [ "$USER" = "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows
 else 
  export folderbase=$HOME
 fi
fi
 export pathbase=$folderbase/Accounting
 export codebase=$pathbase
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "   IncDumpGeany initiated from Make."
  echo "   IncDumpGeany initiated."
else
  ~/sysprocs/LOGMSG "   IncDumpGeany initiated from Terminal."
  echo "   IncDumpGeany initiated."
fi
TEMP_PATH=$HOME/temp
#
 if [ "$P1" != "-U" ];then
  echo "** IncDumpGeany  [-u <mount-name>] unrecognized option $P1 - abandoned. **"
  read -p "Enter ctrl-c to remain in Terminal: "
  exit 1
 fi
 if ! test -d $U_DISK/$P2;then
  echo "$P2 not mounted... Mount flash drive $P2"
  read -p "  Drive mounted and continue (y/n)? "
  yn=${REPLY^^}
  if [ "$yn" != "Y" ];then
   echo "IncDumpGeany abandoned at user request."
   exit 1
  else
   if ! test -d $U_DISK/$P2;then
    echo "$P2 still not mounted - IncDumpGeany abandoned."
    exit 1
   else
    echo "continuing with $P2 mounted..."
   fi
  fi
 else
    echo "continuing with $P2 mounted..."
 fi
echo "P1 = : '$P1'"
echo "P2 = : '$P2'"
echo "parameter tests complete."
#exit
#procbodyhere
pushd ./ > /dev/null
dump_path=$U_DISK/$P2/$SYSID/Accounting
if ! test -d $U_DISK/$P2/$SYSID/Accounting;then
 echo " ** 	missing $P2/Accounting on flashdrive - run RestartIncGeany.sh **"
 exit 1
fi
cd $pathbase
if ! test -d $dump_path/log;then
  echo " ** missing $P2/Accounting/log on flashdrve - run RestartIncGean.sh **"
  exit 1
fi
export dumpfile=Geany
export dumpname=$dumpfile
export level=level
export nextlevel=nextlevel
export newlevel=newlevel
# if $dump_path/log/Geany.snar-0 does not exist, initialize and perform level 0 tar.
if ! test -f $dump_path/log/$dumpname.snar-0;then
  # initial archive
  echo "0" > $dump_path/log/$dumpname$level.txt
  echo "1" > $dump_path/log/$dumpname$nextlevel.txt
  archname=$dumpname.0.tar
  echo $archname
  pushd ./ > /dev/null
  cd $folderbase/Accounting
  tar --create \
	  --listed-incremental=$dump_path/log/$dumpname.snar-0 \
	  --file=$dump_path/$archname \
	  Projects-Geany
  popd > /dev/null
  ~/sysprocs/LOGMSG "  IncDumpGeany complete."
  echo "  IncDumpGeany complete"
  read -p "Verify dump (y/n): "
  yn=${REPLY^^}
  if [ "$yn" == "Y" ];then
   tar --list --file $dump_path/$archname
   echo "  $archname Verify complete."
  fi
  read -p "Enter ctrl-c to remain in Terminal: "
  exit 0
fi
# this is a level-1 tar incremental.
 echo "Level-1 archive."
 file=$dump_path/log/$dumpname$nextlevel.txt
 oldsnar=$dumpname.snar-0
 awk '{$1++; print $0}' $dump_path/log/$dumpname$nextlevel.txt > $dump_path/log/$dumpname$newlevel.txt
 while read -e;do
  archname=$dumpname.$REPLY.tar
  echo $archname
  snarname=$oldsnar
  pushd ./ > /dev/null
  cd $folderbase/Accounting
  tar --create \
	--listed-incremental=$dump_path/log/$snarname \
	--file=$dump_path/$archname \
	Projects-Geany
  popd > /dev/null
done < $file
cp $dump_path/log/$dumpname$newlevel.txt   $dump_path/log/$dumpname$nextlevel.txt
#
if [ ! -z "${DIRSTACK[1]}" ];then popd > /dev/null;fi
#endprocbody
~/sysprocs/LOGMSG "  IncDumpGeany $P1 $P2 complete."
echo "  IncDumpGeany $P1 $P2 complete."
  read -p "Verify dump (y/n): "
  yn=${REPLY^^}
  if [ "$yn" == "Y" ];then
   tar --list --file $dump_path/$archname
   echo "  $archname Verify complete."
  fi
# end IncDumpGeany
