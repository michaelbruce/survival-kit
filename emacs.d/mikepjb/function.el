;;;###autoload
(defmacro aif (&rest forms)
    "Create an anonymous interactive function.
    Mainly for use when binding a key to a non-interactive function."
    `(lambda () (interactive) ,@forms))

;;;###autoload
(defun mikepjb/osx-clipboard-cut-function (text &rest ignore)
    "Copy TEXT to the OS X clipboard using \"pbpaste\".
This is set as the value of `interprogram-cut-function' by
`osx-clipboard-mode'.  It should only be used when Emacs is running in a
text terminal."
    (with-temp-buffer
      (insert text)
      (with-demoted-errors "Error calling pbcopy: %S"
	(call-process-region (point-min) (point-max) "pbcopy"))))

;;;###autoload
(defun mikepjb/osx-clipboard-paste-function ()
  "Return the value of the OS X clipboard using \"pbcopy\".
This is set as the value of `interprogram-paste-function' by
`osx-clipboard-mode'.  It should only be used when Emacs is running in a
text terminal."
  (with-temp-buffer
    (with-demoted-errors "Error calling pbpaste: %S"
      (call-process "pbpaste" nil t)
      (let ((text (buffer-substring-no-properties (point-min) (point-max))))
  ;; The following logic is adapted from `x-selection-value'
  ;; in `ns-win.el.gz'
  (cond
    ((or
       ;; Avoid copying an empty clipboard, or copying the same
       ;; text twice
       (not text)
       (eq text osx-clipboard-last-selected-text)
       (string= text "")
       (string= text (car kill-ring))) nil)
    ((string= text osx-clipboard-last-selected-text)
     ;; Record the newer string, so subsequent calls can use the `eq' test.
     (setq osx-clipboard-last-selected-text text)
     nil)
    (t
      (setq osx-clipboard-last-selected-text text)))))))

;;;###autoload
(defun mikepjb/xsel-cut-function (text &optional push)
  (with-temp-buffer
    (insert text)
    (call-process-region (point-min) (point-max)
      "xsel" nil 0 nil "--clipboard" "--input")))

;;;###autoload
(defun mikepjb/xsel-paste-function()
  (let ((xsel-output (shell-command-to-string "xsel --clipboard --output")))
    (unless (string= (car kill-ring) xsel-output)
                xsel-output )))

;;;###autoload
(defun mikepjb/code-hooks ()
  "Added common behaviour to code editing modes"
            (hl-line-mode 1)
            (hs-minor-mode 1)
            (linum-mode 1))

;;;###autoload
(defun map-normal-evil (key def &rest bindings)
  "Bind `key' to command `def' in `evil-leader/default-map'.
Key has to be readable by `read-kbd-macro' and `def' a command.
Accepts further `key' `def' pairs."
  (interactive "kKey: \naCommand: ")
  (evil-define-key 'normal evil-normal-state-map key def bindings))
(put 'evil-define-key 'lisp-indent-function 'defun)

;;;###autoload
(defun fill-keymap (keymap &rest mappings)
  "Fill `KEYMAP' with `MAPPINGS'.
See `pour-mappings-to'."
  (declare (indent defun))
  (pour-mappings-to keymap mappings))

(defun pour-mappings-to (map mappings)
  "Calls `cofi/set-key' with `map' on every key-fun pair in `MAPPINGS'.
`MAPPINGS' is a list of string-fun pairs, with a `READ-KBD-MACRO'-readable string and a interactive-fun."
  (dolist (mapping (group mappings 2))
    (mikepjb/set-key map (car mapping) (cadr mapping)))
  map)

(defun group (lst n)
  "Group `LST' into portions of `N'."
  (let (groups)
    (while lst
      (push (take n lst) groups)
      (setq lst (nthcdr n lst)))
    (nreverse groups)))

(defun take (n lst)
  "Return atmost the first `N' items of `LST'."
  (let (acc '())
    (while (and lst (> n 0))
      (cl-decf n)
      (push (car lst) acc)
      (setq  lst (cdr lst)))
    (nreverse acc)))

;;; keybinding
(defun mikepjb/set-key (map spec cmd)
  "Set in `map' `spec' to `cmd'.
`Map' may be `'global' `'local' or a keymap.
A `spec' can be a `read-kbd-macro'-readable string or a vector."
  (let ((setter-fun (cl-case map
                      (global #'global-set-key)
                      (local  #'local-set-key)
                      (t      (lambda (key def) (define-key map key def)))))
        (key (cl-typecase spec
               (vector spec)
               (string (read-kbd-macro spec))
               (t (error "wrong argument")))))
    (funcall setter-fun key cmd)))

;;;###autoload
(defun mikepjb/navigation-bindings ()
  (local-set-key (kbd "C-q") (lambda ()
                               (interactive)
                               (evil-quit)
                               (balance-windows)))
  (local-set-key (kbd "C-^") 'evil-buffer)
  (local-set-key (kbd "C-h") 'windmove-left)
  (local-set-key (kbd "C-j") 'windmove-down)
  (local-set-key (kbd "C-k") 'windmove-up)
  (local-set-key (kbd "C-l") 'windmove-right)
  )

;;;###autoload
(defun mikepjb/display-time ()
  (interactive)
  (defvar eve-output)
  (setq eve-output (shell-command-to-string "echo -ne $(date)"))
  (setq eve-output (concat eve-output ", tts: " (mikepjb/time-til-sleep)))
  (message eve-output)
  )

;;;###autoload
(defun mikepjb/time-til-sleep ()
  (interactive)
  (setq eve-wake-time 6)
  (setq eve-current-hour (string-to-number
		      (shell-command-to-string "echo -ne $(date +%H)")))
  (setq eve-current-minute (string-to-number
		      (shell-command-to-string "echo -ne $(date +%M)")))

  (if (<= eve-current-hour 5)
      (setq eve-hours-left (- eve-wake-time eve-current-hour))
      (setq eve-hours-left (+ (- 23 eve-current-hour) eve-wake-time))
      )

  (setq eve-minutes-left (- 60 eve-current-minute))
  (setq eve-minutes-left (number-to-string eve-minutes-left))

  (setq eve-hours-left (number-to-string eve-hours-left))
  (setq eve-output (concat eve-hours-left "h" eve-minutes-left))
  (message "%s" eve-output)
  )

;;;###autoload
(defun mikepjb/comment-or-uncomment-region-or-line ()
  "Comments or uncomments the region or the current line if there's no active region."
  (interactive)
  (let (beg end)
    (if (region-active-p)
	(setq beg (region-beginning) end (region-end))
      (setq beg (line-beginning-position) end (line-end-position)))
            (comment-or-uncomment-region beg end)))

;;;###autoload
(defun mikepjb/launch-postgres ()
  (interactive)
  (if (eq system-type 'darwin) 
      (shell-command "pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start")
    (shell-command "sudo systemctl start postgresql")
    )
  )

;;;###autoload
(defun mikepjb/run-test ()
  (interactive)
  (if (eq major-mode 'ruby-mode)
      (rspec-verify)
    (message "This isn't a ruby file")
    )
  )

;;;###autoload
(defun mikepjb/run-region-or-file ()
  (interactive)
  (let (beg end)
    ;; Elisp
    (if (eq major-mode 'emacs-lisp-mode)
	(if (region-active-p)
	    (progn (call-interactively 'eval-region)
		   (setq deactivate-mark t))
	  (load-file buffer-file-name)
	  )
      )
    ;; Ruby
    (if (eq major-mode 'ruby-mode)
	(if (region-active-p)
	    (progn (call-interactively 'ruby-send-region)
		   (setq deactivate-mark t))
	  (ruby-load-file buffer-file-name)
	  )
      )
    ;; Python
    (if (eq major-mode 'python-mode)
        (if (region-active-p)
            (progn (setq deactivate-mark t))
          (python-shell-switch-to-shell)
          )
      )
    )
    ;; Org
    (if (eq major-mode 'org-mode)
        (org-publish-current-project)
        )
    ;; Clojure
    (if (eq major-mode 'clojure-mode)
        (if (region-active-p)
            (progn (call-interactively 'inf-clojure-eval-region)
        	   (setq deactivate-mark t))
          (inf-clojure-load-file buffer-file-name)
          )
      )
    ;; Snippets
    (if (eq major-mode 'snippet-mode)
        (yas-reload-all)
      )
    ;; Salesforce - Apex and Visualforce
    (if (and (eq major-mode 'web-mode) (or (string-match "\\.page\\'" buffer-file-name)
                                           (string-match "\\.component\\'" buffer-file-name)))
        (mikepjb/salesforce-deploy-current-file)
      )
    (if (and (eq major-mode 'java-mode) (string-match "\\.cls\\'" buffer-file-name))
        (mikepjb/salesforce-deploy-current-file)
      )
  )

;;;###autoload
(defun mikepjb/salesforce-deploy-current-file ()
  "Deploys the current file in buffer to salesforce."
  (interactive)
  (save-buffer)
  (progn (write-region (concat
		 (concat "src" (car (last (split-string (buffer-file-name) "src" t))))
		 "\n"
		 (concat "src" (car (last (split-string (buffer-file-name) "src" t))))
		 "-meta.xml") nil "/tmp/currentFile")
  (compile (let ((home (getenv "HOME")))
		 (format "%s"
			 (concat "java -jar " home "/dotfiles/tooling-force.com-0.3.4.0.jar "
				 "--action=deploySpecificFiles "
				 "--config=" home "/notes/SingletrackDev.properties "
				 "--projectPath=" home "/Workspace/Singletrack-Core/SingletrackDev "
				 "--responseFilePath=/tmp/responseFile "
				 "--specificFiles=/tmp/currentFile "
				 "--ignoreConflicts=true "
				 "--pollWaitMillis=1000 "
				 "--maxPollRequests=1000"))))))



(provide 'function)
