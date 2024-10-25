(set-cursor-color "#00ff00")
(global-set-key (kbd "<f5>") 'ispell-buffer)
(global-set-key (kbd "<f6>") 'delete-trailing-whitespace)
(global-set-key (kbd "<f7>") 'visual-line-mode)
(global-set-key (kbd "<f8>") 'set-buffer-file-coding-system)
(global-set-key (kbd "<f9>") 'hangul-input-method-deactivate)
(setq-default fill-column 80)

;; LaTeX is special, set it up to be convenient
(setq auto-mode-alist (cons '("\\.tex$" . latex-mode) auto-mode-alist))
(add-hook 'latex-mode-hook 'visual-line-mode) ; start visual-line-mode
(add-hook 'latex-mode-hook 'flyspell-mode)    ; start flyspell-mode

;; setup language for ispell
(setq ispell-dictionary "american")           ; set the default dictionary

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(epg-gpg-program "gpg1"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Noto Sans Mono" :foundry "GOOG" :slant normal :weight regular :height 181 :width normal)))))

;;(setq epa-pinentry-mode 'loopback)
;;;;(setq ring-bell-function 'ignore)
