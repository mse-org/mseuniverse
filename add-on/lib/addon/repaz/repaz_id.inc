 id_rcscaption: array[rcscaptionty] of msestring = (
  'Baris sangat panjang',  //rcsLineTooLong
  'Simbol kurang %s',  //rcsExpected 
  'Nilai tidak bisa di set ke ekspresi',  //rcssetexpression
  'Pembagian dengan nol ',  //rcsDivisioZero 
  'Perintah salah',  //rcsEvalsyntax 
  'Konversi type salah',  //rcsEvalType 
  'Operasi tdk benar',  //rcsInvalidOperation 
  'Persamaan tidak dikenal',  //rcsEvalDescIden 
  'Sisi kiri tidak dapat diterapkan',  //rcsEvalDescIdenLeft
  'Tanda kurung salah',  //rcsEvalParent 
  'Variabel didefinisikan kembali',  //rcsVariabledefined 
  'Field tidak ditemukan',  //rcsFieldNotFound
  'Persamaan yang diharapkan',  //rcsIdentifierexpected 
  'String yang harus ada',  //rcsstringexpected 
  'Angka yang diharapkan',  //rcsNumberexpected 
  'Operator yang diharapkan',  //rcsOperatorExpected 
  'Kosong/tidak ada',  //rcsNone
  'Umum',  //rcsGeneral
  'Jumlah',  //rcsSum
  'Minimum',  //rcsMin
  'Maksimum',  //rcsMax    
  'Rata-rata',  //rcsAvg
  'Identifier',  //rcsSIdentifier
  'Kesalahan ekspresi, tidak diterapkan',  //rcsErrorIdenExpression
  'Tidak dapat menerapkan nilai untuk fungsi',  //rcsAssignFunc
  'Tidak dapat menerapkan nilai untuk elemen report',  //rcsAssignReport
  'Tidak dapat menerapkan nilai untuk konstanta',  //rcsAssignConst
  'Tidak dapat menerapkan nilai untuk field',  //rcsAssignfield
  'Tidak dapat menerapkan nilai untuk report elemen',  //rcsAssignreportelement
  'Tidak ada bantuan yang tersedia',  //rcsNohelp
  'Tidak ada parameter',  //rcsNoaparams
  'Tidak ada model yang tersedia',  //rcsNomodel
  'Sebuah konstanta dengan nilai benar (true)',  //rcsTrueHelp
  'Sebuah konstanta dengan nilai salah (false)',  //rcsFalseHelp
  'Database field',  //rcsFieldHelp
  'Report elemen',  //rcsFieldHelp
  'Menjadikan string  menjadi huruf besar',  //rcsUpperCase
  'Strings adalah string yang akan dijadikan huruf besar',  //rcsPUpperCase
  'Menjadikan string menjadi huruf kecil',  //rcsLowerCase
  'Strings adalah string yang akan dijadikan huruf kecil',  //rcsPLowerCase
  'Merubah Float (pecahan) menjadi DateTime (waktu dan tanggal)',  //rcsFloatToDateTime
  'Number adalah angka yang akan dikonversi',  //rcsPFloatToDateTime
  'Menghasilkan Sinus dari sudut',  //rcsSin
  'Angular adalah sudut dalam Radian',  //rcsPSin
  'Membulatkan pecahan menjadi pecahan dengan digit tertentu',  //rcsRound
  'Number adalah angka yanga kan dibulatkan dan Rounded adalah nilai digit pembualatan',  //rcsPRound
  'Menghasilkan bilangan bulat dari pecahan',  //rcsInt
  'Number adalah angka yang akan dibulatkan',  //rcsPInt
  'Mengkonversi angka menjadi string (huruf)',  //rcsStr
  'Number adalah angka yang akan dikonversi',  //rcsPStr
  'Mengkonversi string (huruf) menjadi angka',  //rcsVal
  'Strings adalah string (huruf) yang akan dikonversi',  //rcsPVal
  'Menghilangan spasi di sebelah kanan dan kiri string',  //rcsTrim
  'Strings adalah string yang akan di-trim',  //rcsPtrim
  'Menghasilkan beberapa huruf sebelah kiri dari sebuah string',  //rcsLeft
  'Strings adalah string asal,Count adalah jumlah huruf yang akan diambil dari kiri',  //rcsPLeft
  'Menghasilkan posisi string dalam string lain (0 jika tidak ditemukan)',  //rcsPos
  'SubString adalah string yang akan dicari posisinya',  //rcsPPos
  'Menghasilkan angka absolute (tidak ada minus)',  //rcsAbs
  'Number adalah angka yang akan diabsolutkan',  //rcsPAbs
  'Membandingkan dua angka. Hasil -1 jika angka pertama terendah, 1 jika angka pertama terbesar, 0 jika kedua angka sama',  //rcsCompareValue
  'Number1 dan Number2 adalah angka yang akan dibandingkan, Epsilon adalah angka tolerasi',  //rcsPCompareValue
  'Akar pangkat dari angka',  //rcsSQrt
  'Number adalah angka yang akan dicari akar pangkatnya',  //rcsPSQRt
  'Menghasilkan sisa dari pembagian dua bilangan',  //rcsMod
  'Number1 adalah angka yang dibagi dan Number2 adalah pembagi',  //rcsPMod
  'Menghasilkan tanggal hari ini dalam format DateTime',  //rcsToday
  'Menghasilkan tanggal dan jam hari ini dalam format DateTime',  //rcsNow
  'Menghasilkan nilai dari Header Report', //rcsReportHeader
  'RowIndex adalah indeks dari Header Report dan ColIndex adalah indeks dari tabulator', //rcspReportHeader
  'Menghasilkan nilai dari Footer Report', //rcsReportFooter
  'RowIndex adalah indeks dari Footer Report dan ColIndex adalah indeks dari tabulator', //rcspReportFooter
  'Menghasilkan nilai dari Header Page', //rcsPageHeader
  'RowIndex adalah indeks dari Header Page dan ColIndex adalah indeks dari tabulator', //rcspPageHeader
  'Menghasilkan nilai dari Footer Page', //rcsPageFooter
  'RowIndex adalah indeks dari Footer Page dan ColIndex adalah indeks dari tabulator', //rcspPageFooter
  'Menghasilkan nilai Content Header dari report', //rcsContentHeader
  'ColIndex adalah indeks dari tabulator', //rcspContentHeader
  'Menghasilkan nilai Content Footer dari report', //rcsContentFooter,
  'ColIndex adalah indeks dari tabulator', //rcspContentFooter,
  'Menghasilkan nilai Content Data dari report', //rcsContentData,
  'ColIndex adalah indeks dari tabulator', //rcspContentData,
  'Menghasilkan nilai Group Header dari report', //rcsGroupHeader
  'RowIndex adalah indeks dari Group Header, ColIndex adalah indeks dari tabulator', //rcspGroupHeader
  'Menghasilkan nilai Group Footer dari report', //rcsGroupFooter,
  'RowIndex adalah indeks dari Group Header, ColIndex adalah indeks dari tabulator', //rcspGroupFooter,
  'Menghasilkan nilai Group Data dari report', //rcsGroupData,
  'ColIndex adalah indeks dari tabulator', //rcspGroupData,
  'Menampilkan nomor halaman dari Repaz', //rcsPageNumber,
  'Menampilkan nilai kunci header yang aktif dari TraTreeReport', //rcsHeaderTreeKey
  'Menampilkan nilai kunci footer yang aktif dari TraTreeReport', //rcsFooterTreeKey
  '(indexrow: integer, indexcol:integer, indextree: integer=0)', //rcsPTreeFooterValue
  'Menampilkan footer value terakhir (TraTreeReport)', //rcsTreeFooterValue
  'Menampilkan nomor urut dari data', //rcsRecordNumber
  'Menampilkan nomor urut dari master data', //rcsMasterNumber
  'Menampilkan nomor urut dari setiap seksi/bagian', //rcsDataNumber
  'Menampilkan nomor urut group tertentu', //rcsGroupNumber
  'Index adalah indeks dari group', //rcspGroupnumber
  'Menghasilkan jam sekarang dalam format DateTime',  //rcsTimeH
  'Null konstanta',  //rcsNull
  'Menghasilkan nama bulan dari tanggal',  //rcsMonthName
  'Date adalah tanggal yang akan dikonversi',  //rcsPMonthName
  'Memproses ekspresi menjadi hasil dalam Variant',  //rcsEvalText
  'Expression adalah ekspresi yang akan diproses',  //rcsPEvalText
  'Menghasilkan bulan dalam angka dari tanggal (1-12)',  //rcsMonth
  'Date adalah tanggal yang akan diproses',  //rcsPMonth
  'Menghasilkan tahun dari sebuah tanggal',  //rcsYear
  'Date tanggal yang akan dikonversi',  //rcsPyear
  'Menghasilkan hari dari sebuah tanggal (1-31)',  //rcsDay
  'Date adalah tanggal yang akan diproses',  //rcsPDay
  'Menhasilkan beberapa huruf di sebelah kanan dari string',  //rcsRight
  'Strings adalah string sumber dan Count adalah jumlah huruf yang akan diambil',  //rcsPRight
  'Menghasilkan penggalan pada posisi tertentu dari sebuah string',  //rcsSubStr
  'Strings= string sumber, Start= posisi awal pengambilan, Length= panjang string yang diambil',  //rcsPSubStr
  'Formats a string in diferent ways taking a picture of characters',  //rcsFormatStr
  'Format is the format string: ex.''dd/mm/yyyy'''+#10+' and v is the value to convert to a formated string',  //rcsPFormatStr
  'Menampilkan angka dalam bentuk kata (1=satu, 2=dua, dsb)',  //rcsNumToText
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
  'Mengganti string dalam sebuah string',  //rcsReplaceStr
  'Mencari nilai field dari datasource berdasarkan field kunci tertentu', //rcsFieldWithKey
  'Strings= string sumber, OldPattern= string didalam Strings yang akan diganti, NewPattern= string baru yang akan mengganti OldPattern', //rcsPReplaceStr
  'KeyField: nama field kunci, KeyValue: nilai field kunci, ValueField: nama field yang dicari nilainya', //rcsPFieldWithKey
  'Error on filter',  //rcsErrorFilter
  'Decode base 64 string',  //rcsDecode64
  'Converts string to binary stream',  //rcsStringToBin
  'Konversi string ke time time',   //rcsstringtotime
  'string : time string',   //rcspstringtotime
  'Konversi string ke datetime',   //rcsstringtodatetime
  'string : datetime string',   //rcspstringtodatetime
  'Konversi time ke string',   //rcstimetostring
  'time : tdatetime',   //rcsptimetostring
  'Konversi datetime ke string',   //rcsdatetimetostring
  'datetime : tdatetime',   //rcspdatetimetostring
  'Konversi datetime ke hari dalam minggu',   //rcsdayofweek
  'datetime : tdatetime',   //rcspdayofweek
  '&OK',   //rcsOK
  '&Batal',   //rcsCancel
  'Expression Creator',   //rcsExpCreator
  '&Kategori',   //rcsCategory
  '&Operasi',   //rcsOperation
  '&Tambahkan',   //rcsAddSelection
  '&Cek Sintaks',   //rcsSyntaxCheck
  'Tampilkan &Hasil',   //rcsShowresult
  'Field Database',   //rcsDbFields
  'Fungsi-fungsi',   //rcsFunctions
  'Variable',   //rcsVariables
  'Fungsi Report',   //rcsReportFunctions
  'Konstanta',   //rcsConstants
  'Operator',   //rcsOperators
  'B&ersihkan',   //rcsClear
  'Rumus benar!', //rcsmsgTrueSyntax
  //repaz
  'Desain Report',  //rcsDesignreport
  'Preview (Layar)',  //rcsPreview
  'Printer',  //rcsPrinter
  'Simpan ke file PostScript',  //rcsSavetops
  'Simpan ke file PDF',  //rcsSavetopdf
  'Simpan ke file text (CSV)',  //rcsSavetotext
  'Mendesain report untuk report yang akan dikustomisasi',  //rcsDesigninfo
  'Tampilkan report di layar kemudian bisa dicetak ke printer, simpan ke  Postscript, PDF, dll.',  //rcsPreviewinfo
  'Cetak report ke printer umum seperti LaserJet, InkJet, Dot Matrix, dll.',  //rcsPrintinfo
  'Save to PostScript file and than can print that is support PostScript or convert to another file format.',  //rcsSavetopsinfo
  'Simpan ke file PDF (Portable Document Format) sehingga nanti dapat dilihat dengan aplikasi PDF Reader seperti Adobe Acrobat Reader, dll.',  //rcsSavetopdfinfo
  'Simpan ke file text (CSV) sehingga nanti dapat dilihat dengan aplikasi spreadsheet seperti MS Excel, Open Office Calc, dll.',  //rcsSavetotextinfo
  '&Tipe Aksi',  //rcsActiontype
  'Deskripsi',  //rcsDescription
  '&Tampilkan dialog ini setiap melakukan report action',  //rcsShowdlgagain
  '&Setting',  //rcsSetting
  '&File',  //rcsMnufile
  'Ba&ru',  //rcsMnufilenew
  '&Buka',  //rcsMnufileopen
  '&Simpan',  //rcsMnufilesave
  'Simpan &Sebagai',  //rcsMnufilesaveas
  '&Keluar',  //rcsMnuexit
  '&Report',  //rcsMnureport
  '&Preview',  //rcsMnupreview
  '&Opsi-opsi',  //rcsMnuoptions
  '&Halaman',  //rcsMnupages
  '&Tambah Halaman',  //rcsMnuaddpages
  'Ha&pus Halaman',  //rcsMnuremovepages
  '&Bahasa', //rcsMnuLanguage
  '&Pertolongan',  //rcsMnuhelp
  '&Tentang',  //rcsMnuabout
  'Drag ini untuk mengatur layout',  //rcsDraginfo
  'Buat report baru',  //rcsNewreportinfo
  'Buka report yang sudah ada',  //rcsOpenreportinfo
  'Simpan report',  //rcsSavereportinfo
  'Simpan report sebagai file baru',  //rcsSaveasreportinfo
  'Tampilkan report di layar',  //rcsPreviewreportinfo
  'Tambah halaman report',  //rcsAddpageinfo
  'Hapus halaman report',  //rcsDelpageinfo
  'Pilih halaman report', //rscSelectpageinfo,
  'Pilih satuan report', //rcsSelectunitinfo,
  'Tampil/sembunyi grid',  //rcsShowgridinfo
  'Mati/hidup kunci grid',  //rcsSnapinfo
  'Keluar dari report designer',  //rcsExitinfo
  '&Print',  //rcsMnuprint
  '&Simpan ke PostScript',  //rcsMnusavetops
  'Simpan ke &PDF',  //rcsMnusavetopdf
  'Simpan ke &Text (CSV)',  //rcsMnusavetotext
  '&Pertama',  //rcsMnufirst
  '&Sebelum',  //rcsMnuprev
  '&Ke Halaman...',  //rcsMnugoto
  'Sesu&dah',  //rcsMnunext
  '&Terakhir',  //rcsMnulast
  '&Zoom',  //rcsMnuzoom
  '&Cari',  //rcsMnufind
  'Cari &kata di halaman',  //rcsMnufindtext
  'Ke halaman awal',  //rcsFirstinfo
  'Ke halaman sebelumnya',  //rcsPrevinfo
  'Ke halaman selanjutnya',  //rcsNextinfo
  'Ke halaman akhir',  //rcsLastinfo
  'Nomor halaman',  //rcsPagenumberinfo
  'Total halaman',  //rcsTotalpagesinfo
  'Zoom halaman',  //rcsZoominfo
  'Cetak report',  //rcsPrintrepinfo
  'Simpan ke file text (CSV)',  //rcsSaverepinfo
  'Simpan ke file PostScript',  //rcsSave2psinfo
  'Simpan ke file PDF',  //rcsSave2pdfinfo
  'Cari kata dalam halaman report',  //rcsFindtextinfo
  'Tampilan',  //rcsDisplay
  'Tampilkan &Grid',  //rcsLblshowgrid
  'Buat grid ter&kunci',  //rcsLblsnap
  'Ukuran grid &X',  //rcsLblgridsizex
  'Ukuran grid &Y',  //rcsLblgridsizey
  '&Satuan',  //rcsLblunit
  '&Nama Printer',  //rcsLblprintname
  'Mode &RAW',  //rcsLblrawmode
  'Informasi Printer',  //rcsLblprintinfo
  '&Umum',  //rcsCapgeneral
  'Mode R&AW',  //rcsCaprawmode
  'Pemilihan Halaman',  //rcsCappagessel
  'Semu&a',  //rcsLblall
  '&Range',  //rcsLblrange
  '&Rangkap',  //rcsLblcopies
  'Ukuran Kerta&s',  //rcsCappapersize
  '&Lebar (mm)',  //rcsLblwidth
  '&Tinggi (mm)',  //rcsLblheight
  '&Kode Printer',  //rcsLblprintercode
  'Halaman &bersambung terus',  //rcsLblcontinuespage
  '&Keluarkan kertas dari printer jika selesai',  //rcsLbleject
  '&Potong kertas jika selesai',  //rcsLblcutpaper
  'Ti&dak membuka',  //rcsLbldontopen
  'Buka sebelum &cetak',  //rcsLblopenbefore
  'Buka sete&lah cetak',  //rcsLblopenafter
  'Simpan desain report',  //rcsCapsaverepdesign
  'Silakan tulis nama file report!',  //rcsMsgtyperepfn
  'Simpan Desain Report Sebagai',  //rcsCapsaverepas
  'Report minimal mempunyai 1 halaman!',  //rcsMsgmin1page
  'Fitur ini tidak membutuhkan konfigurasi!',  //rcsMsgprevnotconfig
  'Desainer report tidak diaktifkan!',  //rcsMsgdesignnotactive
  'Preview report tidak diaktifkan!',  //rcsMsgpreviewnotactive
  'Cetak report ke printer tidak diaktifkan!',  //rcsMsgprintnotactive
  'Simpan ke file PostScript',  //rcsCapsave2ps
  'File PostScript',  //rcsLblpostscript
  'Simpan ke file PDF (Portabel Data Document)', //rcsCapsave2pdf
  'File PDF', //rcsLblpdf,
  'Simpan ke file text (CSV)', //rcsCapsave2text,
  'File text/CSV', //rcsLbltext,
  'Semua file',  //rcsLblallfiles
  'Silakan tulis nama file output untuk PostScript!',  //rcsMsgtypepsfn
  'Simpan Repaz Metafile',  //rcsCapsave2metapage
  'Repaz Metafiles',  //rcsLblmetapage
  'Silakan tulis nama file output untuk Repaz Metafile!',  //rcsMsgtypemetapagefn
  'Simpan ke file tidak diaktifkan!',  //rcsMsgsavefilenotactive
  'Report tidak bisa dibuka!',  //rcsMsgreportnotopen
  'Class dari komponen report tidak ditemukan : ',  //rcsMsgclassnotfound  
  'Anda yakin akan menghapus halaman ini?', //rcsMsgdeletepage
  'Hapus Halaman', //rcsCapdeletepage
  'File report tidak ditemukan!', //rcsMsgReportFileNotFound
  'Buat report baru?', //rcsMsgCreateNewReport
  'Konfirmasi', //rcsCapConfirmation
  '&Edit', //rcsMnuedit
  '&Salin', //rcsMnucopy
  '&Potong', //rcsMnucut
  '&Tempel', //rcsMnupaste
  '&Hapus', //rcsMnudelete
  '&Batal Hapus', //rcsMnuundelete
  'Ke &Depan', //rcsMnutofront
  'Ke Be&lakang', //rcsMnutoback
  'Salin ke memory', //rcshintcopy
  'Potong ke memory', //rcshintcut
  'Tempel dari memory', //rcshintpaste
  'Hapus', //rcshintdelete
  'Batalkan penghapusan', //rcshintundelete
  'Pindahkan obyek ke depan obyek lain', //rcshinttofront
  'Pindahkan obyek ke belakang obyek lain', //rcshinttoback
  'Field harus dalam tipe angka (Currency,Integer,dll.)', //rcsFieldmustnumber
  'sama dengan', //rcsequal
  'tidak sama dengan', //rcsnotequal
  'lebih besar dari', //rcsgreater
  'lebih besar atau sama dengan', //rcsgreaterequal
  'kurang dari', //rcsless
  'kurang dari atau sama dengan', //rcslessequal
  'seperti (dengan wilcards)', //rcslike
  'antara 2 nilai', //rcsbetween
  'Filter Data', //rcsfilterform
  'Pakai &Filter', //rcsApplyFilter,
  '&Hapus Filter', //rcsRemoveFilter,
  '&Tutup', //rcsClose,
  'Field &yang difilter', //rcsFieldToFind,
  '&Operan', //rcsOperand,
  '&Nilai Field', //rcsFieldValue,
  'Field bernilai benar', //rcsFieldBoolValue,
  'Untuk operan [LIKE] adalah untuk data text saja, anda dapat menggunakan wilcard *, seperti : *abc, abc*xyz, abc*, etc.', //rcsHintForLike,
  '&Hari', //rcscapDay,
  '&Bulan', //rcscapMonth,
  '&Tahun', //rcscapYear
  'Menampilkan nilai dari header pada tabel tertentu', //rcstableheader
  'TableIndex adalah indeks dari table, RowIndex adalah index dari header, ColIndex adalah indeks dari tabulator pada baris tertentu', //rcsptableheader
  'Menampilkan nilai dari footer pada tabel tertentu', //rcstablefooter
  'TableIndex adalah indeks dari table, RowIndex adalah index dari footer, ColIndex adalah indeks dari tabulator', //rcsptablefooter
  'Menampilkan nilai dari cell pada baris dan kolom yang ditentukan pada letter', //rcsplettervalue
  'RowIndex adalah indeks dari LetterContent, ColIndex adalah indeks dari tabulator', //rcslettervalue
  'Variable seharusnya berupa field database (datasource.fieldname)!', //rcsNotField
  'Simpan perubahan?', //rcsAskSave
  'Menguji apakah tanggal ini adalah hari libur', //rcsisholiday
  'ADate : tanggal yang diuji; IncludeSunday : apakah hari Minggu termasuk hari libur', //rcspisholiday
  'Menguji apakah tanggal ini adalah hari libur', //rcsisdiscountday
  'ADate : tanggal yang diuji; IncludeSunday : apakah hari Minggu termasuk hari libur' //rcspisdiscountday
  );

