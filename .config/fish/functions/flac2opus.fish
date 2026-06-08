function flac2opus
    set dir (if test (count $argv) -gt 0; echo $argv[1]; else; echo .; end)
    find $dir -type f -name "*.flac" | while read -l f
        set out (string replace -r '\.flac$' '.opus' $f)
        if not test -f $out
            ffmpeg -i $f -c:a libopus -b:a 128k $out
        end
    end
end
