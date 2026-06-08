function music2kepler
    set selected (find /mnt/extra/Music -mindepth 1 -type d | fzf --prompt "Sync to kepler: ")
    if test -z "$selected"
        return
    end
    set relative (string replace "/mnt/extra/Music/" "" $selected)
    lftp -u bruno,arstneio -e "mirror -R --only-newer --exclude-glob '*.flac' \"$selected\" \"foobar2000 Music Folder/$relative\"; bye" ftp://192.168.1.134
end
