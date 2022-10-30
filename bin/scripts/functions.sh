# A collection of small functions which do not deserve being placed in a separate file
# These are sourced by the shell process

# Allows running "config" as a way to always refer to my dotfiles git instance globally
# Also defines a git alias which can be used to update my dotfiles to the latest version
config() {
	git \
		--git-dir="$HOME/.dotfiles/" \
		--work-tree="$HOME" \
		-c status.showUntrackedFiles=no \
		-c submodule.recurse=true \
		-c core.hooksPath="$HOME/.config/dotfiles/git_hooks/" \
		-c alias.update="!bash $HOME/.config/dotfiles/update_dotfiles.sh" \
		"$@"
}
alias cfg="config"
alias c="config"

# Useful when you've cd'ed into a symlink to get the real path
fix_cwd() { cd $(pwd -P); }

# Generate a password
pass_gen() {
	head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 ; echo '';
}

uuid_gen() {
	cat /proc/sys/kernel/random/uuid
}

base64_encoded_to_png() {
	[ -z "$1" ] && echo "No input received" && return

	echo $1 | sed -e 's#data:image/png;base64,##' | \
	base64 --decode > out.png && \
	echo "Created file named out.png";
}

jsonp() {
	# xp is an alias to paste from clipboard
	xp | jq;
}

# Convert a printed python object to json
py_json() {
	# TODO optimize
	xp | sed "s/'/\"/g" | sed "s/False/false/g" | sed "s/True/true/g" | jq
}

# restart services in docker-compose
dc-restart(){
	[ -z $@ ] && echo "No containers args given" && return 1
	docker-compose stop $@
	docker-compose rm -f -v $@
	docker-compose create --force-recreate $@
	docker-compose start $@
}

# returns the default app for opening a certain file
mime() {
	[ -z "$1" ] && echo "Missing file arg" && return 1
	[ ! -e "$1" ] && echo "Given arg does not match anything existing" && return 2
	xdg-mime query default $(xdg-mime query filetype "$1")
}

# colorize "go test" output to make it easier to parse for the eyes
# Example "go test . | go_test_color"
go_test_color() {
	forground_color='[97;' # White
	if [[ "$ZSH_THEME" == "light" ]]; then
		forground_color='[30;' # black
	fi
	awk \
		-v ESC='\033' \
		-v COLOR_RED='[31m' \
		-v COLOR_YELLOW='[33m' \
		-v COLOR_GREEN='[32m' \
		-v COLOR_MAGENTA='[35m' \
		-v COLOR_CYAN='[34m' \
		-v COLOR_BLUE_BG='104m' \
		-v COLOR_FOREGROUND="$forground_color" \
		-v RESET='[0m' \
		'{
		sub("FAIL", ESC COLOR_RED "FAIL" ESC RESET, $0);
		sub("ERROR",ESC COLOR_RED "ERROR" ESC RESET, $0);
		sub("WARN", ESC COLOR_YELLOW "WARN" ESC RESET, $0);
		sub("PASS", ESC COLOR_GREEN "PASS" ESC RESET, $0); #
		sub(/=== RUN.+$/, ESC COLOR_FOREGROUND COLOR_BLUE_BG "&" ESC RESET, $0);

		# When t.Errorf("MyMessage") or t.Logf("MyMessage") is called it outputs for example: "    /a/path/to/testfile.go:12 MyMessage". This case catches that and highlights it
		# & is a special character in awk.
		# Source: https://www.gnu.org/software/gawk/manual/html_node/String-Functions.html
		# "If the special character ‘&’ appears in replacement, it stands for the precise substring that was matched by regexp"
		sub(/( ){4}(.+)\/?([^\/]+).go:[0-9]+:/,
			ESC COLOR_MAGENTA "Test case outputted @:" ESC COLOR_CYAN "&" ESC RESET,
			$0);
		print
	}'
}

echo_and_run() {
	echo "Running:" "$@"
	eval $(printf '%q ' "$@") < /dev/tty
}

# TODO figure out how dedup the "echo" and the actual command, very prone to errors
gotest() {
	echo "Running: time go test -cover -failfast -race -v $@ | go_test_color"

	set -o pipefail
	time go test -cover -failfast -race -v $@ | go_test_color

	if [ "$?" -eq 0 ]; then
		notify-send --urgency=low -t 10000 "Test done!" "Result = 👍"
		spd-say "Test ok"
	else
		notify-send --urgency=low -t 10000 "Test done!" "Result = 👎"
		spd-say "Test fail"
	fi
	set +o pipefail
}

# tm - create new tmux session, or switch to existing one. Works from within tmux too. (@bag-man)
# `tm` will allow you to select your tmux session via fzf.
# `tm x` will attach to the irc session (if it exists), else it will create it.
tm() {
	[[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"
	session_name="$1"
	if [[ "$session_name" == "n" ]]; then
		git_branch=$(git branch --show-current)
		[ -z "$git_branch" ] && echo "No Git branch found!" && return

		if [[ "$git_branch" == "master" || "$git_branch" == "main" ]]; then
			session_name="$PWD"'@'"$git_branch"
		else
			session_name="$git_branch"
		fi
		tmux new-session -s $session_name
		return
	fi
	if [ "$session_name" ]; then
		tmux $change -t "$session_name" 2>/dev/null || (tmux new-session -d -s $session_name && tmux $change -t "$session_name"); return
	fi
	session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --exit-0) &&  tmux $change -t "$session" || echo "No sessions found."
}

# Watch a youtube video
wv() {
	mpv --ytdl-format="$YT_DL_FORMAT" "$1"
}

# Better branch creation ergonmics when using git worktrees
create_branch() {
	if [ ! -f "HEAD" ]; then
		echo "You're not in the root of the bare repo. Aborting..."; return 1
	fi

	branch_name="$1"
	if [ -z "$branch_name" ]; then
		branch_name="$(git branch -a | fzf | tr -d '[:space:]' | tr -d '*' | tr -d '+' | sed 's/remotes\/origin\///')"
	else
		git branch "$branch_name"
	fi
	if [ -z "$branch_name" ]; then
		echo "Missing first arg for branch name. Aborting..."; return 1
	fi

	# Removes everything before the last forward slash(/)
	# example "some/branch/name" will be "name"
	dir="branches/${branch_name##*/}"
	git worktree add "$dir" "$branch_name"
	echo "Created dir: $dir"
	cd "$dir"
}

retry() {
	for i in {1..20}; do
		eval "$@"
		sleep 1
	done
}
tmux_delve() {
	tmux split-window -h -t sc "zsh -ic 'retry dlv connect localhost:2345'"
}

mac() {
	printf "$1" | sed 's/://g' | tr '[:lower:]' '[:upper:]'
}

# Count columns in to more easily map {print $x}
awk_columns() {
	awk 'BEGIN {FS=" "} END {print NF}'
}


git_file() {
	branch="$(git branch | fzf --header 'Branch?' | tr -d '[:space:]' | tr -d '*' | tr -d '+')"
	[ -z "$branch" ] && return

	file=$(fzf --header 'File path?')
	[ -z "$file" ] && return

	file_extension="${file##*.}"
	git show "$branch:$file" | nvim -R -c "set ft=$file_extension"
}

