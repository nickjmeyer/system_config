(package-initialize)

(setq initial-major-mode 'org-mode)
(setq initial-scratch-message "# This is a scratch Org buffer")

(global-auto-revert-mode 1)
(setq auto-revert-check-vc-info t)

(setq vc-follow-symlinks t)

(add-to-list 'load-path "~/systemConfig/emacsConfig/")


(add-to-list 'default-frame-alist '(foreground-color . "#aaaaaa"))
(add-to-list 'default-frame-alist '(background-color . "#222222"))

(set-face-attribute 'default nil :height 100)

(setq mouse-avoidance-mode 'banish)

(scroll-bar-mode -1)
(menu-bar-mode -1)
(tool-bar-mode -1)

(setq visible-cursor 1)
(setq blink-cursor-mode 1)

(show-paren-mode 1)

(setq column-number-mode t)

(setq tetris-score-file "~/Dropbox/Emacs/tetris-scores")
(setq snake-score-file "~/Dropbox/Emacs/snake-scores")

(setq backup-by-copying t
      backup-directory-alist '(("." . "~/.emacsBkups"))
      delete-old-versions t
      kept-new-versions 5
      kept-old-versions 2
      version-control t)

(global-set-key (kbd "<f5>") 'compile)
(global-set-key (kbd "<f6>") 'recompile)
(global-set-key (kbd "<f7>") 'kill-compilation)
(global-set-key (kbd "<f8>") 'TeX-command-master)

(setq doc-view-continuous t)
(setq doc-view-resolution 300)
(add-hook 'doc-view-mode-hook 'auto-revert-mode)

(defun bury-compile-buffer-if-successful (buffer string)
  "Bury a compilation buffer if succeeded without warnings "
  (if (and
       (string-match "compilation" (buffer-name buffer))
       (string-match "finished" string)
       (not
        (with-current-buffer buffer
          (search-forward "warning" nil t))))
       ;; (progn
       ;; 	(bury-buffer buffer)
       ;; 	(switch-to-prev-buffer (get-buffer-window buffer) 'kill)
       ;; 	(message "Compilation success")
      ;; 	)
      (progn
	(message "Compilation success")
	;; (run-with-timer 2 nil
	;; 		(lambda (buf)
	;; 		  (bury-buffer buf)
	;; 		  (switch-to-prev-buffer (get-buffer-window buf) 'kill))
	;; 		buffer)
	(bury-buffer buffer)
	(switch-to-prev-buffer (get-buffer-window buffer) 'kill)

	)
    (progn
      (switch-to-buffer-other-window buffer)
      (end-of-buffer)
      )
    )
  )
(add-hook 'compilation-finish-functions 'bury-compile-buffer-if-successful)
(setq compilation-scroll-output 'first-error)

(defun delete-trailing-whitespace-verbose ()
  "Delete trailing whitespace and notify mini-buffer"
  (interactive)
  (delete-trailing-whitespace)
  (message "Deleting trailing whitespace")
  )
(global-set-key (kbd "C-c C-d d") 'delete-trailing-whitespace-verbose)
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq shell-file-name "bash")
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

(setq eshell-prompt-function
      (lambda()
	(concat
	 (propertize (system-name) 'face `(:foreground "green"))
	 (propertize " @ " 'face `(:foreground "gray"))
	 (propertize (replace-regexp-in-string "^.*/" "" (eshell/pwd))
		     'face `(:foreground "blue"))
	 (propertize " $ " `face `(:foreground "gray"))
	 )))
(defun eshell-maybe-bol ()
  (interactive)
  (let ((p (point)))
    (eshell-bol)
    (if (= p (point))
	(beginning-of-line))))
(add-hook 'eshell-mode-hook
	  '(lambda () (define-key eshell-mode-map "\C-a" 'eshell-maybe-bol)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(if (locate-library "package")
    (progn
      (require 'package)
      (add-to-list 'package-archives
		   '("melpa" . "http://melpa.org/packages/") t)
      (package-initialize)
      (message "Loading package")
      )
  (message "Cannot locate package")
  )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(if (locate-library "auctex")
    (progn
      (load "auctex.el" nil t t)
      (require 'tex-site)

      (setq LaTeX-item-indent 0)

      (setq LaTeX-break-at-separators '(\\\( \\\) \\\[ \\\] \\\{
					\\\} "$"))

      (setq LaTeX-command-style '(("" "%(PDF)%(latex)
      -shell-escape %S%(PDFout)")))

      (setq reftex-file-extensions
	    '(("Snw" "Rnw" "nw" "tex" ".tex" ".ltx") ("bib" ".bib")))
      (setq TeX-file-extensions
	    '("Snw" "Rnw" "nw" "tex" "sty" "cls" "ltx" "texi" "texinfo"))

      (setq TeX-auto-save t)
      (setq TeX-parse-self t)
      (setq TeX-PDF-mode t)

      ;; okular viewer
      (setq TeX-view-program-list '(("Okular" "okular --unique
      %o#src:%n%b")))
      (setq TeX-view-program-selection '((output-pdf "Okular")))
      (add-hook 'LaTeX-mode-hook
		(lambda ()
		  (set
		   (make-local-variable 'compile-command)
		   (format "pdflatex --shell-escape -interaction=nonstopmode \"\\input\" %s"
			       (file-name-sans-extension
				(file-name-nondirectory buffer-file-name))))))
      (message "Loading auctex"))
  (message "Cannot locate auctex")
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(if (locate-library "magit")
    (progn
      (global-set-key (kbd "C-x g") 'magit-status)
      (setq magit-last-seen-setup-instructions "1.4.0")
      (message "Loading magit"))
  (message "Cannot locate magit")
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(if (locate-library "preview-latex")
    (progn
      (load "preview-latex.el" nil t t)
      (message "Loading preview-latex"))
  (message "Cannot locate preview-latex")
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(if (locate-library "color-theme")
    (progn
      (require 'color-theme)
      (color-theme-initialize)
      (message "Loading color-theme"))
  (message "Cannot locate color-theme")
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(if (locate-library "yaml-mode")
    (progn
      (require 'yaml-mode)
      (add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
      (add-to-list 'auto-mode-alist '("\\.Rnw\\'" . Rnw-mode))
      (add-to-list 'auto-mode-alist '("\\.Snw\\'" . Rnw-mode))
      (message "Loading yaml-mode"))
  (message "Cannot locate yaml-mode")
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(if (locate-library "ess-site")
    (progn
      (require 'ess-site)
      (ess-toggle-underscore nil)
      (setq ess-history-file nil)
      (setq comint-scroll-to-bottom-on-input t)
      (setq comint-scroll-to-bottom-on-output t)
      (setq ess-swv-toggle-plug-into-AUCTeX t)
      (add-hook 'ess-mode-hook (lambda () (setq ess-arg-function-offset nil)))
      (add-hook 'ess-mode-hook (lambda () (setq ess-indent-level 2) ) )
      (message "Loading ess-site")
      )
  (message "Cannot locate ess-site")
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(if (locate-library "whitespace")
    (progn
      (require 'whitespace)
      (setq whitespace-style '(lines face trailing))
      (setq whitespace-line-column 80)
      (message "Loading whitespace"))
  (message "Cannot locate whitespace")
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(if (locate-library "julia-mode")
    (progn
      (setq inferior-julia-program-name
	    (executable-find "julia")
	    )
      (require 'julia-mode)
      (message "Loading julia-mode"))
  (message "Cannot locate julia-mode")
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

					;(c-set-offset (quote cpp-macro) 0 nil)
(c-set-offset 'access-label '/)

(add-hook 'c-mode-hook 'whitespace-mode)
(add-hook 'c++-mode-hook 'whitespace-mode)
(add-hook 'python-mode-hook 'whitespace-mode)
(add-hook 'org-mode-hook '(lambda ()
			    (auto-fill-mode 1)))
(add-hook 'LaTeX-mode-hook '(lambda ()
			      (auto-fill-mode 1)))
(add-hook 'markdown-mode-hook '(lambda ()
				 (auto-fill-mode 1)))
(add-hook 'LaTeX-mode-hook '(lambda ()
			      (setq auto-fill-function
				    'LaTeX-fill-paragraph)))

(add-to-list 'auto-mode-alist '("\\.cu\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.cuh\\'" . c++-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(if (locate-library "make-mode")
    (progn
      (require 'make-mode)
      (add-to-list 'auto-mode-alist '("\\.mk\\'" . makefile-gmake-mode))
      (message "Loading make-mode")
      )
  (message "Cannot locate make-mode")
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(if (locate-library "ein")
    (progn
      (require 'ein)
      (message "Loading ein")
      (setq ein:notebook-modes '(ein:notebook-python-mode))
      )
  (message "Cannot locate ein")
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(if (locate-library "web-mode")
    (progn
      (require 'web-mode)
      (add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
      (add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
      (add-to-list 'auto-mode-alist '("\\.jsp\\'" . web-mode))
      (add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
      (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
      (add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
      (add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
      (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
      )
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(if (locate-library "lua-mode")
    (progn
      (require 'lua-mode)
      (add-to-list 'auto-mode-alist '("\\.lua\\'" . lua-mode))
      (message "Loading lua-mode")
      )
  (message "Cannot locate lua-mode")
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(if (locate-library "markdown-mode")
    (progn
      (require 'markdown-mode)
      (autoload 'markdown-mode "markdown-mode"
         "Major mode for editing Markdown files" t)
      (add-to-list 'auto-mode-alist '("\\.text\\'" . gfm-mode))
      (add-to-list 'auto-mode-alist '("\\.markdown\\'" . gfm-mode))
      (add-to-list 'auto-mode-alist '("\\.md\\'" . gfm-mode))
      (setq markdown-indent-on-enter nil)
      (message "Loading markdown-mode")
      )
  (message "Cannot locate markdown-mode")
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(if (locate-library '"org")
    (progn
      (require 'org)
      (require 'ox-html)
      (define-key global-map "\C-cl" 'org-store-link)
      (define-key global-map "\C-ca" 'org-agenda)
      (setq org-log-done t)
      (setq org-src-fontify-natively t)
      (setq org-confirm-babel-evaluate nil)
      (setq org-export-html-postamble nil)
      (setf org-highlight-latex-and-related '(latex))
      (setf org-highlight-latex-fragments-and-specials t)
      (setq org-export-latex-table-caption-above nil)
      (setq org-export-html-table-caption-above nil)
      ;; (setq org-latex-listings t)
      ;; (add-to-list 'org-latex-packages-alist '("" "listings"))
      (add-to-list 'org-latex-packages-alist '("" "color"))
      (add-to-list 'org-latex-packages-alist '("" "fullpage"))
      (add-to-list 'org-latex-packages-alist '("" "amsmath"))
      (add-to-list 'org-latex-packages-alist '("" "amssymb"))
      (add-to-list 'org-latex-packages-alist '("" "dsfont"))
      (add-to-list 'org-src-lang-modes
      		   '("html" . web))
      (defun org-custom-link-img-follow (path &rest args)
	(org-open-file-with-emacs
	 (format "../images/%s" path)))
      (defun org-custom-link-img-export (path desc format &rest args)
	(message "hello")
	(message args)
	(cond
	 ((eq format 'html)
	  (format "<img src=\"/images/%s\" alt=\"%s\"/>" path desc))))
      (org-add-link-type "img" 'org-custom-link-img-follow 'org-custom-link-img-export)
      (org-babel-do-load-languages
       'org-babel-load-languages
       '((R . t)
	 (python . t)
	 (julia . t)
	 (latex . t)
	 ))
      (setq org-publish-project-alist
	    '(("webpage-org"
	       :base-directory "~/webpage/_org/"
	       :base-extension "org"
	       :publishing-directory "~/webpage/"
	       :recursive t
	       :publishing-function org-html-publish-to-html
	       :headline-levels 4
	       :html-extension "html"
	       :body-only t
	       :with-toc nil
	       :section-numbers nil
	       )
	      ("webpage-static"
	       :base-directory "~/webpage/_org/"
	       :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf\\|php"
	       :publishing-directory "~/webpage/"
	       :recursive t
	       :publishing-function org-publish-attachment)
	      ("webpage" :components ("webpage-org" "webpage-static"))
	      ))
      (setq org-babel-default-header-args
	    (cons '(:exports . "both")
		  (assq-delete-all :exports org-babel-default-header-args)))
      (setq org-babel-default-header-args
	    (cons '(:results . "output")
		  (assq-delete-all :results org-babel-default-header-args)))
      (message "Loading org")
      )
  (message "Cannot locate org")
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(if (locate-library "arduino-mode")
    (progn
      (require 'arduino-mode)
      (global-ede-mode 1)
      (require 'semantic/sb)
      (semantic-mode 1)
      (setq auto-mode-alist (cons '("\\.\\(pde\\|ino\\)$" . arduino-mode)
				  auto-mode-alist))
      (autoload 'arduino-mode "arduino-mode" "Arduino editing mode." t)
      (message "Loading arduino-mode")
      )
  (message "Cannot locate arduino-mode")
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; this stuff is automatically added by changing preferences in emacs
;; (custom-set-faces
;;  ;; custom-set-faces was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(eshell-prompt ((t (:foreground "color-40" :weight normal))))
;;  '(font-latex-math-face ((t (:foreground "color-148"))))
;;  '(font-lock-comment-face ((t (:foreground "color-160"))))
;;  '(font-lock-constant-face ((t (:foreground "color-226"))))
;;  '(font-lock-function-name-face ((t (:foreground "color-202"))))
;;  '(font-lock-keyword-face ((t (:foreground "color-90"))))
;;  '(font-lock-preprocessor-face ((t (:foreground "color-51"))))
;;  '(font-lock-string-face ((t (:foreground "color-212"))))
;;  '(font-lock-type-face ((t (:foreground "color-34"))))
;;  '(font-lock-variable-name-face ((t (:foreground "color-27"))))
;;  '(minibuffer-prompt ((t (:foreground "color-166"))))
;;  '(region ((t (:background "black" :inverse-video t))))
;;  '(web-mode-html-attr-name-face ((t (:foreground "color-21"))))
;;  '(web-mode-html-tag-bracket-face ((t (:foreground "color-22"))))
;;  '(web-mode-html-tag-face ((t (:foreground "color-22")))))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(dired-listing-switches "-l -h --group-directories-first -X")
 '(ede-project-directories
   (quote
    ("/home/nick/Dropbox/Code/ArduinoStarter/01-Basics"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(font-lock-comment-face ((t (:foreground "red"))))
 '(font-lock-constant-face ((t (:foreground "cyan1"))))
 '(font-lock-function-name-face ((t (:foreground "royal blue"))))
 '(font-lock-keyword-face ((t (:foreground "goldenrod"))))
 '(font-lock-preprocessor-face ((t (:inherit font-lock-builtin-face :foreground "magenta"))))
 '(font-lock-string-face ((t (:foreground "DarkOrange1"))))
 '(font-lock-type-face ((t (:foreground "lime green"))))
 '(font-lock-variable-name-face ((t (:foreground "deep pink"))))
 '(magit-diff-file-header ((t (:inherit nil :background "gray25" :foreground "tomato" :weight semi-bold))))
 '(magit-diff-hunk-header ((t (:inherit diff-hunk-header :background "gray25" :foreground "yellow1" :weight semi-bold))))
 '(magit-item-highlight ((t (:inherit secondary-selection :background "dark slate blue"))))
 '(magit-tag ((t (:background "navy" :foreground "chartreuse" :weight extra-bold))))
 '(minibuffer-prompt ((t (:foreground "DarkGoldenrod1"))))
 '(org-level-4 ((t (:inherit outline-4 :foreground "salmon"))))
 '(org-todo ((t (:foreground "orange1" :weight bold))))
 '(table-cell ((t (:foreground "gray80" :inverse-video nil))))
 '(whitespace-line ((t (:background "dark magenta" :foreground "green")))))


(put 'narrow-to-region 'disabled nil)
