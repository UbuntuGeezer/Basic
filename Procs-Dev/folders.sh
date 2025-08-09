# folders.sh - function definitions for Basic folders. 8/9/25. wmk.
# 8/9/25.	wmk.
#
# Modification History.
# ---------------------
# 12/8/23.	wmk.	original shell; adpapted from Basic.
function cda(){
 P1=$1
 cd $folderbase/Basic/$1
}
function cdab(){
 cd $folderbase/Basic/Projects-Geany/ArchivingBackups
}
function cdb(){
 P1=$1
 cd $folderbase/Basic/src/$P1
}
function cdc(){
 P1=$1
 cd $folderbase/Basic/$P1
}
function cdd(){
 cd $pathbase
}
function cdg(){
 P1=$1
 cd $folderbase/GitHub/$P1
}
function cdj(){
 P1=$1
 cd $folderbase/Basic/Projects-Geany/$P1
}
function cdp(){
 cd $folderbase/Basic/Procs-Dev
}
function cdt(){
 P1=$1
 echo "cdt stubbed."
}
function cdts(){
 echo "cdts stubbed."
}
function cds(){
 P1=$1
 echo "cds stubbed."
}
function cdss(){
 echo "cds stubbed."
}
function cdv(){
 cd $folderbase/Basic/BasicVersion
}
function huh(){
 echo "Basic folders.sh functions:"
 echo "cda - change to Basic main folder."
 echo "cdab - change to Basic/ArchivingBackups project folder."
 echo "cdc - change to Basic [*P1]"
 echo "cdd - change to Basic"
 echo "cdg - change to GitHub/[*P1] project folder."
 echo "cdj - change to Basic Projects-Geany/[*P1] project folder."
 echo "cdp - change to Basic/Procs-Dev folder."
 echo "cdt - stubbed."
 echo "cdts - stubbed."
 echo "cds - stubbed."
 echo "cdss - stubbed."
 echo "cdv - change to Basic/BasicVersion"
 echo "help/huh - list this list to terminal."
}
function help(){
 huh
 }
