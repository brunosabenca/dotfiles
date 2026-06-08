function splitcue
    set dir (find /mnt/extra/Music /home/bruno/network/cave/downloads -mindepth 1 -maxdepth 1 -type d | fzf --prompt "Split CUE: ")
    if test -z "$dir"
        return
    end

    set cue (find "$dir" -maxdepth 1 -name "*.cue" | head -1)
    if test -z "$cue"
        echo "error: no CUE file found in $dir"
        return 1
    end

    set album (basename "$dir")
    set out_dir "/mnt/extra/Music/"(string replace -r '^\d{4} - ' '' "$album")

    python3 ~/.local/bin/splitcue.py "$cue" "$out_dir"
end
