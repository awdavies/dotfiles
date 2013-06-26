dotfiles
========

To set up the dotfiles (symlinks are the default for now).  Go into the git directory and run 

    git submodule init
    git submodule update
    ./setup.sh

If you have any of the files listed in the setup, then they will be ignored.  It's your responsiblity (for now) to back your stuff up before running this script.  It won't overwrite anything, though, so no worries : )
