;;; rc-javascript.el ---                             -*- lexical-binding: t; -*-

;; open javascript interactive shell.
(defun jsc ()
  (interactive)
  (eshell "JSC")
  (insert "rhino")
  (eshell-send-input "


;;Javascript
;; js2
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

(add-to-list 'interpreter-mode-alist '("node" . js2-mode))

(require 'js-comint)
(setq inferior-js-program-command "~/.emacs.d/node-v6.5.0-linux-x64/bin/node")

(setq process-coding-system-alist
      (cons '("js" utf-8 . utf-8) process-coding-system-alist)) ;shit didn't work


(setq inferior-js-mode-hook
      (lambda ()
        ;; We like nice colors
        (ansi-color-for-comint-mode-on)
	(rainbow-delimiters-mode)
        ;; Deal with some prompt nonsense
        (add-to-list 'comint-preoutput-filter-functions
                     (lambda (output)
                       (replace-regexp-in-string ".*1G\.\.\..*5G" "..."
						 (replace-regexp-in-string ".*1G.*3G" "&gt;" output))))))

(add-hook 'js2-mode-hook 'js-comint-my-conf)
(add-hook 'js2-mode-hook
          (lambda () (push '("function" . ?ƒ) prettify-symbols-alist)))
(add-hook 'js2-mode-hook #'rainbow-delimiters-mode)
(setq js2-basic-offset 2)

(defun js-comint-my-conf ()
  (local-set-key "\C-x\C-e" 'js-send-last-sexp)
  (local-set-key "\C-\M-x" 'js-send-last-sexp-and-go)
  (local-set-key "\C-cb" 'js-send-buffer)
  (local-set-key (kbd "<f5>") 'js-send-buffer)
  (local-set-key "\C-c\C-l" 'js-send-buffer-and-go)
  (local-set-key "\C-cl" 'js-load-file-and-go)

  )

;;(autoload 'tern-mode "tern.el" nil t)
;;(add-hook 'js-mode-hook (lambda () (tern-mode t)))

;; (define-key js2-mode-map (kbd "<f5>") 'call-nodejs-command)
(defun call-nodunejs-command ()
  (interactive)
  (save-buffer)(shell-command (format "node %s" (buffer-real-name))))

(defun js-buffer-to-multiline-string ()
  (interactive)
  (kill-new
   (mapconcat
    (lambda (line)
      (concat "'" line "'"))
    (remove-if (lambda (str) (eq (length str) 0))
	       (split-string (buffer-string) "\n"))
    " +\n")
   )
  (message "Copied!")
  )

(defun js-onohiroko-auto-set-indent ()
  "Auto decide how many spaces for indentation.

  [WARNING] This function is just for my personal using
scenario; which is ABSOLUTE NOT what you guess. "
  (if (string-match (map 'string 'identity '(73 110 116 114 105 115 105 110 103))
                    (buffer-file-name))
      (setq-local js-indent-level 2)))

(add-hook 'mmm-mode-hook 'js-onohiroko-auto-set-indent)

(provide 'rc-js)
;;; rc-javascript.el ends here