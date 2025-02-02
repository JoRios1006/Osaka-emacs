;; set transparency
(defvar tr 98)
(set-frame-parameter (selected-frame) 'alpha (list tr tr))
(add-to-list 'default-frame-alist `(alpha ,tr ,tr))
;; Line numbers
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(add-hook 'text-mode-hook 'display-line-numbers-mode)
(set-face-attribute 'default nil :height 140)
(setq display-line-numbers 'relative)
;; Binding to toggle between absolute and
;; relative line numbers
(defun toggle-line-numbers-type ()
  "Toggle line numbers between absolute and relative."
  (interactive)
  (if (eq display-line-numbers-type t)
	  (setq display-line-numbers-type 'relative)
	(setq display-line-numbers-type t))
  (if (bound-and-true-p display-line-numbers-mode)
	  (display-line-numbers-mode)))
(global-set-key (kbd "C-c C-l") 'toggle-line-numbers-type)

(defun toggle-org-support-shift-select ()
  "Toggle the value of `org-support-shift-select'."
  (interactive)
  (setq org-support-shift-select (not org-support-shift-select))
  (message "org-support-shift-select is now %s"
           (if org-support-shift-select "enabled" "disabled")))

(global-set-key (kbd "C-c n -") 'toggle-org-support-shift-select)

;; Capitalize region
(global-set-key (kbd "C-x c") 'capitalize-region)

;; Scheme!
(use-package paredit
  :ensure t)
(use-package geiser
  :ensure t)
(use-package geiser-guile
  :ensure t)

;; Update repo
(defun update-packages ()
  "Update all packages."
  (interactive)
  (package-refresh-contents)
  (package-list-packages)
  (package-menu-mark-upgrades)
  (package-menu-execute t))
(global-set-key (kbd "C-c u") 'update-packages)


;; Recent Files
(recentf-mode 1)
(global-set-key (kbd "C-c C-r") 'recentf-open-files)

;; Remembering the last place you visited
(save-place-mode 1)

;; Evaluate Buffer
(global-set-key (kbd "C-c C-u") 'eval-buffer)

;; Prevent dialog prompt
(setq use-dialog-box nil)

;; Automatically revert buffer for changed files
(global-auto-revert-mode 1)
(setq global-auto-revert-non-file-buffers t)

;; Default to vertical split if creating "other window"
(setq split-height-threshold nil)
(setq split-width-threshold 0)

;; Tabs!
(use-package centaur-tabs
  :ensure t
  :demand
  :config
  (centaur-tabs-mode t)
  (centaur-tabs-change-fonts (face-attribute 'default :font) 110)
  (centaur-tabs-headline-match)
  (setq centaur-tabs-set-close-button nil
		centaur-tabs-show-new-tab-button nil
		centaur-tabs-set-modified-marker t
		centaur-tabs-style "alternate")
  :bind
  ("C-<tab>" . centaur-tabs-backward)
  ("C-<iso-lefttab>" . centaur-tabs-forward))

;; AucTeX
(define-key org-mode-map (kbd "C-c l c") 'org-latex-export-to-pdf)


;; Org-roam
;; A plain-text personal knowledge management system.
(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory "~/ENotes")
  (org-roam-completion-everywhere t)
  (org-roam-capture-templates
   ;; "d" is the letter you'll press to choose the template.
   ;; "default" is the full name of the template.
   ;; plain is the type of text being inserted.
   ;; "%?" is the text that will be inserted.
   ;; unnarrowed t ensures that the full file will be displayed when captured.
	'(("d" "default" plain "%?"
	   :if-new (file+head "%<%Y-%m-%d-%H%M%S>-${slug}.org" "#+title: ${title}\n#+date: %U\n")
	   :unnarrowed t)
	 ("p" "project" plain "* Goals\n\n%?\n\n* Tasks\n\n** TODO Add initial tasks\n\n* Dates\n\n"
	   :if-new (file+head "%<%Y-%m-%d-%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: Project")
	   :unnarrowed t)))
  (org-roam-dailies-capture-templates
	'(("d" "default" entry "* %<%H:%M>: %?"
	   :if-new (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n"))))
  :bind (("C-c n l" . org-roam-buffer-toggle)
		 ("C-c n f" . org-roam-node-find)
		 ("C-c n i" . org-roam-node-insert)
		 ("C-c n t" . org-roam-tag-add)
		 ("C-c n a" . org-roam-alias-add)
		 ("C-c n o" . org-id-get-create)
		 :map org-mode-map
		 ("C-M-i" . completion-at-point)
		 :map org-roam-dailies-map
		 ("Y" . org-roam-dailies-capture-yesterday)
		 ("T" . org-roam-dailies-capture-tomorrow))
  :bind-keymap
  ("C-c n d" . org-roam-dailies-map)
  :config
  (org-roam-setup)
  (require 'org-roam-dailies) ;; Ensure the keymap is available
  (org-roam-db-autosync-mode))

;; Crux: Collection of Ridiculously Useful eXtensions
(use-package crux
  :ensure t)
(global-set-key [remap move-beginning-of-line] #'crux-move-beginning-of-line)
(global-set-key [remap kill-whole-line] #'crux-kill-whole-line)
(global-set-key (kbd "C-S-RET") 'crux-smart-open-line-above)
(global-set-key (kbd "S-RET") 'crux-smart-open-line)
(global-set-key (kbd "C-c k") 'crux-kill-other-buffers)
(global-set-key (kbd "C-c t") 'crux-visit-term-buffer)
(global-set-key (kbd "C-c I") 'crux-find-user-init-file)
(global-set-key (kbd "M-o") 'crux-other-window-or-switch-buffer)
(global-set-key (kbd "C-c c b") 'crux-cleanup-buffer-or-region)
(global-set-key (kbd "C-c e") 'crux-eval-and-replace)
(global-set-key (kbd "C-c D") 'crux-delete-file-and-buffer)

;; Multiple Cursors
(use-package multiple-cursors
  :ensure t)
(global-set-key (kbd "C-c x") 'mc/mark-next-like-this)
(define-key mc/keymap (kbd "<return>") nil)

;; TLDR Pages
(use-package tldr
  :ensure t)

;; Projectile
(use-package projectile
  :ensure t)
(projectile-mode +1)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

;; SLY is Sylvester the Cat's Common Lisp IDE for Emacs
(use-package sly
  :ensure t)
(use-package common-lisp-snippets
  :ensure t)

;; TODO lsp-mode lsp-ui

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(show-paren-mode 1)

(setq inhibit-startup-message t)

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

(setq x-select-enable-clipboard t)

(setq make-backup-files nil)
(setq auto-save-default nil)

(setq scroll-conservatively 100)

(setq ring-bell-function 'ignore)

(setq-default tab-width 4)
(setq-default standard-indent 4)
(setq c-basic-offset tab-width)
(setq-default electric-indent-inhibit t)
(setq-default indent-tabs-mode t)
(setq backward-delete-char-untabify-method 'nil)

(global-prettify-symbols-mode t)

(setq electric-pair-pairs '(
							(?\{ . ?\})
							(?\( . ?\))
							(?\[ . ?\])
							(?\" . ?\")
							))
(electric-pair-mode t)

(defun split-and-follow-horizontally ()
	  (interactive)
	  (split-window-below)
	  (balance-windows)
	  (other-window 1))
(global-set-key (kbd "C-x 2") 'split-and-follow-horizontally)

(defun split-and-follow-vertically ()
	  (interactive)
	  (split-window-right)
	  (balance-windows)
	  (other-window 1))
(global-set-key (kbd "C-x 3") 'split-and-follow-vertically)

(defalias 'yes-or-no-p 'y-or-n-p)

(global-set-key (kbd "s-C-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "s-C-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "s-C-<down>") 'shrink-window)
(global-set-key (kbd "s-C-<up>") 'enlarge-window)

(global-hl-line-mode t)

(setq use-package-always-defer t)

(use-package org
  :config
  (add-hook 'org-mode-hook 'org-indent-mode)
  (add-hook 'org-mode-hook
			#'(lambda ()
			   (visual-line-mode 1))))

(use-package org-indent
  :diminish org-indent-mode)

(use-package htmlize
  :ensure t)

(setq eshell-prompt-regexp "^[^αλ\n]*[αλ] ")
(setq eshell-prompt-function
	  (lambda nil
		(concat
		 (if (string= (eshell/pwd) (getenv "HOME"))
			 (propertize "~" 'face `(:foreground "#99CCFF"))
		   (replace-regexp-in-string
			(getenv "HOME")
			(propertize "~" 'face `(:foreground "#99CCFF"))
			(propertize (eshell/pwd) 'face `(:foreground "#99CCFF"))))
		 (if (= (user-uid) 0)
			 (propertize " α " 'face `(:foreground "#FF6666"))
		 (propertize " λ " 'face `(:foreground "#A6E22E"))))))

(setq eshell-highlight-prompt nil)

(defalias 'open 'find-file-other-window)
(defalias 'clean 'eshell/clear-scrollback)

(defun eshell/sudo-open (filename)
  "Open a file as root in Eshell."
  (let ((qual-filename (if (string-match "^/" filename)
						   filename
						 (concat (expand-file-name (eshell/pwd)) "/" filename))))
	(switch-to-buffer
	 (find-file-noselect
	  (concat "/sudo::" qual-filename)))))

(defun eshell-other-window ()
  "Create or visit an eshell buffer."
  (interactive)
  (if (not (get-buffer "*eshell*"))
	  (progn
		(split-window-sensibly (selected-window))
		(other-window 1)
		(eshell))
	(switch-to-buffer-other-window "*eshell*")))

(global-set-key (kbd "<s-C-return>") 'eshell-other-window)

(use-package auto-package-update
  :defer nil
  :ensure t
  :config
  (setq auto-package-update-delete-old-versions t)
  (setq auto-package-update-hide-results t)
  (auto-package-update-maybe))

(use-package diminish
  :ensure t)

(use-package spaceline
  :ensure t)

(use-package powerline
	  :ensure t
	  :init
	  (spaceline-spacemacs-theme)
	  :hook
	  ('after-init-hook) . 'powerline-reset)

(use-package dashboard
  :ensure t
  :defer nil
  :preface
  (defun update-config ()
	"Update Osaka-emacs to the latest version."
	(interactive)
	(let ((dir (expand-file-name user-emacs-directory)))
	  (if (file-exists-p dir)
		  (progn
			(message "Osaka-emacs is updating!")
			(cd dir)
			(shell-command "git pull")
			(message "Update finished. Switch to the messages buffer to see changes and then restart Emacs"))
		(message "\"%s\" doesn't exist." dir))))

  (defun create-scratch-buffer ()
	"Create a scratch buffer"
	(interactive)
	(switch-to-buffer (get-buffer-create "*scratch*"))
	(lisp-interaction-mode))
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-items '((recents . 5)))
  (setq dashboard-banner-logo-title "O S A K A E M A C S - The dumbest Emacs distribution!")
  (setq dashboard-startup-banner "~/.emacs.d/osakavector.png")
  (setq dashboard-center-content t)
  (setq dashboard-show-shortcuts nil)
  (setq dashboard-set-init-info t)
  (setq dashboard-init-info (format "%d packages loaded in %s"
									(length package-activated-list) (emacs-init-time)))
  (setq dashboard-set-footer nil)
  (setq dashboard-set-navigator t)
  (setq dashboard-navigator-buttons
		`(;; line1
		  ((,nil
			"Osaka-emacs on github"
			"Open Osaka-emacs' github page on your browser"
			(lambda (&rest _) (browse-url "https://github.com/JoRios1006/Osaka-emacs"))
			'default)
		   (nil
			"Osaka-emacs crash course"
			"Open Osaka-emacs' introduction to Emacs"
			(lambda (&rest _) (find-file "~/.emacs.d/cheatsheet.org"))
			'default)
		   (nil
			"Update Osaka-emacs"
			"Get the latest Osaka-emacs update. Check out the github commits for changes!"
			(lambda (&rest _) (update-config))
			'default)
		   )
		  ;; line 2
		  ((,nil
			"Open scratch buffer"
			"Switch to the scratch buffer"
			(lambda (&rest _) (create-scratch-buffer))
			'default)
		   (nil
			"Open config.org"
			"Open Osaka-emacs' configuration file for easy editing"
			(lambda (&rest _) (find-file "~/.emacs.d/config.org"))
			'default)))))

;(insert (concat
;         (propertize (format "%d packages loaded in %s"
;                             (length package-activated-list) (emacs-init-time))
;                     'face 'font-lock-comment-face)))
;
;(dashboard-center-line)

(use-package which-key
  :ensure t
  :diminish which-key-mode
  :init
  (which-key-mode))

(use-package swiper
	  :ensure t
	  :bind ("C-s" . 'swiper))

(use-package evil
  :ensure t
  :defer nil
  :init
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  :config
  (evil-mode 1))

;(use-package evil-collection
;  :after evil
;  :ensure t
;  :config
;  (evil-collection-init))

(use-package beacon
  :ensure t
  :diminish beacon-mode
  :init
  (beacon-mode 1))

(use-package avy
	  :ensure t
	  :bind
	  ("M-s" . avy-goto-char))

(use-package switch-window
	  :ensure t
	  :config
	  (setq switch-window-input-style 'minibuffer)
	  (setq switch-window-increase 4)
	  (setq switch-window-threshold 2)
	  (setq switch-window-shortcut-style 'qwerty)
	  (setq switch-window-qwerty-shortcuts
		'("a" "s" "d" "f" "j" "k" "l"))
	  :bind
	  ([remap other-window] . switch-window))

(use-package ido
  :init
  (ido-mode 1)
  :config
  (setq ido-enable-flex-matching nil)
  (setq ido-create-new-buffer 'always)
  (setq ido-everywhere t))

(use-package ido-vertical-mode
  :ensure t
  :init
  (ido-vertical-mode 1))
; This enables arrow keys to select while in ido mode. If you want to
; instead use the default Emacs keybindings, change it to
; "'C-n-and-C-p-only"
(setq ido-vertical-define-keys 'C-n-C-p-up-and-down)

(use-package async
	  :ensure t
	  :init
	  (dired-async-mode 1))

(use-package page-break-lines
  :ensure t
  :diminish (page-break-lines-mode visual-line-mode))

(use-package undo-tree
  :ensure t
  :diminish undo-tree-mode)

(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
	(define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn
	(setq treemacs-collapse-dirs                 (if (executable-find "python3") 3 0)
		  treemacs-deferred-git-apply-delay      0.5
		  treemacs-display-in-side-window        t
		  treemacs-eldoc-display                 t
		  treemacs-file-event-delay              5000
		  treemacs-file-follow-delay             0.2
		  treemacs-follow-after-init             t
		  treemacs-git-command-pipe              ""
		  treemacs-goto-tag-strategy             'refetch-index
		  treemacs-indentation                   2
		  treemacs-indentation-string            " "
		  treemacs-is-never-other-window         nil
		  treemacs-max-git-entries               5000
		  treemacs-missing-project-action        'ask
		  treemacs-no-png-images                 nil
		  treemacs-no-delete-other-windows       t
		  treemacs-project-follow-cleanup        nil
		  treemacs-persist-file                  (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
		  treemacs-recenter-distance             0.1
		  treemacs-recenter-after-file-follow    nil
		  treemacs-recenter-after-tag-follow     nil
		  treemacs-recenter-after-project-jump   'always
		  treemacs-recenter-after-project-expand 'on-distance
		  treemacs-show-cursor                   nil
		  treemacs-show-hidden-files             t
		  treemacs-silent-filewatch              nil
		  treemacs-silent-refresh                nil
		  treemacs-sorting                       'alphabetic-desc
		  treemacs-space-between-root-nodes      t
		  treemacs-tag-follow-cleanup            t
		  treemacs-tag-follow-delay              1.5
		  treemacs-width                         30)
	(treemacs-resize-icons 11)

	(treemacs-follow-mode t)
	(treemacs-filewatch-mode t)
	(treemacs-fringe-indicator-mode t)
	(pcase (cons (not (null (executable-find "git")))
				 (not (null (executable-find "python3"))))
	  (`(t . t)
	   (treemacs-git-mode 'deferred))
	  (`(t . _)
	   (treemacs-git-mode 'simple))))
  :bind
  (:map global-map
		("M-0"       . treemacs-select-window)
		("C-x t 1"   . treemacs-delete-other-windows)
		("C-x t t"   . treemacs)
		("C-x t B"   . treemacs-bookmark)
		("C-x t C-t" . treemacs-find-file)
		("C-x t M-t" . treemacs-find-tag)))

(use-package treemacs-evil
  :after treemacs evil
	:ensure t)

  (use-package treemacs-icons-dired
	:after treemacs dired
	:ensure t
	:config (treemacs-icons-dired-mode))

(use-package magit
  :ensure t)

(use-package eldoc
  :diminish eldoc-mode)

(use-package abbrev
  :diminish abbrev-mode)

(use-package company
  :ensure t
  :diminish (meghanada-mode company-mode irony-mode)
  :config
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 3)
  (define-key company-active-map (kbd "M-n") nil)
  (define-key company-active-map (kbd "M-p") nil)
  (define-key company-active-map (kbd "C-n") #'company-select-next)
  (define-key company-active-map (kbd "C-p") #'company-select-previous)
  (define-key company-active-map (kbd "SPC") #'company-abort)
  :hook
  ((java-mode c-mode c++-mode) . company-mode))

(use-package yasnippet
  :ensure t
  :diminish yas-minor-mode
  :hook
  ((c-mode c++-mode) . yas-minor-mode)
  :config
  (yas-reload-all))

(use-package yasnippet-snippets
  :ensure t)

(use-package company-c-headers
  :defer nil
  :ensure t)

(use-package company-irony
  :defer nil
  :ensure t
  :config
  (setq company-backends '((company-c-headers
							company-dabbrev-code
							company-irony))))
(use-package irony
  :defer nil
  :ensure t
  :config
  :hook
  ((c++-mode c-mode) . irony-mode)
  ('irony-mode-hook) . 'irony-cdb-autosetup-compile-options)

