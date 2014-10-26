2014-09-19 mse

MSEtest is a unit test and program group compile tool.

Predefined macros:
${FILE}     the file path of the current item.

File path macros, format is ${FILE_*(fileparameter)} or ${FILE_*("fileparameter")}:
FILE_MSE    convert to MSE format.
FILE_SYS    convert to sys format.
FILE_PATH   absolute path.
FILE_FILE   no trailing path delimiter.
FILE_DIR    trailing path delimiter.
FILE_NAME   no directory part.
FILE_EXT    file name extension.
FILE_NONAME directory part only.
FILE_NOEXT  no file name extension.

