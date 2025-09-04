if status is-interactive
    source ~/.aliases
    source ~/bin/scripts/bastion.sh
    source ~/.gl_aliases

    set -gx CLAUDE_CODE_USE_BEDROCK 1
    set -gx AWS_REGION eu-west-1
    set -gx ANTHROPIC_SMALL_FAST_MODEL_AWS_REGION eu-west-1
    set -gx ANTHROPIC_MODEL 'arn:aws:bedrock:eu-west-1:792372355255:inference-profile/eu.anthropic.claude-sonnet-4-20250514-v1:0'
    set -gx ANTHROPIC_SMALL_FAST_MODEL 'arn:aws:bedrock:eu-west-1:792372355255:inference-profile/eu.anthropic.claude-3-haiku-20240307-v1:0'
    set -gx TUNNELTO_INSTALL "/home/bruno/.tunnelto"

    fish_add_path "$HOME/.local/bin"
    fish_add_path "$HOME/bin/scripts"
    fish_add_path "$TUNNELTO_INSTALL/bin"

    mise activate fish --shims | source

    set -x EDITOR nvim

    function starship_transient_prompt_func
        starship module character
    end

    starship init fish | source

    #enable_transience

    zoxide init fish | source
end

if status is-interactive && test -f ~/.config/fish/conf.d/git_fzf.fish
    source ~/.config/fish/conf.d/git_fzf.fish
    git_fzf_key_bindings
end
