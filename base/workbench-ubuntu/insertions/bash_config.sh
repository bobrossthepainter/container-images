### START - Ubuntu Jammy insertions #####
git_branch(){
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

source /etc/profile

PS1='\[\033[01;32m\]\u@docker\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
### END - Ubuntu Jammy insertions #####