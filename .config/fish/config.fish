if status is-interactive
    # Set GL specific stuff, should make this modular later
    if test -f ~/.gl_aliases
        test -f ~/.gl_aliases; and source ~/.gl_aliases
        test -f ~/.aliases; and source ~/.aliases
        test -f ~/bin/scripts/bastion.sh; and source ~/bin/scripts/bastion.sh

        set -gx TUNNELTO_INSTALL "/home/bruno/.tunnelto"
        fish_add_path "$TUNNELTO_INSTALL/bin"

        #  Bedrock environment variables
        set -gx CLAUDE_CODE_USE_BEDROCK 1
        set -gx AWS_REGION eu-west-1
        set -gx ANTHROPIC_SMALL_FAST_MODEL_AWS_REGION eu-west-1
        set -gx ANTHROPIC_MODEL 'arn:aws:bedrock:eu-west-1:792372355255:inference-profile/eu.anthropic.claude-sonnet-4-20250514-v1:0'
        set -gx ANTHROPIC_SMALL_FAST_MODEL 'arn:aws:bedrock:eu-west-1:792372355255:inference-profile/eu.anthropic.claude-3-haiku-20240307-v1:0'

        mise activate fish | source
    end

    # Path additions
    fish_add_path "$HOME/.local/bin"
    fish_add_path "$HOME/bin/scripts"

    # Environment variables
    set -gx EDITOR nvim

    # Initialize tools
    starship init fish | source
    zoxide init fish | source
    fzf --fish | source

    # Get colorised help with bat
    abbr -a --position anywhere -- --help '--help | bat -plhelp'
    abbr -a --position anywhere -- -h '-h | bat -plhelp'

    # Ues fd with bat preview
    function fdp
        fd --type file --type symlink $argv -X bat
    end

    # Prompt transience
    enable_transience
    function starship_transient_prompt_func
        starship module character
    end
end

if status is-interactive && test -f ~/.config/fish/conf.d/git_fzf.fish
    source ~/.config/fish/conf.d/git_fzf.fish
    git_fzf_key_bindings
end
