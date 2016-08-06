#! /bin/bash
# vim: set tabstop=4 shiftwidth=4 filetype=sh:

boot_tar_xz='boot.tar.xz'
root_tar_xz='root.tar.xz'

boot_base_size=63
boot_expand_increment=64
boot_margin_size=12

root_margin_size=400


# tarball_expanded_size - determine uncompressed size of .tar.xz file
# returns	Size expanded size of the tarball rounded up to the next megabyte
# $1		Name of an xz-compressed tarball
#
# NOOBS uses .tar.xz files to populate partitions, and partitions.json needs to
# indicate their expanded size.  Fortunately xz --robot -l <file> gives us
# output like this:
#
# name    boot.tar.xz
# file    1       1       11744760        20910080        0.562   CRC64   0
# totals  1       1       11744760        20910080        0.562   CRC64   0       1
#
# Fields are tab-separated, and the 5th field of the last line contains the
# number we need in bytes.  We need only round up from there to the next meg
# (10^6) and return that value.  This is potentially different than du(1) would
# output for actual disk usage, but this is how Raspbian images appear to be
# generated, so we'll go with that for now.
tarball_expanded_size()
{
	local tarball_bytes tarball_megs

	tarball_bytes="$(xz --robot -l $1 | tail -1 | cut -d "	" -f 5)"
	tarball_megs=$(( ($tarball_bytes + 999999) / 1000000 ))
	echo "$tarball_megs"
}


# boot_nominal_size - Determine approx. size of boot partition
# returns   Nominal (minimum) size of boot partition
# $1		Size of the expanded boot.tar.xz file
#
# NOOBS expects partitions.json to tell it how large the boot partition should
# be.  The partition we get may not be precisely this size, but it should be at
# least this big.  Since overlays and kernels and potentially other things live
# in this partition, we'll try to give the user at least $boot_margin_size
# free.  If that number is larger than $boot_base_size (63 megs in August
# 2016), we'll expand the boot partition in increments of $boot_expnd_increment
# until the requisite margin is available.
boot_nominal_size()
{
	local boot_size_multiplier=$(( ($1 + $boot_margin_size) / $boot_base_size ))
	echo $(( $boot_base_size + ($boot_size_multiplier * $boot_expand_increment) ))
}


# root_nominal_size - Determine approx. size of root partition
# returns   Nominal (minimum) size of root partition
# $1		Size of the expanded root.tar.xz file
#
# NOOBS expects partitions.json to tell it how large the root partition should
# be, at a minimum.  In Raspbian, this is the expanded size of the root
# filesystem, plus a fixed amount (400 as of August 2016).  This value is set
# by $root_margin_size.
root_nominal_size()
{
	echo $(( $1 + $root_margin_size ))
}



if [[ ! -e "$boot_tar_xz" ]]; then
	echo "$0: file not found: boot tarball \"$boot_tar_xz\" does not exist."
	exit 1
fi
if [[ ! -e "$root_tar_xz" ]]; then
	echo "$0: file not found: root tarball \"$root_tar_xz\" does not exist."
	exit 1
fi

#install -m 755 -d out

gen_boot_tarball_size="$(tarball_expanded_size $boot_tar_xz)"
gen_boot_nominal_size=$(boot_nominal_size $gen_boot_tarball_size)
gen_root_tarball_size="$(tarball_expanded_size $root_tar_xz)"
gen_root_nominal_size=$(root_nominal_size $gen_boot_tarball_size)

cat >out/partitions.json <<EOF
{
    "partitions": [
        {
            "filesystem_type": "FAT",
            "label": "boot",
            "partition_size_nominal": $gen_boot_nominal_size,
            "uncompressed_tarball_size": $gen_boot_tarball_size,
            "want_maximised": false
        },
        {
            "filesystem_type": "ext4",
            "label": "root",
            "mkfs_options": "-O ^huge_file",
            "partition_size_nominal": $gen_root_nominal_size,
            "uncompressed_tarball_size": $gen_root_tarball_size,
            "want_maximised": true
        }
    ]
}
EOF
