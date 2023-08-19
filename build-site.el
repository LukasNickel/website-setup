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
(package-install 'ox-rss)
;; Load the publishing system
(require 'ox-publish)

;; Customize the HTML output
(setq org-html-validation-link nil            ;; Don't show validation link
      org-html-head-include-scripts nil       ;; Use our own scripts
      org-html-head-include-default-style nil ;; Use our own styles
      org-html-head "<link rel=\"stylesheet\" href=\"/style.css\">"
      org-html-htmlize-output-type 'css
      )


; Based on this post: https://writepermission.com/org-blogging-rss-feed.html
; I was not able to get a proper fulltext feed myself and this one works quite well!
; Reduced it a bit to my needs here. Check the original post for details
(defun rw/org-rss-publish-to-rss (plist filename pub-dir)
  "Publish RSS with PLIST, only when FILENAME is 'rss.org'.
PUB-DIR is when the output will be placed."
  (if (equal "rss.org" (file-name-nondirectory filename))
      (org-rss-publish-to-rss plist filename pub-dir)))

(defun rw/format-rss-feed (title list)
  "Generate RSS feed, as a string.
TITLE is the title of the RSS feed.  LIST is an internal
representation for the files to include, as returned by
`org-list-to-lisp'.  PROJECT is the current project."
  (concat "#+TITLE: " title "\n\n"
          (org-list-to-subtree list)))

(defun rw/format-rss-feed-entry (entry style project)
  "Format ENTRY for the RSS feed.
ENTRY is a file name.  STYLE is either 'list' or 'tree'.
PROJECT is the current project."
  (cond ((not (directory-name-p entry))
         (let* ((file (org-publish--expand-file-name entry project))
                (title (org-publish-find-title entry project))
                (date (format-time-string "%Y-%m-%d" (org-publish-find-date entry project)))
                (link (concat (file-name-sans-extension entry) ".html")))
           (with-temp-buffer
             (insert (format "* [[file:%s][%s]]\n" file title))
             (org-set-property "RSS_PERMALINK" link)
             (org-set-property "PUBDATE" date)
             (insert-file-contents file)
             (buffer-string))))
        ((eq style 'tree)
         ;; Return only last subdir.
         (file-name-nondirectory (directory-file-name entry)))
        (t entry)))


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
        (list "org-site:rss"
              :base-directory "./content/posts"
              :base-extension "org"
              :recursive t
              :publishing-function 'rw/org-rss-publish-to-rss
              :publishing-directory "./build"
              :rss-extension "xml"
              :html-link-home "https://lukasnickel.com"
              :html-link-use-abs-url t
              :html-link-org-files-as-html t
              :auto-sitemap t
              :sitemap-filename "rss.org"
              :sitemap-style 'list
              :sitemap-sort-files 'anti-chronologically
              :sitemap-function 'rw/format-rss-feed
              :sitemap-format-entry 'rw/format-rss-feed-entry)
       (list "org-site:main"
             :recursive t
             :base-directory "./content"
             :base-extension "org"
             :exclude "rss.org"
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
                <li><a href=\"/index.html\">Home</a></li>
                <li><a href=\"/blog.html\">Blog</a></li>
                <li><a href=\"/setup.html\">Setup</a></li>
                <li><a href=\"/sitemap.html\">Sitemap</a></li>
                </ul>
                <hr>
                </div>")
))

;; Generate the site output
(org-publish-all t)

(message "Build complete!")
