function music2kepler
    set selected (find /mnt/extra/Music -mindepth 1 -type d | fzf --prompt "Sync to kepler: ")
    if test -z "$selected"
        return
    end

    set relative (string replace "/mnt/extra/Music/" "" $selected)
    set remote "foobar2000 Music Folder/$relative"

    # Find cover art that needs renaming
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

    # Mirror everything, excluding original cover if it needs renaming
    set mirror_cmd "mirror -R --only-newer --exclude-glob '*.flac' --exclude-glob '*.ape'"
    if test -n "$cover_src" -a (basename "$cover_src") != "$cover_dest"
        set cover_orig (basename "$cover_src")
        set mirror_cmd "$mirror_cmd --exclude-glob '$cover_orig'"
    end
    set mirror_cmd "$mirror_cmd \"$selected\" \"$remote\""

    # Upload cover with normalised name if needed
    set put_cmd ""
    if test -n "$cover_src"
        set put_cmd "; put \"$cover_src\" -o \"$remote/$cover_dest\""
    end

    lftp -u bruno,arstneio -e "$mirror_cmd$put_cmd; bye" ftp://192.168.1.134
end
