function music2kepler
    set selected (find /mnt/extra/Music -mindepth 1 -type f \( -name "*.opus" -o -name "*.mp3" -o -name "*.flac" -o -name "*.ape" -o -name "*.wv" \) -printf '%h\n' | sort -u | fzf --prompt "Sync to kepler: ")
    if test -z "$selected"
        return
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

    # Mirror everything except cover art and lossless sources
    # then upload cover separately with normalised name
    set put_cmd ""
    if test -n "$cover_src"
        set put_cmd "; put \"$cover_src\" -o \"$remote/$cover_dest\""
    end

    set cover_exclude ""
    if test -n "$cover_src"
        set cover_exclude "--exclude-glob '"(basename "$cover_src")"'"
    end
    lftp -u bruno,arstneio -e "mirror -R --only-newer --exclude-glob '*.flac' --exclude-glob '*.ape' $cover_exclude \"$selected\" \"$remote\"$put_cmd; bye" ftp://192.168.1.134
end
