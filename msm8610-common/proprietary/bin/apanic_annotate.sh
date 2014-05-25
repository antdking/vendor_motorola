#!/system/bin/sh
#
# Copyright (c) 2012, Motorola Mobility LLC,  All rights reserved.
#
# The purpose of this script is to annotate panic dumps with useful information
# about the context of the event.
#

export PATH=/system/bin:$PATH

annotate()
{
    VAL=`$2`
    [ "$VAL" ] || return

    # Elaborate trick to prevent multiple annotations, due to shell limitations
    PREVIFS="$IFS"
    IFS="
"
    for LINE in `cat /proc/apanic_annotate` ; do
        if [ ${LINE%:*} = "$1" ] ; then
            IFS="$PREVIFS"
            return
        fi
    done
    IFS="$PREVIFS"

    echo "$1: $VAL" > /proc/apanic_annotate
}

case $1 in
    build*)
        annotate "Build number" "getprop ro.build.display.id"
        annotate "Build config" "getprop ro.build.config.version"
        annotate "Kernel version" "cat /proc/sys/kernel/osrelease"
        ;;
    baseband*)
        annotate "Baseband version" "getprop gsm.version.baseband"
        ;;
esac
