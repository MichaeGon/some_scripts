#! /bin/sh

# qemu x86_64, boot from floppy a, 
qemu-system-x86_64 -boot once=a -fda ${1} -monitor stdio
