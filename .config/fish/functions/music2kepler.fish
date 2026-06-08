function music2kepler
    set selected (find /mnt/extra/Music -mindepth 1 -type d | fzf --prompt "Sync to kepler: ")
    if test -z "$selected"
        return
    end

    set relative (string replace "/mnt/extra/Music/" "" $selected)
    set remote "foobar2000 Music Folder/$relative"

    # Find cover art
    set cover_orig ""
    set cover_dest ""
    for f in "$selected"/{cover,Cover,folder,Folder,album,Album,front,Front,albumart,AlbumArt}.{jpg,jpeg,png,webp}
        if test -f "$f"
            set ext (string lower (string match -r '\.[^.]+$' "$f"))
            set cover_orig (basename "$f")
            set cover_dest "cover$ext"
            break
        end
    end

    # Mirror everything, then rename cover on remote if needed
    set lftp_cmds "mirror -R --only-newer --exclude-glob '*.flac' --exclude-glob '*.ape' \"$selected\" \"$remote\""
    if test -n "$cover_orig" -a "$cover_orig" != "$cover_dest"
        set lftp_cmds "$lftp_cmds; mv \"$remote/$cover_orig\" \"$remote/$cover_dest\""
    end

    lftp -u bruno,arstneio -e "$lftp_cmds; bye" ftp://192.168.1.134
end
