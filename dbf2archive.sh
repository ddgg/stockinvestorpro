#!/bin/sh
exedir="$HOME/Downloads/ci"
workdir="$exedir/tmp"
cabdir="$workdir/Disk1"
exe="$exedir/$1"
tmpname=${1##*_}
fntype=0
fdate=${tmpname%%.*}
if [[ ! $fdate =~ ^[0-9]+$ ]]; then 
    # for fullupdate20000101.exe format
    fdate=${fdate#*e}
    echo "filename after process $fdate"
    if [[ ! $fdate =~ ^[0-9]+$ ]]; then 
        echo "file name $1 $fdate error" >&2; 
        exit 1; 
    else
        fntype=1
    fi
fi
targetdir="/f/sip/$fdate/"
if [ -d $targetdir ]; then
    echo "target dir $targetdir exists!" >&2
else
    mkdir $targetdir
fi
rm $workdir/1.exe
cp $1 $workdir/1.exe
cd $workdir
if [[ $fntype -eq 0 ]]; then
    rm -rf $cabdir
    echo "file name contains underscore"
    wine 1.exe /extract_all:"Z:\\"
    if [ ! -d "$cabdir" ]; then
        echo "unpack $exe failed" >&2
        exit 1
    fi
    cd $cabdir
else
    echo "no underscore in file name"
    ls|grep -v 1.exe|grep -v isxunpack.exe|xargs rm -rf
    echo \x13|wine isxunpack.exe 1.exe
fi
unshield x data1.cab
if [[ $fntype -eq 0 && ! -d "$cabdir/Static_Data_Files" ]]; then
    echo "unshield error $exe" >&2
    exit 1
fi
#find $workdir -iname si*.dbf -o -iname si*.fpt| xargs -I '{}' mv '{}' $targetdir
# first time missed memo file, this is one time run to add fpt to archieve dir
find $workdir -iname si*.fpt | xargs -I '{}' mv '{}' $targetdir
