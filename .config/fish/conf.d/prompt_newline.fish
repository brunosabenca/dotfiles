# Adds a newline before each prompt, but only once after clear or initial shell start.
#
# Remember to disable starship's own newline setting if you want to use this:
#   ~/.config/starship.toml
#   add_newline = false

set PROMPT_NEEDS_NEWLINE false

function add_prompt_newline --on-event fish_prompt
    if "$PROMPT_NEEDS_NEWLINE" == true
        echo
    end
    set PROMPT_NEEDS_NEWLINE true
end

function clear
    set PROMPT_NEEDS_NEWLINE false
    command clear
end
