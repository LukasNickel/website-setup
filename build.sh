#!/bin/sh
cp build-site.el build/build-site.el
emacs -Q --script build-site.el
