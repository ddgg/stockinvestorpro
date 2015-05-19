#!/bin/sh
exedir="$HOME/Downloads/ci"
workdir="$exedir/tmp"
cabdir="$workdir/Disk1"
exe="$exedir/$1"
tmpname=${1##*_}
fdate=${tmpname%%.*}
if [[ ! $fdate =~ [0-9]+$ ]]; then 
    # for fullupdate20000101.exe format
    tmpname=${1#*e}
    fdate=${tmpname%%.*}
    if [[ ! $fdate =~ [0-9]+$ ]]; then 
        echo "file name $1 $fdate error" >&2; 
        exit 1; 
    fi
fi
targetdir="/f/sip/$fdate/"
if [ -d $targetdir ]; then
    echo "target dir $targetdir exists!" >&2
    exit 1
fi
mkdir $targetdir
rm -rf $workdir/*
cp $1 $workdir/1.exe
cd $workdir
wine 1.exe /extract_all:"Z:\\"
if [ ! -d "$cabdir" ]; then
    echo "unpack $exe failed" >&2
    exit 1
fi
cd $cabdir
unshield x data1.cab
if [ ! -d "$cabdir/Static_Data_Files" ]; then
    echo "unshield error $exe" >&2
    exit 1
fi
find $cabdir -iname si*.dbf | xargs -I '{}' mv '{}' $targetdir
