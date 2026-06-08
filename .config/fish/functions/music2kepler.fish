function music2kepler
    set selected (find /mnt/extra/Music -mindepth 1 -type f \( -name "*.opus" -o -name "*.mp3" -o -name "*.flac" -o -name "*.ape" -o -name "*.wv" \) -printf '%h\n' | sort -u | fzf --prompt "Sync to kepler: ")
    if test -z "$selected"
        return
    end

    # Convert lossless sources to Opus 128k if needed
    set cue (find "$selected" -maxdepth 1 -name "*.cue" | head -1)
    if test -n "$cue"
        echo "Splitting CUE+lossless → Opus..."
        python3 ~/.local/bin/splitcue.py "$cue" "$selected"
    else
        set lossless (find "$selected" -maxdepth 1 \( -name "*.flac" -o -name "*.ape" -o -name "*.wv" \))
        if test -n "$lossless"
            echo "Converting lossless → Opus..."
            for f in $lossless
                set out (string replace -r '\.(flac|ape|wv)$' '.opus' $f)
                if not test -f $out
                    ffmpeg -i $f -c:a libopus -b:a 128k -map_metadata 0 -vn $out 2>/dev/null
                    and echo "  "(basename $out)
                end
            end
        end
    end

    set relative (string replace "/mnt/extra/Music/" "" $selected | string replace -a ': ' ' - ' | string replace -a ':' ' - ')
    set remote "foobar2000 Music Folder/$relative"

    # Find cover art
    set cover_src ""
    set cover_dest ""
    for f in "$selected"/{cover,Cover,folder,Folder,album,Album,front,Front,albumart,AlbumArt}.{jpg,jpeg,png,webp}
        if test -f "$f"
            set ext (string lower (string match -r '\.[^.]+$' "$f"))
            set cover_src "$f"
            set cover_dest "cover$ext"
            break
        end
    end

    # Mirror everything except lossless sources and cover art,
    # then upload cover separately with normalised name
    set put_cmd ""
    if test -n "$cover_src"
        set put_cmd "; put \"$cover_src\" -o \"$remote/$cover_dest\""
    end

    set cover_exclude ""
    if test -n "$cover_src"
        set cover_exclude "--exclude-glob '"(basename "$cover_src")"'"
    end

    echo "Syncing to kepler..."
    lftp -u bruno,arstneio -e "mirror -R --only-newer --exclude-glob '*.flac' --exclude-glob '*.ape' --exclude-glob '*.wv' $cover_exclude \"$selected\" \"$remote\"$put_cmd; bye" ftp://192.168.1.134
end
