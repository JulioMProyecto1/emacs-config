;;;; ----------------------------
;;;; Keyboard behavior
;;;; ----------------------------
(setq x-super-keysym 'meta)
(setq x-alt-keysym nil)

;;;; ----------------------------
;;;; UI
;;;; ----------------------------
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

(load-theme 'gruber-darker t)
(setq frame-background-mode 'dark)

(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)

(set-face-attribute 'default nil
                    :family "Iosevka"
                    :height 160)

;;;; ----------------------------
;;;; Dired
;;;; ----------------------------
(require 'dired-x)
(setq dired-listing-switches "-alh --group-directories-first")

;;;; ----------------------------
;;;; Ido
;;;; ----------------------------
(ido-mode 1)
(setq ido-enable-flex-matching t
      ido-everywhere t)

;;;; ----------------------------
;;;; Shell PATH (GUI)
;;;; ----------------------------
(when (display-graphic-p)
  (require 'exec-path-from-shell)
  (exec-path-from-shell-initialize))

;;;; ----------------------------
;;;; Startup directory
;;;; ----------------------------
(setq initial-buffer-choice "~/programming/")

;;;; ----------------------------
;;;; TypeScript / TSX (Emacs 29+)
;;;; ----------------------------
(when (fboundp 'typescript-ts-mode)
  (add-to-list 'auto-mode-alist '("\\.ts\\'"  . typescript-ts-mode))
  (add-to-list 'auto-mode-alist '("\\.tsx\\'" . tsx-ts-mode)))

;; Install once:
;; M-x treesit-install-language-grammar RET typescript
;; M-x treesit-install-language-grammar RET tsx

;;;; ----------------------------
;;;; Apheleia (formatter)
;;;; ----------------------------
(use-package apheleia
  :ensure t
  :config
  (apheleia-global-mode +1)

  ;; Use project-local prettier via npx
  (setf (alist-get 'prettier apheleia-formatters)
        '("npx" "--yes" "prettier" "--stdin-filepath" filepath))

  (add-to-list 'apheleia-mode-alist '(js-mode . prettier))
  (add-to-list 'apheleia-mode-alist '(typescript-ts-mode . prettier))
  (add-to-list 'apheleia-mode-alist '(tsx-ts-mode . prettier)))

;;;; ----------------------------
;;;; Grep (ignore node_modules)
;;;; ----------------------------
(with-eval-after-load 'grep
  (add-to-list 'grep-find-ignored-directories "node_modules"))

(setq treesit-language-source-alist
      '((typescript . ("https://github.com/tree-sitter/tree-sitter-typescript"
                       "master"
                       "typescript/src"))
        (tsx        . ("https://github.com/tree-sitter/tree-sitter-typescript"
                       "master"
                       "tsx/src"))
        (javascript . ("https://github.com/tree-sitter/tree-sitter-javascript"
                       "master"
                       "src"))))
(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize))
(add-hook 'typescript-ts-mode-hook #'eglot-ensure)
(add-hook 'tsx-ts-mode-hook #'eglot-ensure)
(global-set-key (kbd "M-.") #'xref-find-definitions)
(global-set-key (kbd "M-,") #'xref-go-back)

;; Do NOT auto-preview xref results
(setq xref-show-definitions-function #'xref-show-definitions-completing-read)
(setq xref-show-xrefs-function       #'xref-show-xrefs-completing-read)
(setq eldoc-echo-area-use-multiline-p nil)
