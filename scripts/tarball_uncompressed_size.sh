#! /bin/bash
# vim: set tabstop=4 shiftwidth=4 filetype=sh:

# NOOBS uses .tar.xz files for its root and /boot partitions and the JSON file
# should be updated with the unpacked size of these files.  The xz command can
# generate this in a human-readable format with xz --robot -l <file>, with
# output looking something like:
#
# name    boot.tar.xz
# file    1       1       11744760        20910080        0.562   CRC64   0
# totals  1       1       11744760        20910080        0.562   CRC64   0       1
#
# We only need the last line (tail -1) and the 5th tab-separated field (cut -d
# "\t" -f 5).
#
# That's not enough, however, since that's the number of bytes.  We need the
# number of megabytes (10^6), rounding up.  Bash's builtin division is
# integer-based, so we first must add just shy of one megabyte before dividing.  The result is fit to echo.


if [[ -n "$1" ]]; then
	# FIXME: Maybe handle anything besides .tar.xz here?
	tarball_bytes="$(xz --robot -l $1 | tail -1 | cut -d "	" -f 5)"
	tarball_megs=$(( ($tarball_bytes + 999999) / 1000000 ))
	echo "$tarball_megs"
else
	echo "Usage: $0 <tarball>"
	exit 1
fi

