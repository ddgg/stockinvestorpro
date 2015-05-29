# extract stock invester pro updates exe

This is the steps I used to automatically process sip installshield files from aaii.com, the target is to automatically extract dbf from sip update installshield exe, and import into database.

##Enviroment:

* Archlinux
* wine

##original idea:

> http://boards.fool.com/stock-investor-pro-sipro-dbf-to-mysql-26796167.aspx?sort=whole#27423261
> http://helpnet.installshield.com/installshield17helplib/HelpLib.htm#IHelpSetup_EXECmdLine.htm
> http://unattended.sourceforge.net/installers.php
 
### what working as Feb 2015
> unshield
#### for old files before 20110729
installshield version before 12:

use winecfg to map Z to target dir

~~echo \x13|WINEPREFIX=~/win32/ wine ../isxunpack.exe install.exe~~
```
wine proinstall_20110722.exe /extract_all:"Z:\\"
cd Disk1
unshild x data1.cab
```
~~not working:~~
~~since `proinstall_20110729.exe` and all newer files `stockinvestorinstall_yyyymmdd.exe`~~
~~installshield version 17 18 19~~

thanks to https://github.com/twogood/unshield

unshield now work perfectly for all the installshield version

#### 2015-05-19 version 17 single character problem
~~unshield proinstall_20110729 till 20120622 still has single character problem~~
#### 20150520 version 17 single character problem solved after unshield update

# history dbf to sqlite
## batch cp dbf to a directory tree

date as directory name
``` 
for i in stockinvestorinstall_*; do ~/trade/sip/dbf2archive.sh $i;done
```

for fullupdate files, the begining isxunpack report exceptions, so begin from backwards(latest files first)

```
for i in `ls -1 fullupdate200*|sort -r`; do ~/trade/sip/dbf2archive.sh $i;done
```
20070531 isxunpack raise exceptions, but after click 'show details', program continue

22M     ./20030103
22M     ./20050211
22M     ./20051202
85M     ./20060616
118M    ./20070531
119M    ./20061110

these are the incomplete extractions and their size

122G as of 20050520
# put dbf into sqlite for easy query
## dbf schema
### Static_Data_Files

here store the concerned fundametal data

* si_ci.dbf company info, company code, ticker, name address etc
* si_date.dbf exact date of the period Y1, Y2 ... Y7 etc
* si_bsa.dbf annual balance sheet
* si_bsq.dbf quarterly balance sheet
* si_cfa.dbf annually cash flow statement
* si_cfq.dbf quarterly cash flow statement
* SI_DOW.DBF dow index abbreviation code
* SI_EXCHG.DBF exchange code
* si_isa.dbf annually income statement
* si_isq.dbf quauterly income statement
* SI_MGDSC.DBF industry/sector code and description
### Dynamic_Data_Files

here store the price data files

* si_psda.dbf yearly price data, including past 7 year end's price, high, low, volume
* si_psdc.dbf monthly price data, past 120 month's closing price

http://www.dbf2002.com/dbf-file-format.html

## support table
## si_ci company infomation? companyid vs ticker
```
cd /f/sip/ # must in this folder, code use fullpath to extract date and table names
find . -name si_ci.dbf|xargs python ~/cr48/trade/sip/pdbf -c -f 0,1,2,3 -s ~/1.db
```
## si_date date filed _Y1...7 vs actual date

```
cd /f/sip/ # must in this folder, code use fullpath to extract date and table names
find . -name si_date.dbf|xargs python ~/cr48/trade/sip/pdbf -c -f 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15 -s ~/1.db
```
## fundamental data
### si_bsq.dbf
table structure change with the time, so find result need to be order reverse time. and pdbf will abonden dbf if structure change, need more robust logic, like create new table.
```
cd /f/sip/ # must in this folder, code use fullpath to extract date and table names
find . -name si_bsq.dbf|sort -r|head -200|xargs python ~/cr48/trade/sip/pdbf -c -s ~/1.db
```
