# agh-git

agh-git is a shell script that adds a git server functionality to the linux account at your university server (eg. `http://student.university.edu/~yourname`).

## installation

Using `curl`:

    curl -L https://raw.githubusercontent.com/klausweiss/agh-git/0.1.1/install.sh | sh
    
Or using `wget`:

    wget -qO- https://raw.githubusercontent.com/klausweiss/agh-git/0.1.1/install.sh | sh
    
Or manually - place the *[agh-git](https://github.com/klausweiss/agh-git/blob/0.1.1/agh-git)* file into one of the directories in your `$PATH` variable (eg. `/usr/local/bin`).


## usage

**Warning!** This script (namely `init-server` function) changes `~/public_html/.htaccess` file on your server! If you do not know what `.htaccess` is, don't worry.


    Usage: agh-git user@hostname COMMAND [OPTION]
        or agh-git --help [COMMAND]

    List of available commands:
        list, ls       List repository from the server
        delete, rm     Delete repository from the server
        init           Init git repository on the server
        init-server    Init git-related directories and files on the server


To initialize a git server on the server connect to your universities network and execute the following once:

    agh-git you@student.university.edu init-server
    
To add an empty repository execute the following after initializing a git server:

    agh-git you@student.university.edu init sample-repo
    
To see your repositories go to `http://student.university.edu/~you/git`

## disclaimer

This software has been tested with [AGH UST](http://www.agh.edu.pl) server and may not work with account at different universities. It assumes that the server uses `Apache` web server, that users' websites are hosted in `~/public_html` and that the host you connect to via SSH is the same as the one you connect to using your browser.


## license

The software is licensed under [MIT license](https://opensource.org/licenses/MIT).
