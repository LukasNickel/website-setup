;; Copied from https://github.com/SystemCrafters/org-website-example/ with some adaptions
;; Set the package installation directory so that packages aren't stored in the
;; ~/.emacs.d/elpa path.
(require 'package)
(setq package-user-dir (expand-file-name "./.packages"))
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

;; Initialize the package system
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Install dependencies
(package-install 'htmlize)
;; Load the publishing system
(require 'ox-publish)

;; Customize the HTML output
(setq org-html-validation-link nil            ;; Don't show validation link
      org-html-head-include-scripts nil       ;; Use our own scripts
      org-html-head-include-default-style nil ;; Use our own styles
      org-html-head "<link rel=\"stylesheet\" href=\"style.css\">"
      org-html-htmlize-output-type 'css
      )

;; Define the publishing project
(setq org-publish-project-alist
      (list
       (list "org-site:css"
             :base-directory "./css"
             :base-extension "css"
             :publishing-directory "./build"
             :recursive t
             :publishing-function 'org-publish-attachment)
       (list "org-site:media"
             :base-directory "./media"
             :base-extension "png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
             :publishing-directory "./build"
             :recursive t
             :publishing-function 'org-publish-attachment)
       (list "org-site:main"
             :recursive t
             :base-directory "./content"
             :base-extension "org"
             :publishing-function 'org-html-publish-to-html
             :publishing-directory "./build"
             :auto-sitemap t
             :with-title nil
             :with-author nil           ;; Don't include author name
             :with-creator t            ;; Include Emacs and Org versions in footer
             :with-toc nil                ;; Include a table of contents
             :section-numbers nil       ;; Don't include section numbers
             :time-stamp-file nil
             :auto-preamble nil
             :html-preamble "<div id=\"navbar\"> <ul>
                <li><a href=\"index.html\">Home</a></li>
                <li><a href=\"blog.html\">Blog</a></li>
                <li><a href=\"setup.html\">Setup</a></li>
                <li><a href=\"sitemap.html\">Sitemap</a></li>
                </ul>
                <hr>
                </div>"
)))

;; Generate the site output
(org-publish-all t)

(message "Build complete!")
