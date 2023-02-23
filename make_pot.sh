#!/bin/zsh

####################################
# INITILIZE VARIABLES
####################################

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# root of the documentation repository
SRCDIR_MODULE="./docs"

# place where the po files are
if [ -z "$PO_DIR" ] ; then
	PO_DIR="./l10n/po"
fi

####################################
# TEST IF IT CAN WORK
####################################

if [ ! -d "$SRCDIR_MODULE" ] ; then
    echo "Error, please check that SRCDIR match to the root of the documentation repository"
    echo "You specified modules are in $SRCDIR_MODULE"
    exit 1
fi

#######################################################################
# UPDATE/GENERATE .POT/.PO FILES WITHOUT GENERATING TRANSLATED ASCIIDOC
#######################################################################

for f in `ls $CURRENT_DIR/$PO_DIR/*.cfg`; do
    po4a -v --srcdir $CURRENT_DIR --destdir $CURRENT_DIR -k 0 -M utf-8 -L utf-8 --no-translations -o nolinting $f
done