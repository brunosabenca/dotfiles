function music2kepler
    set selected (find /mnt/extra/Music -mindepth 1 -type d | fzf --prompt "Sync to kepler: ")
    if test -z "$selected"
        return
    end

    set relative (string replace "/mnt/extra/Music/" "" $selected)
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

    set cover_re '(?i)^(cover|folder|album|front|albumart)\.(jpg|jpeg|png|webp)$'
    lftp -u bruno,arstneio -e "mirror -R --only-newer --exclude-glob '*.flac' --exclude-glob '*.ape' --exclude '$cover_re' \"$selected\" \"$remote\"$put_cmd; bye" ftp://192.168.1.134
end
