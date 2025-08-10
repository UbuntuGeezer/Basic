#!/bin/bash
# ReloadBasic.sh  - Reload file(s) from archive of Basic subdirectory.
#	8/10/25.	wmk.
#
# Usage. bash   ReloadBasic <filespec> [-o] -u mountname [src_sysid]
#
#	<filespec> = file to reload or pattern to reload
#	-o = (optional) overwrite existing file(s) when reloading
#	-u = (optional) reload from unloadable device (flashdrive)
#	mountname (optional) = mount name for flashdrive
#	<src-sysid> = (optional) dump source system ID;
#				if '!' then reload from unqualified dump
#
# Dependencies.
#	*U_DISK/../*SYSID/Basic/ - base directory in which all reloads will be placed.
#	*SYSID/Basic/log - tar log subfolder of incremental dump tracking
#
# Exit Results.
#	/Basic*P2.n.tar - incremental dump of ./DB-Dev folder
#	  where "n" is the incremental dump child level; if 0 is level-0 dump.
#	/Basic/log/Basic*P2.snar-n - snapshot "listed-incremental"
#	  supplementary information for targeting changed files for dump. This
#	  same file (usually n=0) is the "listed-incremental" file supplied for
#	  all incremental dumps based on this level-0 dump.
#	/Basic/log/Basic*P2level.txt - current level of incremental DB-Dev
#	  archive files.
#
# Modification History.
# ---------------------
# 8/10/25.	wmk.	original shell; adapted from Tutoring.
#
# Notes. ReloadBasic.sh performs a *tar* reload of the
# DB-Dev subdirectory file(s). If the folder *pathbase*/*congterr*/log does
# not exist it is considered an unrecoverable error, since the current
# archive level cannot be detemined.
# The file ./log/Basic.snar is created as the listed-incremental archive
# information. The file *pathbase*/*congterr*/log/nextlevel.txt contains
# the next archive level. If this is '0', then no retrieval is possible.
# Otherwise, $(nextlevel)-1 is assumed to be the latest dump level.
# All .level.tar files will have the filespec reloaded, starting with
# level = 0 through $(nextlevel)-1.
#
# P1=<filespec>, P2=-u, P3=<mount-name>, [P4=<src-sysid>]
#
P1=$1
P2=${2,,}
P3=$3
P4=${4^^}
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ];then
 echo "ReloadBasic <filespec> -u|-ou|-uo <mountname> [<src-sysid>|!] missing parameter(s) - abandoned."
 exit 1
fi
if [ "$P1" == "!" ];then
 isAll=1
else
 isAll=0
fi
# if P2 is present, P3 must also.
# to specify P4, P2, P3 must be present, but may be empty strings.
if  [ ! -z "$P3" ] && $([ "${P3:1:1}" == "u" ] || [ "${P3:2:1}" == "u" ]) && [ -z "$P4" ];then
  echo "ReloadBasic <filespec> -u <mountname> [<src-sysid>] missing parameter(s) - abandoned."
  echo "P1 = : $P1"
  echo "P2 = : $P2"
  echo "P3 = : $P3"
  echo "P4 = : $P4"
  echo "P5 = : $P5"
  exit 1
fi
if [ "$P2" != "-u" ] && [ "$P2" != "-ou" ] && [ "$P2" != "-uo" ]&& [ "$P2" != "-o" ];then
  echo "ReloadBasic <filespec> -u <mountname> [<src-sysid>] unrecognized '-' option - abandoned."
fi
if [ "${P2:1:1}" == "u" ] || [ "${P2:2:1}" == "u" ] ;then
  if ! test -d $U_DISK/$P3;then
   echo "** $P3 not mounted - mount $P3..."
   read -p "  then press {enter} or 'q' to quit: "
   yq=${REPLY^^}
   if [ "$yq" == "Q" ];then
    echo "  ReloadBasic abandoned, drive not mounted."
    ~/sysprocs/LOGMSG "  ReloadBasic abandoned, drive not mounted."
    exit 0
   fi
  else
   echo "  continuing with $P3 mounted..."
  fi
fi
#
if [ "${P2:1:1}" == "o" ] || [ "${P2:2:1}" == "o" ] ;then
 writeover=--overwrite
else
 writeover=--keep-newer-files
fi
echo "P4 = : $P4"
if [ -z "$P5" ];then
 D_SYSID=$SYSID
elif [ "$P5" == "!" ];then
 D_SYSID=null
else
 D_SYSID=$P5
fi
#
# debugging code...
#echo "P1 = : $P1"
#echo "P2 = : $P2"
#echo "P3 = : $P3"
#echo "P4 = : $P4"
#echo "P5 = : $P5"
#echo "ReloadBasic parameter tests complete"
#exit 0
# end debugging code.
#
#procbodyhere
pushd ./ > /dev/null
if [ "$D_SYSID" != "$SYSID" ];then
 echo " **WARNING: You are about to reload Basic files archived"
 read -p "  on a different system ($D_SYSID).. continue (y/n)?: "
 yn=${REPLY^^}
 if [ "$yn" != "Y" ];then
  echo "ReloadBasic exiting at user request."
  ~/sysprocs/LOGMSG " ReloadBasic exiting at user request."
  exit 1
 fi
 echo " Dump source *SYSID: '$D_SYSID'"
 echo " Reload target *SYSID: '$SYSID'"
fi
if [ "$D_SYSID" != "null" ];then
 dump_path=$U_DISK/$P3/$D_SYSID/Basic
else
 dump_path=$U_DISK/$P3/Basic
fi
level=level
nextlevel=nextlevel
newlevel=newlevel
tutor=Basic
# check for .snar file.
echo " dump_path = '$dump_path'"
sleep 2
if ! test -f $dump_path/log/$tutor.snar-0;then
  echo "** cannot locate .snar file.. abandoned."
  exit 1
fi
# cat ./log/$Basic$nextlevel.txt
awk '{$1--; print $0}' $dump_path/log/$tutor$nextlevel.txt \
  > $TEMP_PATH/LastTarLevel.txt
file=$TEMP_PATH/LastTarLevel.txt
while read -e;do
#  echo "Last *tar* level = : $REPLY"
  lastlevel=$REPLY
 done < $file
 seq 0 $lastlevel > $TEMP_PATH/TarLevelList.txt
# seq 0 $lastlevel
 file=$TEMP_PATH/TarLevelList.txt
 echo "Reloading from $D_SYSID..$tutor.*.tar incremental dumps..."
  while read -e;do
   echo " Processing $tutor.$REPLY.tar."
   pushd ./ > /dev/null
   cd $pathbase
   if [ $isAll -ne 0 ];then
     tar --extract --wildcards \
      $writeover \
      --file=$dump_path/$tutor.$REPLY.tar \
      *
   else	# not full reload
     tar --extract --wildcards \
      $writeover \
      --file=$dump_path/$tutor.$REPLY.tar \
      $P1
   fi
   popd > /dev/null
done < $file
exit 0
# end ReloadBasic.sh
