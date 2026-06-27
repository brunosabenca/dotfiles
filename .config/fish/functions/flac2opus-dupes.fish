function flac2opus-dupes
    set dir (if test (count $argv) -gt 0; echo $argv[1]; else; echo .; end)
    find $dir -type f -name "*.opus" -print0 \
        | xargs -0 sha256sum \
        | sort \
        | awk 'seen[$1]++ { print "DUPE:", $0 }'
end
