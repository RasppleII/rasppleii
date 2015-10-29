<?php

$orig_json = false;
try {
    $orig_json = file_get_contents("http://downloads.raspberrypi.org/os_list_v2.json", NULL, stream_context_create(array('http'=>array('ignore_errors'=>true))));
    $rasppleII_entry = file_get_contents("http://ivanx.com/rasppleii/noobs-os/rasppleii_entry.json", NULL, stream_context_create(array('http'=>array('ignore_errors'=>true))));
} catch (Exception $e) {
    exit;
}

if (strpos($orig_json, '"os_list": [') === false || strpos($rasppleII_entry, "Raspple II") === false) {
    exit;
}

header('Content-Type: application/json');
$jsonParts = explode("{", $orig_json);

$newParts = array();
$thisNewPart = "";
$c = 0;

$a = count($jsonParts);
for ($x = 0; $x <= $a; $x++) {
    $thisPart = $jsonParts[$x];
    $c++;
    $thisNewPart .= $thisPart;
    $c = ($c - substr_count($thisPart, "}"));
    if ($c <= 2) {
        $newParts[] = $thisNewPart;
        $thisNewPart = "";
    }
}

$a = count($newParts);
for ($x = 0; $x <= $a; $x++) {
    if (strpos($newParts[$x], '"os_name": "Raspbian"') !== false) {
        $newParts[$x] = $rasppleII_entry;
        break;
    }
}

echo implode("{", $newParts)

// echo "---------";
// echo $orig_json;


/*
orig version:
        {
            "feature_level": 35120124,
            "flavours": [
                {
                    "description": "A version of Raspbian that boots straight into Scratch",
                    "feature_level": 35120124,
                    "icon": "http://downloads.raspberrypi.org/raspbian/Raspbian_-_Boot_to_Scratch.png",
                    "name": "Raspbian - Boot to Scratch",
                    "supported_hex_revisions": "2,3,4,5,6,7,8,9,d,e,f,10,11,12,14,19,1040,1041"
                },
                {
                    "description": "A Debian wheezy port, optimised for the Raspberry Pi",
                    "feature_level": 35120124,
                    "icon": "http://downloads.raspberrypi.org/raspbian/Raspbian.png",
                    "name": "Raspbian",
                    "supported_hex_revisions": "2,3,4,5,6,7,8,9,d,e,f,10,11,12,14,19,1040,1041"
                }
            ],
            "icon": "http://downloads.raspberrypi.org/raspbian/Raspbian.png",
            "marketing_info": "http://downloads.raspberrypi.org/raspbian/marketing.tar",
            "nominal_size": 2760,
            "os_info": "http://downloads.raspberrypi.org/raspbian/os.json",
            "os_name": "Raspbian",
            "partition_setup": "http://downloads.raspberrypi.org/raspbian/partition_setup.sh",
            "partitions_info": "http://downloads.raspberrypi.org/raspbian/partitions.json",
            "release_date": "2015-02-16",
            "supported_hex_revisions": "2,3,4,5,6,7,8,9,d,e,f,10,11,12,14,19,1040,1041",
            "tarballs": [
                "http://downloads.raspberrypi.org/raspbian/boot.tar.xz",
                "http://downloads.raspberrypi.org/raspbian/root.tar.xz"
            ]
        },

change to:
        {
            "feature_level": 35120124,
            "flavours": [
                {
                    "description": "Raspbian with A2SERVER, A2CLOUD, and Apple II Pi",
                    "feature_level": 35120124,
                    "icon": "http://ivanx.com/rasppleii/files/Raspple_II.png",
                    "name": "Raspple II",
                    "supported_hex_revisions": "2,3,4,5,6,7,8,9,d,e,f,10,11,12,14,19,1040,1041"
                }
            ],
            "icon": "http://ivanx.com/rasppleii/noobs-os/Raspple_II.png",
            "marketing_info": "http://ivanx.com/rasppleii/noobs-os/slidesAB.tar",
            "nominal_size": 2760,
            "os_info": "http://ivanx.com/rasppleii/noobs-os/os.json",
            "os_name": "Raspple II",
            "partition_setup": "http://ivanx.com/rasppleii/noobs-os/partition_setup.sh",
            "partitions_info": "http://ivanx.com/rasppleii/noobs-os/partitions.json",
            "release_date": "2015-03-01",
            "supported_hex_revisions": "2,3,4,5,6,7,8,9,d,e,f,10,11,12,14,19,1040,1041",
            "tarballs": [
                "http://ivanx.com/rasppleii/noobs-os/boot.tar.xz",
                "http://ivanx.com/rasppleii/noobs-os/root.tar.xz"
            ]
        },
        {

*/

?>
