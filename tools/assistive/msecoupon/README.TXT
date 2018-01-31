2018-01-27 mse

MSEcoupon prints and manages coupons. It demonstrates the use of 
TAssistiveHandler. License is GPL.
Database is placed in working directory.

Installation on Linux
---------------------

64 bit:
- Download libespeak-ngsync.so.1, libsonic.so.0 and libpcaudio.so from
https://sourceforge.net/projects/mseuniverse/files/eSpeakNG/linux64/
- Copy the files to "/usr/lib64".

32 bit:
- Download libespeak-ngsync.so.1, libsonic.so.0 and libpcaudio.so from
https://sourceforge.net/projects/mseuniverse/files/eSpeakNG/linux32/
- Copy the files to "/usr/lib".

32 and 64 bit:
- Set the executable flags of the libraries.
- Run "ldconfig".
- Download espeak-ng-data.zip from
https://sourceforge.net/projects/mseuniverse/files/eSpeakNG/
- Extract it to the MSEcoupon working directory.
- Install Firebird 3
https://firebirdsql.org/en/firebird-3-0/
- Install GhostScript (most likely already installed).
- Install PDFtk
https://www.pdflabs.com/tools/pdftk-server/

Installation on Windows
-----------------------

First Steps
-----------
On first start of MSEcoupon there will be an errormessage about
missing database. 'Einstellungen'-'Leere Datenbank erzeugen' creates an empty
database. There must be at least one object before it is possible to create
coupons, use 'Leistungs-Katalog'-'Neue Leistung' 

MSEtoken needs a special version of eSpeakNG with the possibility
to cancel speech operation in synchronous mode.
The project is here:
https://gitlab.com/mseide-msegui/espeak-ngsync
Binaries are here:
https://sourceforge.net/projects/mseuniverse/files/eSpeakNG/
libespeak-ngsync7.dll is for Windows 7 with XAudioD2_7.dll.