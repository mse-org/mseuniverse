2018-02-01 mse

MSEcoupon prints and manages coupons. It demonstrates the use of 
TAssistiveHandler. License is GPL, it needs MSEide+MSEgui git master version
from 2018-02-01 or newer.
https://gitlab.com/mseide-msegui/mseide-msegui

Database is placed in MSEcoupon runtime working directory.

Installation
------------
32/64 bit of all libraries must match the 32/64 bit state of the compiled
MSEcoupon application.

On Linux
--------

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

On Windows
----------
Windows 7:
Download libespeakng-sync7.dll
Windows 8 or 10:
Download libespeakng-sync.dll
Windows 7,8,or 10:
from
https://sourceforge.net/projects/mseuniverse/files/eSpeakNG/
copy it to "C:\Windows\System32" or to the directorey of "msecoupon.exe".
Install eSpeakNG:
https://github.com/espeak-ng/espeak-ng/releases
Install Ghostscript:
https://www.ghostscript.com/download/
Install GSView:
http://www.gsview.com/
Install PDFtk:
https://www.pdflabs.com/tools/pdftk-server/
Install Firebird 3:
https://firebirdsql.org/en/firebird-3-0/
Restart Windows (IMPORTANT!).

First Steps
-----------
Check the tool paths in 'Einstellungen'.
On first start of MSEcoupon there will be an errormessage about
missing database. 'Einstellungen'-'Leere Datenbank erzeugen' creates an empty
database. There must be at least one object before it is possible to create
coupons, please use 'Leistungs-Katalog'-'Neue Leistung'.

Key-bindigs
-----------
Space -> execute buttons ('Schaltfeld').
Ctrl+Space or Ctrl+PadReturn -> repeat current text.
Shift+Ctrl+Space or Shift+Ctrl+PadReturn -> repeat whole current text.
Ctrl+PadMinus -> speak slower.
Ctrl+PadPlus -> speak faster.
Ctrl+Y F -> focus first field of current form.
Ctrl+Y L -> focus last field of current form.