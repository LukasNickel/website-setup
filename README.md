# About
A very simple setup to export org files to html including some CSS and attachments.

# Requirements
- Emacs
- Optionally: A Webserver

# How To
- Content goes into _content_
- CSS goes into _CSS_
- Attachments goes into _attachments_
- Run `./build-site.sh` or just `emacs -Q --script build-site.el` if you do not link the build script in the content.
(I include it to show the code that is being run to create the website.)
The `-Q` makes this independent of your local emacs configuration and thus better reproducible.
