function splitcue
    set dir (find /mnt/extra/Music -mindepth 1 -maxdepth 1 -type d | fzf --prompt "Split CUE+FLAC: ")
    if test -z "$dir"
        return
    end

    set cue (find "$dir" -maxdepth 1 -name "*.cue" | head -1)
    set flac (find "$dir" -maxdepth 1 -name "*.flac" | head -1)

    if test -z "$cue"
        echo "error: no CUE file found in $dir"
        return 1
    end
    if test -z "$flac"
        echo "error: no FLAC file found in $dir"
        return 1
    end

    python3 ~/.local/bin/splitcue.py "$flac" "$cue" "$dir"
end
