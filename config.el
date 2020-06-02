;;; config.el -*- lexical-binding: t; -*-

;; [[file:~/.config/doom/config.org::*Personal Information][Personal Information:1]]
(setq user-full-name "TEC"
      user-mail-address "tec@tecosaur.com")
;; Personal Information:1 ends here

;; [[file:~/.config/doom/config.org::*Personal Information][Personal Information:2]]
(setq auth-sources '("~/.authinfo.gpg")
      auth-source-cache-expiry nil) ; default is 7200 (2h)
;; Personal Information:2 ends here

;; [[file:~/.config/doom/config.org::*Simple settings][Simple settings:1]]
(setq-default
 delete-by-moving-to-trash t                      ; Delete files to trash
 tab-width 4                                      ; Set width for tabs
 uniquify-buffer-name-style 'forward              ; Uniquify buffer names
 window-combination-resize t                      ; take new window space from all other windows (not just current)
 x-stretch-cursor t)                              ; Stretch cursor to the glyph width

(setq undo-limit 80000000                         ; Raise undo-limit to 80Mb
      evil-want-fine-undo t                       ; By default while in insert all changes are one big blob. Be more granular
      auto-save-default t                         ; Nobody likes to loose work, I certainly don't
      inhibit-compacting-font-caches t            ; When there are lots of glyphs, keep them in memory
      truncate-string-ellipsis "…")               ; Unicode ellispis are nicer than "...", and also save /precious/ space

(delete-selection-mode 1)                         ; Replace selection when inserting text
(display-time-mode 1)                             ; Enable time in the mode-line
(display-battery-mode 1)                          ; On laptops it's nice to know how much power you have
(global-subword-mode 1)                           ; Iterate through CamelCase words
;; Simple settings:1 ends here

;; [[file:~/.config/doom/config.org::*Fullscreen][Fullscreen:1]]
(if (eq initial-window-system 'x)                 ; if started by emacs command or desktop file
    (toggle-frame-maximized)
  (toggle-frame-fullscreen))
;; Fullscreen:1 ends here

;; [[file:~/.config/doom/config.org::*Auto-customisations][Auto-customisations:1]]
(setq-default custom-file (expand-file-name ".custom.el" doom-private-dir))
(when (file-exists-p custom-file)
  (load custom-file))
;; Auto-customisations:1 ends here

;; [[file:~/.config/doom/config.org::*Windows][Windows:1]]
(setq evil-vsplit-window-right t
      evil-split-window-below t)
;; Windows:1 ends here

;; [[file:~/.config/doom/config.org::*Windows][Windows:2]]
(defadvice! prompt-for-buffer (&rest _)
  :after '(evil-window-split evil-window-vsplit)
  (+ivy/switch-buffer))
;; Windows:2 ends here

;; [[file:~/.config/doom/config.org::*Windows][Windows:3]]
(setq +ivy-buffer-preview t)
;; Windows:3 ends here

;; [[file:~/.config/doom/config.org::*Windows][Windows:4]]
(map! :map evil-window-map
      "SPC" #'rotate-layout)
;; Windows:4 ends here

;; [[file:~/.config/doom/config.org::*Buffer defaults][Buffer defaults:1]]
;; (setq-default major-mode 'org-mode)
;; Buffer defaults:1 ends here

;; [[file:~/.config/doom/config.org::*Font Face][Font Face:1]]
(setq doom-font (font-spec :family "JetBrains Mono" :size 24)
      doom-big-font (font-spec :family "JetBrains Mono" :size 36)
      doom-variable-pitch-font (font-spec :family "Overpass" :size 24)
      doom-serif-font (font-spec :family "IBM Plex Mono" :weight 'light))
;; Font Face:1 ends here

;; [[file:~/.config/doom/config.org::*Theme and modeline][Theme and modeline:1]]
(setq doom-theme 'doom-vibrant)
;; Theme and modeline:1 ends here

;; [[file:~/.config/doom/config.org::*Theme and modeline][Theme and modeline:2]]
(custom-set-faces!
  '(doom-modeline-buffer-modified :foreground "orange"))
;; Theme and modeline:2 ends here

;; [[file:~/.config/doom/config.org::*Theme and modeline][Theme and modeline:3]]
(defun doom-modeline-conditional-buffer-encoding ()
  "We expect the encoding to be LF UTF-8, so only show the modeline when this is not the case"
  (setq-local doom-modeline-buffer-encoding
              (unless (or (eq buffer-file-coding-system 'utf-8-unix)
                          (eq buffer-file-coding-system 'utf-8)))))

(add-hook 'after-change-major-mode-hook #'doom-modeline-conditional-buffer-encoding)
;; Theme and modeline:3 ends here

;; [[file:~/.config/doom/config.org::*Miscellaneous][Miscellaneous:1]]
(setq display-line-numbers-type 'relative)
;; Miscellaneous:1 ends here

;; [[file:~/.config/doom/config.org::*Miscellaneous][Miscellaneous:2]]
(setq doom-fallback-buffer-name "► Doom"
      +doom-dashboard-name "► Doom")
;; Miscellaneous:2 ends here

;; [[file:~/.config/doom/config.org::*Miscellaneous][Miscellaneous:3]]
(custom-set-faces! '(doom-modeline-evil-insert-state :weight bold :foreground "#339CDB"))
;; Miscellaneous:3 ends here

;; [[file:~/.config/doom/config.org::*Mouse buttons][Mouse buttons:1]]
(map! :n [mouse-8] #'better-jumper-jump-backward
      :n [mouse-9] #'better-jumper-jump-forward)
;; Mouse buttons:1 ends here

;; [[file:~/.config/doom/config.org::*Window title][Window title:1]]
(setq frame-title-format
    '(""
      (:eval
       (if (s-contains-p org-roam-directory (or buffer-file-name ""))
           (replace-regexp-in-string ".*/[0-9]*-?" "🢔 " buffer-file-name)
         "%b"))
      (:eval
       (let ((project-name (projectile-project-name)))
         (unless (string= "-" project-name)
           (format (if (buffer-modified-p)  " ◉ %s" "  ●  %s") project-name))))))
;; Window title:1 ends here

;; [[file:~/.config/doom/config.org::*Splash screen][Splash screen:1]]
(defvar fancy-splash-image-template
  (expand-file-name "misc/splash-images/blackhole-lines-template.svg" doom-private-dir)
  "Default template svg used for the splash image, with substitutions from ")
(defvar fancy-splash-image-nil
  (expand-file-name "misc/splash-images/transparent-pixel.png" doom-private-dir)
  "An image to use at minimum size, usually a transparent pixel")

(setq fancy-splash-sizes
  `((:height 500 :min-height 50 :padding (0 . 4) :template ,(expand-file-name "misc/splash-images/blackhole-lines-0.svg" doom-private-dir))
    (:height 440 :min-height 42 :padding (1 . 4) :template ,(expand-file-name "misc/splash-images/blackhole-lines-0.svg" doom-private-dir))
    (:height 400 :min-height 38 :padding (1 . 4) :template ,(expand-file-name "misc/splash-images/blackhole-lines-1.svg" doom-private-dir))
    (:height 350 :min-height 36 :padding (1 . 3) :template ,(expand-file-name "misc/splash-images/blackhole-lines-2.svg" doom-private-dir))
    (:height 300 :min-height 34 :padding (1 . 3) :template ,(expand-file-name "misc/splash-images/blackhole-lines-3.svg" doom-private-dir))
    (:height 250 :min-height 32 :padding (1 . 2) :template ,(expand-file-name "misc/splash-images/blackhole-lines-4.svg" doom-private-dir))
    (:height 200 :min-height 30 :padding (1 . 2) :template ,(expand-file-name "misc/splash-images/blackhole-lines-5.svg" doom-private-dir))
    (:height 100 :min-height 24 :padding (1 . 2) :template ,(expand-file-name "misc/splash-images/emacs-e-template.svg" doom-private-dir))
    (:height 0   :min-height 0  :padding (0 . 0) :file ,fancy-splash-image-nil)))

(defvar fancy-splash-sizes
  `((:height 500 :min-height 50 :padding (0 . 2))
    (:height 440 :min-height 42 :padding (1 . 4))
    (:height 330 :min-height 35 :padding (1 . 3))
    (:height 200 :min-height 30 :padding (1 . 2))
    (:height 0   :min-height 0  :padding (0 . 0) :file ,fancy-splash-image-nil))
  "list of plists with the following properties
  :height the height of the image
  :min-height minimum `frame-height' for image
  :padding `+doom-dashboard-banner-padding' to apply
  :template non-default template file
  :file file to use instead of template")

(defvar fancy-splash-template-colours
  '(("$colour1" . keywords) ("$colour2" . type) ("$colour3" . base5) ("$colour4" . base8))
  "list of colour-replacement alists of the form (\"$placeholder\" . 'theme-colour) which applied the template")

(unless (file-exists-p (expand-file-name "theme-splashes" doom-cache-dir))
  (make-directory (expand-file-name "theme-splashes" doom-cache-dir) t))

(defun fancy-splash-filename (theme-name height)
  (expand-file-name (concat (file-name-as-directory "theme-splashes")
                            (symbol-name doom-theme)
                            "-" (number-to-string height) ".svg")
                    doom-cache-dir))

(defun fancy-splash-clear-cache ()
  "Delete all cached fancy splash images"
  (interactive)
  (delete-directory (expand-file-name "theme-splashes" doom-cache-dir) t)
  (message "Cache cleared!"))

(defun fancy-splash-generate-image (template height)
  "Read TEMPLATE and create an image if HEIGHT with colour substitutions as  ;described by `fancy-splash-template-colours' for the current theme"
    (with-temp-buffer
      (insert-file-contents template)
      (re-search-forward "$height" nil t)
      (replace-match (number-to-string height) nil nil)
      (dolist (substitution fancy-splash-template-colours)
        (beginning-of-buffer)
        (while (re-search-forward (car substitution) nil t)
          (replace-match (doom-color (cdr substitution)) nil nil)))
      (write-region nil nil
                    (fancy-splash-filename (symbol-name doom-theme) height) nil nil)))

(defun fancy-splash-generate-images ()
  "Perform `fancy-splash-generate-image' in bulk"
  (dolist (size fancy-splash-sizes)
    (unless (plist-get size :file)
      (fancy-splash-generate-image (or (plist-get size :file)
                                       (plist-get size :template)
                                       fancy-splash-image-template)
                                   (plist-get size :height)))))

(defun ensure-theme-splash-images-exist (&optional height)
  (unless (file-exists-p (fancy-splash-filename
                          (symbol-name doom-theme)
                          (or height
                              (plist-get (car fancy-splash-sizes) :height))))
    (fancy-splash-generate-images)))

(defun get-appropriate-splash ()
  (let ((height (frame-height)))
    (cl-some (lambda (size) (when (>= height (plist-get size :min-height)) size))
             fancy-splash-sizes)))

(setq fancy-splash-last-size nil)
(setq fancy-splash-last-theme nil)
(defun set-appropriate-splash (&optional frame)
  (let ((appropriate-image (get-appropriate-splash)))
    (unless (and (equal appropriate-image fancy-splash-last-size)
                 (equal doom-theme fancy-splash-last-theme)))
    (unless (plist-get appropriate-image :file)
      (ensure-theme-splash-images-exist (plist-get appropriate-image :height)))
    (setq fancy-splash-image
          (or (plist-get appropriate-image :file)
              (fancy-splash-filename (symbol-name doom-theme) (plist-get appropriate-image :height))))
    (setq +doom-dashboard-banner-padding (plist-get appropriate-image :padding))
    (setq fancy-splash-last-size appropriate-image)
    (setq fancy-splash-last-theme doom-theme)
    (+doom-dashboard-reload)))

(add-hook 'window-size-change-functions #'set-appropriate-splash)
(add-hook 'doom-load-theme-hook #'set-appropriate-splash)
;; Splash screen:1 ends here

;; [[file:~/.config/doom/config.org::*Systemd daemon][Systemd daemon:3]]
(defun greedily-do-daemon-setup ()
  (when (daemonp)
    (require 'org)
    (require 'mu4e)
    (setq mu4e-confirm-quit t)
    (setq mu4e-lock-greedy t)
    (setq mu4e-lock-relaxed t)
    (mu4e-lock-add-watcher)
    (when (mu4e-lock-avalible t)
      (mu4e~start))))

(add-hook 'emacs-startup-hook #'greedily-do-daemon-setup)
;; Systemd daemon:3 ends here

;; [[file:~/.config/doom/config.org::*Fun][Fun:8]]
(use-package! keycast
  :commands keycast-mode
  :config
  (define-minor-mode keycast-mode
    "Show current command and its key binding in the mode line."
    :global t
    (if keycast-mode
        (progn
          (add-hook 'pre-command-hook 'keycast-mode-line-update t)
          (add-to-list 'global-mode-string '("" mode-line-keycast " ")))
      (remove-hook 'pre-command-hook 'keycast-mode-line-update)
      (setq global-mode-string (remove '("" mode-line-keycast " ") global-mode-string))))
  (custom-set-faces!
    '(keycast-command :inherit doom-modeline-debug
                      :height 0.9)
    '(keycast-key :inherit custom-modified
                  :height 1.1
                  :weight bold)))
;; Fun:8 ends here

;; [[file:~/.config/doom/config.org::*Abbrev mode][Abbrev mode:1]]
(use-package abbrev
  :init
  (setq-default abbrev-mode t)
  ;; a hook funtion that sets the abbrev-table to org-mode-abbrev-table
  ;; whenever the major mode is a text mode
  (defun tec/set-text-mode-abbrev-table ()
    (if (derived-mode-p 'text-mode)
        (setq local-abbrev-table org-mode-abbrev-table)))
  :commands abbrev-mode
  :hook
  (abbrev-mode . tec/set-text-mode-abbrev-table)
  :config
  (setq abbrev-file-name (expand-file-name "abbrev.el" doom-private-dir))
  (setq save-abbrevs 'silently))
;; Abbrev mode:1 ends here

;; [[file:~/.config/doom/config.org::*Calc][Calc:1]]
(setq calc-angle-mode 'rad  ;; radians are rad
      calc-algebraic-mode t ;; allows '2*x instead of 'x<RET>2*
      calc-symbolic-mode t) ;; keeps stuff like √2 irrational for as long as possible
(after! calctex
  (setq calctex-format-latex-header (concat calctex-format-latex-header
                                            "\n\\usepackage{arevmath}")))
(add-hook 'calc-mode-hook #'calctex-mode)
;; Calc:1 ends here

;; [[file:~/.config/doom/config.org::*Centaur Tabs][Centaur Tabs:1]]
(after! centaur-tabs
  (centaur-tabs-mode -1)
  (setq centaur-tabs-height 36
        centaur-tabs-set-icons t
        centaur-tabs-modified-marker "o"
        centaur-tabs-close-button "×"
        centaur-tabs-set-bar 'above)
        centaur-tabs-gray-out-icons 'buffer
  (centaur-tabs-change-fonts "P22 Underground Book" 160))
;; (setq x-underline-at-descent-line t)
;; Centaur Tabs:1 ends here

;; [[file:~/.config/doom/config.org::*Company][Company:1]]
(after! company
  (setq company-idle-delay 0.5
        company-minimum-prefix-length 2)
  (setq company-show-numbers t)
(add-hook 'evil-normal-state-entry-hook #'company-abort)) ;; make aborting less annoying.
;; Company:1 ends here

;; [[file:~/.config/doom/config.org::*Company][Company:2]]
(setq-default history-length 1000)
(setq-default prescient-history-length 1000)
;; Company:2 ends here

;; [[file:~/.config/doom/config.org::*Plain Text][Plain Text:1]]
(set-company-backend! '(text-mode
                        markdown-mode
                        gfm-mode)
  '(:seperate company-ispell
              company-files
              company-yasnippet))
;; Plain Text:1 ends here

;; [[file:~/.config/doom/config.org::*ESS][ESS:1]]
(set-company-backend! 'ess-r-mode '(company-R-args company-R-objects company-dabbrev-code :separate))
;; ESS:1 ends here

;; [[file:~/.config/doom/config.org::*Elcord][Elcord:1]]
(setq elcord-use-major-mode-as-main-icon t)
;; Elcord:1 ends here

;; [[file:~/.config/doom/config.org::*\[\[https://github.com/zachcurry/emacs-anywhere\]\[Emacs Anywhere\]\] configuration][[[https://github.com/zachcurry/emacs-anywhere][Emacs Anywhere]] configuration:1]]
(defun markdown-window-p (window-title)
  "Judges from WINDOW-TITLE whether the current window likes markdown"
  (if (string-match-p (rx (or "Stack Exchange" "Stack Overflow"
                          "Pull Request" "Issue" "Discord"))
                  window-title) t nil))
;; [[https://github.com/zachcurry/emacs-anywhere][Emacs Anywhere]] configuration:1 ends here

;; [[file:~/.config/doom/config.org::*\[\[https://github.com/zachcurry/emacs-anywhere\]\[Emacs Anywhere\]\] configuration][[[https://github.com/zachcurry/emacs-anywhere][Emacs Anywhere]] configuration:2]]
(defvar emacs-anywhere--active-markdown nil
  "Whether the buffer started off as markdown.
Affects behaviour of `emacs-anywhere--finalise-content'")

(defun emacs-anywhere--finalise-content (&optional _frame)
  (when emacs-anywhere--active-markdown
    (fundamental-mode)
    (goto-char (point-min))
    (insert "#+OPTIONS: toc:nil\n")
    (rename-buffer "*EA Pre Export*")
    (org-export-to-buffer 'gfm ea--buffer-name)
    (kill-buffer "*EA Pre Export*"))
  (gui-select-text (buffer-string)))

(define-minor-mode emacs-anywhere-mode
  "To tweak the current buffer for some emacs-anywhere considerations"
  :init-value nil
  :keymap (list
           ;; Finish edit, but be smart in org mode
           (cons (kbd "C-c C-c") (lambda! (if (and (eq major-mode 'org-mode)
                                                   (org-in-src-block-p))
                                              (org-ctrl-c-ctrl-c)
                                            (delete-frame))))
           ;; Abort edit. emacs-anywhere saves the current edit for next time.
           (cons (kbd "C-c C-k") (lambda! (setq ea-on nil)
                                          (delete-frame))))
  (when emacs-anywhere-mode
    ;; line breaking
    (turn-off-auto-fill)
    (visual-line-mode t)
    ;; DEL/C-SPC to clear (first keystroke only)
    (set-transient-map (let ((keymap (make-sparse-keymap)))
                         (define-key keymap (kbd "DEL")   (lambda! (delete-region (point-min) (point-max))))
                         (define-key keymap (kbd "C-SPC") (lambda! (delete-region (point-min) (point-max))))
                         keymap))
    ;; disable tabs
    (when (bound-and-true-p centaur-tabs-mode)
      (centaur-tabs-local-mode t))))

(defun ea-popup-handler (app-name window-title x y w h)
  (interactive)
  (set-frame-size (selected-frame) 80 12)
  ;; position the frame near the mouse
  (let* ((mousepos (split-string (shell-command-to-string "xdotool getmouselocation | sed -E \"s/ screen:0 window:[^ ]*|x:|y://g\"")))
         (mouse-x (- (string-to-number (nth 0 mousepos)) 100))
         (mouse-y (- (string-to-number (nth 1 mousepos)) 50)))
    (set-frame-position (selected-frame) mouse-x mouse-y))

  (set-frame-name (concat "Quick Edit ∷ " ea-app-name " — "
                          (truncate-string-to-width
                           (string-trim
                            (string-trim-right window-title
                                               (format "-[A-Za-z0-9 ]*%s" ea-app-name))
                            "[\s-]+" "[\s-]+")
                           45 nil nil "…")))
  (message "window-title: %s" window-title)

  (when-let ((selection (gui-get-selection 'PRIMARY)))
    (insert selection))

  (setq emacs-anywhere--active-markdown (markdown-window-p window-title))

  ;; convert buffer to org mode if markdown
  (when emacs-anywhere--active-markdown
    (shell-command-on-region (point-min) (point-max)
                             "pandoc -f markdown -t org" nil t)
    (deactivate-mark) (goto-char (point-max)))

  ;; set major mode
  (org-mode)

  (advice-add 'ea--delete-frame-handler :before #'emacs-anywhere--finalise-content)

  ;; I'll be honest with myself, I /need/ spellcheck
  (flyspell-buffer)

  (evil-insert-state) ; start in insert
  (emacs-anywhere-mode 1))

(add-hook 'ea-popup-hook 'ea-popup-handler)
;; [[https://github.com/zachcurry/emacs-anywhere][Emacs Anywhere]] configuration:2 ends here

;; [[file:~/.config/doom/config.org::*Eros-eval][Eros-eval:1]]
(setq eros-eval-result-prefix "⟹ ")
;; Eros-eval:1 ends here

;; [[file:~/.config/doom/config.org::*EVIL][EVIL:1]]
(after! evil (evil-escape-mode nil))
;; EVIL:1 ends here

;; [[file:~/.config/doom/config.org::*Flyspell][Flyspell:1]]
(after! flyspell (require 'flyspell-lazy) (flyspell-lazy-mode 1))
;; Flyspell:1 ends here

;; [[file:~/.config/doom/config.org::*Info colors][Info colors:1]]
(use-package! info-colors
  :commands (info-colors-fontify-node))

(add-hook 'Info-selection-hook 'info-colors-fontify-node)

(add-hook 'Info-mode-hook #'mixed-pitch-mode)
;; Info colors:1 ends here

;; [[file:~/.config/doom/config.org::*Ispell][Ispell:1]]
(setq ispell-dictionary "en_GBs_au_SCOWL_80_0_k_hr")
;; Ispell:1 ends here

;; [[file:~/.config/doom/config.org::*Ispell][Ispell:2]]
(setq ispell-personal-dictionary (expand-file-name ".hunspell_personal" doom-private-dir))
;; Ispell:2 ends here

;; [[file:~/.config/doom/config.org::*Ivy][Ivy:1]]
(setq ivy-read-action-function #'ivy-hydra-read-action)
;; Ivy:1 ends here

;; [[file:~/.config/doom/config.org::*Ivy][Ivy:2]]
(setq ivy-sort-max-size 50000)
;; Ivy:2 ends here

;; [[file:~/.config/doom/config.org::*Magit][Magit:1]]
;; (after! magit
;;   (magit-delta-mode +1))
;; Magit:1 ends here

;; [[file:~/.config/doom/config.org::*Rebuild mail index while using mu4e][Rebuild mail index while using mu4e:1]]
(after! mu4e
  (defvar mu4e-reindex-request-file "/tmp/mu_reindex_now"
    "Location of the reindex request, signaled by existance")
  (defvar mu4e-reindex-request-min-seperation 5.0
    "Don't refresh again until this many second have elapsed.
Prevents a series of redisplays from being called (when set to an appropriate value)")

  (defvar mu4e-reindex-request--file-watcher nil)
  (defvar mu4e-reindex-request--file-just-deleted nil)
  (defvar mu4e-reindex-request--last-time 0)

  (defun mu4e-reindex-request--add-watcher ()
    (setq mu4e-reindex-request--file-just-deleted nil)
    (setq mu4e-reindex-request--file-watcher
          (file-notify-add-watch mu4e-reindex-request-file
                                 '(change)
                                 #'mu4e-file-reindex-request)))

  (defadvice! mu4e-stop-watching-for-reindex-request ()
    :after #'mu4e~proc-kill
    (if mu4e-reindex-request--file-watcher
        (file-notify-rm-watch mu4e-reindex-request--file-watcher)))

  (defadvice! mu4e-watch-for-reindex-request ()
    :after #'mu4e~proc-start
    (mu4e-stop-watching-for-reindex-request)
    (when (file-exists-p mu4e-reindex-request-file)
      (delete-file mu4e-reindex-request-file))
    (mu4e-reindex-request--add-watcher))

    (defun mu4e-file-reindex-request (event)
      "Act based on the existance of `mu4e-reindex-request-file'"
      (if mu4e-reindex-request--file-just-deleted
          (mu4e-reindex-request--add-watcher)
        (when (equal (nth 1 event) 'created)
          (delete-file mu4e-reindex-request-file)
          (setq mu4e-reindex-request--file-just-deleted t)
          (mu4e-reindex-maybe t))))

    (defun mu4e-reindex-maybe (&optional new-request)
      "Run `mu4e~proc-index' if it's been more than `mu4e-reindex-request-min-seperation' seconds since the last request,"
      (let ((time-since-last-request (- (float-time) mu4e-reindex-request--last-time)))
        (when new-request
          (setq mu4e-reindex-request--last-time (float-time)))
        (if (> time-since-last-request mu4e-reindex-request-min-seperation)
            (mu4e~proc-index nil t)
          (when new-request
            (run-at-time (* 1.1 mu4e-reindex-request-min-seperation) nil
                         #'mu4e-reindex-maybe))))))
;; Rebuild mail index while using mu4e:1 ends here

;; [[file:~/.config/doom/config.org::*Mu4e][Mu4e:1]]
(add-to-list 'load-path "/usr/local/share/emacs/site-lisp/mu4e")
;; Mu4e:1 ends here

;; [[file:~/.config/doom/config.org::*Viewing Mail][Viewing Mail:1]]
(setq mu4e-view-use-gnus t)
;; Viewing Mail:1 ends here

;; [[file:~/.config/doom/config.org::*Viewing Mail][Viewing Mail:2]]
(after! mu4e
  (defun my-string-width (str)
    "Return the width in pixels of a string in the current
window's default font. If the font is mono-spaced, this
will also be the width of all other printable characters."
    (let ((window (selected-window))
          (remapping face-remapping-alist))
      (with-temp-buffer
        (make-local-variable 'face-remapping-alist)
        (setq face-remapping-alist remapping)
        (set-window-buffer window (current-buffer))
        (insert str)
        (car (window-text-pixel-size)))))


  (cl-defun mu4e~normalised-icon (name &key set colour height v-adjust)
    "Convert :icon declaration to icon"
    (let* ((icon-set (intern (concat "all-the-icons-" (or set "faicon"))))
           (v-adjust (or v-adjust 0.02))
           (height (or height 0.8))
           (icon (if colour
                     (apply icon-set `(,name :face ,(intern (concat "all-the-icons-" colour)) :height ,height :v-adjust ,v-adjust))
                   (apply icon-set `(,name  :height ,height :v-adjust ,v-adjust))))
           (icon-width (my-string-width icon))
           (space-width (my-string-width " "))
           (space-factor (- 2 (/ (float icon-width) space-width))))
      (concat (propertize " " 'display `(space . (:width ,space-factor))) icon)
      ))

  (setq mu4e-use-fancy-chars t
        mu4e-headers-draft-mark      (cons "D" (mu4e~normalised-icon "pencil"))
        mu4e-headers-flagged-mark    (cons "F" (mu4e~normalised-icon "flag"))
        mu4e-headers-new-mark        (cons "N" (mu4e~normalised-icon "sync" :set "material" :height 0.8 :v-adjust -0.10))
        mu4e-headers-passed-mark     (cons "P" (mu4e~normalised-icon "arrow-right"))
        mu4e-headers-replied-mark    (cons "R" (mu4e~normalised-icon "arrow-right"))
        mu4e-headers-seen-mark       (cons "S" "") ;(mu4e~normalised-icon "eye" :height 0.6 :v-adjust 0.07 :colour "dsilver"))
        mu4e-headers-trashed-mark    (cons "T" (mu4e~normalised-icon "trash"))
        mu4e-headers-attach-mark     (cons "a" (mu4e~normalised-icon "file-text-o" :colour "silver"))
        mu4e-headers-encrypted-mark  (cons "x" (mu4e~normalised-icon "lock"))
        mu4e-headers-signed-mark     (cons "s" (mu4e~normalised-icon "certificate" :height 0.7 :colour "dpurple"))
        mu4e-headers-unread-mark     (cons "u" (mu4e~normalised-icon "eye-slash" :v-adjust 0.05))))
;; Viewing Mail:2 ends here

;; [[file:~/.config/doom/config.org::*Viewing Mail][Viewing Mail:3]]
(after! mu4e

  (defun mu4e-header-colourise (str)
    (let* ((str-sum (apply #'+ (mapcar (lambda (c) (% c 3)) str)))
           (colour (nth (% str-sum (length mu4e-header-colourised-faces))
                        mu4e-header-colourised-faces)))
      (put-text-property 0 (length str) 'face colour str)
      str))

  (defvar mu4e-header-colourised-faces
    '(all-the-icons-lblue
      all-the-icons-purple
      all-the-icons-blue-alt
      all-the-icons-green
      all-the-icons-maroon
      all-the-icons-yellow
      all-the-icons-orange))

  (setq mu4e-headers-fields
        '((:account . 12)
          (:human-date . 8)
          (:flags . 6)
          (:from . 25)
          (:folder . 10)
          (:recipnum . 2)
          (:subject)))
  (plist-put (cdr (assoc :flags mu4e-header-info)) :shortname " Flags") ; default=Flgs
  (setq mu4e-header-info-custom
        '((:account .
           (:name "Account" :shortname "Account" :help "Which account this email belongs to" :function
            (lambda (msg)
              (let ((maildir
                     (mu4e-message-field msg :maildir)))
                (mu4e-header-colourise (replace-regexp-in-string "^gmail" (propertize "g" 'face 'bold-italic)
                                                                 (format "%s"
                                                                         (substring maildir 1
                                                                                    (string-match-p "/" maildir 1)))))))))
          (:folder .
           (:name "Folder" :shortname "Folder" :help "Lowest level folder" :function
            (lambda (msg)
              (let ((maildir
                     (mu4e-message-field msg :maildir)))
                (mu4e-header-colourise (replace-regexp-in-string "\\`.*/" "" maildir))))))
          (:recipnum .
           (:name "Number of recipients"
            :shortname " ⭷"
            :help "Number of recipients for this message"
            :function
            (lambda (msg)
              (propertize (format "%2d"
                                  (+ (length (mu4e-message-field msg :to))
                                     (length (mu4e-message-field msg :cc))))
                          'face 'mu4e-footer-face)))))))
;; Viewing Mail:3 ends here

;; [[file:~/.config/doom/config.org::*Viewing Mail][Viewing Mail:4]]
(map! :map mu4e-headers-mode-map
    :after mu4e
    :v "*" #'mu4e-headers-mark-for-something
    :v "!" #'mu4e-headers-mark-for-read
    :v "?" #'mu4e-headers-mark-for-unread
    :v "u" #'mu4e-headers-mark-for-unmark)
;; Viewing Mail:4 ends here

;; [[file:~/.config/doom/config.org::*Viewing Mail][Viewing Mail:5]]
(defadvice! mu4e~main-action-prettier-str (str &optional func-or-shortcut)
  "Highlight the first occurrence of [.] in STR.
If FUNC-OR-SHORTCUT is non-nil and if it is a function, call it
when STR is clicked (using RET or mouse-2); if FUNC-OR-SHORTCUT is
a string, execute the corresponding keyboard action when it is
clicked."
  :override #'mu4e~main-action-str
  (let ((newstr
         (replace-regexp-in-string
          "\\[\\(..?\\)\\]"
          (lambda(m)
            (format "%s"
                    (propertize (match-string 1 m) 'face '(mode-line-emphasis bold))))
          (replace-regexp-in-string "\t\\*" "\t⚫" str)))
        (map (make-sparse-keymap))
        (func (if (functionp func-or-shortcut)
                  func-or-shortcut
                (if (stringp func-or-shortcut)
                    (lambda()(interactive)
                      (execute-kbd-macro func-or-shortcut))))))
    (define-key map [mouse-2] func)
    (define-key map (kbd "RET") func)
    (put-text-property 0 (length newstr) 'keymap map newstr)
    (put-text-property (string-match "[A-Za-z].+$" newstr)
                       (- (length newstr) 1) 'mouse-face 'highlight newstr)
    newstr))

(setq evil-collection-mu4e-end-region-misc "quit")
;; Viewing Mail:5 ends here

;; [[file:~/.config/doom/config.org::*Viewing Mail][Viewing Mail:6]]
(map! :map mu4e-main-mode-map
      :after mu4e
      :nive "h" #'+workspace/other)
;; Viewing Mail:6 ends here

;; [[file:~/.config/doom/config.org::*Viewing Mail][Viewing Mail:7]]
(defadvice! delete-current-worspace-if-empty ()
  "Close the current workspace if it is empty."
  :before #'=mu4e
  (unless (+workspace-buffer-list)
    (+workspace-delete (+workspace-current-name))))
;; Viewing Mail:7 ends here

;; [[file:~/.config/doom/config.org::*Sending Mail][Sending Mail:1]]
(after! mu4e
  (setq sendmail-program "/usr/local/bin/msmtp"
        send-mail-function 'smtpmail-send-it
        message-sendmail-f-is-evil t
        message-sendmail-extra-arguments '("--read-envelope-from"); , "--read-recipients")
        message-send-mail-function 'message-send-mail-with-sendmail))
;; Sending Mail:1 ends here

;; [[file:~/.config/doom/config.org::*Sending Mail][Sending Mail:2]]
(after! mu4e
  (defun my-mu4e-set-account ()
    "Set the account for composing a message."
    (unless (and mu4e-compose-parent-message
                 (let ((to (cdr (car (mu4e-message-field mu4e-compose-parent-message :to))))
                       (from (cdr (car (mu4e-message-field mu4e-compose-parent-message :from)))))
                 (if (member to (plist-get mu4e~server-props :personal-addresses))
                     (setq user-mail-address to)
                   (if (member from (plist-get mu4e~server-props :personal-addresses))
                       (setq user-mail-address from)
                       nil))))
      (ivy-read "Account: " (plist-get mu4e~server-props :personal-addresses) :action (lambda (candidate) (setq user-mail-address candidate)))))

  (add-hook 'mu4e-compose-pre-hook 'my-mu4e-set-account))
;; Sending Mail:2 ends here

;; [[file:~/.config/doom/config.org::*Sending Mail][Sending Mail:5]]
(defun mu4e-compose-from-mailto (mailto-string)
  (require 'mu4e)
  (unless mu4e~server-props (mu4e t) (sleep-for 0.1))
  (let* ((mailto (rfc2368-parse-mailto-url mailto-string))
         (to (cdr (assoc "To" mailto)))
         (subject (or (cdr (assoc "Subject" mailto)) ""))
         (body (cdr (assoc "Body" mailto)))
         (org-msg-greeting-fmt (if (assoc "Body" mailto)
                                   (replace-regexp-in-string "%" "%%"
                                                             (cdr (assoc "Body" mailto)))
                                 org-msg-greeting-fmt))
         (headers (-filter (lambda (spec) (not (-contains-p '("To" "Subject" "Body") (car spec)))) mailto)))
    (mu4e~compose-mail to subject headers)))
;; Sending Mail:5 ends here

;; [[file:~/.config/doom/config.org::*Getting notified][Getting notified:1]]
(use-package! mu4e-alert
  :after mu4e
  :config
  (mu4e-alert-enable-mode-line-display)

  (mu4e-alert-enable-notifications)
  (mu4e-alert-set-default-style 'libnotify)
  (setq mu4e-alert-icon "/usr/share/icons/Papirus/64x64/apps/evolution.svg")

  (defun mu4e-alert-iconised-modeline-formatter (mail-count)
    "Formatter used to get the string to be displayed in the mode-line, using all-the-icons.
MAIL-COUNT is the count of mails for which the string is to displayed"
    (when (not (zerop mail-count))
      (concat " "
              (propertize
               (concat
                (all-the-icons-material "mail_outline")
                (if (zerop mail-count)
                    ""
                  (format " %d" mail-count)))
               'help-echo (concat (if (= mail-count 1)
                                      "You have an unread email"
                                    (format "You have %s unread emails" mail-count))
                                  "\nClick here to view "
                                  (if (= mail-count 1) "it" "them"))
               'mouse-face 'mode-line-highlight
               'keymap '(mode-line keymap
                                   (mouse-1 . mu4e-alert-view-unread-mails)
                                   (mouse-2 . mu4e-alert-view-unread-mails)
                                   (mouse-3 . mu4e-alert-view-unread-mails))))))
  (setq mu4e-alert-modeline-formatter #'mu4e-alert-iconised-modeline-formatter)

  (setq mu4e-alert-email-notification-types '(subjects))
  (defun mu4e-alert-grouped-mail-notification-formatter-with-bell (mail-group all-mails)
    "Default function to format MAIL-GROUP for notification.
ALL-MAILS are the all the unread emails"
    (shell-command "paplay /usr/share/sounds/freedesktop/stereo/message.oga")
    (if (> (length mail-group) 1)
         (let* ((mail-count (length mail-group))
                (total-mails (length all-mails))
                (first-mail (car mail-group))
                (title-prefix (format "You have %d unread emails"
                                      mail-count))
                (field-value (mu4e-alert--get-group first-mail))
                (title-suffix (format (pcase mu4e-alert-group-by
                                        (`:from "from %s:")
                                        (`:to "to %s:")
                                        (`:maildir "in %s:")
                                        (`:priority "with %s priority:")
                                        (`:flags "with %s flags:"))
                                      field-value))
                (title (format "%s %s" title-prefix title-suffix)))
           (list :title title
                 :body (s-join "\n"
                               (mapcar (lambda (mail)
                                         (format "%s<b>%s</b> • %s"
                                                 (cond
                                                  ((plist-get mail :in-reply-to) "⮩ ")
                                                  ((string-match-p "\\`Fwd:"
                                                                   (plist-get mail :subject)) " ⮯ ")
                                                  (t "  "))
                                                 (truncate-string-to-width (caar (plist-get mail :from))
                                                                           20 nil nil t)
                                                 (truncate-string-to-width
                                                  (replace-regexp-in-string "\\`Re: \\|\\`Fwd: " ""
                                                                            (plist-get mail :subject))
                                                  40 nil nil t)))
                                       mail-group))))
      (let* ((new-mail (car mail-group))
             (subject (plist-get new-mail :subject))
             (sender (caar (plist-get new-mail :from))))
        (list :title sender :body subject))))
  (setq mu4e-alert-grouped-mail-notification-formatter #'mu4e-alert-grouped-mail-notification-formatter-with-bell))
;; Getting notified:1 ends here

;; [[file:~/.config/doom/config.org::*Process control][Process control:1]]
(after! mu4e
  (defvar mu4e-lock-file "/tmp/mu4e_lock"
    "Location of the lock file which stores the PID of the process currenty running mu4e")
  (defvar mu4e-lock-request-file "/tmp/mu4e_lock_request"
    "Location of the lock file for which creating indicated that another process wants the lock to be released")

  (defvar mu4e-lock-greedy nil
    "Whether to 'grab' the `mu4e-lock-file' if nobody else has it, i.e. start Mu4e")
  (defvar mu4e-lock-relaxed nil
    "Whether if someone else wants the lock (signaled via `mu4e-lock-request-file'), we should stop Mu4e and let go of it")

  (defun mu4e-lock-pid-info ()
    "Get info on the PID refered to in `mu4e-lock-file' in the form (pid . process-attributes)
 If the file or process do not exist, the lock file is deleted an nil returned."
    (when (file-exists-p mu4e-lock-file)
      (let* ((pid (string-to-number (f-read-text mu4e-lock-file 'utf-8)))
             (process (process-attributes pid)))
          (if process (cons pid process)
            (delete-file mu4e-lock-file) nil))))

  (defun mu4e-lock-avalible (&optional strict)
    "If the `mu4e-lock-file' is avalible (unset or owned by this emacs) return t.
If STRICT only accept an unset lock file."
    (not (when-let* ((lock-info (mu4e-lock-pid-info))
                (pid (car lock-info)))
           (when (or strict (/= (emacs-pid) pid)) t))))

  (defadvice! mu4e-lock-file-delete-maybe ()
    "Check `mu4e-lock-file', and delete it if this process is responsible for it."
    :after #'mu4e-quit
    (when (mu4e-lock-avalible)
      (delete-file mu4e-lock-file)
      (file-notify-rm-watch mu4e-lock--request-watcher)))

  (add-hook 'kill-emacs-hook #'mu4e-lock-file-delete-maybe)

  (defadvice! mu4e-lock-start (orig-fun &optional callback)
    "Check `mu4e-lock-file', and if another process is responsible for it, abort starting.
Else, write to this process' PID to the lock file"
    :around #'mu4e~start
    (unless (mu4e-lock-avalible)
      (shell-command (format "touch %s" mu4e-lock-request-file))
      (message "Lock file exists, requesting that it be given up")
      (sleep-for 0.1)
      (delete-file mu4e-lock-request-file))
    (if (not (mu4e-lock-avalible))
        (user-error "Unfortunately another Emacs is already doing stuff with Mu4e, and you can only have one at a time")
      (f-write-text (number-to-string (emacs-pid)) 'utf-8 mu4e-lock-file)
      (delete-file mu4e-lock-request-file)
      (funcall orig-fun callback)
      (setq mu4e-lock--request-watcher
            (file-notify-add-watch mu4e-lock-request-file
                                   '(change)
                                   #'mu4e-lock-request))))

  (defvar mu4e-lock--file-watcher nil)
  (defvar mu4e-lock--file-just-deleted nil)
  (defvar mu4e-lock--request-watcher nil)

  (defun mu4e-lock-add-watcher ()
    (setq mu4e-lock--file-just-deleted nil)
    (file-notify-rm-watch mu4e-lock--file-watcher)
    (setq mu4e-lock--file-watcher
          (file-notify-add-watch mu4e-lock-file
                                 '(change)
                                 #'mu4e-lock-file-updated)))

  (defun mu4e-lock-request (event)
    "Handle another process requesting the Mu4e lock."
    (when (equal (nth 1 event) 'created)
      (when mu4e-lock-relaxed
        (mu4e~stop)
        (file-notify-rm-watch mu4e-lock--file-watcher)
        (message "Someone else wants to use Mu4e, releasing lock")
        (delete-file mu4e-lock-file)
        (run-at-time 0.2 nil #'mu4e-lock-add-watcher))
      (delete-file mu4e-lock-request-file)))

  (defun mu4e-lock-file-updated (event)
    (if mu4e-lock--file-just-deleted
        (mu4e-lock-add-watcher)
      (when (equal (nth 1 event) 'deleted)
        (setq mu4e-lock--file-just-deleted t)
        (when (and mu4e-lock-greedy (mu4e-lock-avalible t))
          (message "Noticed Mu4e lock was avalible, grabbed it")
          (run-at-time 0.2 nil #'mu4e~start))
        ))))
;; Process control:1 ends here

;; [[file:~/.config/doom/config.org::*Org Msg][Org Msg:1]]
(defvar org-msg-currently-exporting nil
  "Helper variable to indicate whether org-msg is currently exporting the org buffer to HTML.
Usefull for affecting some of my HTML export config.")

(use-package! org-msg
  :after mu4e
  :config
  (setq org-msg-options "html-postamble:nil H:5 num:nil ^:{} toc:nil author:nil email:nil \\n:t tex:dvipng"
        org-msg-startup "hidestars indent inlineimages"
        org-msg-greeting-fmt "\nHi %s,\n\n"
        org-msg-greeting-name-limit 3
        org-msg-text-plain-alternative t)
  (map! :map org-msg-edit-mode-map
        :n "G" #'org-msg-goto-body)
  (defadvice! org-msg--now-exporting (&rest _)
    :before #'org-msg-org-to-xml
    (setq org-msg-currently-exporting t))
  (defadvice! org-msg--not-exporting (&rest _)
    :after #'org-msg-org-to-xml
    (setq org-msg-currently-exporting nil))
  (setq org-msg-enforce-css
        (let* ((font-family '(font-family . "-apple-system, BlinkMacSystemFont, \"Segoe UI\", Roboto, Oxygen, Ubuntu, Cantarell,\
          \"Fira Sans\", \"Droid Sans\", \"Helvetica Neue\", Arial, sans-serif, \"Apple Color Emoji\", \"Segoe UI Emoji\", \"Segoe UI Symbol\";"))
               (monospace-font '(font-family . "SFMono-Regular, Menlo, Monaco, Consolas, \"Liberation Mono\", \"Courier New\", monospace;"))
               (font-size '(font-size . "11pt"))
               (font `(,font-family ,font-size))
               (line-height '(line-height . "1.2"))
               (theme-color "#2654BF")
               (bold '(font-weight . "bold"))
               (color `(color . ,theme-color))
               (table `((margin-top . "6px") (margin-bottom . "6px")
                        (border-left . "none") (border-right . "none")
                        (border-top . "2px solid #222222") (border-bottom . "2px solid #222222")
                        ))
               (ftl-number `(,color ,bold (text-align . "left")))
               (inline-modes '(asl c c++ conf cpp csv diff ditaa emacs-lisp
                                   fundamental ini json makefile man org plantuml
                                   python sh xml))
               (inline-src `((background-color . "rgba(27,31,35,.05)")
                             (border-radius . "3px")
                             (padding . ".2em .4em")
                             (font-size . "90%") ,monospace-font
                             (margin . 0)))
               (code-src
                (mapcar (lambda (mode)
                          `(code ,(intern (concat "src src-" (symbol-name mode)))
                                 ,inline-src))
                        inline-modes)))
          `((del nil ((color . "grey") (border-left . "none")
                      (text-decoration . "line-through") (margin-bottom . "0px")
                      (margin-top . "10px") (line-height . "11pt")))
            (a nil (,color))
            (a reply-header ((color . "black") (text-decoration . "none")))
            (div reply-header ((padding . "3.0pt 0in 0in 0in")
                               (border-top . "solid #e1e1e1 1.0pt")
                               (margin-bottom . "20px")))
            (span underline ((text-decoration . "underline")))
            (li nil (,line-height (margin-bottom . "0px")
                                  (margin-top . "2px")))
            (nil org-ul ((list-style-type . "square")))
            (nil org-ol (,@font ,line-height (margin-bottom . "0px")
                                (margin-top . "0px") (margin-left . "30px")
                                (padding-top . "0px") (padding-left . "5px")))
            (nil signature (,@font (margin-bottom . "20px")))
            (blockquote nil ((padding . "0px 10px") (margin-left . "10px")
                             (margin-top . "20px") (margin-bottom . "0")
                             (border-left . "3px solid #ccc") (font-style . "italic")
                             (background . "#f9f9f9")))
            (code nil (,font-size ,monospace-font (background . "#f9f9f9")))
            ,@code-src
            (nil linenr ((padding-right . "1em")
                         (color . "black")
                         (background-color . "#aaaaaa")))
            (pre nil ((line-height . "1.2")
                      (color . ,(doom-color 'fg))
                      (background-color . ,(doom-color 'bg))
                      (margin . "4px 0px 8px 0px")
                      (padding . "8px 12px")
                      (width . "95%")
                      (border-radius . "5px")
                      (font-weight . "500")
                      ,monospace-font))
            (div org-src-container ((margin-top . "10px")))
            (nil figure-number ,ftl-number)
            (nil table-number)
            (caption nil ((text-align . "left")
                          (background . ,theme-color)
                          (color . "white")
                          ,bold))
            (nil t-above ((caption-side . "top")))
            (nil t-bottom ((caption-side . "bottom")))
            (nil listing-number ,ftl-number)
            (nil figure ,ftl-number)
            (nil org-src-name ,ftl-number)
            (img nil ((vertical-align . "middle")
                      (max-width . "100%")))
            (img latex-fragment ((transform . ,(format "translateY(-1px) scale(%.3f)"
                                                       (/ 1.0 (if (boundp 'preview-scale)
                                                                  preview-scale 1.4))))
                                 (margin . "0 -0.35em")))
            (table nil (,@table ,line-height (border-collapse . "collapse")))
            (th nil ((border . "none") (border-bottom . "1px solid #222222")
                     (background-color . "#EDEDED") (font-weight . "500")
                     (padding . "3px 10px")))
            (td nil (,@table (padding . "1px 10px")
                             (background-color . "#f9f9f9") (border . "none")))
            (td org-left ((text-align . "left")))
            (td org-right ((text-align . "right")))
            (td org-center ((text-align . "center")))
            (kbd nil ((border . "1px solid #d1d5da") (border-radius . "3px")
                      (box-shadow . "inset 0 -1px 0 #d1d5da") (background-color . "#fafbfc")
                      (color . "#444d56") (padding . "3px 5px") (display . "inline-block")))
            (div outline-text-4 ((margin-left . "15px")))
            (div outline-4 ((margin-left . "10px")))
            (h4 nil ((margin-bottom . "0px") (font-size . "11pt")))
            (h3 nil ((margin-bottom . "0px")
                     ,color (font-size . "14pt")))
            (h2 nil ((margin-top . "20px") (margin-bottom . "20px")
                     ,color (font-size . "18pt")))
            (h1 nil ((margin-top . "20px")
                     (margin-bottom . "0px") ,color (font-size . "24pt")))
            (p nil ((text-decoration . "none") (margin-bottom . "0px")
                    (margin-top . "10px") (line-height . "11pt") ,font-size
                    (max-width . "100ch")))
            (b nil ((font-weight . "500") (color . ,theme-color)))
            (div nil (,@font (line-height . "12pt"))))))
  
  (org-msg-mode t))
;; Org Msg:1 ends here

;; [[file:~/.config/doom/config.org::*Org Chef][Org Chef:1]]
(use-package! org-chef
  :commands (org-chef-insert-recipe org-chef-get-recipe-from-url))
;; Org Chef:1 ends here

;; [[file:~/.config/doom/config.org::*Projectile][Projectile:1]]
(setq projectile-ignored-projects '("~/" "/tmp" "~/.emacs.d/.local/straight/repos/"))
(defun projectile-ignored-project-function (filepath)
  "Return t if FILEPATH is within any of `projectile-ignored-projects'"
  (or (mapcar (lambda (p) (s-starts-with-p p filepath)) projectile-ignored-projects)))
;; Projectile:1 ends here

;; [[file:~/.config/doom/config.org::*Smart Parentheses][Smart Parentheses:1]]
(sp-local-pair
     '(org-mode)
     "<<" ">>"
     :actions '(insert))
;; Smart Parentheses:1 ends here

;; [[file:~/.config/doom/config.org::*Spray][Spray:1]]
(setq spray-wpm 500
      spray-height 700)
;; Spray:1 ends here

;; [[file:~/.config/doom/config.org::*Theme magic][Theme magic:1]]
(add-hook 'doom-load-theme-hook 'theme-magic-from-emacs)
;; Theme magic:1 ends here

;; [[file:~/.config/doom/config.org::*Tramp][Tramp:1]]
(after! tramp
  (setenv "SHELL" "/bin/bash")
  (setq tramp-shell-prompt-pattern "\\(?:^\\|\\)[^]#$%>\n]*#?[]#$%>] *\\(\\[[0-9;]*[a-zA-Z] *\\)*")) ;; default + 
;; Tramp:1 ends here

;; [[file:~/.config/doom/config.org::*Treemacs][Treemacs:1]]
(after! treemacs
  (defvar treemacs-file-ignore-extensions '()
    "File extension which `treemacs-ignore-filter' will ensure are ignored")
  (defvar treemacs-file-ignore-globs '()
    "Globs which will are transformed to `treemacs-file-ignore-regexps' which `treemacs-ignore-filter' will ensure are ignored")
  (defvar treemacs-file-ignore-regexps '()
    "RegExps to be tested to ignore files, generated from `treeemacs-file-ignore-globs'")
  (defun treemacs-file-ignore-generate-regexps ()
    "Generate `treemacs-file-ignore-regexps' from `treemacs-file-ignore-globs'"
    (setq treemacs-file-ignore-regexps (mapcar 'dired-glob-regexp treemacs-file-ignore-globs)))
  (if (equal treemacs-file-ignore-globs '()) nil (treemacs-file-ignore-generate-regexps))
  (defun treemacs-ignore-filter (file full-path)
    "Ignore files specified by `treemacs-file-ignore-extensions', and `treemacs-file-ignore-regexps'"
    (or (member (file-name-extension file) treemacs-file-ignore-extensions)
        (let ((ignore-file nil))
          (dolist (regexp treemacs-file-ignore-regexps ignore-file)
            (setq ignore-file (or ignore-file (if (string-match-p regexp full-path) t nil)))))))
  (add-to-list 'treemacs-ignored-file-predicates #'treemacs-ignore-filter))
;; Treemacs:1 ends here

;; [[file:~/.config/doom/config.org::*Treemacs][Treemacs:2]]
(setq treemacs-file-ignore-extensions '(;; LaTeX
                                        "aux"
                                        "ptc"
                                        "fdb_latexmk"
                                        "fls"
                                        "synctex.gz"
                                        "toc"
                                        ;; LaTeX - glossary
                                        "glg"
                                        "glo"
                                        "gls"
                                        "glsdefs"
                                        "ist"
                                        "acn"
                                        "acr"
                                        "alg"
                                        ;; LaTeX - pgfplots
                                        "mw"
                                        ;; LaTeX - pdfx
                                        "pdfa.xmpi"
                                        ))
(setq treemacs-file-ignore-globs '(;; LaTeX
                                   "*/_minted-*"
                                   ;; AucTeX
                                   "*/.auctex-auto"
                                   "*/_region_.log"
                                   "*/_region_.tex"))
;; Treemacs:2 ends here

;; [[file:~/.config/doom/config.org::*VTerm][VTerm:1]]
(setq vterm-module-cmake-args "-DUSE_SYSTEM_LIBVTERM=yes")
;; VTerm:1 ends here

;; [[file:~/.config/doom/config.org::*Which-key][Which-key:1]]
(setq which-key-idle-delay 0.5) ;; I need the help, I really do
;; Which-key:1 ends here

;; [[file:~/.config/doom/config.org::*Which-key][Which-key:2]]
(setq which-key-allow-multiple-replacements t)
(after! which-key
  (pushnew!
   which-key-replacement-alist
   '(("" . "\\`+?evil[-:]?\\(?:a-\\)?\\(.*\\)") . (nil . "◂\\1"))
   '(("\\`g s" . "\\`evilem--?motion-\\(.*\\)") . (nil . "◃\\1"))
   ))
;; Which-key:2 ends here

;; [[file:~/.config/doom/config.org::*xkcd][xkcd:1]]
(use-package! xkcd
  :commands (xkcd-get-json xkcd-download xkcd-get
             ;; now for funcs from my extension of this pkg
             +xkcd-find-and-copy +xkcd-find-and-view
             +xkcd-fetch-info +xkcd-select)
  :config
  (add-to-list 'evil-snipe-disabled-modes 'xkcd-mode)
  :general (:states 'normal
            :keymaps 'xkcd-mode-map
            "<right>" #'xkcd-next
            "n"       #'xkcd-next ; evil-ish
            "<left>"  #'xkcd-prev
            "N"       #'xkcd-prev ; evil-ish
            "r"       #'xkcd-rand
            "a"       #'xkcd-rand ; because image-rotate can interfere
            "t"       #'xkcd-alt-text
            "q"       #'xkcd-kill-buffer
            "o"       #'xkcd-open-browser
            "e"       #'xkcd-open-explanation-browser
            ;; extras
            "s"       #'+xkcd-find-and-view
            "/"       #'+xkcd-find-and-view
            "y"       #'+xkcd-copy))
;; xkcd:1 ends here

;; [[file:~/.config/doom/config.org::*xkcd][xkcd:2]]
(after! xkcd
  (require 'emacsql-sqlite)

  (defun +xkcd-select ()
    "Prompt the user for an xkcd using `ivy-read' and `+xkcd-select-format'. Return the xkcd number or nil"
    (let* (prompt-lines
           (-dummy (maphash (lambda (key xkcd-info)
                              (push (+xkcd-select-format xkcd-info) prompt-lines))
                            +xkcd-stored-info))
           (num (ivy-read (format "xkcd (%s): " xkcd-latest) prompt-lines)))
      (if (equal "" num) xkcd-latest
        (string-to-number (replace-regexp-in-string "\\([0-9]+\\).*" "\\1" num)))))

  (defun +xkcd-select-format (xkcd-info)
    "Creates each ivy-read line from an xkcd info plist. Must start with the xkcd number"
    (format "%-4s  %-30s %s"
            (propertize (number-to-string (plist-get xkcd-info :num))
                        'face 'counsel-key-binding)
            (plist-get xkcd-info :title)
            (propertize (plist-get xkcd-info :alt)
                        'face '(variable-pitch font-lock-comment-face))))

  (defun +xkcd-fetch-info (&optional num)
    "Fetch the parsed json info for comic NUM. Fetches latest when omitted or 0"
    (require 'xkcd)
    (when (or (not num) (= num 0))
      (+xkcd-check-latest)
      (setq num xkcd-latest))
    (let ((res (or (gethash num +xkcd-stored-info)
                   (puthash num (+xkcd-db-read num) +xkcd-stored-info))))
      (unless res
        (+xkcd-db-write
         (let* ((url (format "http://xkcd.com/%d/info.0.json" num))
                (json-assoc
                 (if (assoc num +xkcd-stored-info)
                     (assoc num +xkcd-stored-info)
                   (json-read-from-string (xkcd-get-json url num)))))
           json-assoc))
        (setq res (+xkcd-db-read num)))
      res))

  ;; since we've done this, we may as well go one little step further
  (defun +xkcd-find-and-copy ()
    "Prompt for an xkcd using `+xkcd-select' and copy url to clipboard"
    (interactive)
    (+xkcd-copy (+xkcd-select)))

  (defun +xkcd-copy (&optional num)
    "Copy a url to xkcd NUM to the clipboard"
    (interactive "i")
    (let ((num (or num xkcd-cur)))
      (gui-select-text (format "https://xkcd.com/%d" num))
      (message "xkcd.com/%d copied to clipboard" num)))

  (defun +xkcd-find-and-view ()
    "Prompt for an xkcd using `+xkcd-select' and view it"
    (interactive)
    (xkcd-get (+xkcd-select))
    (switch-to-buffer "*xkcd*"))

  (defvar +xkcd-latest-max-age (* 60 60) ; 1 hour
    "Time after which xkcd-latest should be refreshed, in seconds")

  ;; initialise `xkcd-latest' and `+xkcd-stored-info' with latest xkcd
  (add-transient-hook! '+xkcd-select
    (require 'xkcd)
    (+xkcd-fetch-info xkcd-latest)
    (setq +xkcd-stored-info (+xkcd-db-read-all)))

  (add-transient-hook! '+xkcd-fetch-info
    (xkcd-update-latest))

  (defun +xkcd-check-latest ()
    "Use value in `xkcd-cache-latest' as long as it isn't older thabn `+xkcd-latest-max-age'"
    (unless (and (file-exists-p xkcd-cache-latest)
                 (< (- (time-to-seconds (current-time))
                       (time-to-seconds (file-attribute-modification-time (file-attributes xkcd-cache-latest))))
                    +xkcd-latest-max-age))
      (let* ((out (xkcd-get-json "http://xkcd.com/info.0.json" 0))
             (json-assoc (json-read-from-string out))
             (latest (cdr (assoc 'num json-assoc))))
        (when (/= xkcd-latest latest)
          (+xkcd-db-write json-assoc)
          (with-current-buffer (find-file xkcd-cache-latest)
            (setq xkcd-latest latest)
            (erase-buffer)
            (insert (number-to-string latest))
            (save-buffer)
            (kill-buffer (current-buffer)))))
      (shell-command (format "touch %s" xkcd-cache-latest))))

  (defvar +xkcd-stored-info (make-hash-table :test 'eql)
    "Basic info on downloaded xkcds, in the form of a hashtable")

  (defadvice! xkcd-get-json--and-cache (url &optional num)
    "Fetch the Json coming from URL.
If the file NUM.json exists, use it instead.
If NUM is 0, always download from URL.
The return value is a string."
    :override #'xkcd-get-json
    (let* ((file (format "%s%d.json" xkcd-cache-dir num))
           (cached (and (file-exists-p file) (not (eq num 0))))
           (out (with-current-buffer (if cached
                                         (find-file file)
                                       (url-retrieve-synchronously url))
                  (goto-char (point-min))
                  (unless cached (re-search-forward "^$"))
                  (prog1
                      (buffer-substring-no-properties (point) (point-max))
                    (kill-buffer (current-buffer))))))
      (unless (or cached (eq num 0))
        (xkcd-cache-json num out))
      out))

  (defadvice! +xkcd-get (num)
    "Get the xkcd number NUM."
    :override 'xkcd-get
    (interactive "nEnter comic number: ")
    (xkcd-update-latest)
    (get-buffer-create "*xkcd*")
    (switch-to-buffer "*xkcd*")
    (xkcd-mode)
    (let (buffer-read-only)
      (erase-buffer)
      (setq xkcd-cur num)
      (let* ((xkcd-data (+xkcd-fetch-info num))
             (num (plist-get xkcd-data :num))
             (img (plist-get xkcd-data :img))
             (safe-title (plist-get xkcd-data :safe-title))
             (alt (plist-get xkcd-data :alt))
             title file)
        (message "Getting comic...")
        (setq file (xkcd-download img num))
        (setq title (format "%d: %s" num safe-title))
        (insert (propertize title
                            'face 'outline-1))
        (center-line)
        (insert "\n")
        (xkcd-insert-image file num)
        (if (eq xkcd-cur 0)
            (setq xkcd-cur num))
        (setq xkcd-alt alt)
        (message "%s" title))))

  (defconst +xkcd-db--sqlite-available-p
    (with-demoted-errors "+org-xkcd initialization: %S"
      (emacsql-sqlite-ensure-binary)
      t))

  (defvar +xkcd-db--connection (make-hash-table :test #'equal)
    "Database connection to +org-xkcd database.")

  (defun +xkcd-db--get ()
    "Return the sqlite db file."
    (expand-file-name "xkcd.db" xkcd-cache-dir))

  (defun +xkcd-db--get-connection ()
    "Return the database connection, if any."
    (gethash (file-truename xkcd-cache-dir)
             +xkcd-db--connection))

  (defconst +xkcd-db--table-schema
    '((xkcds
       [(num integer :unique :primary-key)
        (year        :not-null)
        (month       :not-null)
        (link        :not-null)
        (news        :not-null)
        (safe_title  :not-null)
        (title       :not-null)
        (transcript  :not-null)
        (alt         :not-null)
        (img         :not-null)])))

  (defun +xkcd-db--init (db)
    "Initialize database DB with the correct schema and user version."
    (emacsql-with-transaction db
      (pcase-dolist (`(,table . ,schema) +xkcd-db--table-schema)
        (emacsql db [:create-table $i1 $S2] table schema))))

  (defun +xkcd-db ()
    "Entrypoint to the +org-xkcd sqlite database.
Initializes and stores the database, and the database connection.
Performs a database upgrade when required."
    (unless (and (+xkcd-db--get-connection)
                 (emacsql-live-p (+xkcd-db--get-connection)))
      (let* ((db-file (+xkcd-db--get))
             (init-db (not (file-exists-p db-file))))
        (make-directory (file-name-directory db-file) t)
        (let ((conn (emacsql-sqlite db-file)))
          (set-process-query-on-exit-flag (emacsql-process conn) nil)
          (puthash (file-truename xkcd-cache-dir)
                   conn
                   +xkcd-db--connection)
          (when init-db
            (+xkcd-db--init conn)))))
    (+xkcd-db--get-connection))

  (defun +xkcd-db-query (sql &rest args)
    "Run SQL query on +org-xkcd database with ARGS.
SQL can be either the emacsql vector representation, or a string."
    (if  (stringp sql)
        (emacsql (+xkcd-db) (apply #'format sql args))
      (apply #'emacsql (+xkcd-db) sql args)))

  (defun +xkcd-db-read (num)
    (when-let ((res
                (car (+xkcd-db-query [:select * :from xkcds
                                      :where (= num $s1)]
                                     num
                                     :limit 1))))
      (+xkcd-db-list-to-plist res)))

  (defun +xkcd-db-read-all ()
    (let ((xkcd-table (make-hash-table :test 'eql :size 4000)))
      (mapcar (lambda (xkcd-info-list)
                (puthash (car xkcd-info-list) (+xkcd-db-list-to-plist xkcd-info-list) xkcd-table))
              (+xkcd-db-query [:select * :from xkcds]))
      xkcd-table))

  (defun +xkcd-db-list-to-plist (xkcd-datalist)
    `(:num ,(nth 0 xkcd-datalist)
      :year ,(nth 1 xkcd-datalist)
      :month ,(nth 2 xkcd-datalist)
      :link ,(nth 3 xkcd-datalist)
      :news ,(nth 4 xkcd-datalist)
      :safe-title ,(nth 5 xkcd-datalist)
      :title ,(nth 6 xkcd-datalist)
      :transcript ,(nth 7 xkcd-datalist)
      :alt ,(nth 8 xkcd-datalist)
      :img ,(nth 9 xkcd-datalist)))

  (defun +xkcd-db-write (data)
    (+xkcd-db-query [:insert-into xkcds
                     :values $v1]
                    (list (vector
                           (cdr (assoc 'num        data))
                           (cdr (assoc 'year       data))
                           (cdr (assoc 'month      data))
                           (cdr (assoc 'link       data))
                           (cdr (assoc 'news       data))
                           (cdr (assoc 'safe_title data))
                           (cdr (assoc 'title      data))
                           (cdr (assoc 'transcript data))
                           (cdr (assoc 'alt        data))
                           (cdr (assoc 'img        data))
                           )))))
;; xkcd:2 ends here

;; [[file:~/.config/doom/config.org::*YASnippet][YASnippet:1]]
(setq yas-triggers-in-field t)
;; YASnippet:1 ends here

;; [[file:~/.config/doom/config.org::*File Templates][File Templates:1]]
(set-file-template! "\\.tex$" :trigger "__" :mode 'latex-mode)
;; File Templates:1 ends here

;; [[file:~/.config/doom/config.org::*Plaintext][Plaintext:1]]
(after! text-mode
  (add-hook! 'text-mode-hook
    ;; Apply ANSI color codes
    (with-silent-modifications
      (ansi-color-apply-on-region (point-min) (point-max)))))
;; Plaintext:1 ends here

;; [[file:~/.config/doom/config.org::*Tweaking defaults][Tweaking defaults:1]]
(setq org-directory "~/.org"                      ; let's put files here
      org-use-property-inheritance t              ; it's convenient to have properties inherited
      org-log-done 'time                          ; having the time a item is done sounds convininet
      org-list-allow-alphabetical t               ; have a. A. a) A) list bullets
      org-export-in-background t                  ; run export processes in external emacs process
      org-catch-invisible-edits 'smart)           ; try not to accidently do weird stuff in invisible regions
;; Tweaking defaults:1 ends here

;; [[file:~/.config/doom/config.org::*Tweaking defaults][Tweaking defaults:2]]
(setq org-babel-default-header-args '((:session . "none")
                                      (:results . "replace")
                                      (:exports . "code")
                                      (:cache . "no")
                                      (:noweb . "no")
                                      (:hlines . "no")
                                      (:tangle . "no")
                                      (:comments . "link")))
;; Tweaking defaults:2 ends here

;; [[file:~/.config/doom/config.org::*Tweaking defaults][Tweaking defaults:3]]
(remove-hook 'text-mode-hook #'visual-line-mode)
(add-hook 'text-mode-hook #'auto-fill-mode)
;; Tweaking defaults:3 ends here

;; [[file:~/.config/doom/config.org::*Org buffer creation][Org buffer creation:1]]
(evil-define-command evil-buffer-org-new (count file)
  "Creates a new ORG buffer replacing the current window, optionally
   editing a certain FILE"
  :repeat nil
  (interactive "P<f>")
  (if file
      (evil-edit file)
    (let ((buffer (generate-new-buffer "*new org*")))
      (set-window-buffer nil buffer)
      (with-current-buffer buffer
        (org-mode)))))
(map! :leader
  (:prefix "b"
    :desc "New empty ORG buffer" "o" #'evil-buffer-org-new))
;; Org buffer creation:1 ends here

;; [[file:~/.config/doom/config.org::*List bullet sequence][List bullet sequence:1]]
(setq org-list-demote-modify-bullet '(("+" . "-") ("-" . "+") ("*" . "+")))
;; List bullet sequence:1 ends here

;; [[file:~/.config/doom/config.org::*Citation][Citation:1]]
(use-package! org-ref
   :after org
   :config
    (setq org-ref-completion-library 'org-ref-ivy-cite))
;; Citation:1 ends here

;; [[file:~/.config/doom/config.org::*cdlatex][cdlatex:1]]
(after! org (add-hook 'org-mode-hook 'turn-on-org-cdlatex))
;; cdlatex:1 ends here

;; [[file:~/.config/doom/config.org::*cdlatex][cdlatex:2]]
(after! org
  (defadvice! org-edit-latex-emv-after-insert ()
    :after #'org-cdlatex-environment-indent
    (org-edit-latex-environment)))
;; cdlatex:2 ends here

;; [[file:~/.config/doom/config.org::*Spellcheck][Spellcheck:1]]
(after! org (add-hook 'org-mode-hook 'turn-on-flyspell))
;; Spellcheck:1 ends here

;; [[file:~/.config/doom/config.org::*LSP support in ~src~ blocks][LSP support in ~src~ blocks:1]]
(cl-defmacro lsp-org-babel-enable (lang)
    "Support LANG in org source code block."
    (setq centaur-lsp 'lsp-mode)
    (cl-check-type lang stringp)
    (let* ((edit-pre (intern (format "org-babel-edit-prep:%s" lang)))
           (intern-pre (intern (format "lsp--%s" (symbol-name edit-pre)))))
      `(progn
         (defun ,intern-pre (info)
           (let ((file-name (->> info caddr (alist-get :file))))
             (unless file-name
               (setq file-name (make-temp-file "babel-lsp-")))
             (setq buffer-file-name file-name)
              (lsp-deferred)))
         (put ',intern-pre 'function-documentation
              (format "Enable lsp-mode in the buffer of org source block (%s)."
                      (upcase ,lang)))
         (if (fboundp ',edit-pre)
             (advice-add ',edit-pre :after ',intern-pre)
           (progn
             (defun ,edit-pre (info)
               (,intern-pre info))
             (put ',edit-pre 'function-documentation
                  (format "Prepare local buffer environment for org source block (%s)."
                          (upcase ,lang))))))))
  (defvar org-babel-lang-list
    '("go" "python" "ipython" "bash" "sh"))
  (dolist (lang org-babel-lang-list)
    (eval `(lsp-org-babel-enable ,lang)))
;; LSP support in ~src~ blocks:1 ends here

;; [[file:~/.config/doom/config.org::*View exported file][View exported file:1]]
(after! org
  (map! :map org-mode-map
        :localleader
        :desc "View exported file" "v" #'org-view-output-file)

  (defun org-view-output-file (&optional org-file-path)
    (interactive)
    "Visit buffer open on the first output file (if any) found, using `org-view-output-file-extensions'"
    (let* ((org-file-path (or org-file-path (buffer-file-name) ""))
           (dir (file-name-directory org-file-path))
           (basename (file-name-base org-file-path))
           (output-file nil))
      (dolist (ext org-view-output-file-extensions)
        (unless output-file
          (when (file-exists-p
                 (concat dir basename "." ext))
                 (setq output-file (concat dir basename "." ext)))))
      (if output-file
        (pop-to-buffer (or (find-buffer-visiting output-file)
                           (find-file-noselect output-file)))
        (message "No exported file found")))))

(defvar org-view-output-file-extensions '("pdf" "md" "rst" "txt" "tex")
  "Search for output files with these extensions, in order, viewing the first that matches")
;; View exported file:1 ends here

;; [[file:~/.config/doom/config.org::*Super agenda][Super agenda:1]]
(use-package! org-super-agenda
  :commands (org-super-agenda-mode))
(after! org-agenda
  (org-super-agenda-mode))

(setq org-agenda-skip-scheduled-if-done t
      org-agenda-skip-deadline-if-done t
      org-agenda-include-deadlines t
      org-agenda-block-separator nil
      org-agenda-tags-column 100 ;; from testing this seems to be a good value
      org-agenda-compact-blocks t)

(setq org-agenda-custom-commands
      '(("o" "Overview"
         ((agenda "" ((org-agenda-span 'day)
                      (org-super-agenda-groups
                       '((:name "Today"
                                :time-grid t
                                :date today
                                :todo "TODAY"
                                :scheduled today
                                :order 1)))))
          (alltodo "" ((org-agenda-overriding-header "")
                       (org-super-agenda-groups
                        '((:name "Next to do"
                                 :todo "NEXT"
                                 :order 1)
                          (:name "Important"
                                 :tag "Important"
                                 :priority "A"
                                 :order 6)
                          (:name "Due Today"
                                 :deadline today
                                 :order 2)
                          (:name "Due Soon"
                                 :deadline future
                                 :order 8)
                          (:name "Overdue"
                                 :deadline past
                                 :face error
                                 :order 7)
                          (:name "Assignments"
                                 :tag "Assignment"
                                 :order 10)
                          (:name "Issues"
                                 :tag "Issue"
                                 :order 12)
                          (:name "Emacs"
                                 :tag "Emacs"
                                 :order 13)
                          (:name "Projects"
                                 :tag "Project"
                                 :order 14)
                          (:name "Research"
                                 :tag "Research"
                                 :order 15)
                          (:name "To read"
                                 :tag "Read"
                                 :order 30)
                          (:name "Waiting"
                                 :todo "WAITING"
                                 :order 20)
                          (:name "University"
                                 :tag "uni"
                                 :order 32)
                          (:name "Trivial"
                                 :priority<= "E"
                                 :tag ("Trivial" "Unimportant")
                                 :todo ("SOMEDAY" )
                                 :order 90)
                          (:discard (:tag ("Chore" "Routine" "Daily")))))))))))
;; Super agenda:1 ends here

;; [[file:~/.config/doom/config.org::*Capture][Capture:1]]
(use-package! doct
  :commands (doct))

(after! org-capture
  (defun org-capture-select-template-prettier (&optional keys)
    "Select a capture template, in a prettier way than default
  Lisp programs can force the template by setting KEYS to a string."
    (let ((org-capture-templates
           (or (org-contextualize-keys
                (org-capture-upgrade-templates org-capture-templates)
                org-capture-templates-contexts)
               '(("t" "Task" entry (file+headline "" "Tasks")
                  "* TODO %?\n  %u\n  %a")))))
      (if keys
          (or (assoc keys org-capture-templates)
              (error "No capture template referred to by \"%s\" keys" keys))
        (org-mks org-capture-templates
                 "Select a capture template\n━━━━━━━━━━━━━━━━━━━━━━━━━"
                 "Template key: "
                 `(("q" ,(concat (all-the-icons-octicon "stop" :face 'all-the-icons-red :v-adjust 0.01) "\tAbort")))))))
  (advice-add 'org-capture-select-template :override #'org-capture-select-template-prettier)
  
  (defun org-mks-pretty (table title &optional prompt specials)
    "Select a member of an alist with multiple keys. Prettified.
  
  TABLE is the alist which should contain entries where the car is a string.
  There should be two types of entries.
  
  1. prefix descriptions like (\"a\" \"Description\")
     This indicates that `a' is a prefix key for multi-letter selection, and
     that there are entries following with keys like \"ab\", \"ax\"…
  
  2. Select-able members must have more than two elements, with the first
     being the string of keys that lead to selecting it, and the second a
     short description string of the item.
  
  The command will then make a temporary buffer listing all entries
  that can be selected with a single key, and all the single key
  prefixes.  When you press the key for a single-letter entry, it is selected.
  When you press a prefix key, the commands (and maybe further prefixes)
  under this key will be shown and offered for selection.
  
  TITLE will be placed over the selection in the temporary buffer,
  PROMPT will be used when prompting for a key.  SPECIALS is an
  alist with (\"key\" \"description\") entries.  When one of these
  is selected, only the bare key is returned."
    (save-window-excursion
      (let ((inhibit-quit t)
      (buffer (org-switch-to-buffer-other-window "*Org Select*"))
      (prompt (or prompt "Select: "))
      case-fold-search
      current)
        (unwind-protect
      (catch 'exit
        (while t
          (setq-local evil-normal-state-cursor (list nil))
          (erase-buffer)
          (insert title "\n\n")
          (let ((des-keys nil)
          (allowed-keys '("\C-g"))
          (tab-alternatives '("\s" "\t" "\r"))
          (cursor-type nil))
      ;; Populate allowed keys and descriptions keys
      ;; available with CURRENT selector.
      (let ((re (format "\\`%s\\(.\\)\\'"
            (if current (regexp-quote current) "")))
            (prefix (if current (concat current " ") "")))
        (dolist (entry table)
          (pcase entry
            ;; Description.
            (`(,(and key (pred (string-match re))) ,desc)
             (let ((k (match-string 1 key)))
         (push k des-keys)
         ;; Keys ending in tab, space or RET are equivalent.
         (if (member k tab-alternatives)
             (push "\t" allowed-keys)
           (push k allowed-keys))
         (insert (propertize prefix 'face 'font-lock-comment-face) (propertize k 'face 'bold) (propertize "›" 'face 'font-lock-comment-face) "  " desc "…" "\n")))
            ;; Usable entry.
            (`(,(and key (pred (string-match re))) ,desc . ,_)
             (let ((k (match-string 1 key)))
         (insert (propertize prefix 'face 'font-lock-comment-face) (propertize k 'face 'bold) "   " desc "\n")
         (push k allowed-keys)))
            (_ nil))))
      ;; Insert special entries, if any.
      (when specials
        (insert "─────────────────────────\n")
        (pcase-dolist (`(,key ,description) specials)
          (insert (format "%s   %s\n" (propertize key 'face '(bold all-the-icons-red)) description))
          (push key allowed-keys)))
      ;; Display UI and let user select an entry or
      ;; a sub-level prefix.
      (goto-char (point-min))
      (unless (pos-visible-in-window-p (point-max))
        (org-fit-window-to-buffer))
      (let ((pressed (org--mks-read-key allowed-keys prompt)))
        (setq current (concat current pressed))
        (cond
         ((equal pressed "\C-g") (user-error "Abort"))
         ;; Selection is a prefix: open a new menu.
         ((member pressed des-keys))
         ;; Selection matches an association: return it.
         ((let ((entry (assoc current table)))
            (and entry (throw 'exit entry))))
         ;; Selection matches a special entry: return the
         ;; selection prefix.
         ((assoc current specials) (throw 'exit current))
         (t (error "No entry available")))))))
    (when buffer (kill-buffer buffer))))))
  (advice-add 'org-mks :override #'org-mks-pretty)
  (setq +org-capture-uni-units (split-string (f-read-text "~/.org/.uni-units")))
  (setq +org-capture-recipies  "~/Desktop/TEC/Organisation/recipies.org")

  (defun +doct-icon-declaration-to-icon (declaration)
    "Convert :icon declaration to icon"
    (let ((name (pop declaration))
          (set  (intern (concat "all-the-icons-" (plist-get declaration :set))))
          (face (intern (concat "all-the-icons-" (plist-get declaration :color))))
          (v-adjust (or (plist-get declaration :v-adjust) 0.01)))
      (apply set `(,name :face ,face :v-adjust ,v-adjust))))

  (defun +doct-iconify-capture-templates (groups)
    "Add declaration's :icon to each template group in GROUPS."
    (let ((templates (doct-flatten-lists-in groups)))
      (setq doct-templates (mapcar (lambda (template)
                                     (when-let* ((props (nthcdr (if (= (length template) 4) 2 5) template))
                                                 (spec (plist-get (plist-get props :doct) :icon)))
                                       (setf (nth 1 template) (concat (+doct-icon-declaration-to-icon spec)
                                                                      "\t"
                                                                      (nth 1 template))))
                                     template)
                                   templates))))

  (setq doct-after-conversion-functions '(+doct-iconify-capture-templates))

  (add-transient-hook! 'org-capture-select-template
    (setq org-capture-templates
          (doct `(("Personal todo" :keys "t"
                   :icon ("checklist" :set "octicon" :color "green")
                   :file +org-capture-todo-file
                   :prepend t
                   :headline "Inbox"
                   :type entry
                   :template ("* TODO %?"
                              "%i %a")
                   )
                  ("Personal note" :keys "n"
                   :icon ("sticky-note-o" :set "faicon" :color "green")
                   :file +org-capture-todo-file
                   :prepend t
                   :headline "Inbox"
                   :type entry
                   :template ("* %?"
                              "%i %a")
                   )
                  ("University" :keys "u"
                   :icon ("graduation-cap" :set "faicon" :color "purple")
                   :file +org-capture-todo-file
                   :headline "University"
                   :unit-prompt ,(format "%%^{Unit|%s}" (string-join +org-capture-uni-units "|"))
                   :prepend t
                   :type entry
                   :children (("Test" :keys "t"
                               :icon ("timer" :set "material" :color "red")
                               :template ("* TODO [#C] %{unit-prompt} %? :uni:tests:"
                                          "SCHEDULED: %^{Test date:}T"
                                          "%i %a"))
                              ("Assignment" :keys "a"
                               :icon ("library_books" :set "material" :color "orange")
                               :template ("* TODO [#B] %{unit-prompt} %? :uni:assignments:"
                                          "DEADLINE: %^{Due date:}T"
                                          "%i %a"))
                              ("Lecture" :keys "l"
                               :icon ("keynote" :set "fileicon" :color "orange")
                               :template ("* TODO [#C] %{unit-prompt} %? :uni:lecture:"
                                          "%i %a"))
                              ("Miscellaneous task" :keys "u"
                               :icon ("list" :set "faicon" :color "yellow")
                               :template ("* TODO [#D] %{unit-prompt} %? :uni:"
                                          "%i %a"))))
                  ("Email" :keys "e"
                   :icon ("envelope" :set "faicon" :color "blue")
                   :file +org-capture-todo-file
                   :prepend t
                   :headline "Inbox"
                   :type entry
                   :template ("* TODO %^{type|reply to|contact} %\\3 %? :email:"
                              "Send an email %^{urgancy|soon|ASAP|anon|at some point|eventually} to %^{recipiant}"
                              "about %^{topic}"
                              "%U %i %a"))
                  ("Interesting" :keys "i"
                   :icon ("eye" :set "faicon" :color "lcyan")
                   :file +org-capture-todo-file
                   :prepend t
                   :headline "Interesting"
                   :type entry
                   :template ("* [ ] %{desc}%? :%{i-type}:"
                              "%i %a")
                   :children (("Webpage" :keys "w"
                               :icon ("globe" :set "faicon" :color "green")
                               :desc "%(org-cliplink-capture) "
                               :i-type "read:web"
                               )
                              ("Article" :keys "a"
                               :icon ("file-text" :set "octicon" :color "yellow")
                               :desc ""
                               :i-type "read:reaserch"
                               )
                              ("\tRecipie" :keys "r"
                               :icon ("spoon" :set "faicon" :color "dorange")
                               :file +org-capture-recipies
                               :headline "Unsorted"
                               :template "%(org-chef-get-recipe-from-url)"
                               )
                              ("Information" :keys "i"
                               :icon ("info-circle" :set "faicon" :color "blue")
                               :desc ""
                               :i-type "read:info"
                               )
                              ("Idea" :keys "I"
                               :icon ("bubble_chart" :set "material" :color "silver")
                               :desc ""
                               :i-type "idea"
                               )))
                  ("Tasks" :keys "k"
                   :icon ("inbox" :set "octicon" :color "yellow")
                   :file +org-capture-todo-file
                   :prepend t
                   :headline "Tasks"
                   :type entry
                   :template ("* TODO %? %^G%{extra}"
                              "%i %a")
                   :children (("General Task" :keys "k"
                               :icon ("inbox" :set "octicon" :color "yellow")
                               :extra ""
                               )
                              ("Task with deadline" :keys "d"
                               :icon ("timer" :set "material" :color "orange" :v-adjust -0.1)
                               :extra "\nDEADLINE: %^{Deadline:}t"
                               )
                              ("Scheduled Task" :keys "s"
                               :icon ("calendar" :set "octicon" :color "orange")
                               :extra "\nSCHEDULED: %^{Start time:}t"
                               )
                              ))
                ("Project" :keys "p"
                 :icon ("repo" :set "octicon" :color "silver")
                   :prepend t
                   :type entry
                   :headline "Inbox"
                   :template ("* %{time-or-todo} %?"
                              "%i"
                              "%a")
                   :file ""
                   :custom (:time-or-todo "")
                   :children (("Project-local todo" :keys "t"
                               :icon ("checklist" :set "octicon" :color "green")
                               :time-or-todo "TODO"
                               :file +org-capture-project-todo-file)
                              ("Project-local note" :keys "n"
                               :icon ("sticky-note" :set "faicon" :color "yellow")
                               :time-or-todo "%U"
                               :file +org-capture-project-notes-file)
                              ("Project-local changelog" :keys "c"
                               :icon ("list" :set "faicon" :color "blue")
                               :time-or-todo "%U"
                               :heading "Unreleased"
                               :file +org-capture-project-changelog-file))
                   )
                  ("\tCentralised project templates"
                   :keys "o"
                   :type entry
                   :prepend t
                   :template ("* %{time-or-todo} %?"
                              "%i"
                              "%a")
                   :children (("Project todo"
                               :keys "t"
                               :prepend nil
                               :time-or-todo "TODO"
                               :heading "Tasks"
                               :file +org-capture-central-project-todo-file)
                              ("Project note"
                               :keys "n"
                               :time-or-todo "%U"
                               :heading "Notes"
                               :file +org-capture-central-project-notes-file)
                              ("Project changelog"
                               :keys "c"
                               :time-or-todo "%U"
                               :heading "Unreleased"
                               :file +org-capture-central-project-changelog-file))
                   ))))))
;; Capture:1 ends here

;; [[file:~/.config/doom/config.org::*Capture][Capture:3]]
(setf (alist-get 'height +org-capture-frame-parameters) 15)
      ;; (alist-get 'name +org-capture-frame-parameters) "❖ Capture") ;; ATM hardcoded in other places, so changing breaks stuff
(setq +org-capture-fn
      (lambda ()
        (interactive)
        (set-window-parameter nil 'mode-line-format 'none)
        (org-capture)))
;; Capture:3 ends here

;; [[file:~/.config/doom/config.org::*Basic settings][Basic settings:1]]
(setq org-roam-directory "~/Desktop/TEC/Organisation/Roam/")
;; Basic settings:1 ends here

;; [[file:~/.config/doom/config.org::*Graph Behaviour][Graph Behaviour:2]]
(after! org-roam
  (setq +org-roam-graph--html-template (replace-regexp-in-string "%\\([^s]\\)" "%%\\1" (f-read-text (concat doom-private-dir "misc/org-roam-template.html"))))

  (defadvice! +org-roam-graph--build-html (&optional node-query)
    "Generate a graph showing the relations between nodes in NODE-QUERY. HTML style."
    :override #'org-roam-graph--build
    (unless org-roam-graph-executable
      (user-error "Can't find %s executable.  Please check if it is in your path"
                  org-roam-graph-executable))
    (let* ((node-query (or node-query
                           `[:select [file titles]
                                     :from titles
                                     ,@(org-roam-graph--expand-matcher 'file t)]))
           (graph      (org-roam-graph--dot node-query))
           (temp-dot   (make-temp-file "graph." nil ".dot" graph))
           (temp-graph (make-temp-file "graph." nil ".svg"))
           (temp-html  (make-temp-file "graph." nil ".html")))
      (call-process org-roam-graph-executable nil 0 nil
                    temp-dot "-Tsvg" "-o" temp-graph)
      (sleep-for 0.1)
      (write-region (format +org-roam-graph--html-template (f-read-text temp-graph)) nil temp-html)
      temp-html)))
;; Graph Behaviour:2 ends here

;; [[file:~/.config/doom/config.org::*Modeline file name][Modeline file name:1]]
(defadvice! doom-modeline--reformat-roam (orig-fun)
  :around #'doom-modeline-buffer-file-name
  (message "Reformat?")
  (message (buffer-file-name))
  (if (s-contains-p org-roam-directory (or buffer-file-name ""))
      (replace-regexp-in-string
       "\\(?:^\\|.*/\\)\\([0-9]\\{4\\}\\)\\([0-9]\\{2\\}\\)\\([0-9]\\{2\\}\\)[0-9]*-"
       "🢔(\\1-\\2-\\3) "
       (funcall orig-fun))
    (funcall orig-fun)))
;; Modeline file name:1 ends here

;; [[file:~/.config/doom/config.org::*Nicer generated heading IDs][Nicer generated heading IDs:1]]
(defvar org-heading-contraction-max-words 3
  "Maximum number of words in a heading")
(defvar org-heading-contraction-max-length 35
  "Maximum length of resulting string")
(defvar org-heading-contraction-stripped-words
  '("the" "on" "in" "off" "a" "for" "by" "of" "and" "is" "to")
  "Unnecesary words to be removed from a heading")

(defun org-heading-contraction (heading-string)
  "Get a contracted form of HEADING-STRING that is onlu contains alphanumeric charachters.
Strips 'joining' words in `org-heading-contraction-stripped-words',
and then limits the result to the first `org-heading-contraction-max-words' words.
If the total length is > `org-heading-contraction-max-length' then individual words are
truncated to fit within the limit"
  (let ((heading-words
         (-filter (lambda (word)
                    (not (member word org-heading-contraction-stripped-words)))
                  (split-string
                   (->> heading-string
                        s-downcase
                        (replace-regexp-in-string "\\[\\[[^]]+\\]\\[\\([^]]+\\)\\]\\]" "\\1") ; get description from org-link
                        (replace-regexp-in-string "[-/ ]+" " ") ; replace seperator-type chars with space
                        (replace-regexp-in-string "[^a-z0-9 ]" "") ; strip chars which need %-encoding in a uri
                        ) " "))))
    (when (> (length heading-words)
             org-heading-contraction-max-words)
      (setq heading-words
            (subseq heading-words 0 org-heading-contraction-max-words)))

    (when (> (+ (-sum (mapcar #'length heading-words))
                (1- (length heading-words)))
             org-heading-contraction-max-length)
      ;; trucate each word to a max word length determined by
      ;;   max length = \floor{ \frac{total length - chars for seperators - \sum_{word \leq average length} length(word) }{num(words) > average length} }
      (setq heading-words (let* ((total-length-budget (- org-heading-contraction-max-length  ; how many non-separator chars we can use
                                                         (1- (length heading-words))))
                                 (word-length-budget (/ total-length-budget                  ; max length of each word to keep within budget
                                                        org-heading-contraction-max-words))
                                 (num-overlong (-count (lambda (word)                             ; how many words exceed that budget
                                                         (> (length word) word-length-budget))
                                                       heading-words))
                                 (total-short-length (-sum (mapcar (lambda (word)                 ; total length of words under that budget
                                                                     (if (<= (length word) word-length-budget)
                                                                         (length word) 0))
                                                                   heading-words)))
                                 (max-length (/ (- total-length-budget total-short-length)   ; max(max-length) that we can have to fit within the budget
                                                num-overlong)))
                            (mapcar (lambda (word)
                                      (if (<= (length word) max-length)
                                          word
                                        (substring word 0 max-length)))
                                    heading-words))))
    (string-join heading-words "-")))
;; Nicer generated heading IDs:1 ends here

;; [[file:~/.config/doom/config.org::*Nicer generated heading IDs][Nicer generated heading IDs:2]]
(define-minor-mode unpackaged/org-export-html-with-useful-ids-mode
  "Attempt to export Org as HTML with useful link IDs.
Instead of random IDs like \"#orga1b2c3\", use heading titles,
made unique when necessary."
  :global t
  (if unpackaged/org-export-html-with-useful-ids-mode
      (advice-add #'org-export-get-reference :override #'unpackaged/org-export-get-reference)
    (advice-remove #'org-export-get-reference #'unpackaged/org-export-get-reference)))

(defun unpackaged/org-export-get-reference (datum info)
  "Like `org-export-get-reference', except uses heading titles instead of random numbers."
  (let ((cache (plist-get info :internal-references)))
    (or (car (rassq datum cache))
        (let* ((crossrefs (plist-get info :crossrefs))
               (cells (org-export-search-cells datum))
               ;; Preserve any pre-existing association between
               ;; a search cell and a reference, i.e., when some
               ;; previously published document referenced a location
               ;; within current file (see
               ;; `org-publish-resolve-external-link').
               ;;
               ;; However, there is no guarantee that search cells are
               ;; unique, e.g., there might be duplicate custom ID or
               ;; two headings with the same title in the file.
               ;;
               ;; As a consequence, before re-using any reference to
               ;; an element or object, we check that it doesn't refer
               ;; to a previous element or object.
               (new (or (cl-some
                         (lambda (cell)
                           (let ((stored (cdr (assoc cell crossrefs))))
                             (when stored
                               (let ((old (org-export-format-reference stored)))
                                 (and (not (assoc old cache)) stored)))))
                         cells)
                        (when (org-element-property :raw-value datum)
                          ;; Heading with a title
                          (unpackaged/org-export-new-title-reference datum cache))
                        ;; NOTE: This probably breaks some Org Export
                        ;; feature, but if it does what I need, fine.
                        (org-export-format-reference
                         (org-export-new-reference cache))))
               (reference-string new))
          ;; Cache contains both data already associated to
          ;; a reference and in-use internal references, so as to make
          ;; unique references.
          (dolist (cell cells) (push (cons cell new) cache))
          ;; Retain a direct association between reference string and
          ;; DATUM since (1) not every object or element can be given
          ;; a search cell (2) it permits quick lookup.
          (push (cons reference-string datum) cache)
          (plist-put info :internal-references cache)
          reference-string))))

(defun unpackaged/org-export-new-title-reference (datum cache)
  "Return new reference for DATUM that is unique in CACHE."
  (cl-macrolet ((inc-suffixf (place)
                             `(progn
                                (string-match (rx bos
                                                  (minimal-match (group (1+ anything)))
                                                  (optional "--" (group (1+ digit)))
                                                  eos)
                                              ,place)
                                ;; HACK: `s1' instead of a gensym.
                                (-let* (((s1 suffix) (list (match-string 1 ,place)
                                                           (match-string 2 ,place)))
                                        (suffix (if suffix
                                                    (string-to-number suffix)
                                                  0)))
                                  (setf ,place (format "%s--%s" s1 (cl-incf suffix)))))))
    (let* ((title (org-element-property :raw-value datum))
           ;; get ascii-only form of title without needing percent-encoding
           (ref (org-heading-contraction (substring-no-properties title)))
           (parent (org-element-property :parent datum)))
      (while (--any (equal ref (car it))
                    cache)
        ;; Title not unique: make it so.
        (if parent
            ;; Append ancestor title.
            (setf title (concat (org-element-property :raw-value parent)
                                "--" title)
                  ;; get ascii-only form of title without needing percent-encoding
                  ref (org-heading-contraction (substring-no-properties title))
                  parent (org-element-property :parent parent))
          ;; No more ancestors: add and increment a number.
          (inc-suffixf ref)))
      ref)))

(add-hook 'org-load-hook #'unpackaged/org-export-html-with-useful-ids-mode)
;; Nicer generated heading IDs:2 ends here

;; [[file:~/.config/doom/config.org::*Nicer ~org-return~][Nicer ~org-return~:1]]
(after! org
  (defun unpackaged/org-element-descendant-of (type element)
    "Return non-nil if ELEMENT is a descendant of TYPE.
TYPE should be an element type, like `item' or `paragraph'.
ELEMENT should be a list like that returned by `org-element-context'."
    ;; MAYBE: Use `org-element-lineage'.
    (when-let* ((parent (org-element-property :parent element)))
      (or (eq type (car parent))
          (unpackaged/org-element-descendant-of type parent))))

;;;###autoload
  (defun unpackaged/org-return-dwim (&optional default)
    "A helpful replacement for `org-return-indent'.  With prefix, call `org-return-indent'.

On headings, move point to position after entry content.  In
lists, insert a new item or end the list, with checkbox if
appropriate.  In tables, insert a new row or end the table."
    ;; Inspired by John Kitchin: http://kitchingroup.cheme.cmu.edu/blog/2017/04/09/A-better-return-in-org-mode/
    (interactive "P")
    (if default
        (org-return t)
      (cond
       ;; Act depending on context around point.

       ;; NOTE: I prefer RET to not follow links, but by uncommenting this block, links will be
       ;; followed.

       ;; ((eq 'link (car (org-element-context)))
       ;;  ;; Link: Open it.
       ;;  (org-open-at-point-global))

       ((org-at-heading-p)
        ;; Heading: Move to position after entry content.
        ;; NOTE: This is probably the most interesting feature of this function.
        (let ((heading-start (org-entry-beginning-position)))
          (goto-char (org-entry-end-position))
          (cond ((and (org-at-heading-p)
                      (= heading-start (org-entry-beginning-position)))
                 ;; Entry ends on its heading; add newline after
                 (end-of-line)
                 (insert "\n\n"))
                (t
                 ;; Entry ends after its heading; back up
                 (forward-line -1)
                 (end-of-line)
                 (when (org-at-heading-p)
                   ;; At the same heading
                   (forward-line)
                   (insert "\n")
                   (forward-line -1))
                 ;; FIXME: looking-back is supposed to be called with more arguments.
                 (while (not (looking-back (rx (repeat 3 (seq (optional blank) "\n")))))
                   (insert "\n"))
                 (forward-line -1)))))

       ((org-at-item-checkbox-p)
        ;; Checkbox: Insert new item with checkbox.
        (org-insert-todo-heading nil))

       ((org-in-item-p)
        ;; Plain list.  Yes, this gets a little complicated...
        (let ((context (org-element-context)))
          (if (or (eq 'plain-list (car context))  ; First item in list
                  (and (eq 'item (car context))
                       (not (eq (org-element-property :contents-begin context)
                                (org-element-property :contents-end context))))
                  (unpackaged/org-element-descendant-of 'item context))  ; Element in list item, e.g. a link
              ;; Non-empty item: Add new item.
              (org-insert-item)
            ;; Empty item: Close the list.
            ;; TODO: Do this with org functions rather than operating on the text. Can't seem to find the right function.
            (delete-region (line-beginning-position) (line-end-position))
            (insert "\n"))))

       ((when (fboundp 'org-inlinetask-in-task-p)
          (org-inlinetask-in-task-p))
        ;; Inline task: Don't insert a new heading.
        (org-return t))

       ((org-at-table-p)
        (cond ((save-excursion
                 (beginning-of-line)
                 ;; See `org-table-next-field'.
                 (cl-loop with end = (line-end-position)
                          for cell = (org-element-table-cell-parser)
                          always (equal (org-element-property :contents-begin cell)
                                        (org-element-property :contents-end cell))
                          while (re-search-forward "|" end t)))
               ;; Empty row: end the table.
               (delete-region (line-beginning-position) (line-end-position))
               (org-return t))
              (t
               ;; Non-empty row: call `org-return-indent'.
               (org-return t))))
       (t
        ;; All other cases: call `org-return-indent'.
        (org-return t)))))
  (advice-add #'org-return-indent :override #'unpackaged/org-return-dwim))
;; Nicer ~org-return~:1 ends here

;; [[file:~/.config/doom/config.org::*xkcd][xkcd:1]]
(after! org
  (org-link-set-parameters "xkcd"
                           :image-data-fun #'+org-xkcd-image-fn
                           :follow #'+org-xkcd-open-fn
                           :export #'+org-xkcd-export
                           :complete #'+org-xkcd-complete)

  (defun +org-xkcd-open-fn (link)
    (+org-xkcd-image-fn nil link nil))

  (defun +org-xkcd-image-fn (protocol link description)
    "Get image data for xkcd num LINK"
    (let* ((xkcd-info (+xkcd-fetch-info (string-to-number link)))
           (img (plist-get xkcd-info :img))
           (alt (plist-get xkcd-info :alt)))
      (message alt)
      (+org-image-file-data-fn protocol (xkcd-download img (string-to-number link)) description)))

  (defun +org-xkcd-export (path desc backend _com)
    "Convert xkcd to html/LaTeX form"
    (let* ((xkcd-info (+xkcd-fetch-info (string-to-number path)))
           (img (plist-get xkcd-info :img))
           (alt (plist-get xkcd-info :alt))
           (title (plist-get xkcd-info :title))
           (file (xkcd-download img (string-to-number path))))
      (cond ((org-export-derived-backend-p backend 'html)
             (format "<img src='%s' title=\"%s\" alt='%s'>" img (subst-char-in-string ?\" ?“ alt) title))
            ((org-export-derived-backend-p backend 'latex)
             (format "\\begin{figure}[!htb]
  \\centering
  \\includegraphics[scale=0.4]{%s}
  \\caption*{\\label{xkcd:%s} %s}
\\end{figure}" file path (or desc
                             (format "\\textbf{%s} %s" title alt))))
            (t (format "https://xkcd.com/%s" path)))))

  (defun +org-xkcd-complete (&optional arg)
    "Complete xkcd using `+xkcd-stored-info'"
    (format "xkcd:%d" (+xkcd-select))))
;; xkcd:1 ends here

;; [[file:~/.config/doom/config.org::*YouTube][YouTube:1]]
(after! org
  (org-link-set-parameters "yt" :export #'+org-export-yt)
  (defun +org-export-yt (path desc backend _com)
    (cond ((org-export-derived-backend-p backend 'html)
           (format "<iframe width='440' \
height='335' \
src='https://www.youtube.com/embed/%s' \
frameborder='0' \
allowfullscreen>%s</iframe>" path (or "" desc)))
          ((org-export-derived-backend-p backend 'latex)
           (format "\\href{https://youtu.be/%s}{%s}" path (or desc "youtube")))
          (t (format "https://youtu.be/%s" path)))))
;; YouTube:1 ends here

;; [[file:~/.config/doom/config.org::*Font Display][Font Display:1]]
(add-hook! 'org-mode-hook #'+org-pretty-mode #'mixed-pitch-mode)
;; Font Display:1 ends here

;; [[file:~/.config/doom/config.org::*Font Display][Font Display:2]]
(setq global-org-pretty-table-mode t)
;; Font Display:2 ends here

;; [[file:~/.config/doom/config.org::*Font Display][Font Display:3]]
(custom-set-faces!
  '(outline-1 :weight extra-bold :height 1.25)
  '(outline-2 :weight bold :height 1.15)
  '(outline-3 :weight bold :height 1.12)
  '(outline-4 :weight semi-bold :height 1.09)
  '(outline-5 :weight semi-bold :height 1.06)
  '(outline-6 :weight semi-bold :height 1.03)
  '(outline-8 :weight semi-bold)
  '(outline-9 :weight semi-bold))
;; Font Display:3 ends here

;; [[file:~/.config/doom/config.org::*Symbols][Symbols:1]]
;; (after! org
;;   (use-package org-pretty-tags
;;   :config
;;    (setq org-pretty-tags-surrogate-strings
;;          `(("uni"        . ,(all-the-icons-faicon   "graduation-cap" :face 'all-the-icons-purple  :v-adjust 0.01))
;;            ("ucc"        . ,(all-the-icons-material "computer"       :face 'all-the-icons-silver  :v-adjust 0.01))
;;            ("assignment" . ,(all-the-icons-material "library_books"  :face 'all-the-icons-orange  :v-adjust 0.01))
;;            ("test"       . ,(all-the-icons-material "timer"          :face 'all-the-icons-red     :v-adjust 0.01))
;;            ("lecture"    . ,(all-the-icons-fileicon "keynote"        :face 'all-the-icons-orange  :v-adjust 0.01))
;;            ("email"      . ,(all-the-icons-faicon   "envelope"       :face 'all-the-icons-blue    :v-adjust 0.01))
;;            ("read"       . ,(all-the-icons-octicon  "book"           :face 'all-the-icons-lblue   :v-adjust 0.01))
;;            ("article"    . ,(all-the-icons-octicon  "file-text"      :face 'all-the-icons-yellow  :v-adjust 0.01))
;;            ("web"        . ,(all-the-icons-faicon   "globe"          :face 'all-the-icons-green   :v-adjust 0.01))
;;            ("info"       . ,(all-the-icons-faicon   "info-circle"    :face 'all-the-icons-blue    :v-adjust 0.01))
;;            ("issue"      . ,(all-the-icons-faicon   "bug"            :face 'all-the-icons-red     :v-adjust 0.01))
;;            ("someday"    . ,(all-the-icons-faicon   "calendar-o"     :face 'all-the-icons-cyan    :v-adjust 0.01))
;;            ("idea"       . ,(all-the-icons-octicon  "light-bulb"     :face 'all-the-icons-yellow  :v-adjust 0.01))
;;            ("emacs"      . ,(all-the-icons-fileicon "emacs"          :face 'all-the-icons-lpurple :v-adjust 0.01))))
;;    (org-pretty-tags-global-mode)))

(after! org-superstar
  (setq org-superstar-headline-bullets-list '("◉" "○" "✸" "✿" "✤" "✜" "◆" "▶")
        ;; org-superstar-headline-bullets-list '("Ⅰ" "Ⅱ" "Ⅲ" "Ⅳ" "Ⅴ" "Ⅵ" "Ⅶ" "Ⅷ" "Ⅸ" "Ⅹ")
        org-superstar-prettify-item-bullets t ))
(after! org
  (setq org-ellipsis " ▾ "
        org-priority-highest ?A
        org-priority-lowest ?E
        org-priority-faces
        '((?A . 'all-the-icons-red)
          (?B . 'all-the-icons-orange)
          (?C . 'all-the-icons-yellow)
          (?D . 'all-the-icons-green)
          (?E . 'all-the-icons-blue))))
;; Symbols:1 ends here

;; [[file:~/.config/doom/config.org::*Symbols][Symbols:2]]
(after! org
  (appendq! +pretty-code-symbols
            `(:checkbox      "☐"
              :pending       "◼"
              :checkedbox    "☑"
              :list_property "∷"
              :results       "🠶"
              :property      "☸"
              :properties    "⚙"
              :end           "∎"
              :options       "⌥"
              :title         "𝙏"
              :author        "𝘼"
              :date          "𝘿"
              :latex_header  "⇥"
              :latex_class   "🄲"
              :begin_quote   "❮"
              :end_quote     "❯"
              :begin_export  "⯮"
              :end_export    "⯬"
              :priority_a   ,(propertize "⚑" 'face 'all-the-icons-red)
              :priority_b   ,(propertize "⬆" 'face 'all-the-icons-orange)
              :priority_c   ,(propertize "■" 'face 'all-the-icons-yellow)
              :priority_d   ,(propertize "⬇" 'face 'all-the-icons-green)
              :priority_e   ,(propertize "❓" 'face 'all-the-icons-blue)
              :em_dash       "—"))
  (set-pretty-symbols! 'org-mode
    :merge t
    :checkbox      "[ ]"
    :pending       "[-]"
    :checkedbox    "[X]"
    :list_property "::"
    :results       "#+RESULTS:"
    :property      "#+PROPERTY:"
    :property      ":PROPERTIES:"
    :end           ":END:"
    :options       "#+OPTIONS:"
    :title         "#+TITLE:"
    :author        "#+AUTHOR:"
    :date          "#+DATE:"
    :latex_class   "#+LATEX_CLASS:"
    :latex_header  "#+LATEX_HEADER:"
    :begin_quote   "#+BEGIN_QUOTE"
    :end_quote     "#+END_QUOTE"
    :begin_export  "#+BEGIN_EXPORT"
    :end_export    "#+END_EXPORT"
    :priority_a    "[#A]"
    :priority_b    "[#B]"
    :priority_c    "[#C]"
    :priority_d    "[#D]"
    :priority_e    "[#E]"
    :em_dash       "---"))
(plist-put +pretty-code-symbols :name "⁍") ; or › could be good?
;; Symbols:2 ends here

;; [[file:~/.config/doom/config.org::*Symbols][Symbols:3]]
(add-hook 'org-mode-hook 'org-fragtog-mode)
;; Symbols:3 ends here

;; [[file:~/.config/doom/config.org::*LaTeX Fragments][LaTeX Fragments:1]]
(after! org
  (setq org-highlight-latex-and-related '(native script entities)))
;; LaTeX Fragments:1 ends here

;; [[file:~/.config/doom/config.org::*LaTeX Fragments][LaTeX Fragments:2]]
(setq org-format-latex-header "\\documentclass{article}
\\usepackage[usenames]{color}

\\usepackage[T1]{fontenc}
\\usepackage{mathtools}
\\usepackage{textcomp,amssymb}
\\usepackage[makeroom]{cancel}

\\usepackage{booktabs}

\\pagestyle{empty}             % do not remove
% The settings below are copied from fullpage.sty
\\setlength{\\textwidth}{\\paperwidth}
\\addtolength{\\textwidth}{-3cm}
\\setlength{\\oddsidemargin}{1.5cm}
\\addtolength{\\oddsidemargin}{-2.54cm}
\\setlength{\\evensidemargin}{\\oddsidemargin}
\\setlength{\\textheight}{\\paperheight}
\\addtolength{\\textheight}{-\\headheight}
\\addtolength{\\textheight}{-\\headsep}
\\addtolength{\\textheight}{-\\footskip}
\\addtolength{\\textheight}{-3cm}
\\setlength{\\topmargin}{1.5cm}
\\addtolength{\\topmargin}{-2.54cm}
% my custom stuff
\\usepackage{arev}
\\usepackage{arevmath}")
;; LaTeX Fragments:2 ends here

;; [[file:~/.config/doom/config.org::*LaTeX Fragments][LaTeX Fragments:3]]
(after! org
;; make background of fragments transparent
;; (let ((dvipng--plist (alist-get 'dvipng org-preview-latex-process-alist)))
;;   (plist-put dvipng--plist :use-xcolor t)
;;   (plist-put dvipng--plist :image-converter '("dvipng -D %D -bg 'transparent' -T tight -o %O %f")))
  (add-hook! 'doom-load-theme-hook
    (defun +org-refresh-latex-background ()
      (plist-put! org-format-latex-options
                  :background
                  (face-attribute (or (cadr (assq 'default face-remapping-alist))
                                      'default)
                                  :background nil t))))
)
;; LaTeX Fragments:3 ends here

;; [[file:~/.config/doom/config.org::*LaTeX Fragments][LaTeX Fragments:4]]
(after! org
  (add-to-list 'org-latex-regexps '("\\ce" "^\\\\ce{\\(?:[^\000{}]\\|{[^\000}]+?}\\)}" 0 nil)))
;; LaTeX Fragments:4 ends here

;; [[file:~/.config/doom/config.org::*Stolen from \[\[https://github.com/jkitchin/scimax\]\[scimax\]\] (semi-working right now)][Stolen from [[https://github.com/jkitchin/scimax][scimax]] (semi-working right now):1]]
(after! org
  (defun scimax-org-latex-fragment-justify (justification)
    "Justify the latex fragment at point with JUSTIFICATION.
JUSTIFICATION is a symbol for 'left, 'center or 'right."
    (interactive
     (list (intern-soft
            (completing-read "Justification (left): " '(left center right)
                             nil t nil nil 'left))))
    (let* ((ov (ov-at))
           (beg (ov-beg ov))
           (end (ov-end ov))
           (shift (- beg (line-beginning-position)))
           (img (overlay-get ov 'display))
           (img (and (and img (consp img) (eq (car img) 'image)
                          (image-type-available-p (plist-get (cdr img) :type)))
                     img))
           space-left offset)
      (when (and img
                 ;; This means the equation is at the start of the line
                 (= beg (line-beginning-position))
                 (or
                  (string= "" (s-trim (buffer-substring end (line-end-position))))
                  (eq 'latex-environment (car (org-element-context)))))
        (setq space-left (- (window-max-chars-per-line) (car (image-size img)))
              offset (floor (cond
                             ((eq justification 'center)
                              (- (/ space-left 2) shift))
                             ((eq justification 'right)
                              (- space-left shift))
                             (t
                              0))))
        (when (>= offset 0)
          (overlay-put ov 'before-string (make-string offset ?\ ))))))

  (defun scimax-org-latex-fragment-justify-advice (beg end image imagetype)
    "After advice function to justify fragments."
    (scimax-org-latex-fragment-justify (or (plist-get org-format-latex-options :justify) 'left)))


  (defun scimax-toggle-latex-fragment-justification ()
    "Toggle if LaTeX fragment justification options can be used."
    (interactive)
    (if (not (get 'scimax-org-latex-fragment-justify-advice 'enabled))
        (progn
          (advice-add 'org--format-latex-make-overlay :after 'scimax-org-latex-fragment-justify-advice)
          (put 'scimax-org-latex-fragment-justify-advice 'enabled t)
          (message "Latex fragment justification enabled"))
      (advice-remove 'org--format-latex-make-overlay 'scimax-org-latex-fragment-justify-advice)
      (put 'scimax-org-latex-fragment-justify-advice 'enabled nil)
      (message "Latex fragment justification disabled"))))
;; Stolen from [[https://github.com/jkitchin/scimax][scimax]] (semi-working right now):1 ends here

;; [[file:~/.config/doom/config.org::*Stolen from \[\[https://github.com/jkitchin/scimax\]\[scimax\]\] (semi-working right now)][Stolen from [[https://github.com/jkitchin/scimax][scimax]] (semi-working right now):2]]
;; Numbered equations all have (1) as the number for fragments with vanilla
;; org-mode. This code injects the correct numbers into the previews so they
;; look good.
(after! org
  (defun scimax-org-renumber-environment (orig-func &rest args)
    "A function to inject numbers in LaTeX fragment previews."
    (let ((results '())
          (counter -1)
          (numberp))
      (setq results (loop for (begin .  env) in
                          (org-element-map (org-element-parse-buffer) 'latex-environment
                            (lambda (env)
                              (cons
                               (org-element-property :begin env)
                               (org-element-property :value env))))
                          collect
                          (cond
                           ((and (string-match "\\\\begin{equation}" env)
                                 (not (string-match "\\\\tag{" env)))
                            (incf counter)
                            (cons begin counter))
                           ((string-match "\\\\begin{align}" env)
                            (prog2
                                (incf counter)
                                (cons begin counter)
                              (with-temp-buffer
                                (insert env)
                                (goto-char (point-min))
                                ;; \\ is used for a new line. Each one leads to a number
                                (incf counter (count-matches "\\\\$"))
                                ;; unless there are nonumbers.
                                (goto-char (point-min))
                                (decf counter (count-matches "\\nonumber")))))
                           (t
                            (cons begin nil)))))

      (when (setq numberp (cdr (assoc (point) results)))
        (setf (car args)
              (concat
               (format "\\setcounter{equation}{%s}\n" numberp)
               (car args)))))

    (apply orig-func args))


  (defun scimax-toggle-latex-equation-numbering ()
    "Toggle whether LaTeX fragments are numbered."
    (interactive)
    (if (not (get 'scimax-org-renumber-environment 'enabled))
        (progn
          (advice-add 'org-create-formula-image :around #'scimax-org-renumber-environment)
          (put 'scimax-org-renumber-environment 'enabled t)
          (message "Latex numbering enabled"))
      (advice-remove 'org-create-formula-image #'scimax-org-renumber-environment)
      (put 'scimax-org-renumber-environment 'enabled nil)
      (message "Latex numbering disabled.")))

  (advice-add 'org-create-formula-image :around #'scimax-org-renumber-environment)
  (put 'scimax-org-renumber-environment 'enabled t))
;; Stolen from [[https://github.com/jkitchin/scimax][scimax]] (semi-working right now):2 ends here

;; [[file:~/.config/doom/config.org::*Exporting (general)][Exporting (general):1]]
(after! org (setq org-export-headline-levels 5)) ; I like nesting
;; Exporting (general):1 ends here

;; [[file:~/.config/doom/config.org::*Exporting (general)][Exporting (general):2]]
(after! org
  (require 'ox-extra)
  (ox-extras-activate '(ignore-headlines)))
;; Exporting (general):2 ends here

;; [[file:~/.config/doom/config.org::*Custom CSS/JS][Custom CSS/JS:2]]
(after! org
(defun my-org-inline-css-hook (exporter)
  "Insert custom inline css to automatically set the
   background of code to whatever theme I'm using's background"
  (when (eq exporter 'html)
    (setq
     org-html-head-extra
     (concat
      (if (s-contains-p "<!––tec/custom-head-start-->" org-html-head-extra)
          (s-replace-regexp "<!––tec\\/custom-head-start-->[^🙜]*<!––tec\\/custom-head-end-->" "" org-html-head-extra)
        org-html-head-extra)
      "<!––tec/custom-head-start-->"
      (format "<style type=\"text/css\">
   :root {
      --theme-bg: %s;
      --theme-bg-alt: %s;
      --theme-base0: %s;
      --theme-base1: %s;
      --theme-base2: %s;
      --theme-base3: %s;
      --theme-base4: %s;
      --theme-base5: %s;
      --theme-base6: %s;
      --theme-base7: %s;
      --theme-base8: %s;
      --theme-fg: %s;
      --theme-fg-alt: %s;
      --theme-grey: %s;
      --theme-red: %s;
      --theme-orange: %s;
      --theme-green: %s;
      --theme-teal: %s;
      --theme-yellow: %s;
      --theme-blue: %s;
      --theme-dark-blue: %s;
      --theme-magenta: %s;
      --theme-violet: %s;
      --theme-cyan: %s;
      --theme-dark-cyan: %s;
   }
</style>"
              (doom-color 'bg)
              (doom-color 'bg-alt)
              (doom-color 'base0)
              (doom-color 'base1)
              (doom-color 'base2)
              (doom-color 'base3)
              (doom-color 'base4)
              (doom-color 'base5)
              (doom-color 'base6)
              (doom-color 'base7)
              (doom-color 'base8)
              (doom-color 'fg)
              (doom-color 'fg-alt)
              (doom-color 'grey)
              (doom-color 'red)
              (doom-color 'orange)
              (doom-color 'green)
              (doom-color 'teal)
              (doom-color 'yellow)
              (doom-color 'blue)
              (doom-color 'dark-blue)
              (doom-color 'magenta)
              (doom-color 'violet)
              (doom-color 'cyan)
              (doom-color 'dark-cyan))
      (if org-msg-currently-exporting ""
      "
<link rel='stylesheet' type='text/css' href='https://fniessen.github.io/org-html-themes/styles/readtheorg/css/htmlize.css'/>
<link rel='stylesheet' type='text/css' href='https://fniessen.github.io/org-html-themes/styles/readtheorg/css/readtheorg.css'/>

<script src='https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js'></script>
<script src='https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/js/bootstrap.min.js'></script>
<script type='text/javascript' src='https://fniessen.github.io/org-html-themes/styles/lib/js/jquery.stickytableheaders.min.js'></script>
<script type='text/javascript' src='https://fniessen.github.io/org-html-themes/styles/readtheorg/js/readtheorg.js'></script>

<style>
 pre.src {
     background-color: var(--theme-bg);
     color: var(--theme-fg);
     scrollbar-color:#bbb6#9992;
     scrollbar-width: thin;
     margin: 0;
     border: none;
 }
 div.org-src-container {
     border-radius: 12px;
     overflow: hidden;
     margin-bottom: 24px;
     margin-top: 1px;
     border: 1px solid#e1e4e5;
 }
 pre.src::before {
     background-color:#6666;
     top: 8px;
     border: none;
     border-radius: 5px;
     line-height: 1;
     border: 2px solid var(--theme-bg);
     opacity: 0;
     transition: opacity 200ms;
 }
 pre.src:hover::before { opacity: 1; }
 pre.src:active::before { opacity: 0; }

 pre.example {
     border-radius: 12px;
     background: var(--theme-bg-alt);
     color: var(--theme-fg);
 }

 code {
     border-radius: 5px;
     background:#e8e8e8;
     font-size: 80%;
 }

 kbd {
     display: inline-block;
     padding: 3px 5px;
     font: 80% SFMono-Regular,Consolas,Liberation Mono,Menlo,monospace;
     line-height: normal;
     line-height: 10px;
     color:#444d56;
     vertical-align: middle;
     background-color:#fafbfc;
     border: 1px solid#d1d5da;
     border-radius: 3px;
     box-shadow: inset 0 -1px 0#d1d5da;
 }

 table {
     max-width: 100%;
     overflow-x: auto;
     display: block;
     border-top: none;
 }

 a:not([aria-hidden='true']) {
     text-decoration: none;
     background-image: linear-gradient(#d8dce9, #d8dce9);
     background-position: 0% 100%;
     background-repeat: no-repeat;
     background-size: 0% 2px;
     transition: background-size .3s;
 }
 \#table-of-contents a {
     background-image: none;
 }
 a:hover:not([aria-hidden='true']),
 a:focus:not([aria-hidden='true']) {
     background-size: 100% 2px;
 }
 a[href^='#'] { font-variant-numeric: oldstyle-nums; }
 a[href^='#']:visited { color:#3091d1; }

 li .checkbox {
     display: inline-block;
     width: 0.9em;
     height: 0.9em;
     border-radius: 3px;
     margin: 3px;
     top: 4px;
     position: relative;
 }
 li.on > .checkbox { background: var(--theme-green); box-shadow: 0 0 2px var(--theme-green); }
 li.trans > .checkbox { background: var(--theme-orange); box-shadow: 0 0 2px var(--theme-orange); }
 li.off > .checkbox { background: var(--theme-red); box-shadow: 0 0 2px var(--theme-red); }
 li.on > .checkbox::after {
     content: '';
     height: 0.45em;
     width: 0.225em;
     -webkit-transform-origin: left top;
     transform-origin: left top;
     transform: scaleX(-1) rotate(135deg);
     border-right: 2.8px solid#fff;
     border-top: 2.8px solid#fff;
     opacity: 0.9;
     left: 0.10em;
     top: 0.45em;
     position: absolute;
 }
 li.trans > .checkbox::after {
     content: '';
     font-weight: bold;
     font-size: 1.6em;
     position: absolute;
     top: 0.23em;
     left: 0.09em;
     width: 0.35em;
     height: 0.12em;
     background:#fff;
     opacity: 0.9;
     border-radius: 0.1em;
 }
 li.off > .checkbox::after {
     content: '✖';
     color:#fff;
     opacity: 0.9;
     position: relative;
     top: -0.40rem;
     left: 0.17em;
     font-size: 0.75em;
 }

 span.timestamp {
     color: #003280;
     background: #647CFF44;
     border-radius: 3px;
     line-height: 1.25;
 }

 \#content img {
     border-radius: 3px;
 }

 \#table-of-contents { overflow-y: auto; }
 blockquote p { margin: 8px 0px 16px 0px; }
 \#postamble .date { color: var(--theme-green); }

 ::-webkit-scrollbar { width: 10px; height: 8px; }
 ::-webkit-scrollbar-track { background:#9992; }
 ::-webkit-scrollbar-thumb { background:#ccc; border-radius: 10px; }
 ::-webkit-scrollbar-thumb:hover { background:#888; }

 /* sometimes this all-important space seems to go missing
 /so let's protect against that. If it's exteranious it's
 /just gobbled anyway. */
 span.section-number-1:after,
 span.section-number-2:after,
 span.section-number-3:after,
 span.section-number-4:after,
 span.section-number-5:after,
 span.section-number-6:after {
     content: ' '
 }

 /* so the bounding box coveres the <a> */
 h1,h2,h3,h4,h5,h6 {
     padding-left: 30px;
     margin-left: -30px;
 }

 h1 > a[aria-hidden='true'],
 h2 > a[aria-hidden='true'],
 h3 > a[aria-hidden='true'],
 h4 > a[aria-hidden='true'],
 h5 > a[aria-hidden='true'],
 h6 > a[aria-hidden='true'] {
     color: #6a737d;
     float: left;
     padding-right: 4px;
     margin-left: -25px;
     position: relative;
     top: 7px;
     line-height: 1;
     font-size: 70%;
     visibility: hidden;
 }

 h1:hover > a[aria-hidden='true'],
 h2:hover > a[aria-hidden='true'],
 h3:hover > a[aria-hidden='true'],
 h4:hover > a[aria-hidden='true'],
 h5:hover > a[aria-hidden='true'],
 h6:hover > a[aria-hidden='true'] {
     visibility: visible;
 }
</style>
")
      "<!––tec/custom-head-end-->"
      ))))

(add-hook 'org-export-before-processing-hook 'my-org-inline-css-hook))
;; Custom CSS/JS:2 ends here

;; [[file:~/.config/doom/config.org::*Make verbatim different to code][Make verbatim different to code:1]]
(setq org-html-text-markup-alist
      '((bold . "<b>%s</b>")
        (code . "<code>%s</code>")
        (italic . "<i>%s</i>")
        (strike-through . "<del>%s</del>")
        (underline . "<span class=\"underline\">%s</span>")
        (verbatim . "<kbd>%s</kbd>")))
;; Make verbatim different to code:1 ends here

;; [[file:~/.config/doom/config.org::*Change checkbox type][Change checkbox type:1]]
(after! org
(appendq! org-html-checkbox-types '((html-span .
	  ((on . "<span class='checkbox'></span>")
	  (off . "<span class='checkbox'></span>")
	  (trans . "<span class='checkbox'></span>")))))
(setq org-html-checkbox-type 'html-span))
;; Change checkbox type:1 ends here

;; [[file:~/.config/doom/config.org::*Header anchors][Header anchors:1]]
(after! org
  (defun tec/org-export-html-headline-anchor (text backend info)
    (when (org-export-derived-backend-p backend 'html)
      (unless org-msg-currently-exporting
        (replace-regexp-in-string
         "<h\\([0-9]\\) id=\"\\([a-z0-9-]+\\)\">" ; this is quite restrictive, but due to `org-heading-contraction' I can do this
         "<h\\1 id=\"\\2\">\
 <a class=\"anchor\" aria-hidden=\"true\" href=\"#\\2\">🔗</a>"
         text))))

  (add-to-list 'org-export-filter-headline-functions
               'tec/org-export-html-headline-anchor))
;; Header anchors:1 ends here

;; [[file:~/.config/doom/config.org::*LaTeX Rendering][LaTeX Rendering:1]]
(after! org
(defadvice! org-html-latex-fragment-scaled (latex-fragment _contents info)
  "Transcode a LATEX-FRAGMENT object from Org to HTML.
CONTENTS is nil.  INFO is a plist holding contextual information."
  :override #'org-html-latex-fragment
  (let ((latex-frag (org-element-property :value latex-fragment))
        (processing-type (plist-get info :with-latex))
        (attrs '(:class "latex-fragment")))
    (when (eq processing-type 'dvipng)
      (plist-put attrs :style (format "transform: scale(%.3f)" (/ 1.0 preview-scale))))
    (cond
     ((memq processing-type '(t mathjax))
      (org-html-format-latex latex-frag 'mathjax info))
     ((memq processing-type '(t html))
      (org-html-format-latex latex-frag 'html info))
     ((assq processing-type org-preview-latex-process-alist)
      (let ((formula-link
             (org-html-format-latex latex-frag processing-type info)))
        (when (and formula-link (string-match "file:\\([^]]*\\)" formula-link))
          (let ((source (org-export-file-uri (match-string 1 formula-link))))
            (org-html--format-image source attrs info)))))
     (t latex-frag))))

(defadvice! org-html-latex-environment-scaled (latex-environment _contents info)
  "Transcode a LATEX-ENVIRONMENT element from Org to HTML.
CONTENTS is nil.  INFO is a plist holding contextual information."
  :override #'org-html-latex-environment
  (let ((processing-type (plist-get info :with-latex))
        (latex-frag (org-remove-indentation
                     (org-element-property :value latex-environment)))
        (attributes (org-export-read-attribute :attr_html latex-environment))
        (label (and (org-element-property :name latex-environment)
                    (org-export-get-reference latex-environment info)))
        (caption (and (org-html--latex-environment-numbered-p latex-environment)
                      (number-to-string
                       (org-export-get-ordinal
                        latex-environment info nil
                        (lambda (l _)
                          (and (org-html--math-environment-p l)
                               (org-html--latex-environment-numbered-p l))))))))
    (plist-put attributes :class "latex-environment")
    (when (eq processing-type 'dvipng)
      (plist-put attributes :style (format "transform: scale(%.3f)" (/ 1.0 preview-scale))))
    (cond
     ((memq processing-type '(t mathjax))
      (org-html-format-latex
       (if (org-string-nw-p label)
	   (replace-regexp-in-string "\\`.*"
				     (format "\\&\n\\\\label{%s}" label)
				     latex-frag)
	 latex-frag)
       'mathjax info))
     ((assq processing-type org-preview-latex-process-alist)
      (let ((formula-link
             (org-html-format-latex
              (org-html--unlabel-latex-environment latex-frag)
              processing-type info)))
        (when (and formula-link (string-match "file:\\([^]]*\\)" formula-link))
          (let ((source (org-export-file-uri (match-string 1 formula-link))))
	    (org-html--wrap-latex-environment
	     (org-html--format-image source attributes info)
	     info caption label)))))
     (t (org-html--wrap-latex-environment latex-frag info caption label))))))
;; LaTeX Rendering:1 ends here

;; [[file:~/.config/doom/config.org::*LaTeX Rendering][LaTeX Rendering:2]]
;; (setq-default org-html-with-latex `dvisvgm)
;; LaTeX Rendering:2 ends here

;; [[file:~/.config/doom/config.org::*Exporting to LaTeX][Exporting to LaTeX:1]]
;; TODO make this /only/ apply to text (i.e. not URL)
(after! org
  (defun tec/org-export-latex-filter-acronym (text backend info)
    (when (org-export-derived-backend-p backend 'latex)
      (let ((case-fold-search nil))
        (replace-regexp-in-string
         "[;\\\\]?\\b[A-Z][A-Z]+s?"
         (lambda (all-caps-str)
           ; only \acr if str doesn't start with ";" or "\" (for LaTeX commands)
           (cond ((equal (aref all-caps-str 0) ?\;) (substring all-caps-str 1))
                 ((equal (aref all-caps-str 0) ?\\) all-caps-str)
                 ((equal (aref all-caps-str (- (length all-caps-str) 1)) ?s)
                  (concat "\\textls*[70]{\\textsc{"
                            (s-downcase (substring all-caps-str 0 -1))
                            "}\\protect\\scalebox{.91}[.84]{s}}"))
                 (t (concat "\\textls*[70]{\\textsc{"
                              (s-downcase all-caps-str) "}}"))))
         text t t))))

  (add-to-list 'org-export-filter-plain-text-functions
               'tec/org-export-latex-filter-acronym)
  (add-to-list 'org-export-filter-headline-functions
               'tec/org-export-latex-filter-acronym))
;; Exporting to LaTeX:1 ends here

;; [[file:~/.config/doom/config.org::*Exporting to LaTeX][Exporting to LaTeX:2]]
(after! org
  (defun tec/org-export-latex-fancy-item-checkboxes (text backend info)
    (when (org-export-derived-backend-p backend 'latex)
      (replace-regexp-in-string
       "\\\\item\\[{$\\\\\\(\\w+\\)$}\\]"
       (lambda (fullmatch)
         (concat "\\\\item[" (pcase (substring fullmatch 9 -3) ; content of capture group
                               ("square"   "\\\\ifdefined\\\\checkboxUnchecked\\\\checkboxUnchecked\\\\else$\\\\square$\\\\fi"    )
                               ("boxminus" "\\\\ifdefined\\\\checkboxTransitive\\\\checkboxTransitive\\\\else$\\\\boxminus$\\\\fi")
                               ("boxtimes" "\\\\ifdefined\\\\checkboxChecked\\\\checkboxChecked\\\\else$\\\\boxtimes$\\\\fi"      )
                               (_ (substring fullmatch 9 -3))) "]"))
       text)))

  (add-to-list 'org-export-filter-item-functions
               'tec/org-export-latex-fancy-item-checkboxes))
;; Exporting to LaTeX:2 ends here

;; [[file:~/.config/doom/config.org::*Exporting to LaTeX][Exporting to LaTeX:3]]
(after! ox-latex
  (add-to-list 'org-latex-classes
               '("fancy-article"
                 "\\documentclass{scrartcl}\n\
\\usepackage[T1]{fontenc}\n\
\\usepackage[osf,largesc,helvratio=0.9]{newpxtext}\n\
\\usepackage[scale=0.92]{sourcecodepro}\n\
\\usepackage[varbb]{newpxmath}\n\

\\usepackage[activate={true,nocompatibility},final,tracking=true,kerning=true,spacing=true,factor=2000]{microtype}\n\
\\usepackage{xcolor}\n\
\\usepackage{booktabs}

\\usepackage{subcaption}
\\usepackage[hypcap=true]{caption}
\\setkomafont{caption}{\\sffamily\\small}
\\setkomafont{captionlabel}{\\upshape\\bfseries}
\\captionsetup{justification=raggedright,singlelinecheck=true}
\\setcapindent{0pt}

\\setlength{\\parskip}{\\baselineskip}\n\
\\setlength{\\parindent}{0pt}\n\

\\usepackage{pifont}
\\newcommand{\\checkboxUnchecked}{$\\square$}
\\newcommand{\\checkboxTransitive}{\\rlap{\\raisebox{0.0ex}{\\hspace{0.35ex}\\Large\\textbf -}}$\\square$}
\\newcommand{\\checkboxChecked}{\\rlap{\\raisebox{0.2ex}{\\hspace{0.35ex}\\scriptsize \\ding{56}}}$\\square$}
"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
  (add-to-list 'org-latex-classes
               '("blank"
               "[NO-DEFAULT-PACKAGES]
               [NO-PACKAGES]
               [EXTRA]"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
  (add-to-list 'org-latex-classes
               '("bmc-article"
               "\\documentclass[article,code,maths]{bmc}
               [NO-DEFAULT-PACKAGES]
               [NO-PACKAGES]
               [EXTRA]"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
  (add-to-list 'org-latex-classes
               '("bmc"
               "\\documentclass[code,maths]{bmc}
               [NO-DEFAULT-PACKAGES]
               [NO-PACKAGES]
               [EXTRA]"
               ("\\chapter{%s}" . "\\chapter*{%s}")
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
  (setq org-latex-default-class "fancy-article")

  (add-to-list 'org-latex-packages-alist '("" "minted"))
  (setq org-latex-listings 'minted
        org-latex-minted-options
        '(("frame" "lines")
          ("fontsize" "\\scriptsize")
          ("linenos" "")
          ("breakanywhere" "true")
          ("breakautoindent" "true")
          ("breaklines" "true")
          ("autogobble" "true")
          ("obeytabs" "true")
          ("python3" "true")
          ("breakbefore" "\\\\\\.+")
          ("breakafter" "\\,")
          ("style" "autumn")
          ("breaksymbol" "\\tiny\\ensuremath{\\hookrightarrow}")
          ("breakanywheresymbolpre" "\\,\\footnotesize\\ensuremath{{}_{\\rfloor}}")
          ("breakbeforesymbolpre" "\\,\\footnotesize\\ensuremath{{}_{\\rfloor}}")
          ("breakaftersymbolpre" "\\,\\footnotesize\\ensuremath{{}_{\\rfloor}}")))
  (setq org-latex-tables-booktabs t)

  (setq org-latex-hyperref-template "
\\colorlet{greenyblue}{blue!70!green}
\\colorlet{blueygreen}{blue!40!green}
\\providecolor{link}{named}{greenyblue}
\\providecolor{cite}{named}{blueygreen}
\\hypersetup{
  pdfauthor={%a},
  pdftitle={%t},
  pdfkeywords={%k},
  pdfsubject={%d},
  pdfcreator={%c},
  pdflang={%L},
  breaklinks=true,
  colorlinks=true,
  linkcolor=,
  urlcolor=link,
  citecolor=cite\n}
\\urlstyle{same}\n")
  (setq org-latex-pdf-process
        '("latexmk -shell-escape -interaction=nonstopmode -f -pdf -output-directory=%o %f")))
;; Exporting to LaTeX:3 ends here

;; [[file:~/.config/doom/config.org::*Chameleon --- aka. match theme][Chameleon --- aka. match theme:1]]
(after! ox
  (defvar ox-chameleon-base-class "fancy-article"
    "The base class that chameleon builds on")

  (defvar ox-chameleon--p nil
    "Used to indicate whether the current export is trying to blend in. Set just before being accessed.")

  ;; (setf (alist-get :filter-latex-class
  ;;                  (org-export-backend-filters
  ;;                   (org-export-get-backend 'latex)))
  ;;       'ox-chameleon-latex-class-detector-filter)

  ;; (defun ox-chameleon-latex-class-detector-filter (info backend)
  ;;   ""
  ;;   (setq ox-chameleon--p (when (equal (plist-get info :latex-class)
  ;;                                      "chameleon")
  ;;                           (plist-put info :latex-class ox-chameleon-base-class)
  ;;                           t)))

  ;; TODO make this less hacky. One ideas was as follows
  ;; (map-put (org-export-backend-filters (org-export-get-backend 'latex))
  ;;           :filter-latex-class 'ox-chameleon-latex-class-detector-filter))
  ;; Never seemed to execute though
  (defadvice! ox-chameleon-org-latex-detect (orig-fun info)
    :around #'org-export-install-filters
    (setq ox-chameleon--p (when (equal (plist-get info :latex-class)
                                       "chameleon")
                            (plist-put info :latex-class ox-chameleon-base-class)
                            t))
    (funcall orig-fun info))

  (defadvice! ox-chameleon-org-latex-export (orig-fn info &optional template snippet?)
    :around #'org-latex-make-preamble
    (funcall orig-fn info)
    (if (not ox-chameleon--p)
        (funcall orig-fn info template snippet?)
      (concat (funcall orig-fn info template snippet?)
              (ox-chameleon-generate-colourings))))

  (defun ox-chameleon-generate-colourings ()
    (apply #'format
           "%% make document follow Emacs theme
\\definecolor{bg}{HTML}{%s}
\\definecolor{fg}{HTML}{%s}

\\definecolor{red}{HTML}{%s}
\\definecolor{orange}{HTML}{%s}
\\definecolor{green}{HTML}{%s}
\\definecolor{teal}{HTML}{%s}
\\definecolor{yellow}{HTML}{%s}
\\definecolor{blue}{HTML}{%s}
\\definecolor{dark-blue}{HTML}{%s}
\\definecolor{magenta}{HTML}{%s}
\\definecolor{violet}{HTML}{%s}
\\definecolor{cyan}{HTML}{%s}
\\definecolor{dark-cyan}{HTML}{%s}

\\definecolor{level1}{HTML}{%s}
\\definecolor{level2}{HTML}{%s}
\\definecolor{level3}{HTML}{%s}
\\definecolor{level4}{HTML}{%s}
\\definecolor{level5}{HTML}{%s}
\\definecolor{level6}{HTML}{%s}
\\definecolor{level7}{HTML}{%s}
\\definecolor{level8}{HTML}{%s}

\\definecolor{link}{HTML}{%s}
\\definecolor{cite}{HTML}{%s}
\\definecolor{itemlabel}{HTML}{%s}
\\definecolor{code}{HTML}{%s}
\\definecolor{verbatim}{HTML}{%s}

\\pagecolor{bg}
\\color{fg}

\\addtokomafont{section}{\\color{level1}}
\\newkomafont{sectionprefix}{\\color{level1}}
\\addtokomafont{subsection}{\\color{level2}}
\\newkomafont{subsectionprefix}{\\color{level2}}
\\addtokomafont{subsubsection}{\\color{level3}}
\\newkomafont{subsubsectionprefix}{\\color{level3}}
\\addtokomafont{paragraph}{\\color{level4}}
\\newkomafont{paragraphprefix}{\\color{level4}}
\\addtokomafont{subparagraph}{\\color{level5}}
\\newkomafont{subparagraphprefix}{\\color{level5}}

\\renewcommand{\\labelitemi}{\\textcolor{itemlabel}{\\textbullet}}
\\renewcommand{\\labelitemii}{\\textcolor{itemlabel}{\\normalfont\\bfseries \\textendash}}
\\renewcommand{\\labelitemiii}{\\textcolor{itemlabel}{\\textasteriskcentered}}
\\renewcommand{\\labelitemiv}{\\textcolor{itemlabel}{\\textperiodcentered}}

\\renewcommand{\\labelenumi}{\\textcolor{itemlabel}{\\theenumi.}}
\\renewcommand{\\labelenumii}{\\textcolor{itemlabel}{(\\theenumii)}}
\\renewcommand{\\labelenumiii}{\\textcolor{itemlabel}{\\theenumiii.}}
\\renewcommand{\\labelenumiv}{\\textcolor{itemlabel}{\\theenumiv.}}

\\DeclareTextFontCommand{\\texttt}{\\color{code}\\ttfamily}
\\makeatletter
\\def\\verbatim@font{\\color{verbatim}\\normalfont\\ttfamily}
\\makeatother
%% end customisations
"
           (mapcar (doom-rpartial #'substring 1)
                   (list
                    (face-attribute 'solaire-default-face :background)
                    (face-attribute 'default :foreground)
                    ;;
                    (doom-color 'red)
                    (doom-color 'orange)
                    (doom-color 'green)
                    (doom-color 'teal)
                    (doom-color 'yellow)
                    (doom-color 'blue)
                    (doom-color 'dark-blue)
                    (doom-color 'magenta)
                    (doom-color 'violet)
                    (doom-color 'cyan)
                    (doom-color 'dark-cyan)
                    ;;
                    (face-attribute 'outline-1 :foreground)
                    (face-attribute 'outline-2 :foreground)
                    (face-attribute 'outline-3 :foreground)
                    (face-attribute 'outline-4 :foreground)
                    (face-attribute 'outline-5 :foreground)
                    (face-attribute 'outline-6 :foreground)
                    (face-attribute 'outline-7 :foreground)
                    (face-attribute 'outline-8 :foreground)
                    ;;
                    (face-attribute 'link :foreground)
                    (or (face-attribute 'org-ref-cite-face :foreground) (doom-color 'yellow))
                    (face-attribute 'org-list-dt :foreground)
                    (face-attribute 'org-code :foreground)
                    (face-attribute 'org-verbatim :foreground)
                    ))))
  )
;; Chameleon --- aka. match theme:1 ends here

;; [[file:~/.config/doom/config.org::*Make verbatim different to code][Make verbatim different to code:1]]
(setq org-latex-text-markup-alist '((bold . "\\textbf{%s}")
           (code . protectedtexttt)
           (italic . "\\emph{%s}")
           (strike-through . "\\sout{%s}")
           (underline . "\\uline{%s}")
           (verbatim . verb)))
;; Make verbatim different to code:1 ends here

;; [[file:~/.config/doom/config.org::*Exporting to Beamer][Exporting to Beamer:1]]
(setq org-beamer-theme "[progressbar=foot]metropolis")
;; Exporting to Beamer:1 ends here

;; [[file:~/.config/doom/config.org::*Exporting to Beamer][Exporting to Beamer:2]]

;; Exporting to Beamer:2 ends here

;; [[file:~/.config/doom/config.org::*Exporting to Beamer][Exporting to Beamer:3]]
(setq org-beamer-frame-level 2)
;; Exporting to Beamer:3 ends here

;; [[file:~/.config/doom/config.org::*Exporting to GFM][Exporting to GFM:1]]
(eval-after-load "org"
  '(require 'ox-gfm nil t))
;; Exporting to GFM:1 ends here

;; [[file:~/.config/doom/config.org::*Babel][Babel:1]]
(setq org-babel-python-command "python3")
;; Babel:1 ends here

;; [[file:~/.config/doom/config.org::*Babel][Babel:2]]
(defun tec-org-python ()
  (if (eq major-mode 'python-mode)
   (progn (anaconda-mode t)
          (company-mode t)))
  )
(add-hook 'org-src-mode-hook 'tec-org-python)
;; Babel:2 ends here

;; [[file:~/.config/doom/config.org::*ESS][ESS:1]]
(setq ess-eval-visibly 'nowait)
;; ESS:1 ends here

;; [[file:~/.config/doom/config.org::*ESS][ESS:2]]
(setq ess-R-font-lock-keywords '((ess-R-fl-keyword:keywords . t)
 (ess-R-fl-keyword:constants . t)
 (ess-R-fl-keyword:modifiers . t)
 (ess-R-fl-keyword:fun-defs . t)
 (ess-R-fl-keyword:assign-ops . t)
 (ess-R-fl-keyword:%op% . t)
 (ess-fl-keyword:fun-calls . t)
 (ess-fl-keyword:numbers . t)
 (ess-fl-keyword:operators . t)
 (ess-fl-keyword:delimiters . t)
 (ess-fl-keyword:= . t)
 (ess-R-fl-keyword:F&T . t)))
;; ESS:2 ends here

;; [[file:~/.config/doom/config.org::*Compilation][Compilation:1]]
(setq TeX-save-query nil
      TeX-show-compilation t
      TeX-command-extra-options "-shell-escape")
(after! latex
  (add-to-list 'TeX-command-list '("XeLaTeX" "%`xelatex%(mode)%' %t" TeX-run-TeX nil t)))
;; Compilation:1 ends here

;; [[file:~/.config/doom/config.org::*Compilation][Compilation:2]]
(setq +latex-viewers '(pdf-tools evince zathura okular skim sumatrapdf))
;; Compilation:2 ends here

;; [[file:~/.config/doom/config.org::*Template][Template:2]]
(setq tec/yas-latex-template-preamble "
\\usepackage[pdfa,unicode=true,hidelinks]{hyperref}

\\usepackage[dvipsnames,svgnames,table,hyperref]{xcolor}
\\renewcommand{\\UrlFont}{\\ttfamily\\small}

\\usepackage[a-2b]{pdfx} % why not be archival

\\usepackage[T1]{fontenc}
\\usepackage[osf,helvratio=0.9]{newpxtext} % pallatino
\\usepackage[scale=0.92]{sourcecodepro}

\\usepackage[varbb]{newpxmath}
\\usepackage{mathtools}
\\usepackage{amssymb}

\\usepackage[activate={true,nocompatibility},final,tracking=true,kerning=true,spacing=true,factor=2000]{microtype}
% microtype makes text look nicer

\\usepackage{graphicx} % include graphics
\\usepackage{grffile} % fix allowed graphicx filenames

\\usepackage{booktabs} % nice table rules
")

(defun tec/yas-latex-get-class-choice ()
  "Prompt user for LaTeX class choice"
  (setq tec/yas-latex-class-choice (ivy-read "Select document class: " '("article" "scrartcl" "bmc") :def "bmc")))

(defun tec/yas-latex-preamble-if ()
  "Based on class choice prompt for insertion of default preamble"
    (if (equal tec/yas-latex-class-choice "bmc") 'nil
             (eq (read-char-choice "Include default preamble? [Type y/n]" '(?y ?n)) ?y)))
;; Template:2 ends here

;; [[file:~/.config/doom/config.org::*Deliminators][Deliminators:1]]
(after! tex
  (defvar tec/tex-last-delim-char nil
    "Last open delim expanded in a tex document")
  (defvar tec/tex-delim-dot-second t
    "When the `tec/tex-last-delim-char' is . a second charachter (this) is prompted for")
  (defun tec/get-open-delim-char ()
    "Exclusivly read next char to tec/tex-last-delim-char"
    (setq tec/tex-delim-dot-second nil)
    (setq tec/tex-last-delim-char (read-char-exclusive "Opening deliminator, recognises: 9 ( [ { < | ."))
    (when (eql ?. tec/tex-last-delim-char)
      (setq tec/tex-delim-dot-second (read-char-exclusive "Other deliminator, recognises: 0 9 (  ) [ ] { } < > |"))))
  (defun tec/tex-open-delim-from-char (&optional open-char)
    "Find the associated opening delim as string"
    (unless open-char (setq open-char (if (eql ?. tec/tex-last-delim-char)
                                          tec/tex-delim-dot-second
                                        tec/tex-last-delim-char)))
    (case open-char
      (?\( "(")
      (?9  "(")
      (?\[ "[")
      (?\{ "\\{")
      (?<  "<")
      (?|  (if tec/tex-delim-dot-second "." "|"))
      (t   ".")))
  (defun tec/tex-close-delim-from-char (&optional open-char)
    "Find the associated closing delim as string"
    (if tec/tex-delim-dot-second
        (case tec/tex-delim-dot-second
          (?\) ")")
          (?0  ")")
          (?\] "]")
          (?\} "\\}")
          (?\> ">")
          (?|  "|")
          (t   "."))
      (case (or open-char tec/tex-last-delim-char)
        (?\( ")")
        (?9  ")")
        (?\[ "]")
        (?\{ "\\}")
        (?<  ")")
        (?\) ")")
        (?0  ")")
        (?\] "]")
        (?\} "\\}")
        (?\> ">")
        (?|  "|")
        (t   "."))))
  (defun tec/tex-next-char-smart-close-delim (&optional open-char)
    (and (bound-and-true-p smartparens-mode)
         (eql (char-after) (case (or open-char tec/tex-last-delim-char)
                             (?\( ?\))
                             (?\[ ?\])
                             (?{ ?})
                             (?< ?>)))))
  (defun tec/tex-delim-yas-expand (&optional open-char)
    (yas-expand-snippet (yas-lookup-snippet "_deliminators" 'latex-mode) (point) (+ (point) (if (tec/tex-next-char-smart-close-delim open-char) 2 1)))))
;; Deliminators:1 ends here

;; [[file:~/.config/doom/config.org::*Editor visuals][Editor visuals:1]]
(add-hook 'LaTeX-mode-hook #'mixed-pitch-mode)
;; Editor visuals:1 ends here

;; [[file:~/.config/doom/config.org::*Editor visuals][Editor visuals:2]]
(after! latex
  (setcar (assoc "⋆" LaTeX-fold-math-spec-list) "★")) ;; make \star bigger

(setq TeX-fold-math-spec-list
      `(;; missing/better symbols
        ("≤" ("le"))
        ("≥" ("ge"))
        ("≠" ("ne"))
        ;; conviniance shorts -- these don't work nicely ATM
        ;; ("‹" ("left"))
        ;; ("›" ("right"))
        ;; private macros
        ("ℝ" ("RR"))
        ("ℕ" ("NN"))
        ("ℤ" ("ZZ"))
        ("ℚ" ("QQ"))
        ("ℂ" ("CC"))
        ("ℙ" ("PP"))
        ("ℍ" ("HH"))
        ("𝔼" ("EE"))
        ("𝑑" ("dd"))
        ;; known commands
        ("" ("phantom"))
        (,(lambda (num den) (if (and (TeX-string-single-token-p num) (TeX-string-single-token-p den))
                           (concat num "／" den)
                         (concat "❪" num "／" den "❫"))) ("frac"))
        (,(lambda (arg) (concat "√" (TeX-fold-parenthesize-as-neccesary arg))) ("sqrt"))
        (,(lambda (arg) (concat "⭡" (TeX-fold-parenthesize-as-neccesary arg))) ("vec"))
        ("‘{1}’" ("text"))
        ;; private commands
        ("|{1}|" ("abs"))
        ("‖{1}‖" ("norm"))
        ("⌊{1}⌋" ("floor"))
        ("⌈{1}⌉" ("ceil"))
        ("⌊{1}⌉" ("round"))
        ("𝑑{1}/𝑑{2}" ("dv"))
        ("∂{1}/∂{2}" ("pdv"))
        ;; fancification
        ("{1}" ("mathrm"))
        (,(lambda (word) (string-offset-roman-chars 119743 word)) ("mathbf"))
        (,(lambda (word) (string-offset-roman-chars 119951 word)) ("mathcal"))
        (,(lambda (word) (string-offset-roman-chars 120003 word)) ("mathfrak"))
        (,(lambda (word) (string-offset-roman-chars 120055 word)) ("mathbb"))
        (,(lambda (word) (string-offset-roman-chars 120159 word)) ("mathsf"))
        (,(lambda (word) (string-offset-roman-chars 120367 word)) ("mathtt"))
        )
      TeX-fold-macro-spec-list
      '(
        ;; as the defaults
        ("[f]" ("footnote" "marginpar"))
        ("[c]" ("cite"))
        ("[l]" ("label"))
        ("[r]" ("ref" "pageref" "eqref"))
        ("[i]" ("index" "glossary"))
        ("..." ("dots"))
        ("{1}" ("emph" "textit" "textsl" "textmd" "textrm" "textsf" "texttt"
            "textbf" "textsc" "textup"))
        ;; tweaked defaults
        ("©" ("copyright"))
        ("®" ("textregistered"))
        ("™"  ("texttrademark"))
        ("[1]:||►" ("item"))
        ("❡❡ {1}" ("part" "part*"))
        ("❡ {1}" ("chapter" "chapter*"))
        ("§ {1}" ("section" "section*"))
        ("§§ {1}" ("subsection" "subsection*"))
        ("§§§ {1}" ("subsubsection" "subsubsection*"))
        ("¶ {1}" ("paragraph" "paragraph*"))
        ("¶¶ {1}" ("subparagraph" "subparagraph*"))
        ;; extra
        ("⬖ {1}" ("begin"))
        ("⬗ {1}" ("end"))
        ))

(defun string-offset-roman-chars (offset word)
  "Shift the codepoint of each charachter in WORD by OFFSET with an extra -6 shift if the letter is lowercase"
    (apply 'string
       (mapcar (lambda (c) (+ (if (>= c 97) (- c 6) c) offset)) word)))

(defun TeX-fold-parenthesize-as-neccesary (tokens &optional suppress-left suppress-right)
  "Add ❪ ❫ parenthesis as if multiple LaTeX tokens appear to be present"
  (if (TeX-string-single-token-p tokens) tokens
    (concat (if suppress-left "" "❪")
            tokens
            (if suppress-right "" "❫"))))

(defun TeX-string-single-token-p (teststring)
  "Return t if TESTSTRING appears to be a single token, nil otherwise"
 (if (string-match-p "^\\\\?\\w+$" teststring) t nil))
;; Editor visuals:2 ends here

;; [[file:~/.config/doom/config.org::*Editor visuals][Editor visuals:3]]
(after! tex
  (map!
   :map LaTeX-mode-map
   :ei [C-return] #'LaTeX-insert-item

   ;; normal stuff here
   :localleader
   :desc "View" "v" #'TeX-view)
  (setq TeX-electric-math '("\\(" . "")))
;; Editor visuals:3 ends here

;; [[file:~/.config/doom/config.org::*Editor visuals][Editor visuals:4]]
;; Making \( \) less visible
(defface unimportant-latex-face
  '((t
     :inherit font-lock-comment-face :family "Overpass" :weight light))
  "Face used to make \\(\\), \\[\\] less visible."
  :group 'LaTeX-math)

(font-lock-add-keywords
 'latex-mode
 `((,(rx (and "\\" (any "()[]"))) 0 'unimportant-latex-face prepend))
 'end)

(font-lock-add-keywords
 'latex-mode
 `((,"\\\\[[:word:]]+" 0 'font-lock-keyword-face prepend))
 'end)
;; Editor visuals:4 ends here

;; [[file:~/.config/doom/config.org::*Editor visuals][Editor visuals:5]]
(setq preview-LaTeX-command '("%`%l \"\\nonstopmode\\nofiles\
\\PassOptionsToPackage{" ("," . preview-required-option-list) "}{preview}\
\\AtBeginDocument{\\ifx\\ifPreview\\undefined"
preview-default-preamble "\\fi}\"%' \"\\detokenize{\" %t \"}\""))
;; Editor visuals:5 ends here

;; [[file:~/.config/doom/config.org::*CDLaTeX][CDLaTeX:1]]
(after! cdlatex
  (setq ;; cdlatex-math-symbol-prefix ?\; ;; doesn't work at the moment :(
   cdlatex-math-symbol-alist
   '( ;; adding missing functions to 3rd level symbols
     (?_    ("\\downarrow"  ""           "\\inf"))
     (?2    ("^2"           "\\sqrt{?}"     ""     ))
     (?3    ("^3"           "\\sqrt[3]{?}"  ""     ))
     (?^    ("\\uparrow"    ""           "\\sup"))
     (?k    ("\\kappa"      ""           "\\ker"))
     (?m    ("\\mu"         ""           "\\lim"))
     (?c    (""             "\\circ"     "\\cos"))
     (?d    ("\\delta"      "\\partial"  "\\dim"))
     (?D    ("\\Delta"      "\\nabla"    "\\deg"))
     ;; no idea why \Phi isnt on 'F' in first place, \phi is on 'f'.
     (?F    ("\\Phi"))
     ;; now just conveniance
     (?.    ("\\cdot" "\\dots"))
     (?:    ("\\vdots" "\\ddots"))
     (?*    ("\\times" "\\star" "\\ast")))
   cdlatex-math-modify-alist
   '( ;; my own stuff
     (?B    "\\mathbb"        nil          t    nil  nil)
     (?a    "\\abs"           nil          t    nil  nil))))
;; CDLaTeX:1 ends here

;; [[file:~/.config/doom/config.org::*CDLaTeX][CDLaTeX:2]]
(defun prvt/auto-number-subscript ()
  (interactive)
  (if (and (or (and (>= (char-before) ?a) (<= (char-before) ?z))
               (and (>= (char-before) ?A) (<= (char-before) ?Z)))
           (cl-digit-char-p (string-to-char (this-command-keys)))
           (texmathp))
      (insert "_" (this-command-keys))
    (insert (this-command-keys))))

(map!
 :after tex :map LaTeX-mode-map
 :i "1" #'prvt/auto-number-subscript
 :i "2" #'prvt/auto-number-subscript
 :i "3" #'prvt/auto-number-subscript
 :i "4" #'prvt/auto-number-subscript
 :i "5" #'prvt/auto-number-subscript
 :i "6" #'prvt/auto-number-subscript
 :i "7" #'prvt/auto-number-subscript
 :i "8" #'prvt/auto-number-subscript
 :i "9" #'prvt/auto-number-subscript)
;; CDLaTeX:2 ends here

;; [[file:~/.config/doom/config.org::*SyncTeX][SyncTeX:1]]
(after! tex
  (add-to-list 'TeX-view-program-list '("Evince" "evince %o"))
  (add-to-list 'TeX-view-program-selection '(output-pdf "Evince")))
;; SyncTeX:1 ends here

;; [[file:~/.config/doom/config.org::*Evilification][Evilification:1]]
(use-package! evil-tex
  :hook (LaTeX-mode . evil-tex-mode))
;; Evilification:1 ends here

;; [[file:~/.config/doom/config.org::*Python][Python:1]]
(after! lsp-python-ms
  (set-lsp-priority! 'mspyls 1))
;; Python:1 ends here

;; [[file:~/.config/doom/config.org::*Editor Visuals][Editor Visuals:1]]
(after! ess-r-mode
  (appendq! +pretty-code-symbols
            '(:assign "⟵"
              :multiply "×"))
  (set-pretty-symbols! 'ess-r-mode
    ;; Functional
    :def "function"
    ;; Types
    :null "NULL"
    :true "TRUE"
    :false "FALSE"
    :int "int"
    :floar "float"
    :bool "bool"
    ;; Flow
    :not "!"
    :and "&&" :or "||"
    :for "for"
    :in "%in%"
    :return "return"
    ;; Other
    :assign "<-"
    :multiply "%*%"))
;; Editor Visuals:1 ends here

;; [[file:~/.config/doom/config.org::*hledger][hledger:1]]
(setq ledger-mode-should-check-version nil
      ledger-report-links-in-register nil
      ledger-binary-path "hledger")
;; hledger:1 ends here

;; [[file:~/.config/doom/config.org::*Markdown][Markdown:1]]
(add-hook! (gfm-mode markdown-mode) #'mixed-pitch-mode)
;; Markdown:1 ends here

;; [[file:~/.config/doom/config.org::*Markdown][Markdown:2]]
(add-hook! (gfm-mode markdown-mode) #'visual-line-mode #'turn-off-auto-fill)
;; Markdown:2 ends here

;; [[file:~/.config/doom/config.org::*Markdown][Markdown:3]]
(custom-set-faces!
  '(markdown-header-face-1 :height 1.25 :weight extra-bold :inherit markdown-header-face)
  '(markdown-header-face-2 :height 1.15 :weight bold       :inherit markdown-header-face)
  '(markdown-header-face-3 :height 1.08 :weight bold       :inherit markdown-header-face)
  '(markdown-header-face-4 :height 1.00 :weight bold       :inherit markdown-header-face)
  '(markdown-header-face-5 :height 0.90 :weight bold       :inherit markdown-header-face)
  '(markdown-header-face-6 :height 0.75 :weight extra-bold :inherit markdown-header-face))
;; Markdown:3 ends here

;; [[file:~/.config/doom/config.org::*Beancount][Beancount:1]]
(use-package! beancount
  :load-path "~/.config/doom/lisp"
  :mode ("\\.beancount\\'" . beancount-mode)
  :config
  (setq beancount-electric-currency t)
  (defun beancount-bal ()
    "Run bean-report bal."
    (interactive)
    (let ((compilation-read-command nil))
      (beancount--run "bean-report"
                      (file-relative-name buffer-file-name) "bal")))
  (map! :map beancount-mode-map
        :n "TAB" #'beancount-align-to-previous-number
        :i "TAB" #'beancount-tab-dwim))
;; Beancount:1 ends here
