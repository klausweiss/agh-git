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
RewriteRule ^git/(([a-zA-Z0-9._-]*.git/(HEAD|info/refs|objects/(info/[^/]+|[0-9a-f]{2}/[0-9a-f]{38}|pack/pack-[0-9a-f]{40}.(pack|idx))|git-(upload|receive)-pack)))$ __git/git.cgi/\\\$1\

# python cgi
AddHandler cgi-script .py
"
ssh -T $1@$2 <<EndOfInput
    echo "$HTACCESS" > ~/public_html/.htaccess
    mkdir -p ~/public_html/__git
    ln -s ~/public_html/__git ~/git
EndOfInput
}

init_server $1 $2
