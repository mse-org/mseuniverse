1. Compile MSEide+MSEgui with new library TRAWprinter.
   - copy regcomponents.inc to 'APPS/IDE/'
   - copy folder 'trawprinter' to 'LIB/COMMON/'
   - open mseide project.
   - add option for make from Project->Options, on 'Make' tab select 'Make Options' tab,
     add '-dmorecomponents' at column 'Command line options'
   - build

2. Open demo in folder 'RAWDEMO'.