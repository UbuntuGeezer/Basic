#!/bin/bash
echo " ** ReloadGeany.sh not supported with Tutoring subsystem. **";exit 1
# ReloadGeany.sh  - Reload file(s) from archive of Geany subdirectories.
# 10/23/23.	wmk.
#
# Usage. bash   ReloadGeany <filespec>  -u|-ou|-uo  <mount-name> [<src-sysid>]
#
#	<filespec> = file to reload or pattern to reload
#	-o = (optional) overwrite existing file(s) when reloading
#	-u = reload from unloadable device (flashdrive)
#	mount-name = mount name for flashdrive
#	<src_sysid> = (optional) system ID of dump source 
#
# Note: The Accounting subfolder on the *mount-name* drive is where
# Geany.*.tar exists to reload from.
#
# Dependencies.
#	*pathbase* - base directory in which all reloads will be placed.
#	*pathbase* or *U_DISK/*P3
#		/*congterr*/.log - tar log subfolder of incremental dump tracking
#
# Exit Results.
#	/Accounting/Geany.n.tar - incremental dump of ./Geany folders
#	  where "n" is the incremental dump child level; if 0 is level-0 dump.
#	/Accounting/Geany/log/Geany.snar-n - snapshot "listed-incremental"
#	  supplementary information for targeting changed files for dump. This
#	  same file (usually n=0) is the "listed-incremental" file supplied for
#	  all incremental dumps based on this level-0 dump.
#	/Accounting/log/Geanylevel.txt - current level of incremental Geany 
#	  archive files.
#
# Modification History.
# ---------------------
# 10/17/23.	wmk.	ver2.0 path updates; *SYSID support.
# 10/23/23.	wmk.	<filelist> to <filespec> in comments; <src-sysid> support.
# Legacy mods.
# 10/13/22.	wmk.	modified for Chromebook support; jumpto references removed.
# 7/24/23.	wmk.	parameters mandatory; bullet-proof popd.
# Legacy mods.
# 7/31/22.	wmk.	original code; adapted from FL/SARA/86777 code.
# 8/18/22.	wmk.	-u, <mount-name> support.
#
# Notes. 7/31/22. '!' is now supported as the <filespec> parameter since bash interprets
#  '*' by expanding the current folder file list. The environment var *isAll is set to
#  1 if '!' is encountered as the <filespec>.
#
# ReloadGeany.sh performs a *tar* reload of the
# Geany subdirectory file(s). If the folder *pathbase*/*congterr*/log does
# not exist under
# Geany, it is considered an unrecoverable error, since the current
# archive level cannot be detemined.
# The file ./log/Geany.snar is created as the listed-incremental archive
# information. The file *pathbase*/*congterr*/log/nextlevel.txt contains
# the next archive level. If this is '0', then no retrieval is possible.
# Otherwise, $(nextlevel)-1 is assumed to be the latest dump level.
# All .level.tar files will have the filespec reloaded, starting with
# level = 0 through $(nextlevel)-1. 
#
# P1=<filespec>| !, P2=-[o]u, P3=<mount-name>, [P4=<src-sysid>]
P1=$1
P2=${2,,}
P3=$3
P4=${4^^}
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ];then
 echo "ReloadGeany <filespec>|!  -u|-ou|-uo <mountname> [<src-sysid>] missing parameter(s) - abandoned."
 read -p "Enter ctrl-c to remain in Terminal: "
 exit 1
fi
isAll=0
if [ "$P1" == "!" ];then
 isAll=1
fi
if  [ ! -z "$P2" ] && $([ "${P2:1:1}" == "u" ] || [ "${P2:2:1}" == "u" ]) && [ -z "$P3" ];then
  echo "ReloadGeany <filespec> -u <mountname> missing parameter(s) - abandoned."
  echo "P1 = : $P1"	# filespec
  echo "P2 = : $P2"	# -u
  echo "P3 = : $P3"	# <mount-name>
 read -p "Enter ctrl-c to remain in Terminal: "
  exit 1
fi
if [ "$P2" != "-u" ] && [ "$P2" != "-ou" ] && [ "$P2" != "-uo" ]&& [ "$P2" != "-o" ];then
  echo "ReloadGeany <filespec> -u <mountname>  unrecognized '-' option - abandoned."
fi
if ! test -d $U_DISK/$P3;then
   echo "** $P3 not mounted - mount $P3..."
   read -p "  then press {enter} or 'q' to quit: "
   yq=${REPLY^^}
   if [ "$yq" == "Q" ];then
    echo "  ReloadGeany abandoned, drive not mounted."
    sysprocs/LOGMSG "  ReloadGeany abandoned, drive not mounted."
    read -p "Enter ctrl-c to remain in Terminal: "
    exit 0
   fi
   if ! test -d $U_DISK/$P3;then
    echo "  ReloadGeany abandoned, drive $P3 still not mounted."
   else
    echo "  continuing with $P3 mounted..."
   fi
else
 echo "  continuing with $P3 mounted..."
fi
# D_SYSID is the dump source SYSID.
if [ -z "$P4" ];then
 D_SYSID=$SYSID
else
 D_SYSID=$P4
fi
echo "  ReloadGeany proceeding for SYSID = '$SYSID'"
if [ -z "$P1" ];then
 echo "ReloadGeany <filespec> -u|-ou|-uo <mountname> [<src-sysid>] missing parameter(s) - abandoned."
 exit 1
fi
if [ "${P2:1:1}" == "o" ] || [ "${P2:2:1}" == "o" ] ;then
 writeover=--overwrite
else
 writeover=--keep-newer-files
fi

if [ -z "$folderbase" ];then
 if [ "$USER" = "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows
 else 
  export folderbase=$HOME
 fi
fi
if [ -z "$P4" ];then
 D_SYSID=$SYSID
else
 D_SYSID=$P4
fi
#
 pathbase=$folderbase/Accounting
# debugging code...
#echo "P1 = : $P1"
#echo "P2 = : $P2"
#echo "P3 = : $P3"
#echo "isAll = $isAll"
#echo "ReloadGeany parameter tests complete"
#exit 0
# end debugging code.
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  export system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "   ReloadGeany $P1 $P2 $P3 $P4 initiated from Make."
  echo "   ReloadGeany initiated."
else
  ~/sysprocs/LOGMSG "   ReloadGeany $P1 $P2 $P3 $P4 initiated from Terminal."
  echo "   ReloadGeany initiated."
fi
TEMP_PATH=$HOME/temp
#
#procbodyhere
if [ "$D_SYSID" != "$SYSID" ];then
 echo "  **WARNING - you are about to reload files from a different system"
 read -p "   onto this system - OK to proceed (y/n)? "
 yn=${REPLY^^}
 if [ "$yn" != "Y" ];then
  ~/sysprocs/LOGMSG "   ReloadGeany - user cancelled due to source/target system conflict."
  echo "ReloadGeany - user cancelled due to source/target system conflict."
  exit 1
 fi
fi
pushd ./ > /dev/null
dump_path=$U_DISK/$P3/$D_SYSID/Accounting
cd $dump_path
#cd $pathbase
geany=Geany
level=level
nextlevel=nextlevel
newlevel=newlevel
# check for .snar file.
if ! test -f $dump_path/log/$geany.snar-0;then
  echo "** cannot locate .snar file.. abandoned."
 read -p "Enter ctrl-c to remain in Terminal: "
  exit 1
fi
if ! test -f $dump_path/log/$geany.snar-0;then
  echo "** cannot locate .snar file.. abandoned."
  read -p "Enter ctrl-c to remain in Terminal: "
  exit 1
fi
# cat $dump_path/log/$geany$nextlevel.txt
awk '{$1--; print $0}' $dump_path/log/$geany$nextlevel.txt > $TEMP_PATH/LastTarLevel.txt
file=$TEMP_PATH/LastTarLevel.txt
while read -e;do
#  echo "Last *tar* level = : $REPLY"
  lastlevel=$REPLY
done < $file
seq 0 $lastlevel > $TEMP_PATH/TarLevelList.txt
# seq 0 $lastlevel
file=$TEMP_PATH/TarLevelList.txt
echo "Reloading from $geany.*.tar incremental dumps..."
while read -e;do
   echo " Processing $geany.$REPLY.tar."
   if [ $isAll -eq 0 ];then
    pushd ./ > /dev/null
    cd $folderbase/Accounting
    tar --extract \
     --file=$dump_path/$geany.$REPLY.tar \
     --wildcards    \
     $writeover --\
    -- Projects-Geany/$P1
    popd > /dev/null
   else
    pushd ./ > /dev/null
    cd $folderbase/Accounting
    tar --extract \
     --file=$dump_path/$geany.$REPLY.tar \
     --wildcards    \
     $writeover --\
    -- Projects-Geany
    popd > /dev/null
   fi
done < $file
read -p "Enter ctrl-c to remain in Terminal: "
exit 0
# end ReloadGeany.sh
