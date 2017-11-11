#!/bin/sh
#
# MIT License
# 
# Copyright (c) 2017 Mikolaj Biel
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


#=== FUNCTION ======================================================
# NAME: init_server
# DESC: Init git-related directories and files on the server
#   $1: remote username
#   $2: remote server
#===================================================================
init_server() {

HTACCESS="\
# git
SetEnv GIT_PROJECT_ROOT ~/public_html/__git
SetEnv GIT_HTTP_EXPORT_ALL

RewriteEngine  on
RewriteBase /~$1/
RewriteRule ^git/(([a-zA-Z0-9._-]*.git/(HEAD|info/refs|objects/(info/[^/]+|[0-9a-f]{2}/[0-9a-f]{38}|pack/pack-[0-9a-f]{40}.(pack|idx))|git-(upload|receive)-pack)))$ __git/git.cgi/\\\$1
RewriteRule ^git/?$ __git/index.py

# python cgi
AddHandler cgi-script .py\
"

GIT_CGI="\
#!/bin/sh

PATH_TRANSLATED=~/git/\\\${PATH_TRANSLATED:24}

PATH=~/git/:\\\$PATH
git http-backend \\\"\\\$@\\\"\
"

WEBAPP_CSS="
body {
    margin: 40px auto;
    max-width: 650px;
    line-height: 1.6;
    font-size: 18px;
    color: #587188;
    padding: 0 10px;
}

* {
    font-family: monospace;
}

ul, li {
    margin: 0;
    padding: 0;
}

li {
    display: block;
    list-style: none;
    background-color: #ebf2fa;
    padding: 1em;
    margin-bottom: .4em;
}

li span {
    display: inline-block;
    width: 3em;
}

li input {
    font-size: 16px;
    padding: 2px;
    width: calc(100% - 4.5em);
}

h2 {
    margin: 0;
    padding: 0;
}

footer {
    font-size: .7em;
    text-align: right;
}
"

WEBAPP="\
#!/usr/bin/python
import os

def get_ssh_link(name):
    return 'ssh://$1@$2/~/git/%s.git' % name

def get_http_link(name):
    return 'http://$2/~$1/git/%s.git' % name

def print_header():
    print '''
    <html><head>
    <title>$1's git repositories</title>
    <style>$WEBAPP_CSS</style>
    </head><body><ul>
    '''

def print_repository(name):
    print '''
    <li>
        <h2>%s</h2>
        <div><span>ssh:</span> <input value='%s' /></div>
        <div><span>http:</span> <input value='%s' /></div>
    </li>
    ''' % (name, get_ssh_link(name), get_http_link(name))

def print_empty():
    print '''
    <li>
        <h2>there are no repositories ):</h2>
        <div>init one!</div>
    </li>
    '''

def print_footer():
    print '''
    </ul>
    <footer>powered by agh-git</footer>
    </body>
    </html>
    '''

home = os.path.expanduser('~')
repositories = [dir[:-4] for dir
                in next(os.walk('%s/git' % home))[1]
                if dir.endswith('.git')]

print 'Content-type: text/html\n\n'
print_header()
for repo in sorted(repositories):
    print_repository(repo)
if not repositories:
    print_empty()
print_footer()
"

ssh -T $1@$2 <<EndOfInput
    echo "$HTACCESS" > ~/public_html/.htaccess
    mkdir -p ~/public_html/__git
    ln -sf -T ~/public_html/__git/ ~/git
    echo "$WEBAPP" > ~/git/index.py
    echo "$GIT_CGI" > ~/git/git.cgi
    chmod 755 ~/git/index.py ~/git/git.cgi
EndOfInput
}

init_server $1 $2
