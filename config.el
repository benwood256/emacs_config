

(load-theme 'dracula t)                             ;; theme type


(set-face-attribute 'font-lock-comment-face nil     ;; comments were too feint, changed colour
                  :foreground "#56B6C2"  
                  :slant 'italic)

(set-frame-font "JetBrainsMono Nerd Font-14" nil t) ;; font type & size

(set-face-attribute 'org-level-1 nil
		    :height 1.25)

;; searching for packages also includes 'melpa' -> default is only gnu & nongnu
(setq package-archives
	    '(("gnu"    . "https://elpa.gnu.org/packages/")
	    ("nongnu" . "https://elpa.nongnu.org/nongnu/")
	    ("melpa"  . "https://melpa.org/packages/")))

(require 'evil)                                   ;; Evil package
(evil-mode 1)

(require 'consult)                                ;; Consult package
(global-set-key (kbd "M-y") 'consult-yank-pop)    ;; Binds the key M-y to the function consult-yank-pop
(global-set-key (kbd "C-x b") #'consult-buffer)   ;; switch buffers/files with consult

(require 'vertico)                                ;; Vertico package
(vertico-mode 1)

(add-hook 'text-mode-hook #'flyspell-mode)        ;; Spellcheck for Emacs

;; can't boot in the symbols without this
(require 'nerd-icons)

;; set keybinding (C-c d) to return to the homepage -> M-x dashboard-open
(global-set-key (kbd "C-c d") #'dashboard-open)

;; use-package with package.el:
(use-package dashboard
    :ensure t
    :config

    ;; Set the title
    (setq dashboard-banner-logo-title "Chaos is a ladder")

    ;; Set the banner
    (setq dashboard-startup-banner "~/.emacs.d/images/targaryen.png")

    ;; cap the size of the image pixels
    (setq dashboard-image-banner-max-height 300)


    ;; To disable shortcut "jump" indicators for each section, set
    (setq dashboard-show-shortcuts nil)

    ;; which widgets are displayed -> 6 means 6 items will be displayed under this sub-header
    (setq dashboard-items '((bookmarks . 7)
                            (recents  . 3)))

    ;; Content is not centered by default. To center, set
    (setq dashboard-center-content t)

    ;; add heading icons
    (setq dashboard-icon-type 'nerd-icons)
    (setq dashboard-set-heading-icons t)
    (setq dashboard-set-file-icons t)

    ;; select the heading icons & assing them
    (dashboard-modify-heading-icons '((recents . "nf-oct-history")
                                    (bookmarks . "nf-oct-book")))

    (with-eval-after-load 'dashboard
    (set-face-attribute 'dashboard-banner-logo-title-face nil ;; the quote
                        :height 180
                        :weight 'bold)
    (set-face-attribute 'dashboard-heading-face nil           ;; section headings (recents, bookmarks, registers)
			:height 200
                        :weight 'bold)
    (set-face-attribute 'dashboard-items-face nil
                        :height 125))

    ;; orders the layout of dashboard, all the newlines are a space (so I can center my image, then have everything else follow)
    (setq dashboard-startupify-list
    '(dashboard-insert-banner
    dashboard-insert-newline
    dashboard-insert-banner-title
    dashboard-insert-navigator
    dashboard-insert-newline
    dashboard-insert-init-info
    dashboard-insert-items
    dashboard-insert-newline))

    ;; format 'bookmarks' so it hides the file paths (& just shows the names)
    (setq dashboard-bookmarks-item-format "%s")

    ;; move cursor to first link on homescreen
    (defun my-dashboard-goto-first-item ()
        (goto-char (point-min))
        (re-search-forward "^  " nil t)
        (back-to-indentation))
    (add-hook 'dashboard-after-initialize-hook #'my-dashboard-goto-first-item)

    (dashboard-setup-startup-hook))

;; (add-to-list 'default-frame-alist '(alpha-background . 85))  ;; Sets opacity for future Emacs frames (frame -> the Emacs window)

(setq org-startup-indented t)                     ;; Indent headers within headers

(add-hook 'org-mode-hook #'org-num-mode)          ;; Add number mode (i.e. each header & subsequent header is numbered)

(setq org-hide-emphasis-markers t)                ;; Hide Remove bold/italic extra syntax
                                                  ;; (i.e. *bold this* would just come bold this -> org mode would ignore the *s)
(setq org-M-RET-may-split-line nil)               ;; When using M-RET (new bullet point), it won't split the text & move it down
                                                  ;; (i.e. if I was in the middle of a line, it would move all the text to the next bullet point)

;; When I start a list (C-c -), it starts at 1. instead of -(defun my-org-numbered-list ()                    
(defun my-org-numbered-list ()                    ;; (define-function create-a-new-function (empty = takes no arguments))
  (interactive)                                   ;; This function can be called by a user interactively -> allows me to bind a key to my function
  (beginning-of-line)                             ;; Moves cursor to beginning of line
  (insert "1. "))                                 ;; Inserts 1.
(with-eval-after-load 'org                        ;; Wait until in org-mode before running (can't use this function in any other mode -> error)
  (define-key org-mode-map (kbd "C-c -")          ;; Sets this keyboard shortcut
              #'my-org-numbered-list))            ;; When shortcut is pressed, run my function


;; allow org babel to evaluate these languages if code blocks are placed between #+begin_src <name> & #+end_src
(org-babel-do-load-languages
   'org-babel-load-languages
       '((python . t)                             ;; Python
         (js . t)                                 ;; JavaScript
         (shell . t)))                            ;; shell

(setq make-backup-files t)                        ;; Forces Emacs to check & update backup files before I save them -> <filename>~

(global-display-line-numbers-mode 1)              ;; Set up numbers at the start of each line

(setq inhibit-startup-message t)                  ;; remove opening tutorial/help buffer

(recentf-mode 1)                                  ;; Remember files recently opened in Emacs (M-x & 'recentf-open-file')

;; These 3 lines mean registers are saved even when closing Emacs
(require 'savehist)                               ;; Loads in Emacs package for savehist (saves minibuffer, search & command history)
(add-to-list 'savehist-additional-variables 'register-alist) ;; (adds item to list 'the list being modified 'what we're adding (register)
(savehist-mode 1)                                 ;; Turns savehist on -> saves as it goes so it's not emptied on restart

;; jump page up & down by x number of lines shortcuts
(setq evil-scroll-count 20)                       ;; set default 'scroll' lines so jump are by x amount
(with-eval-after-load 'evil
  (define-key evil-normal-state-map (kbd "C-d") #'evil-scroll-down)
  (define-key evil-normal-state-map (kbd "C-u") #'evil-scroll-up))

;; Emacs customize system created this
 ;; This means: Emacs package system is tracking what packages I've installed

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(vertico consult fantom-theme evil abyss-theme)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
