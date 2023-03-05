#!/bin/sh
cp build-site.el build/build-site.el # I couldn't get the link to work and did not want to put the script in a subdir
emacs -Q --script build-site.el
