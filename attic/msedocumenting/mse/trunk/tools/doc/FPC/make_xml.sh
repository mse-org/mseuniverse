#!/bin/sh

cpu=`ppc386 -l | head -1 | awk '{ print $NF }'`
os=`uname | tr "LW" "lw"`
subos=
[ $os == "linux" ] && subos="unix"
[ $os == "win32" ] && subos="win32"
[ $os == "windows" ] && subos="win32"

#fpc_ver=`fpc -l | head -1 | awk '{ print $5; }'`

this_dir=`pwd`

# reading the settings
source ../ini/fplib_doc.ini

[ -d $fpc_doc_root ] || mkdir -p -- $fpc_doc_root || exit
#*******************************************************************************************
function one_dir () {
# $1 : output directory for XML-files
# $2 : package name to write in XML-files
# $3 : -Fi<include_dir>-s & -d<define>-s 

  local in_file; local out_file;

  for in_file in `ls -A1 *.pas *.pp 2>/dev/null`; do
    cat ./$in_file | head -40 | egrep -ie "^[ \t]*program[[:space:]]+[[:alpha:]]+[_[:alnum:]]*[[:space:]]*;" >/dev/null && continue  
    out_file=$1"/"`echo $in_file | sed "s/\.\(pas\|pp\)$/\.xml/"`
#    out_file1="${out_file}.xxx"
    
    echo "  ${in_file} -> ${out_file}"
    [ -f $out_file ] || rm -f -- $out_file

    bl_err=n
    if [ "$blacklist_fpc" != "" ]; then
	for bl in $blacklist_fpc; do
	    echo  $out_file | egrep -e $bl && {
		echo "...skipping black listed file $in_file"
		bl_err=y
	    }
	done
    fi
    
    if [ $bl_err == n ]; then
	
#	in_file1="${in_file}.xxx"
#	cat ./${in_file} | egrep -ve "operator[ \t]+(\>|\<)+" > ./${in_file1}
    
	if ! makeskel --package=$2 --input=./${in_file}" $3" --output=${out_file} --disable-private --disable-protected; then
    	    rm -f -- ${out_file}
#	else
#	    cat $out_file1 | \
#		sed -e "s/operator[ \t]\+<[ \t]*(/operator \&lt;(/"  | \
#		sed -e "s/operator[ \t]\+<=[ \t]*(/operator \&le;(/" | \
#		sed -e "s/operator[ \t]\+>[ \t]*(/operator \&gt;(/"  | \
#		sed -e "s/operator[ \t]\+>=[ \t]*(/operator \&ge;(/" \
#		> $out_file && rm -f -- ${out_file1}
#	    cat $out_file1 > $out_file && rm -f -- ${out_file1}
	fi
#	rm -f -- ./${in_file1}
    fi

  done
}
#---------- RTL start ----------------------------------------
ref=
defs=
inc_dirs=
xml_descr=
#--------------
function do_it () {
  local inc_dirs1;

# if docs dir does not exist then to create it  
  xml_dir="${fpc_doc_root}/xml/$ref"
  rm -rf -- $xml_dir
  mkdir -p -- $xml_dir || exit 0
  cp -f -- $this_dir/../xml_templates/${xml_descr}.xml $xml_dir/

  for dir in $1; do
    src_dir=${fpc_src_dir}/$ref/${dir}
    inc_dirs1="-Fi./ -Fi${src_dir} ${inc_dirs}"
    tmp=`echo -e $dir | awk -v R=$fpc_src_dir/ '{ gsub(R,"",$0); print $0; }'`
#    out_dir=`echo -e "${xml_dir}/${tmp}" | sed -e "s/\/src//" | sed -e "s/\/packages\/fcl-/\/fcl\//"`
#    out_dir=`echo -e "${xml_dir}/${tmp}" | sed -e "s/\/src//"`
    out_dir="${xml_dir}/${tmp}"
#   package name may not contain "-"    
    pkg_name=`echo -e $tmp | tr "+\/-" "_"`
    mkdir -p -- $out_dir

#   the only way to correctly process "../*" path references in the source files
    cd $src_dir || exit
    echo -e "\nEntering ${src_dir}..."
    one_dir $out_dir $pkg_name "$inc_dirs1 $defs"
  done
}

#---------- RTL ----------------------------------------
function do_rtl () {
  ref="rtl"
  xml_descr="rtl"

  for id in $rtl_inc_dirs; do
    inc_dirs="${inc_dirs} -Fi${fpc_src_dir}/$ref/${id}"
  done

  for def in $rtl_defines; do
    defs="${defs} -d${def}"
  done

  do_it "$rtl_dirs"
}

#---------- PACKAGES ----------------------------------------
function do_pkg () {
  ref="packages"
  xml_descr="packages"
  defs=
  inc_dirs=

  for id in $pkg_inc_dirs; do
    inc_dirs="${inc_dirs} -Fi${fpc_src_dir}/$ref/${id}"
  done

  for def in $pkg_defines; do
    defs="${defs} -d${def}"
  done

  do_it "$pkg_dirs"
}

do_rtl;
do_pkg;

cd $this_dir; exit 0
