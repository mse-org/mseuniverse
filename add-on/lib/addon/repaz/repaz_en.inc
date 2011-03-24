 en_rcscaption: array[rcscaptionty] of msestring = (
  'Line too long',  //rcsLineTooLong
  'Expected %s',  //rcsExpected 
  'Can not set a value to a expression',  //rcssetexpression
  'Division by zero',  //rcsDivisioZero 
  'Syntax error',  //rcsEvalsyntax 
  'Type conversion error',  //rcsEvalType 
  'Invalid operation',  //rcsInvalidOperation 
  'Unknown identifier: ',  //rcsEvalDescIden 
  'Left side can not be assigned',  //rcsEvalDescIdenLeft
  'Parentesis error',  //rcsEvalParent 
  'Variable redefined',  //rcsVariabledefined 
  'Field not found: ',  //rcsFieldNotFound
  'Indentifier expected',  //rcsIdentifierexpected 
  'String expected',  //rcsstringexpected 
  'Number expected',  //rcsNumberexpected 
  'Operator expected',  //rcsOperatorExpected 
  'None',  //rcsNone
  'General',  //rcsGeneral
  'Sum',  //rcsSum
  'Return minimum number between 2 number',  //rcsMin
  'Return maximum number between 2 number',  //rcsMax
  'Average',  //rcsAvg
  'Identifier',  //rcsSIdentifier
  'Error expression item no assigned (idenexpression)',  //rcsErrorIdenExpression
  'Can not set a value to a function',  //rcsAssignFunc
  'Can not set a value to a report element',  //rcsAssignreport
  'Can not set a value to a constant',  //rcsAssignConst
  'Can not set a value to a field',  //rcsAssignfield
  'Can not set a value to a report element',  //rcsAssignreportelement
  'No help available',  //rcsNohelp
  'No parameters',  //rcsNoaparams
  'No model',  //rcsNomodel
  'A constant with True value',  //rcsTrueHelp
  'A constant with False value',  //rcsFalseHelp
  'Database field',  //rcsFieldHelp
  'Report element',  //rcsReportElementHelp
  'Return the string in uppercase',  //rcsUpperCase
  'Strings is the string to do uppercase',  //rcsPUpperCase
  'Returns the string in lowercase',  //rcsLowerCase
  'Strings is the string to do lowercase',  //rcsPLowerCase
  'Converts a float to a datetime type',  //rcsFloatToDateTime
  'Number is the number to convert',  //rcsPFloatToDateTime
  'Returns the sin of an angle',  //rcsSin
  'ang is expressed in radians',  //rcsPSin
  'Rounds to a multiple of a number.',  //rcsRound
  'num is the number to round and r i the multiplier',  //rcsPRound
  'Returns the integer part of a number',  //rcsInt
  'num is the number to obtain the int part.',  //rcsPInt
  'Converts a number to a string',  //rcsStr
  'num is the number to convert',  //rcsPStr
  'Converts a string to a number',  //rcsVal
  'Strings is the string to convert',  //rcsPVal
  'Returns a string without spaces in right-left sides',  //rcsTrim
  'Strings is the string to be trimmed',  //rcsPtrim
  'Returns the left side of a string',  //rcsLeft
  'Strings is the source string,count is the number of chars to return',  //rcsPLeft
  'Returns the position index of a string inside another string (0 if not found)',  //rcsPos
  'SubStr is the substring to search for',  //rcsPPos
  'Returns absolute value of a number.',  //rcsAbs
  'num is the number change sign',  //rcsPAbs
  'Returns -1 if first number is lower, 1 if first number is greater or zero if equal.',  //rcsCompareValue
  'num1 and num2 are numbers to compare, epsilon de diference tolerance',  //rcsPCompareValue
  'The square of a number',  //rcsSQrt
  'num is the number to square',  //rcsPSQRt
  'Returns the module that is the rest of the integer division',  //rcsMod
  'd1 is the dividend d2 is the divisor',  //rcsPMod
  'Returns today date in datetime data type',  //rcsToday
  'Returns today and time in datetime data type',  //rcsNow
  'Return the value of Report Header', //rcsReportHeader
  'RowIndex is index of Report Header and ColIndex is index of tabulator', //rcspReportHeader
  'Return the value of Report Footer', //rcsReportFooter
  'RowIndex is index of Report Footer and ColIndex is index of tabulator', //rcspReportFooter
  'Return the value of Page Header', //rcsPageHeader
  'RowIndex is index of Page Header and ColIndex is index of tabulator', //rcspPageHeader
  'Return the value of Page Footer', //rcsPageFooter
  'RowIndex is index of Page Footer and ColIndex is index of tabulator', //rcspPageFooter
  'Return the value of Header Content of report', //rcsContentHeader
  'ColIndex is index of tabulator', //rcspContentHeader
  'Return the value of Footer Content of report', //rcsContentFooter,
  'ColIndex is index of tabulator', //rcspContentFooter,
  'Return the value of Data Content of report', //rcsContentData,
  'ColIndex is index of tabulator', //rcspContentData,
  'Return the value of Header Group of report', //rcsGroupHeader
  'RowIndex is index of Header Group, ColIndex is index of tabulator', //rcspGroupHeader
  'Return the value of Footer Group of report', //rcsGroupFooter,
  'RowIndex is index of Header Group, ColIndex is index of tabulator', //rcspGroupFooter
  'Return the value of Data Group of report', //rcsGroupData
  'ColIndex is index of tabulator', //rcspGroupData,
  'Return page number of Repaz page', //rcsPageNumber
  'Return value of active key header (TraTreeReport)', //rcsHeaderTreeKey
  'Return value of active key footer (TraTreeReport)', //rcsFooterTreeKey
  'Return value of last footer value (TraTreeReport)',  //rcsTreeFooterValue
  '(indexrow: integer, indexcol:integer, indextree: integer=0)', //rcsPTreeFooterValue
  'Return record number of data', //rcsRecordNumber
  'Return record number of master data', //rcsMasterNumber
  'Return data number in every section', //rcsDataNumber
  'Return group number', //rcsGroupNumber
  'Index is index of group report', //rcspGroupNumber
  'Returns the time in datetime datatype',  //rcsTimeH
  'Null',  //rcsNull
  'The name of the month in string',  //rcsMonthName
  'd es de date to be decoded',  //rcsPMonthName
  'Evals an expression, returns the evaluated result',  //rcsEvalText
  'expr is the expression to evaluate',  //rcsPEvalText
  'Returns the month number (1-12)',  //rcsMonth
  'd is the date to decode',  //rcsPMonth
  'Returns the year',  //rcsYear
  'd is the date to decode',  //rcsPyear
  'Returns the day',  //rcsDay
  'd is the date to decode',  //rcsPDay
  'Returns the right side of a string',  //rcsRight
  'Strings is the source string and count is the number of characters to copy',  //rcsPRight
  'Returns a substring of a string',  //rcsSubStr
  'cadena is the sorce string, index is the index to copy from '+#10+' and count is the number of characters to copy',  //rcsPSubStr
  'Formats a string in diferent ways taking a picture of characters',  //rcsFormatStr
  'Format is the format string: ex.''dd/mm/yyyy'''+#10+' and v is the value to convert to a formated string',  //rcsPFormatStr
  'Text representation of a number',  //rcsNumToText
  'Number is the number',  //rcsPNumToText
   'Type conversion error',  //rcsConvertError 
   'Invalid Binary',  //rcsInvalidBinary 
   'Duplicated field you must use the alias',  //rcsFieldDuplicated 
  'Sum operator',  //rcsOperatorSum
  'Substract operator',  //rcsOperatorDif
  'Multiply operator',  //rcsOperatorMul
  'Division operator',  //rcsOperatorDiv
  'Comparison operator',  //rcsOperatorComp
  'Logical operator',  //rcsOperatorLog
  'Decision operator',  //rcsOperatorDec
  'IIF(condition,action1,action2)',  //rcsOperatorDecM
  'Condition is a boolean expression, if it''s true the '+#10+' first parameter is executed, else the second is executed',  //rcsOperatorDecP
  'Separator operator',  //rcsOperatorSep
  'Is used to execute more than one expresi?n, the last is the result',  //rcsOperatorSepP
  'Error opening the printer ',  //rcsErrorOpenImp
  'Returns the length, in characters, of a string',  //rcsLength
  'Strings is the source string',  //rcsPLength
  'Returns the maximum value',  //rcsPMax
  'Parameter already exists',  //rcsParameterExists
  'Shared Image',  //rcsCached
  'Returns true if the string is a valid integer',  //rcsIsInteger
  'Returns true if the string is a valid number',  //rcsIsNumeric
  'Returns true if the string is a valid date and time',  //rcsIsValidDateTime
  'Raises an exception with provided message if the expression is false',  //rcsCheckExpression
  'Fixed Image',  //rcsCachedFixed
  'Variable Image',  //rcsCachedVariable
  'Obtain a value from a sql sentence',  //rcsGetValueFromSQL
  'You use a connection name and a sql sentence that should return a value',  //rcsGetValueFromSQLP
  'Formats a number using a mask',  //rcsFormatNum
  'The mask can be like ##,##,##,##0.00',  //rcsPFormatNum
  'Replace a string within a string',  //rcsReplaceStr
  'Search field value from datasource use key field criteria', //rcsFieldWithKey
  'Strings= source string, OldPattern= string within Strings will be replaced, NewPattern= new string to replace OldPattern',  //rcsPReplaceStr
  'KeyField: name of key field, KeyValue: value of key field, ValueField: field name that is searched', //rcsPFieldWithKey
  'Error on filter',  //rcsErrorFilter
  'Decode base 64 string',  //rcsDecode64
  'Converts string to binary stream',  //rcsStringToBin
  'Convert string to time',   //rcsstringtotime
  'string : time string',   //rcspstringtotime
  'Convert string to datetime',   //rcsstringtodatetime
  'string : datetime string',   //rcspstringtodatetime
  'Convert time to string',   //rcstimetostring
  'time : tdatetime',   //rcsptimetostring
  'Convert datetime to string',   //rcsdatetimetostring
  'datetime : tdatetime',   //rcspdatetimetostring
  'Convert datetime to day of the week',   //rcsdayofweek
  'datetime : tdatetime',   //rcspdayofweek
  '&OK',   //rcsOK
  '&Cancel',   //rcsCancel
  'Expression Creator',   //rcsExpCreator
  'Category',   //rcsCategory
  'Operation',   //rcsOperation
  '&Add Selection',   //rcsAddSelection
  '&Syntax Check',   //rcsSyntaxCheck
  'Show &Result',   //rcsShowresult
  'Database Fields',   //rcsDbFields
  'Functions',   //rcsFunctions
  'Variables',   //rcsVariables
  'Report Functions',   //rcsReportFunctions
  'Constants',   //rcsConstants
  'Operators',   //rcsOperators
  '&Clear',   //rcsClear
  'Syntax is correct!', //rcsmsgTrueSyntax
  //repaz
  'Design Report',  //rcsDesignreport
  'Preview (Screen)',  //rcsPreview
  'Printer',  //rcsPrinter
  'Save to PostScript File',  //rcsSavetops
  'Save to PDF File',  //rcsSavetopdf
  'Save to text (CSV) File',  //rcsSavetotext
  'Design report for customized report',  //rcsDesigninfo
  'Show report on screen then can be printed on printer, save to Postscript, PDF, etc.',  //rcsPreviewinfo
  'Print report on general printer like LaserJet, InkJet, Dot Matrix, etc.',  //rcsPrintinfo
  'Save to PostScript file and than can print that is support PostScript or convert to another file format.',  //rcsSavetopsinfo
  'Save to PDF (Portable Document Format) file and than can be viewed with PDF Reader Application like Adobe Acrobat Reader, etc.',  //rcsSavetopdfinfo
  'Save to text (CSV) file and than can be viewed with spreadsheet application like MS Excel, Open Office Calc, etc.',  //rcsSavetotextinfo
  'Action &Type',  //rcsActiontype
  'Description',  //rcsDescription
  'S&how this dialog again every execute report action',  //rcsShowdlgagain
  '&Setting',  //rcsSetting
  '&File',  //rcsMnufile
  '&New',  //rcsMnufilenew
  '&Open',  //rcsMnufileopen
  '&Save',  //rcsMnufilesave
  'Save &As',  //rcsMnufilesaveas
  'E&xit',  //rcsMnuexit
  '&Report',  //rcsMnureport
  '&Preview',  //rcsMnupreview
  '&Options',  //rcsMnuoptions
  '&Pages',  //rcsMnupages
  '&Add Page',  //rcsMnuaddpages
  '&Remove Page',  //rcsMnuremovepages
  '&Language', //rcsMnuLanguage
  '&Help',  //rcsMnuhelp
  '&About',  //rcsMnuabout
  'Drag this to resize layout',  //rcsDraginfo
  'Create new report',  //rcsNewreportinfo
  'Open existing report',  //rcsOpenreportinfo
  'Save report',  //rcsSavereportinfo
  'Save report as new file',  //rcsSaveasreportinfo
  'Preview report',  //rcsPreviewreportinfo
  'Add report page',  //rcsAddpageinfo
  'Remove report page',  //rcsDelpageinfo
  'Select page report',  //rscSelectpageinfo,
  'Select unit report', //rcsSelectunitinfo,
  'Show/hide grid',  //rcsShowgridinfo
  'On/off snap to grid',  //rcsSnapinfo
  'Exit report designer',  //rcsExitinfo
  '&Print',  //rcsMnuprint
  '&Save to PostScript',  //rcsMnusavetops
  'Save to &PDF',  //rcsMnusavetopdf
  'Save to &Text (CSV)',  //rcsMnusavetotext
  '&First',  //rcsMnufirst
  '&Previous',  //rcsMnuprev
  '&Go to...',  //rcsMnugoto
  '&Next',  //rcsMnunext
  '&Last',  //rcsMnulast
  '&Zoom',  //rcsMnuzoom
  '&Find',  //rcsMnufind
  '&Text in pages',  //rcsMnufindtext
  'Go to first page',  //rcsFirstinfo
  'Go to previous page',  //rcsPrevinfo
  'Go to next page',  //rcsNextinfo
  'Go to last page',  //rcsLastinfo
  'Page number',  //rcsPagenumberinfo
  'Total of pages',  //rcsTotalpagesinfo
  'Zoom page',  //rcsZoominfo
  'Print report',  //rcsPrintrepinfo
  'Save to text (CSV) file',  //rcsSaverepinfo
  'Save to PostScript file',  //rcsSave2psinfo
  'Save to PDF file',  //rcsSave2pdfinfo
  'Find text in report',  //rcsFindtextinfo
  'Display',  //rcsDisplay
  'Show &grid',  //rcsLblshowgrid
  '&Snap to grid',  //rcsLblsnap
  'Grid size &X',  //rcsLblgridsizex
  'Grid size &Y',  //rcsLblgridsizey
  '&Measure Unit',  //rcsLblunit
  'Printer &Name',  //rcsLblprintname
  '&RAW Mode',  //rcsLblrawmode
  'Printer Information',  //rcsLblprintinfo
  '&General',  //rcsCapgeneral
  'R&AW Mode',  //rcsCaprawmode
  'Pages Selection',  //rcsCappagessel
  'A&ll',  //rcsLblall
  '&Range',  //rcsLblrange
  '&Copies',  //rcsLblcopies
  'Paper Si&ze',  //rcsCappapersize
  '&Width (mm)',  //rcsLblwidth
  '&Height (mm)',  //rcsLblheight
  'Printer &Code',  //rcsLblprintercode
  '&Continues Page',  //rcsLblcontinuespage
  '&Eject on finished',  //rcsLbleject
  'Cu&t paper on finished',  //rcsLblcutpaper
  '&Don''t open',  //rcsLbldontopen
  'Open &before print',  //rcsLblopenbefore
  'Open &after print',  //rcsLblopenafter
  'Save Report Design',  //rcsCapsaverepdesign
  'Please type report filename!',  //rcsMsgtyperepfn
  'Save Report Design As',  //rcsCapsaverepas
  'Report should have at least 1 page!',  //rcsMsgmin1page
  'This feature does not need to be configured!',  //rcsMsgprevnotconfig
  'Report Designer is not activated!',  //rcsMsgdesignnotactive
  'Report preview is not activated!',  //rcsMsgpreviewnotactive
  'Print report to printer is not activated!',  //rcsMsgprintnotactive
  'Save to PostScript file',  //rcsCapsave2ps
  'PostScript files',  //rcsLblpostscript
  'Save to PDF (Portabel Data Document) file', //rcsCapsave2pdf
  'PDF Files', //rcsLblpdf,
  'Save to text (CSV) file', //rcsCapsave2text,
  'Text/CSV files', //rcsLbltext,
  'All files',  //rcsLblallfiles
  'Please type name of PostScript file output',  //rcsMsgtypepsfn
  'Save Repaz Metafile',  //rcsCapsave2metapage
  'Repaz Metafiles',  //rcsLblmetapage
  'Please type name of Repaz Metafile output!',  //rcsMsgtypemetapagefn
  'Save to file is not activated!',  //rcsMsgsavefilenotactive
  'Report file can''t be opened!',  //rcsMsgreportnotopen
  'Class of report component not found : ',  //rcsMsgclassnotfound  
  'Are you sure to delete this page?', //rcsMsgdeletepage
  'Delete page', //rcsCapdeletepage
  'Report file not found!', //rcsMsgReportFileNotFound
  'Create new report?', //rcsMsgCreateNewReport
  'Confirmation', //rcsCapConfirmation
  '&Edit', //rcsMnuedit
  '&Copy', //rcsMnucopy
  'Cu&t', //rcsMnucut
  '&Paste', //rcsMnupaste
  '&Delete', //rcsMnudelete
  '&Undelete', //rcsMnuundelete
  'Bring to &Front', //rcsMnutofront
  'Send to &Back', //rcsMnutoback
  'Copy object to clipboard', //rcshintcopy
  'Cut object to clipboard', //rcshintcut
  'Paste object from clipboard', //rcshintpaste
  'Delete object', //rcshintdelete
  'Undelete object', //rcshintundelete
  'Bring object to front of other object', //rcshinttofront
  'Send object to back of other object', //rcshinttoback
  'Field must in number type (Currency,Integer,etc.)', //rcsFieldmustnumber
  'equal', //rcsequal
  'not equal', //rcsnotequal
  'greater than', //rcsgreater
  'greater than or equal', //rcsgreaterequal
  'less than', //rcsless
  'less than or equal', //rcslessequal
  'like criteria (with wilcards)', //rcslike
  'between 2 values', //rcsbetween
  'Record Filter', //rcsfilterform
  'Use &Filter', //rcsApplyFilter,
  '&Remove Filter', //rcsRemoveFilter,
  '&Close', //rcsClose,
  'Field fil&tered', //rcsFieldToFind,
  '&Operand', //rcsOperand,
  'Field &Value', //rcsFieldValue,
  'Field is true', //rcsFieldBoolValue,
  'For operand [LIKE] is for data text only, you can use wilcard *, ex : *abc, abc*xyz, abc*, etc.', //rcsHintForLike,
  '&Day', //rcscapDay,
  '&Month', //rcscapMonth,
  '&Year', //rcscapYear
  'Return the value of header in specific table', //rcstableheader
  'TableIndex is index of table, RowIndex is index of header, ColIndex is index of tabulator', //rcsptableheader
  'Return the value of footer in specific table', //rcstablefooter
  'TableIndex is index of table, RowIndex is index of footer, ColIndex is index of tabulator', //rcsptablefooter
  'Return the value of cell in specific row and column in letter', //rcsplettervalue
  'RowIndex is index of LetterContent, ColIndex is index of tabulator', //rcslettervalue
  'Variable should a field of database (datasource.fieldname)!', //rcsNotField
  'Save changes?', //rcsAskSave
  'To check whether today is a holiday', //rcsisholiday
  'ADate : date to check; IncludeSunday : is Sunday included to holiday', //rcspisholiday
  'To check whether today is a discountday', //rcsisdiscountday
  'ADate : date to check; IncludeSunday : is Sunday included to discountday', //rcspisdiscountday
  '&Lines per page', //rcsLinesperpage
  'Cash Drawer is connected to', //rcsCasdrawerconnection
  '&Printer (i.e RJ45, etc)', //rcsRJ45
  'Serial (RS232)', //rcsRS232
  'Ad&vance', //rcsAdvance
  'Print text as &graphic', //rcsPrinttextasgraphic,
  '&Use anti alias feature' //rcsUseantialias
  );

