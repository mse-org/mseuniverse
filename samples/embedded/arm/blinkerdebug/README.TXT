Debug demo project for STM32L100C-Discovery board    2018-04-06 mse
-------------------------------------------------

- clone, build and install the texane ST-Link tools:
https://github.com/texane/stlink
see
https://github.com/texane/stlink/blob/master/doc/compiling.md

- Download the ARM toolchain for Linux 64-bit:
https://developer.arm.com/open-source/gnu-toolchain/gnu-rm/downloads
 extract it to a directory of your choice (<toolchaindir>).
 
- Download the ST firmware STM32CubeL1:
http://www.st.com/content/st_com/en/products/embedded-software/mcus-embedded-software/stm32-embedded-software/stm32cube-mcu-packages/stm32cubel1.html#getsoftware-scroll
 extract it to a directory of your choice (<firmwaredir>).
 
- Run MSEide.
- 'Project'-'Open'-"blinkerdebug.prj".
- 'Project'-'Options'-'Macros', update <toolchaindir> and <firmwaredir>.
- 'Target'-'Download' in order to flash the program.
- 'Target'-'Continue' in order to run the program.

Have a lot of fun!

Martin