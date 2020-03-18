#!/bin/bash

function nice_19()
{
    echo $(date) "Start process  with nice 19" 
    nice -n 19 gzip -c /boot /var /usr >/tmp/nice_19.gz >/dev/null 2>&1
}

function nice_20()
{
    echo $(date) " Start process  with nice -20"
    nice -n -20 gzip -c /boot /var /usr >/tmp/nice_20.gz >/dev/null 2>&1
}

time nice_19
time nice_20