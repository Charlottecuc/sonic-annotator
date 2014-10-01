#!/bin/bash

mypath=`dirname $0`
r=$mypath/../sonic-annotator

tmpfile=$mypath/tmp_1_$$

trap "rm -f $tmpfile" 0

. test-include.sh

transform=$mypath/transforms/transforms-summaries-percussiononsets-detectionfunction.n3 

# Note, the output here depends on all the audio files present -- we
# would have to regenerate it if we added more test audio files
$r -t $transform -w csv --csv-stdout $mypath -r --summary-only > $tmpfile 2>/dev/null || \
    fail "Fails to run transform $transform with recursive dir option"

expected=$mypath/expected/transforms-summaries-percussiononsets-all-files
csvcompare $tmpfile $expected.csv || \
    fail "Output mismatch for transform $transform with summaries and recursive dir option"

# Here we remove any leading path from the audio file in the output,
# because the playlist reader will have resolved files to absolute
# paths and those will differ between systems
$r -t $transform -w csv --csv-stdout $mypath/audio/playlist.m3u --summary-only 2>/dev/null | sed 's,^"\.*/[^"]*/,",' > $tmpfile || \
    fail "Fails to run transform $transform with playlist input"

expected=$mypath/expected/transforms-summaries-percussiononsets-playlist
csvcompare $tmpfile $expected.csv || \
    fail "Output mismatch for transform $transform with summaries and playlist input"



