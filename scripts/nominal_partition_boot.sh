#! /bin/bash
# vim: set tabstop=4 shiftwidth=4 filetype=sh:

# NOOBS requires an OS's partitions.json to tell it how big a partition should
# be, nominally speaking.  As of August 2016, 63 megs is regarded as sufficient
# for the /boot filesystem and the tarball of the filesystem is about 1/3 that
# size.  However should the tarball ever get to witnin 12 megs of the partition
# size, we'll increase it in 64 meg increments.

base_size=63
expand_increment=64
space_margin=12

echo $(( $base_size + ((($1 + $space_margin) / $base_size) * $expand_increment) ))


