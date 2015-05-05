# process stock invester pro updates exe

This is the program I used to automatically process sip installshield files from aaii.com, the target is to automatically extract dbf from sip update installshield exe, and import into database.

##Enviroment:

* Archlinux
* wine

##original idea:

> http://boards.fool.com/stock-investor-pro-sipro-dbf-to-mysql-26796167.aspx?sort=whole#27423261
> http://helpnet.installshield.com/installshield17helplib/HelpLib.htm#IHelpSetup_EXECmdLine.htm
> http://unattended.sourceforge.net/installers.php
 
### what working as Feb 2015

#### for old files before 20110729
installshield version before 12:

use winecfg to map Z to target dir

```
#echo \x13|WINEPREFIX=~/win32/ wine ../isxunpack.exe install.exe
wine proinstall_20110722.exe /extract_all:"Z:\\"
cd Disk1
unshild x data1.cab
```

not working:
since `proinstall_20110729.exe` and all newer files `stockinvestorinstall_yyyymmdd.exe`
installshield version 17 18 19
create a template response file, result setup.iss in `~/win32/drive_c/windows` directory
```
WINEPREFIX=~/win32/ wine proinstall\_20110729.exe /r
cp ~/win32/drive_c/windows/setup.iss .
```
test respond file
```
WINEPREFIX=~/win32/ wine proinstall\_20110729.exe /s /r /sms
```

