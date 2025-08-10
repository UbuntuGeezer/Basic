#!/bin/bash
# IncDumpBasic.sh  - Incremental archive of Basic folders.
#	8/10/25.	wmk.
#
# Usage. bash   IncDumpBasic.sh -u <mount-name>
#
#	-u - dump to removable (USB) device
#	<mount-name> = mount name of flash drive
#
# Dependencies.
#	*SYSID - 3 char system ID
#	~/Basic/ - base directory main Basic files.
#	~/Basic/.log - tar log subfolder for tracking incremental
#	  dumps
#
# Exit Results.
#	*dump_path/Basic/Basic.n.tar - incremental dump of ./DB-Dev databases
#	  where "n" is the incremental dump child level; if 0 is level-0 dump.
#	*dump_path/Basic/RawData/log/Basic.snar-n - snapshot "listed-incremental"
#	  supplementary information for targeting changed files for dump. This
#	  same file (usually n=0) is the "listed-incremental" file supplied for
#	  all incremental dumps based on this level-0 dump.
#
# Modification History.
# ---------------------
# 8/10/25.	wmk.	original shell; adapted from Basic.
#
# Notes. IncDumpBasic.sh performs an incremental archive (tar) of the
# Basic project folders. If the file ./log/Basic.snar-0 does not exist
# under the Basic folder, it is created and a level-0 incremental
# dump is performed. A shell utility RestartIncBasic.sh is provided to
# reset the Basic dump information so that the next IncDumpBasic
# run will produce the level-0 (full) dump.
# The file ./log/Basic.snar is created as the listed-incremental archive
# information. The file ./log/Basiclevel.txt is intialized with "0". This file
# will keep track of the incremental dump level by being advanced with
# subsequent IncDumpBasic calls. The initial archive file is named
# Basic.0.tar.
# If the ./log folder exists under /Basic a level-1 incremental dump
# will be performed. The previous level listed-incremental file will be
# copied to the next level file named Basic.snar-n, where n is the
# next level # obtained by incrementing ./log/level.txt. tar will be
# invoked with this new RawDataRU.snar-n file as the "listed-incremental"
# parameter, flagging a level-1 tar archive. The archive file for a given
# level "n" is named Basic.n.tar.
#
# P1=-u, P2=<mount-name>
P1=${1,,}
P2=$2
if [ "$P1" != "-u" ];then
  printf "%s\n" "IncDumpBasic -u <mount-name> unrecognized option $P1 - abandoned."
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 1
fi
if ! test -d $U_DISK/$P2;then
  printf "%s\n" "$P2 not mounted... Mount flash drive $P2"
  read -p "  Drive mounted and continue (y/n)? "
  yn=${REPLY^^}
  if [ "$yn" != "Y" ];then
   printf "%s\n" "IncDumpBasic abandoned at user request."
   read -p "Enter ctrl-c to remain in Terminal:"
   exit 1
  else
   if ! test -d $U_DISK/$P2;then
    printf "%s\n" "$P2 still not mounted - IncDumpBasic abandoned."
    read -p "Enter ctrl-c to remain in Terminal:"
    exit 1
   else
    printf "%s\n" "continuing with $P2 mounted..."
   fi	# end still not mounted
  fi  #end user confirmed
else
 printf "%s\n" "continuing with $P2 mounted..."
fi  #end drive not mounted
#procbodyhere
pushd ./ > /dev/null
cd $pathbase
dump_path=$U_DISK/$P2/$SYSID/Basic
if ! test -d $dump_path;then
 printf "%s\n" " ** IncDumpBasic - $P2/$SYSID not found - exiting **"
 exit 1
fi
tutor=Basic
export dumpfile=Basic
export dumpname=$dumpfile
export level=level
export nextlevel=nextlevel
export newlevel=newlevel
# if ./log does not exist, initialize and perform level 0 tar.
if ! test -f $dump_path/log/$dumpname.snar-0;then
  printf "%s\n" "Initial archive."
  # initial archive
 if ! test -d $dump_path/log;then
  mkdir log
 fi
  printf "%s\n" "0" > $dump_path/log/$dumpname$level.txt
  printf "%s\n" "1" > $dump_path/log/$dumpname$nextlevel.txt
  archname=$dumpname.0.tar
  pushd ./ > /dev/null
  cd $folderbase
  printf "%s\n" "  $archname"
   tar --create \
      --wildcards \
	  --listed-incremental=$dump_path/log/$dumpname.snar-0 \
	  --file=$dump_path/$archname \
	  Basic
  popd > /dev/null
  ~/sysprocs/LOGMSG "  IncDumpBasic $P1 $P2 complete."
  printf "%s\n" "  IncDumpBasic $P1 $P2 complete."
  read -p "Verify dump (y/n): "
  yn=${REPLY^^}
  if [ "$yn" == "Y" ];then
   tar --list --file $dump_path/$archname
   printf "%s\n" " $archname verify complete."
  fi
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 0
fi
# this is a level-1 tar incremental.
 printf "%s\n" "Level-1 archive."
 file=$dump_path/log/$dumpname$nextlevel.txt
 oldsnar=$dumpname.snar-0
 awk '{$1++; print $0}' $dump_path/log/$dumpname$nextlevel.txt \
  > $dump_path/log/$dumpname$newlevel.txt
 while read -e;do
  archname=$dumpname.$REPLY.tar
  printf "%s\n" "  $archname"
  snarname=$oldsnar
  pushd ./ > /dev/null
  cd $folderbase
  tar --create \
    --wildcards \
	--listed-incremental=$dump_path/log/$dumpname.snar-0 \
	--file=$dump_path/$archname \
	-- Basic
  popd > /dev/null
done < $file
cp $dump_path/log/$dumpname$newlevel.txt $dump_path/log/$dumpname$nextlevel.txt
#
popd > /dev/null
#endprocbody
~/sysprocs/LOGMSG "  IncDumpBasic $P1 $P2 complete."
printf "%s\n" "  IncDumpBasic $P1  $P2 complete."
read -p "Verify dump (y/n): "
yn=${REPLY^^}
if [ "$yn" == "Y" ];then
   tar --list --file $dump_path/$archname
   printf "%s\n" " $archname verify complete."
fi
read -p "Enter ctrl-c to remain in Terminal:"
# end IncDumpBasic
