# .bash_profile is for login shells, while .bashrc is for non-login
# shells.  On that basis, we want .bashrc to contain the stuff we
# always want, while .bash_profile contains the stuff only executed at
# login.

# Call .bashrc
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

#[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"
