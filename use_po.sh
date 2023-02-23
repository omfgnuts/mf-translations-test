#!/bin/zsh
# SRCDIR root of the documentation repository
# PODIR place where to create the po
# PUB_DIR place where to publish localized files

# USER-CONFIGURABLE VARIABLES

# This value is used to compare with the output of pocount
# 0 means we do not want any non-translated string, i. e. if there is even just 1 untranslated string, output will be 100% English
TRANSLATION_THRESHOLD_STRINGS=0

# This value is used by po4a
TRANSLATION_THRESHOLD_PERCENTAGE=0

############################################### DO NOT MODIFY BELOW THIS LINE ###################################

####################################
# INITIALIZE VARIABLES
####################################

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

SRCDIR_MODULE="./docs"

# place where the po files are
if [ -z "$PO_DIR" ] ; then
	PO_DIR="./l10n/po"
fi

# place where the localized files will be
if [ -z "$PUB_DIR" ] ; then
	PUB_DIR="./l10n/translations"
fi


####################################
# TEST IF IT CAN WORK
####################################

if [ ! -d "$SRCDIR_MODULE" ] ; then
	echo "Please run this script from the documentation' root folder"
	exit 1
fi



#######################################################################
# GENERATE TRANSLATED ASCIIDOC FROM .PO FILES, WITHOUT UPDATING .POT/PO
#######################################################################

for f in $(ls $CURRENT_DIR/$PO_DIR/*.cfg); do
    po4a --srcdir $CURRENT_DIR --destdir $CURRENT_DIR -k $TRANSLATION_THRESHOLD_PERCENTAGE -M utf-8 -L utf-8 --no-update -o nolinting $f
done



####################################################################
# IF NOT TRANSLATED 100%, OVERWRITE WITH ENGLISH
# TODO: Merge this with the above (generating asciidoc from po files) to save some processing
####################################################################

#if [ -f $CURRENT_DIR/for-publication ]; then
#    for module in $(find $CURRENT_DIR/$PO_DIR -mindepth 1 -maxdepth 1 -type d -printf "%f\n"); do
#        for langpo in $(find $CURRENT_DIR/$PO_DIR/$module -mindepth 1 -maxdepth 1 -type f -name "*.po" -printf "%f\n"); do
#            lang=`basename $langpo .po`
#            untranslated_strings=`pocount-3.8 --csv $CURRENT_DIR/$PO_DIR/$module/$langpo | tail -n 1 | cut -d ',' -f 7 | sed -e 's/^[ \t]*//'`
#            if (($untranslated_strings > $TRANSLATION_THRESHOLD_STRINGS)); then
#                mkdir -p $CURRENT_DIR/$PUB_DIR/$lang/modules/$module
#                cp -a $CURRENT_DIR/modules/$module/* $CURRENT_DIR/$PUB_DIR/$lang/modules/$module
#                touch $CURRENT_DIR/$PUB_DIR/$lang/modules/$module/_overwritten-with-English
#            fi
#        done
#    done
#fi