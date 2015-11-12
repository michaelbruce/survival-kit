; TODO my current attempt at unbinding the C-c prefix key
;(global-unset-key (kbd "C-c"))
(global-set-key (kbd "C-c") (aif (evil-normal-state) (keyboard-quit)))
(require 'evil)
(evil-mode 1)
(require 'redo)
;(require 'rect-mark)
(global-set-key (kbd "C-z") 'suspend-emacs)

(setq next-line-add-newlines nil)
(defalias 'yes-or-no-p 'y-or-n-p)

(define-key evil-normal-state-map (kbd "C-h") 'windmove-left)
(define-key evil-normal-state-map (kbd "C-l") 'windmove-right)
(define-key evil-normal-state-map (kbd "C-k") 'windmove-up)
(define-key evil-normal-state-map (kbd "C-j") 'windmove-down)
(define-key evil-normal-state-map (kbd "C-z") 'suspend-emacs)
(define-key evil-normal-state-map (kbd "C-^") 'evil-buffer)

(setq-default
 major-mode 'ruby-mode
 indent-tabs-mode nil
 c-basic-offset 2
 tab-width 2
 default-tab-width 2
 truncate-lines 1)

;; --- Clipboard Integration --------------------------------------------------------------------
(if (and (eq system-type 'darwin) (not window-system)) ;; For OSX
    (progn
      (defvar osx-clipboard-last-selected-text nil)
      (setq interprogram-cut-function 'mikepjb/osx-clipboard-cut-function
            interprogram-paste-function 'mikepjb/osx-clipboard-paste-function))
  )

(if (and (eq system-type 'gnu/linux) (notwindow-system)) ;; For linux
    (progn
      (setq x-select-enable-clipboard t)
      (setq interprogram-cut-function   'mikepjb/xsel-cut-function
            interprogram-paste-function 'mikepjb/xsel-paste-function))
  )

(provide 'start)
