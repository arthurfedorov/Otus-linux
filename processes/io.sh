#!/bin/bash
time ionice -c 1 dd if=/dev/urandom of=test1.img bs=1M count=20 &
time ionice -c 3 dd if=/dev/urandom of=test3.img bs=1M count=20 &
wait