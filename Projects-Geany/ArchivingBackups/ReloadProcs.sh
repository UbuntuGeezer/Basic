#!/bin/bash
echo " ** ReloadProcs.sh not supported with Tutoring subsystem. **";exit 1
# 2023-12-09.	wmk.	(automated) Version 3.0.6 paths eliminated (HPPavilion).
# ReloadProc.sh  - Reload file(s) from archive of Procs-Dev subdirectories.
# 12/9/23.	wmk.
#
# Usage. bash   ReloadProcs <filelist> -ou|-u mountname [<src-sysid>]
#					[--tar-num] <tn>
#
#	<filespec> = file to reload or pattern to reload
#	-o = (optional) overwrite existing file(s) when reloading
#	-u = reload from unloadable device (flashdrive)
#	mount-name (optional) = mount name for flashdrive
#	<src-syid> = (optional) source system ID when reloading from a different
#	  computer (e.g. CB1 ); default this *SYSID
#	--tar-num = use specific .tar number exclusively
#	<tn> = .tar number for --tar-num
#
# Note: <src-sysid> is part of the dump_path from which the archive will be
# taken for the source of files to reload.
#
# Dependencies.
#	*pathbase* - base directory in which all reloads will be placed.
#	*pathbase* or *U_DISK/*P3/*SYSID
#		/*congterr*/.log - tar log subfolder of incremental dump tracking
#
# Exit Results.
#	/Tutoring/Proc.n.tar - incremental dump of ./Procs-Dev folders
#	  where "n" is the incremental dump child level; if 0 is level-0 dump.
#	/Tutoring/Proc/log/Proc.snar-n - snapshot "listed-incremental"
#	  supplementary information for targeting changed files for dump. This
#	  same file (usually n=0) is the "listed-incremental" file supplied for
#	  all incremental dumps based on this level-0 dump.
#	/Tutoring/log/Proclevel.txt - current level of incremental Proc 
#	  archive files.
#
# Modification History.
# ---------------------
# 12/9/23.	wmk.	original shell; adapted from Territories.
# 12/9/23.	wmk.	(automated) echo,s to printf,s throughout.
# 12/9/23.	wmk.	(automated) Version 3.0.6 Make old paths removed.
# 12/9/23.	wmk.	<src_sysid>, --tar-num n support.
# Legacy mods.
# 10/17/23.	wmk.	original shell; adapted from ReloadGeany.
# Legacy mods.
# 10/17/23.	wmk.	ver2.0 path updates; *SYSID support.
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
# ReloadProc.sh performs a *tar* reload of the
# Proc subdirectory file(s). If the folder *pathbase*/*congterr*/log does
# not exist under
# Proc, it is considered an unrecoverable error, since the current
# archive level cannot be detemined.
# The file ./log/Proc.snar is created as the listed-incremental archive
# information. The file *pathbase*/*congterr*/log/nextlevel.txt contains
# the next archive level. If this is '0', then no retrieval is possible.
# Otherwise, $(nextlevel)-1 is assumed to be the latest dump level.
# All .level.tar files will have the filespec reloaded, starting with
# level = 0 through $(nextlevel)-1. 
#
# P1=<filespec>| !, P2=-[o]u, P3=<mount-name>
# P1=<filespec>, P2=u|o|uo, [P3=<mount-name>, [P4=<src-sysid>]
#   [P5=--tar-num, P6=n]
P1=$1
P2=${2,,}
P3=$3
P4=${4^^}
P5=${5,,}
P6=$6
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ];then
 printf "%s\n" "ReloadProcs <filespec> -u|-ou|-uo <mountname> [<src-sysid> --tar-num tn] missing parameter(s) - abandoned."
 read -p "Enter ctrl-c to remain in Terminal: "
 exit 1
fi
isAll=0
if [ "$P1" == "!" ];then
 isAll=1
fi
if  [ ! -z "$P2" ] && $([ "${P2:1:1}" == "u" ] || [ "${P2:2:1}" == "u" ]) && [ -z "$P3" ];then
  printf "%s\n" "ReloadProcs <filespec> -u <mountname> [<src-sysid> --tar-num tn] unrecognized '--' option - abandoned."
  printf "%s\n" "P1 = : $P1"	# filespec
  printf "%s\n" "P2 = : $P2"	# -u
  printf "%s\n" "P3 = : $P3"	# <mount-name>
 read -p "Enter ctrl-c to remain in Terminal: "
  exit 1
fi
if [ "$P2" != "-u" ] && [ "$P2" != "-ou" ] && [ "$P2" != "-uo" ]&& [ "$P2" != "-o" ];then
  printf "%s\n" "ReloadProc <filespec> -u <mountname>  unrecognized '-' option - abandoned."
fi
# now check extended options before drive mount.
dbsonly=0
tarnum=-1
if [ ! -z "$P5" ];then
 if [ "$P5" == "--tar-num" ];then
  tarnum=$P6
 else
  printf "%s\n" "ReloadProcs <filespec> -u <mountname> [<src-sysid> --tar-num tn] unrecognized '--' option - abandoned."
  read -p "Enter ctrl-c to remain in Terminal:"
  exit 1
 fi	# is --tar-num
fi	# end P5 specified
# now check drive mount and overwrite options.
if ! test -d $U_DISK/$P3;then
   printf "%s\n" "** $P3 not mounted - mount $P3..."
   read -p "  then press {enter} or 'q' to quit: "
   yq=${REPLY^^}
   if [ "$yq" == "Q" ];then
    printf "%s\n" "  ReloadProcs abandoned, drive not mounted."
    sysprocs/LOGMSG "  ReloadProcs abandoned, drive not mounted."
    read -p "Enter ctrl-c to remain in Terminal: "
    exit 0
   fi
   if ! test -d $U_DISK/$P3;then
    printf "%s\n" "  ReloadProcs abandoned, drive $P3 still not mounted."
   else
    printf "%s\n" "  continuing with $P3 mounted..."
   fi
else
 printf "%s\n" "  continuing with $P3 mounted..."
fi

if [ "${P2:1:1}" == "o" ] || [ "${P2:2:1}" == "o" ] ;then
 writeover=--overwrite
else
 writeover=--keep-newer-files
fi
# debugging code...
#printf "%s\n" "P1 = : $P1"
#printf "%s\n" "P2 = : $P2"
#printf "%s\n" "P3 = : $P3"
#printf "%s\n" "isAll = $isAll"
#printf "%s\n" "ReloadProcs parameter tests complete"
#exit 0
# end debugging code.
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  export system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "   ReloadProc $P1 $P2 $P3 $P4 initiated from Make."
  printf "%s\n" "   ReloadProc initiated."
else
  ~/sysprocs/LOGMSG "   ReloadProc $P1 $P2 $P3 $P4 initiated from Terminal."
  printf "%s\n" "   ReloadProc initiated."
fi
TEMP_PATH=$HOME/temp
#
#procbodyhere
pushd ./ > /dev/null
dump_path=$U_DISK/$P3/$SYSID/Tutoring
cd $dump_path
#cd $pathbase
proc=Procs
level=level
nextlevel=nextlevel
newlevel=newlevel
# check for .snar file.
if ! test -f $dump_path/log/$proc.snar-0;then
  printf "%s\n" "** cannot locate .snar file.. abandoned."
 read -p "Enter ctrl-c to remain in Terminal: "
  exit 1
fi
if ! test -f $dump_path/log/$proc.snar-0;then
  printf "%s\n" "** cannot locate .snar file.. abandoned."
  read -p "Enter ctrl-c to remain in Terminal: "
  exit 1
fi
#------------tar-num not specfied-----------------------
# 12/9/23.	wmk.	(automated) echo,s to printf,s throughout
if [ $tarnum -lt 0 ];then
# cat $dump_path/log/$proc$nextlevel.txt
awk '{$1--; print $0}' $dump_path/log/$proc$nextlevel.txt > $TEMP_PATH/LastTarLevel.txt
file=$TEMP_PATH/LastTarLevel.txt
while read -e;do
#  printf "%s\n" "Last *tar* level = : $REPLY"
  lastlevel=$REPLY
done < $file
seq 0 $lastlevel > $TEMP_PATH/TarLevelList.txt
# seq 0 $lastlevel
file=$TEMP_PATH/TarLevelList.txt
printf "%s\n" "Reloading from $proc.*.tar incremental dumps..."
while read -e;do
   printf "%s\n" " Processing $proc.$REPLY.tar."
   if [ $isAll -eq 0 ];then
    pushd ./ > /dev/null
    cd $pathbase
    tar --extract \
     --file=$dump_path/$proc.$REPLY.tar \
     --wildcards    \
     $writeover --\
     Procs-Dev/$P1
    popd > /dev/null
   else
    pushd ./ > /dev/null
    cd $HOME/Tutoring
    tar --extract \
     --file=$dump_path/$proc.$REPLY.tar \
     --wildcards    \
     $writeover --\
     Procs-Dev
    popd > /dev/null
   fi
done < $file
#----------------tar-num specified-------------------
# 12/9/23.	wmk.	(automated) echo,s to printf,s throughout
else # tar num specified
 #printf "%s\n" "tar-num specified code stubbed.."
 cd $pathbase
 if [ $isAll -eq 0 ];then
   printf "%s\n" "extracting from $dump_path/$proc.$tarnum.tar.."
     tar --extract \
      --file=$dump_path/$proc.$tarnum.tar \
      --wildcards  \
      $writeover \
     Procs-Dev/$P1
 else		# full reload
   printf "%s\n" "extracting from $dump_path/$proc.$tarnum.tar.."
     tar --extract \
      --file=$dump_path/$proc.$tarnum.tar \
      --wildcards  \
      $writeover \
      Procs-Dev
 fi	# full reload (!)
fi # tar-num not specified
read -p "Enter ctrl-c to remain in Terminal: "
exit 0
# end ReloadProc.sh
