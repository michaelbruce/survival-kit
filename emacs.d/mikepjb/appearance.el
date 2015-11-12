;; UI options
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1)) ;; causes resize weirdness on rerun in fullscreen
;; consider (menu-bar-mode nil)
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)
(setq initial-scratch-message nil)

;; --- GUI Options ------------------------------------------------------------------------------ 
(when (or (eq window-system 'ns)
          (eq window-system 'x))

  (global-set-key (kbd "<s-return>") 'toggle-frame-fullscreen)
  (set-face-attribute 'default nil :font "Inconsolata" :height 160 :bold t) ;; Takes 80ms...
  (set-frame-size (selected-frame) 120 42) ;; Load after font size set
  (setq ring-bell-function 'ignore)
  (set-frame-parameter (selected-frame) 'alpha '(93 93))
  (global-set-key (kbd "<f6>") 'evelyn/toggle-transparency)
  )

(if (eq window-system 'ns)
    (progn (setq-default ns-use-native-fullscreen nil) ;; prefer non-native fullscreen
           (setq-default exec-path (append '("/usr/local/bin") exec-path))
           (setenv "PATH" (concat "/usr/local/bin:" (getenv "PATH"))))
  )

;; --- Options ------------------------------------------------------------------------------ 

(defun display-startup-echo-area-message ()
    (message "Adagio Summoner!"))

(blink-cursor-mode -1)
(setq visible-cursor nil) ;; Disabled cvvis terminfo sequence as urxvt blink the cursor.

(blink-cursor-mode -1)
(setq visible-cursor nil) ;; Disabled cvvis terminfo sequence as urxvt blink the cursor.

(when (or (eq window-system 'ns)
          (eq window-system 'x))
  (fringe-mode 0) ;; Hides fringes
  )

(setq linum-format " %d ")

(setq evil-insert-state-cursor '(bar)
      evil-normal-state-cursor '(box))

(setq-default mode-line-format nil)
;(setq-default mode-line-format
;              (list "-- "
;                    (propertize "%b[%*]" 'face '(:foreground "#99A600"))
;                    " [%m] [%l,%c] %-"))

;; Define colors

;; view all faces with list-faces-display
(custom-set-faces
 '(default ((((class color)) (:foreground "#eeeeee" :background "color-16")))) ;
 ;; '(default ((((class color)) (:foreground "#eeeeee" :background "#222222"))))
 '(grizzl-selection-face ((((class color)) (:foreground nil :background nil))))
 '(hl-line ((((class color)) (:foreground nil :background "#303030"))))
 '(linum ((((class color)) (:foreground "#5f5f5f" :background "#222222"))))
 '(linum-highlight-face ((((class color)) (:foreground "#ffafff" :background "#303030"))))
 '(fringe ((((class color)) (:foreground nil :background nil))))
 '(mode-line ((((class color)) (:foreground "#878787" :background "#222222" :overline nil :underline nil))))
 '(mode-line-inactive ((((class color)) (:foreground "#5f5f5f" :background "#222222" :overline nil :underline nil))))
 '(vertical-border ((((class color)) (:foreground "#5f5f5f"))))
 '(org-link ((((class color)) (:foreground "#ff0087"))))
 '(comint-highlight-prompt ((((class color)) (:foreground "#ff0087"))))
 '(minibuffer-prompt ((((class color)) (:foreground "#ff0087"))))
 '(show-paren-match ((((class color)) (:foreground "#00ffcc"))))
 '(region ((((class color)) (:background "#140029"))))

 ;; Syntax highlighting (a.k.a Font Locking)
 '(font-lock-comment-face ((((class color)) (:foreground "#878787" :italic t))))
 '(font-lock-function-name-face ((((class color)) (:foreground "#88d400"))))
 '(font-lock-variable-face ((((class color)) (:foreground "#ffaf00"))))
 '(font-lock-variable-name-face ((((class color)) (:foreground "#afd787"))))
 '(font-lock-keyword-face ((((class color)) (:foreground "#ff0087"))))
 '(font-lock-type-face ((((class color)) (:foreground "#ffaf00"))))
 '(font-lock-constant-face ((((class color)) (:foreground "#af87ff"))))
 '(font-lock-builtin-face ((((class color)) (:foreground "#ff0087"))))
 '(font-lock-preprocessor-face ((((class color)) (:foreground "#ff0087"))))
 '(font-lock-string-face ((((class color)) (:foreground "#ffff87"))))

 ;; Org-mode
 '(org-level-1 ((((class color)) (:foreground "#ffaf00"))))
 '(org-level-2 ((((class color)) (:foreground "#af87ff"))))

 ;; Helm
 '(helm-source-header ((((class color)) (:foreground "#ff0087" :height 160))))
 '(helm-selection ((((class color)) (:foreground "#EEEEEE" :background "#af87cc"))))
 '(helm-visible-mark ((((class color)) (:foreground "#EEEEEE" :background "#af87cc"))))
 )

(setq org-todo-keyword-faces
      '(("TODO" . (:foreground "green" :weight bold))
        ("DONE" . (:foreground "cyan" :weight bold))
        ("WAITING" . (:foreground "red" :weight bold))
        ("SOMEDAY" . (:foreground "gray" :weight bold))))

(provide 'appearance)
