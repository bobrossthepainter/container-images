### START - Ubuntu Jammy insertions #####
git_branch(){
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# source /etc/profile

if [ -n "$ZSH_VERSION" ]; then
    # zsh: use %{...%} to mark non-printing sequences, and zsh prompt escapes
    PROMPT='%{%F{green}%B%}%n@docker%{%b%f%}:%{%F{blue}%B%}%~%{%b%f%}%# '
elif [ -n "$BASH_VERSION" ]; then
    # bash: use \[...\] to mark non-printing sequences
    PS1='\[\033[01;32m\]\u@docker\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
fi
### END - Ubuntu Jammy insertions ######