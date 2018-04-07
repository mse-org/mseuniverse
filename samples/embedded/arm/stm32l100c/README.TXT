Free Pascal demo project for STM32L100C-Discovery board    2018-04-07 mse
-------------------------------------------

- clone, build and install the texane ST-Link tools:
https://github.com/texane/stlink
see
https://github.com/texane/stlink/blob/master/doc/compiling.md

- Download the ARM toolchain:
https://developer.arm.com/open-source/gnu-toolchain/gnu-rm/downloads
 extract it to a directory of your choice (<toolchaindir>).
 
- Download the Free Pascal ARM-embedded cross compiler:
https://sourceforge.net/projects/mseide-msegui/files/fpccrossarmembedded/
 extract it to a directory of your choice (<crossfpcdir>).
 
- Run MSEide.
- 'Project'-'Open'-"stm32l100c.prj".
- 'Project'-'Options'-'Macros', update <toolchaindir> and <crossfpcdir>.
- 'Target'-'Continue' in order to run the program.

Have a lot of fun!

Martin