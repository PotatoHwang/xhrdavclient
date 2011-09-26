#!/bin/bash - 
#===============================================================================
#
#          FILE:  builder.sh
# 
#         USAGE:  ./builder.sh 
# 
#   DESCRIPTION:  Integrate script file by closurebuilder.py
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR: YOUR NAME (), 
#       COMPANY: 
#       CREATED: 2011/09/22 13時43分28秒 JST
#      REVISION:  ---
#===============================================================================

#set -o nounset                              # Treat unset variables as an error

usage() {
  echo "USAGE: ./tools/$(basename $0) [-a | -g | -s | -w]"
  echo "Options:"
  echo "  -a: Compiling scripts with 'ADVANCED_OPTIMIZATIONS' by closure compiler"
  echo "  -f: output formatting(PRETTY_PRINT, etc.)"
  echo "  -g: Generate integrate scripts WITHOUT OPTIMIZATIONS [DEFAULT]"
  echo "  -h: Print help"
  echo "  -s: Compiling scripts with 'SIMPLE_OPTIMIZATIONS' by closure compiler"
  echo "  -w: Compiling scripts with 'WHITESPACE_ONLY' by closure compiler"
  echo "  -r: Release build(goog.DEBUG=false)"
} 1>&2

while getopts af:ghrsw OPT
do
  case $OPT in
  "a") FLG_ADVANCED="TRUE" ;;
  "f") FLG_FORMAT="TRUE"; FORMAT_PRINT="$OPTARG" ;;
  "g") FLG_GENERAGE="TRUE" ;;     # DEFAULT
  "s") FLG_SIMPLE="TRUE" ;;
  "r") FLG_RELEASE="TRUE" ;;
  "w") FLG_WHITESPACE_ONLY="TRUE" ;;
  "h"|* ) usage
    exit 1 ;;
  esac
done

PYTHON=$(which python)
OUTPUTFILE="xhrdavclient.js"
ROOTS=(
  'closure-library/'
  'scripts/'
)
NAMESPACES=(
  'xhrdav.lib.Client'
  'xhrdav.lib.HttpStatus'
  'xhrdav.lib.DomParser'
  'xhrdav.lib.DomHandler'
  'xhrdav.lib.MultiStatusDomHandler'
)

rootdir=
for d in ${ROOTS[@]}; do rootdir+=" --root=$d"; done

entries=
for n in ${NAMESPACES[@]}; do entries+=" -n $n"; done

if [ "$FLG_ADVANCED" = "TRUE" ]; then
  options='-c tools/compiler/compiler.jar -f "--compilation_level=ADVANCED_OPTIMIZATIONS" -o compiled'
elif [ "$FLG_SIMPLE" = "TRUE" ]; then
  options='-c tools/compiler/compiler.jar -f "--compilation_level=SIMPLE_OPTIMIZATIONS" -o compiled'
elif [ "$FLG_WHITESPACE_ONLY" = "TRUE" ]; then
  options='-c tools/compiler/compiler.jar -f "--compilation_level=WHITESPACE_ONLY" -o compiled'
else
  options='-o script'
fi

# Release build with debug off
if [ "$FLG_RELEASE" = "TRUE" ]; then
  options+=' -f "--define=goog.DEBUG=false"'
fi

# Add optimized script debug option
if [ "$FLG_FORMAT" = "TRUE" ]; then
  options+=' -f "--formatting='$FORMAT_PRINT'"'
fi


command="$PYTHON closure-library/closure/bin/build/closurebuilder.py --output_file=$OUTPUTFILE"
echo $command $rootdir $entries $options | bash
[ $? -ne 0 ] && usage