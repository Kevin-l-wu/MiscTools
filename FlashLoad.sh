#!/bin/bash

OPENOCD_PATH=/usr/local/Cellar/open-ocd/0.11.0/share/openocd
INTERFACE=stlink-v2.cfg
TARGET=stm32f4x.cfg

#echo "\$#=$#"

# check
if [ $# -ne 1 ]
then
    echo "usage: FlashLoad.sh <.bin>"
    exit 1
fi

# download
openocd -f $OPENOCD_PATH/scripts/interface/$INTERFACE -f $OPENOCD_PATH/scripts/target/$TARGET -c init -c "reset halt" -c "flash write_image erase $1 0x08000000" -c shutdown

