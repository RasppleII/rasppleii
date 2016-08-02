#! /bin/bash
# vim: set tabstop=4 shiftwidth=4 filetype=sh:

# NOOBS requires an OS's partitions.json to tell it how big a partition should
# be, nominally speaking.  The root partition is generally set up to take up
# all space not otherwise allocated, rather than being some approximately fixed
# size as is done for the boot partition.  Still, it should be at least big
# enough to boot the OS, and so we simply take the number on the command line
# and add 400 to it, which is what Raspbian seems to be doing for the time
# being.

space_margin=400

echo $(( $1 + $space_margin ))

