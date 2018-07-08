Demo program for Raspberry Pi
-----------------------------

On Raspberry Pi:
- Establish a ssh login without password (public key authentication).

On the i386/x84_64-linux host:
- install the scp program
- download and extract 
  https://sourceforge.net/projects/mseide-msegui/files/fpcrossarm/crossfpc-i386_linux_eabihf_3_0_5.tar.gz
  (or crossfpc-x86_64_linux_eabihf_3_0_5.tar.gz)
  to <your crossfpc directory>.

- Start MSEide, in 'Settings'-'Configure MSEide'-'Global Macros' add:

Name            Value

CROSSMSEDIR     <MSEide+MSEgui directory>
CROSSFPCDIR     <your crossfpc directory>
CROSSFPCVERSION 3.0.5
HOSTIP          <the IP address of the host>
REMOTEIP        <the IP address of the remote target>
REMOTEPORT      <the remote port, ex: 2345>
REMOTEUSER      pi

- 'Project'-'Open', select "minimal.prj"
- 'Project'-'Options'-'Macros', set the TARGETPROJECTDIR value to the project
  path in remote target, ex: "/home/pi/proj/testcase".
- Check the TARGETENV macro.
- If your application needs additional libraries copy them from Raspberry Pi
  /lib/arm-linux-gnueabihf or /usr/lib/arm-linux-gnueabihf to
  <your crossfpc directory>/eabihf/lib

Press F9 and hope the best. ;-)
If there is a debugger timeout at startup enlarge the 
'Project'-'Options'-'Target'-'Wait before connect' value.

Have a lot of fun!

Martin