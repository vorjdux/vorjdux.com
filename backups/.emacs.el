;; Melpa Repository
(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (url (concat (if no-ssl "http" "https") "://melpa.org/packages/")))
  (add-to-list 'package-archives (cons "melpa" url) t))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))

;; Inicializations
(package-initialize)

;; load path
(add-to-list 'load-path "~/.emacs.d/elpa")
(add-to-list 'load-path "~/.emacs.d/themes")
(add-to-list 'load-path "~/.emacs.d/manual")
(add-to-list 'load-path "~/.emacs.d/manual/multiple-cursors.el")
(add-to-list 'load-path "~/.emacs.d/manual/helm")
(add-to-list 'load-path "~/.emacs.d/manual/apib-mode")

;; Requires
(require 'multiple-cursors)
(require 'helm)
(require 'projectile)
(require 'helm-projectile)
(require 'jedi)
(require 'apib-mode)
(require 'restclient)
(require 'web-mode)


;; backup files
(setq make-backup-files nil)

;; clipboard
(delete-selection-mode)

;; themes & related configurations
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(mode-line ((t (:foreground "#00ffff" :background "black" :box nil))))
 '(mode-line-inactive ((t (:foreground "#ffffff" :background nil :box nil)))))

;; Custom Variables
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (erlang web-mode django-theme django-mode jinja2-mode restclient virtualenvwrapper jedi multiple-cursors helm-projectile projectile helm)))
 '(safe-local-variable-values (quote ((engine . django)))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Custom commands ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Duplicate line
(defun duplicate-current-line ()
  (interactive)
  (beginning-of-line nil)
  (let ((b (point)))
    (end-of-line nil)
    (copy-region-as-kill b (point)))
  (beginning-of-line 2)
  (open-line 1)
  (yank)
  (back-to-indentation))

(global-set-key (kbd "C-c C-d") 'duplicate-current-line)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Multiple-cursors keys configuration
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

;; Jedi
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)

;; Virtualenvwrapper
(require 'virtualenvwrapper)
(venv-initialize-interactive-shells)

;; tabs & indentation
(setq-default indent-tabs-mode t)
(setq tab-width 4)
(setq tab-width-8 8)
(defvaralias 'c-basic-offset 'tab-width-8)
(defvaralias 'cperl-indent-level 'tab-width)
(setq js-indent-level 4)
;; (add-hook 'html-mode-hook
;;	  (lambda ()
;;	    ;; Default indentation is usually 2 spaces, changing to 2.
;;	    (set (make-local-variable 'sgml-basic-offset) 2)))
(c-set-offset 'arglist-intro 8)
(c-set-offset 'arglist-close 0)
(c-set-offset 'arglist-cont-nonempty 8)
(c-set-offset 'case-label 8)
(c-set-offset 'statement-cont 0)
(c-set-offset 'substatement-open 0)
(c-set-offset 'member-init-cont -1000)
(add-hook 'python-mode-hook
	  (lambda ()
	    (setq indent-tabs-mode nil)
	    (setq tab-width 4)
	    (setq python-indent-offset 4)))
(add-hook 'less-css-mode-hook
	  (lambda ()
	    (setq indent-tabs-mode t)
	    (setq tab-width 4)))
(setq css-indent-offset 4)
(add-hook 'sh-mode-hook
	  (lambda ()
	    (setq indent-tabs-mode t)))

;; line wrapping
(set-default 'truncate-lines t)

;; menu bar
(menu-bar-mode -1)
(column-number-mode 1)

;; git
(global-git-gutter+-mode)

;; ido
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)
(setq ido-ignore-buffers '("\\` " "^\*"))

;; desktop & workspace
(desktop-save-mode 1)
(setq desktop-restore-frames t)
(setq desktop-restore-forces-onscreen nil)
(projectile-global-mode)
(helm-projectile-on)
(setq projectile-enable-caching t)
(setq projectile-switch-project-action 'helm-projectile-find-file)

;; Themes
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(load-theme 'aurora t)
(set-background-color "black")

;; buffer cycling
(defvar xah-switch-buffer-ignore-dired t "If t, ignore dired buffer when calling `xah-next-user-buffer' or `xah-previous-user-buffer'")
(setq xah-switch-buffer-ignore-dired t)

(defun xah-next-user-buffer ()
  "Switch to the next user buffer.
 “user buffer” is a buffer whose name does not start with “*”.
If `xah-switch-buffer-ignore-dired' is true, also skip directory buffer.
2015-01-05 URL `http://ergoemacs.org/emacs/elisp_next_prev_user_buffer.html'"
  (interactive)
  (next-buffer)
    (let ((i 0))
      (while (< i 20)
	(if (or
	     (string-equal "*" (substring (buffer-name) 0 1))
	     (if (string-equal major-mode "dired-mode")
		 xah-switch-buffer-ignore-dired
	       nil
	       ))
	    (progn (next-buffer)
		   (setq i (1+ i)))
	  (progn (setq i 100))))))

(defun xah-previous-user-buffer ()
    "Switch to the previous user buffer.
 “user buffer” is a buffer whose name does not start with “*”.
If `xah-switch-buffer-ignore-dired' is true, also skip directory buffer.
2015-01-05 URL `http://ergoemacs.org/emacs/elisp_next_prev_user_buffer.html'"
    (interactive)
    (previous-buffer)
    (let ((i 0))
      (while (< i 20)
	(if (or
	     (string-equal "*" (substring (buffer-name) 0 1))
	     (if (string-equal major-mode "dired-mode")
		 xah-switch-buffer-ignore-dired
	       nil
	       ))
	    (progn (previous-buffer)
		   (setq i (1+ i)))
	          (progn (setq i 100))))))

;; compilation
(setq compilation-scroll-output t)

;; folding
(add-hook 'c++-mode-hook 'hs-minor-mode)
(add-hook 'c-mode-common-hook 'hs-minor-mode)
(add-hook 'emacs-lisp-mode-hook 'hs-minor-mode)
(add-hook 'java-mode-hook 'hs-minor-mode)
(add-hook 'lisp-mode-hook 'hs-minor-mode)
(add-hook 'perl-mode-hook 'hs-minor-mode)
(add-hook 'sh-mode-hook 'hs-minor-mode)
(add-hook 'js2-mode-hook 'hs-minor-mode)
(add-hook 'prolog-mode-hook 'hs-minor-mode)
(add-hook 'erlang-mode-hook 'hs-minor-mode)
(add-hook 'markdown-mode-hook 'hs-minor-mode)
(add-hook 'apib-mode-hook 'hs-minor-mode)
(setq hs-hide-initial-comment-block t)

;;apib tweaks
(autoload 'apib-mode "apib-mode"
          "Major mode for editing API Blueprint files" t)
(add-to-list 'auto-mode-alist '("\\.apib\\'" . apib-mode))

;; erlang tweaks
(add-hook 'erlang-mode-hook
	  (lambda ()
	    (define-key erlang-mode-map "\M-q" 'tmux-like-navigation)
	    (global-set-key (kbd "M-q") 'tmux-like-navigation)))

;; c++ tweaks
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.conf\\'" . js2-mode))
(defadvice c-lineup-arglist (around my activate)
  "Improve indentation of continued C++11 lambda function opened as argument."
  (setq ad-return-value
	(if (and (equal major-mode 'c++-mode)
		 (ignore-errors
		   (save-excursion
		     (goto-char (c-langelem-pos langelem))
		     ;; Detect "[...](" or "[...]{". preceded by "," or "(",
		     ;;   and with unclosed brace.
		     (looking-at ".*[(,][ \t]*\\[[^]]*\\][ \t]*[({][^}]*$"))))
	    0                           ; no additional indent
	  ad-do-it)))  

;; prolog tweaks
(add-to-list 'auto-mode-alist '("\\.pro\\'" . prolog-mode))

;; html tweaks
;; (setq mweb-default-major-mode 'html-mode)
;; (setq mweb-tags '((js-mode "<script*>" "</script>")
;; 		  (css-mode "<style +type=\"text/css\"[^>]*>" "</style>")))
;; (setq mweb-filename-extensions '("htm" "html"))
;; (multi-web-global-mode 1)
(setq web-mode-enable-engine-detection t)
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))


;; javascript tweaks
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(add-hook 'js2-mode-hook 'js2-mode-hide-warnings-and-errors)

;; less-css tweaks
(add-to-list 'auto-mode-alist '("\\.scss\\'" . less-css-mode))
(add-to-list 'auto-mode-alist '("\\.overrides\\'" . less-css-mode))
(add-to-list 'auto-mode-alist '("\\.variables\\'" . less-css-mode))

;; gnuplot
(setq auto-mode-alist
      (append '(("\\.\\(gp\\|gnuplot\\)$" . gnuplot-mode)) auto-mode-alist))
(setq auto-mode-alist
      (append '(("etc/default/" . conf-unix-mode)) auto-mode-alist))

;; markdown tweaks
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(add-hook 'markdown-mode-hook
	  (lambda ()
	    (define-key markdown-mode-map "\M-S-<left>" 'xah-previous-user-buffer)
	    (define-key markdown-mode-map "\M-S-<right>" 'xah-next-user-buffer)
	    (global-set-key (kbd "M-S-<left>") 'xah-previous-user-buffer)
	    (global-set-key (kbd "M-S-<right>") 'xah-next-user-buffer)))

;; navigation
(define-prefix-command 'tmux-like-navigation)

;; key bindings
(global-set-key (kbd "C-o") 'find-file)
(global-set-key (kbd "C-x C-f") 'projectile-find-file)
(global-set-key (kbd "M-f") 'projectile-ag)
(global-set-key (kbd "M-Q w") 'projectile-dired)
(global-set-key (kbd "C-M-p") 'desktop-change-dir)
(global-set-key (kbd "M-r") 'replace-string)
(global-set-key (kbd "C-M-f") 'replace-regexp)
(global-set-key (kbd "C-l") 'goto-line)
(global-set-key (kbd "C-x s") 'copy-file)
(global-set-key (kbd "M-S-<left>") 'xah-previous-user-buffer)
(global-set-key (kbd "M-S-<right>") 'xah-next-user-buffer)
(global-set-key (kbd "C-b") 'projectile-compile-project)
(global-set-key (kbd "M-Q") 'mc/mark-next-like-this)
(global-set-key (kbd "M-C") 'mc/edit-lines)
(global-set-key (kbd "C-c c") 'hs-toggle-hiding)

(global-set-key (kbd "M-q") 'tmux-like-navigation)
(global-set-key (kbd "M-q <left>") 'windmove-left)
(global-set-key (kbd "M-q <right>") 'windmove-right)
(global-set-key (kbd "M-q <up>") 'windmove-up)
(global-set-key (kbd "M-q <down>") 'windmove-down)
