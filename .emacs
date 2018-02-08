; -*- mode:lisp; -*-
;; .emacs

;;; uncomment this line to disable loading of "default.el" at startup
;; (setq inhibit-default-init t)

;; turn on font-lock mode
(when (fboundp 'global-font-lock-mode)
  (global-font-lock-mode t))

;;~~~ (set-frame-position (selected-frame) 0 0)  ;; top-left of 1st monitor
;;~~~ (set-frame-position (selected-frame) 1680 0)  ;; top-left of 2nd monitor
;;~~~ (set-frame-size (selected-frame) 476 73)

;; enable visual feedback on selections
;(setq transient-mark-mode t)

;; default to better frame titles
;;;(setq frame-title-format (concat  "%b - emacs@" system-name))
;; dw 05/18/2010 -- file path (%f), buffer status (%+), & buffer name (%b)
;;                  in frame title; two '%+' emulate the mode line
;; dw 10/18/2011 -- added [<user>@<host>] for clarity when using
;;                  Emacs exported over SSH to X-windows display
;; dw 04/06/2012 -- added windowing system detection to also set the
;;                  title when running in console/terminal mode
(if (display-graphic-p)
  (setq frame-title-format
    (list "[" (getenv "USER") "@" system-name "]  " "%f   %+%+   %b"))
  (send-string-to-terminal (concat "\ek" "[" (getenv "USER") "@" system-name "]  Emacs" "\e\\")))

;; dw 03/27/2012 -- no splash screen
(setq inhibit-splash-screen t)
(setq display-time-mode t)
(setq display-time-format "%t%a %B %d %Y %t %H:%M%t%t")
(display-time)

;; dw 02/19/2014 -- Emacs frame position.
;;                  An Emacs frame is a "window" in window manager terminology.
(add-to-list 'default-frame-alist '(left . 0))
(add-to-list 'default-frame-alist '(top . 0))
(add-to-list 'default-frame-alist '(width . 475))
(add-to-list 'default-frame-alist '(height . 73))

;; dw 03/02/2012 -- set frame name to system name in console mode
;;(unless window-system
;;  (set-frame-name (system-name)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-compression-mode t nil (jka-compr))
 '(c-max-one-liner-length 90)
 '(case-fold-search t)
 '(current-language-environment "UTF-8")
 '(default-input-method "rfc1345")
 '(ecb-kill-buffer-clears-history (quote auto))
 '(ecb-layout-name "prophet-2-ecb-layout")
 '(ecb-layout-window-sizes (quote (("prophet-2-ecb-layout" (0.12842105263157894 . 0.6027397260273972) (0.12842105263157894 . 0.3835616438356164)))))
 '(ecb-options-version "2.40")
 '(ecb-primary-secondary-mouse-buttons (quote mouse-1--mouse-2))
 '(ecb-source-path (quote ("~/emacs")))
 '(ecb-tip-of-the-day nil)
 '(ecb-tip-of-the-day-file "")
 '(ecb-tree-buffer-style (quote image))
 '(global-font-lock-mode t nil (font-lock))
 '(safe-local-variable-values (quote ((vvb-column . 90) (longlines-mode-show-newlines . t))))
 '(transient-mark-mode t)
 '(vc-handled-backends (quote (SVN CVS SCCS))))

;; dw 11/26/2008 -- start emacs server if it isn't already running
(setq server-socket-dir "~/emacs/server-socket-dir")
(server-start)

;; dw 03/02/2012 -- Enable mouse support when running in a console
(unless window-system
  (require 'mouse)
  (xterm-mouse-mode t)
  (global-set-key [mouse-4] '(lambda () (interactive) (scroll-down 2)))
  (global-set-key [mouse-5] '(lambda () (interactive) (scroll-up 2)))
  (defun track-mouse (e))
  (setq mouse-sel-mode t)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Customizations
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; dw 03/28/2008 -- get rid of GUI elements
(if (window-system)
  (scroll-bar-mode -1)
  (set-scroll-bar-mode 'right))
(if (fboundp 'tool-bar-mode)
   (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode)
   (menu-bar-mode -1))

;; dw 03/28/2008 -- disable backups & auto-save
(setq backup-inhibited t)
(setq auto-save-default nil)

;; dw 03/27/2008 -- set indentation style
(setq c-default-style "user")

;; dw 03/28/2008 -- display column, in addition to line, in mode line
(setq column-number-mode t)

;; dw 03/31/2008 -- scroll one line at a time
(setq scroll-step 1)
(setq scroll-conservatively 5)  ;; empirically chosen value, don't quite understand

;; dw 01/10/2013 -- disable Emacs splash screen
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)

(setq load-path (cons "~/emacs" load-path))

;; dw 01/11/2013 -- update for newest CEDET from BZR, obtained via
;; bzr checkout bzr://cedet.bzr.sourceforge.net/bzrroot/cedet/code/trunk cedet
(add-to-list 'load-path "~/emacs/cedet-latest/lisp/cedet")

(add-to-list 'load-path "~/emacs/ecb-2.40")

;; dw 05/21/2009 -- add Trac Wiki mode
(add-to-list 'load-path "~/emacs/trac-wiki")

;; dw 12/06/2012 -- add Magit
(add-to-list 'load-path "~/emacs/magit")

;; dw 12/11/2008 -- load cedet/ecb
(require 'cedet)
(require 'ecb)

;; dw 08/16/2010 -- activate ECB
;;                  dummy-up 'stack-trace-on-error' -- some type of mismatch between
;;                  latest Emacs & latest ECB
(setq stack-trace-on-error t)
(ecb-activate)

;; dw 12/02/2011 -- keep the ECB history buffer cleaned up
;; This prevents multiple entries for the same file, one of just the
;; file name and another with the "uniquified" name extension.
(add-hook 'find-file-hooks
  (lambda ()
    (interactive)
    (if (get-buffer ecb-history-buffer-name)
        (ecb-add-all-buffers-to-history))))

;; dw 05/21/2009 -- load Trac Wiki
(require 'trac-wiki)

;; dw 09/18/2009 -- add dot mode, enable on find-file
(add-to-list 'load-path "~/emacs/emacs-dot-mode")
(require 'dot-mode)
(add-hook 'find-file-hooks 'dot-mode-on)

;; dw 12/22/2011 -- use TRAMP mode for remote file editing
;; Works well with no-password (key pair) setup for SSH
;; Open files via: C-x C-f, /host:/path/to/file
(require 'tramp)
(setq tramp-default-method "scp")

;; dw 09/02/2010 -- better scheme for uniquely naming buffers.
;; Helps in indentifying identically-named files in the ECB History buffer.
(require 'uniquify)
(setq uniquify-buffer-name-style 'reverse uniquify-separator ":")

;; dw 01/02/2013 -- add visible vertical bar mode
(unless (window-system)
  (require 'vvb-mode))

;; dw 04/21/2008 -- use spaces over tabs by default
(setq-default indent-tabs-mode nil)

;; dw 04/21/2008 -- mouse-click paste inserts at point instead of at click location
(setq mouse-yank-at-point t)

;; dw 08/26/2008 -- display full path in mode line
;;(setq-default mode-line-buffer-identification '(buffer-file-name ("%f") ("%b")))

;; dw 10/05/2008 -- scroll compile output
(setq compilation-scroll-output t)

;; dw 10/09/2008 -- highlight paren next to cursor
(show-paren-mode t)

;; dw 10/09/2008 -- kill newline on 'C-k' at beginning of line
(setq kill-whole-line t)

;; dw 10/13/2008 -- avoid accidentally closing Emacs
(setq confirm-kill-emacs 'y-or-n-p)

;; dw 11/14/2008 -- add a newline at the end of every file if not already present
(setq require-final-newline t)

;; dw 05/08/2009 -- default to text mode
(setq default-major-mode 'text-mode)

;; dw 05/21/2009 -- default to "trac-wiki-mode" & "longlines-mode" for files named "*.trac"
;;(setq auto-mode-alist (cons '("\\.trac$" . trac-wiki-mode) auto-mode-alist))

;; dw 05/29/2009 -- set mouse wheel scroll speed for Logitech MX Revolution
;;                  from [http://stackoverflow.com/questions/445873/emacs-mouse-scrolling]
;; dw 12/12/2009 -- no longer using Logitech MX; commenting out two following lines
;;(setq mouse-wheel-scroll-amount '(2 ((shift) . 1) ((control) . nil)))
;;(setq mouse-wheel-progressive-speed nil)

;; dw 06/24/2009 -- set up additional org-mode TODO keywords
(setq org-todo-keywords
      '((sequence "TODO" "|" "DONE")
        (sequence "QUESTION" "|" "ANSWER")
        (sequence "BUG" "POTENTIAL-FIX" "|" "WORKAROUND" "RESOLVED" "WONT-FIX")))

;; dw 01/02/2013 -- don't do italics/underlines for file paths, etc. in org-mode
(setq org-fontify-emphasized-text nil)

;; dw 09/01/2009 -- ediff customizations
(setq ediff-window-setup-function 'ediff-setup-windows-plain)
(setq ediff-split-window-function 'split-window-horizontally)

;; dw 10/06/2010 -- for MixedCase word boundaries
(subword-mode 1)

;; dw 02/23/2012 -- Treat device-tree-source (DTS) files as C syntax
(setq auto-mode-alist (cons '("\\.cnf$" . conf-mode) auto-mode-alist))

;; dw 11/06/2012 -- close variant buffers when quitting diff mode
(add-hook 'ediff-cleanup-hooks 'ediff-janitor)
(setq ediff-keep-variants nil)

;; dw 11/07/2012 -- load gtags
(require 'gtags)

;; dw 01/10/2013 -- SNMP mode for MIB files
(add-to-list 'magic-mode-alist '(".* DEFINITIONS ::= BEGIN$" . snmpv2-mode))

;; dw 03/15/2012 -- Automatically save and restore sessions
(setq desktop-dirname             "~/.emacs.d/desktop"
      desktop-base-file-name      "emacs.desktop"
      desktop-base-lock-name      "lock"
      desktop-path                (list desktop-dirname)
      desktop-save                t
      desktop-files-not-to-save   "^$")
(desktop-save-mode 1)
(desktop-read)

;; dw 05/13/2013 -- electric-indent-mode, replacement for newline-and-indent binding
(electric-indent-mode +1)

;; dw 05/13/2013 -- ansi-term setup
;;                  from http://emacs-journey.blogspot.com/2012/06/improving-ansi-term.html
(defvar my-term-shell "/bin/bash")
(defadvice ansi-term (before force-bash)
  (interactive (list my-term-shell)))
(ad-activate 'ansi-term)

(defun my-term-use-utf8 ()
  (set-buffer-process-coding-system 'utf-8-unix 'utf-8-unix))
(add-hook 'term-exec-hook 'my-term-use-utf8)

(defadvice term-sentinel (around my-advice-term-sentinel (proc msg))
  (if (memq (process-status proc) '(signal exit))
      (let ((buffer (process-buffer proc)))
        ad-do-it
        (kill-buffer buffer))
    ad-do-it))
(ad-activate 'term-sentinel)

;; dw 01/21/2014 -- default to "conf-mode" for AFT "*.cnf" files
(setq auto-mode-alist (cons '("\\.cnf$" . conf-mode) auto-mode-alist))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Functions
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; dw 04/02/2008 -- tags look-up for word under cursor; jump to tags list buffer
(defun my-current-word-tags-lookup ()
  "Tags lookup for the word under the cursor; move cursor to tags list"
  (interactive)
  (tags-apropos (thing-at-point 'word))
  (other-window 1))

;; dw 04/02/2008 -- display a list of available buffers; jump to buffer list
(defun my-list-buffers-and-move-to-list ()
  "List available buffers; move cursor to list"
  (interactive)
  (list-buffers)
  (other-window 1))

;; dw 04/14/2008 -- join this line with the next
(defun my-join-line-with-next ()
  "Join this line with the next line"
  (interactive)
  (next-line 1)
  (join-line))

;; dw 08/26/2008 -- open a new line above current and jump to newly opened line
;;                  useless (message ...) present for Lisp experimentation
;;                  TODO: HOW TO ADD FUNCTION PARAMETER TO REPEAT ???
(defun my-open-line ()
  "Open a line below current and jump to newly opened line"
  (interactive)
  (move-end-of-line 1)
  (newline-and-indent)
  (message "Opened line at #%d" (line-number-at-pos)))

;; dw 08/27/2008 -- open a new line above current and jump to newly opened line
;;                  useless (message ...) present for Lisp experimentation
(defun my-open-line-above ()
  "Open a line above current and jump to newly opened line"
  (interactive)
  (move-beginning-of-line 1)
  (newline 1)
  (previous-line 1)
  (message "Opened line at #%d" (line-number-at-pos)))

;; dw 09/02/2008 -- goto beginning of buffer
(defun my-beginning-of-buffer ()
  "Goto the beginning of buffer without clobbering the mark"
  (interactive)
  (goto-char (point-min)))

;; dw 09/02/2008 -- goto end of buffer
(defun my-end-of-buffer ()
  "Goto the end of buffer without clobbering the mark"
  (interactive)
  (goto-char (point-max)))

;; dw 09/02/2008 -- save point to register on buffer save
(setq my-auto-save-bookmark "my-auto-save-bookmark")
(defun my-save-buffer ()
  "Save point location to register when saving the buffer"
  (interactive)
  (bookmark-set my-auto-save-bookmark)
  (save-buffer))

(defun my-manually-set-auto-save-bookmark ()
  "Save point in my auto-save bookmark"
  (interactive)
  (bookmark-set my-auto-save-bookmark)
  (message "Saved point to %s" (point)))

(defun my-jump-to-auto-save-bookmark ()
  "Jump to position in my auto-save bookmark"
  (interactive)
  (bookmark-jump my-auto-save-bookmark))

;; dw 05/21/2009 -- shortcut to re-load .emacs when making changes
(defun my-load-dot-emacs ()
  (interactive)
  (load-file "~/.emacs"))

;; dw 05/26/2009 -- insert a formatted date string
;;                  originally intended for adding completion dates to org-mode TODO items
;;                  from [http://www.geocities.com/kensanata/dot-emacs.html]
(defun my-insert-date-string ()
  "Insert a nicely formated date string."
  (interactive)
  (insert (format-time-string "%m/%d/%Y")))

;; dw 05/26/2009 -- insert a new heading in org-mode notes
;;                  adds a topic line under day heading and two blank lines following
;;                  point is set to begin typing the day's first topic
(defun my-org-new-day-heading ()
  "Insert a new day for org-mode notes."
  (interactive)
  (move-beginning-of-line 1)
  (insert (format-time-string "* %m/%d/%Y, %a%n%n%n%n"))
  (previous-line 3)
  (insert "** "))

;; dw 05/28/2010 -- insert a personal/debug/tracking comment into C/C++ code, also
;;                  save/restore point to location previous to invocation
(defun my-insert-debug-comment ()
  "Insert a personal/debug/tracking comment above the current line."
  (interactive)
  (save-excursion
    (my-open-line-above)
    (insert "    //~~~ ")
    (c-indent-line)))

;; dw 11/29/2010 -- insert a JavaDoc-style comment in C/C++/Java code
(defun my-insert-javadoc-method-comment ()
  ;; Insert a javadoc method comment at the cursor position
  (interactive)
  (move-beginning-of-line 1)
  (insert
"/**
 *
 *
 * @param
 * @return
 */
")
  (previous-line 5)
  (end-of-line)
  (insert " "))

;; dw 12/01/2010 -- move to top, middle, bottom of currently displayed window
(defun my-move-to-top-of-window ()
  "Move point to the top of the currently displayed window"
  (interactive)
  (move-to-window-line 0))

(defun my-move-to-middle-of-window ()
  "Move point to the middle of the currently displayed window"
  (interactive)
  (move-to-window-line (/ (window-height) 2)))

(defun my-move-to-bottom-of-window ()
  "Move point to the bottom of the currently displayed window"
  (interactive)
  (move-to-window-line -1))


(defun my-kill-buffer ()
  "Kill the currently selected buffer"
  (interactive)
  (kill-buffer (buffer-name))
  (if (get-buffer ecb-history-buffer-name)
    (ecb-add-all-buffers-to-history)))

;;~~~ ;; dw 03/15/2012 -- Manually save and restore sessions
;;~~~ (defun my-desktop ()
;;~~~   "Load the desktop and enable autosaving"
;;~~~   (interactive)
;;~~~   (let ((desktop-load-locked-desktop "ask"))
;;~~~     (desktop-read)
;;~~~     (desktop-save-mode 1)))

;; dw 04/30/2013 -- Increment number at point
;;                  from [http://www.emacswiki.org/emacs/IncrementNumber]
(defun my-increment-number-decimal (&optional arg)
  "Increment the number forward from point by 'arg'."
  (interactive "p*")
  (save-excursion
    (save-match-data
      (let (inc-by field-width answer)
        (setq inc-by (if arg arg 1))
        (skip-chars-backward "0123456789")
        (when (re-search-forward "[0-9]+" nil t)
          (setq field-width (- (match-end 0) (match-beginning 0)))
          (setq answer (+ (string-to-number (match-string 0) 10) inc-by))
          (when (< answer 0)
            (setq answer (+ (expt 10 field-width) answer)))
          (replace-match (format (concat "%0" (int-to-string field-width) "d")
                                 answer)))))))

(defun my-decrement-number-decimal (&optional arg)
  (interactive "p*")
  (my-increment-number-decimal (if arg (- arg) -1)))

(defun my-align-after-commas (beg end)
  (interactive "r")
  (align-regexp beg end ",\\(\\s-*\\)" 1 1 t))

;; dw 02/18/2014 -- Created a function for a lambda that was assigned to <f2>.
;;                  Now using this for both keyboard & mouse shortcuts.
(defun my-split-window-horizontally ()
  (interactive)
  (delete-other-windows)
  (split-window-horizontally 177)
  (mode-line-other-buffer))

;; dw 02/19/2014 -- Fullscreen Emacs setup with ECB & two edit windows
(defun my-split-frame-fullscreen ()
  (interactive)
  (set-frame-position (selected-frame) 0 0)
  (set-frame-width (selected-frame) 475)
  (set-frame-height (selected-frame) 73)
  (delete-other-windows)
  (split-window-horizontally 177))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Aliases
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; dw 10/13/2008 -- substitute y/n for yes/no
(defalias 'yes-or-no-p 'y-or-n-p)

;; dw 05/21/2009 -- shortcut to load .emacs
(defalias 'lfe 'my-load-dot-emacs)

;; dw 05/21/2009 -- set default value for fill-column
;;                  having trouble getting set-fill-column to take effect on mode hooks,
;;                  so setting a resonable default as workaround
;;(setq-default fill-column 90)

;; dw 05/26/2009 -- shortcut to insert new day heading in org-mode notes
(defalias 'nd 'my-org-new-day-heading)

;; dw 05/28/2009 -- shortcut to insert a date
(defalias 'id 'my-insert-date-string)

;; dw 09/02/2008 -- regexp search
(defalias 'sfr 'search-forward-regexp)

;; dw 08/26/2008 -- regexp search and replace
(defalias 'qrr 'query-replace-regexp)

;; dw 08/25/2009 -- column insertion/removal
(defalias 'sir 'string-insert-rectangle)
(defalias 'srr 'kill-rectangle)

;; dw 09/21/2009 -- begin/end of buffer
(defalias 'beg 'my-beginning-of-buffer)
(defalias '\0 'my-beginning-of-buffer)
(defalias 'end 'my-end-of-buffer)
(defalias '\$ 'my-end-of-buffer)

;; dw 05/28/2010 -- shortcut to insert a debug comment into C/C++ code
(defalias 'idc 'my-insert-debug-comment)

;; dw 02/14/2011 -- keyboard navitation between ECB windows
(defalias 'egh 'ecb-goto-window-history)
(defalias 'egm 'ecb-goto-window-methods)
(defalias 'ege 'ecb-goto-window-edit1)

;; dw 04/02/2011 -- ECB redrawing layout, which is sometimes lost on window resize
(defalias 'erl 'ecb-redraw-layout-preserving-compwin-state)

;; dw 08/02/2011 -- ECB history filter, clean up after adding/removing buffers w/
;;                  artificially unique names
(defalias 'eah 'ecb-add-all-buffers-to-history)

;; dw 01/18/2012 -- find file at point
(defalias 'fp 'find-file-at-point)

;; dw 01/02/2013 -- visual vertical bar mode customizations
(unless (window-system)
  (setq vvb-column '90)
  (setq-default
    vvb-sticky-p nil
    vvb-permanent-p t
    vvb-right-on-eol-p t))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Keyboard Shortcuts
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; dw 02/26/2010 -- define a minor mode for keybindings
;;                  Having a separate minor mode avoids conflicts in my desired
;;                  key bindings with other minor modes.
(defvar prophet-minor-mode-map (make-keymap) "prophet-minor-mode keymap.")
(define-minor-mode prophet-minor-mode
  "A minor mode so that my key settings supplement/override major modes."
  t " Prophet" 'prophet-minor-mode-map)

;; dw 02/26/2010 -- Changing "global-set-key" to "define-key" for my minor mode
;;                  to avoid collisions from other minor modes

;; dw 03/27/2008 -- goto line # in current file
(define-key prophet-minor-mode-map (kbd "C-l") 'goto-line)

;; dw 04/02/2008 -- lookup tag & jump to tags list
(define-key prophet-minor-mode-map (kbd "C-x t") 'my-current-word-tags-lookup)

;; dw 04/02/2008 -- list buffers & jump to list
(define-key prophet-minor-mode-map (kbd "C-x C-b") 'my-list-buffers-and-move-to-list)

;; dw 04/02/2008 -- go to beginning of function; Why does the native key-binding for this
;;                  require 'A', not 'a', when end-of-defun works with 'e' ???
;;                  For some reason, mapping to C-M-a doesn't change this behaviour; remapping
;;                  these to C-M-<arrrows> for the time being until I think of something better.
(define-key prophet-minor-mode-map (kbd "C-M-<left>") 'beginning-of-defun)
(define-key prophet-minor-mode-map (kbd "C-M-<right>") 'end-of-defun)

;; dw 04/14/2008 -- join the current line with the next
(define-key prophet-minor-mode-map (kbd "C-j") 'my-join-line-with-next)

;; dw 05/20/2008 -- use Ctrl instead of M-x to avoid continually scrunching up left hand
(define-key prophet-minor-mode-map (kbd "C-x C-m") 'execute-extended-command)
(define-key prophet-minor-mode-map (kbd "C-c C-m") 'execute-extended-command)

;; dw 10/15/2012 -- support quitting a "C-x ..." command
(define-key prophet-minor-mode-map (kbd "C-x C-g") 'keyboard-quit)

;; dw 05/20/2008 -- lazy file save
(define-key prophet-minor-mode-map (kbd "<f5>") 'my-save-buffer)

;; dw 08/26/2008 -- open line below current and goto newly opened line
(define-key prophet-minor-mode-map (kbd "C-o") 'my-open-line)

;; dw 08/27/2008 -- open line above current and goto newly opened line
(define-key prophet-minor-mode-map (kbd "C-S-o") 'my-open-line-above)

;; dw 09/21/2009 -- unmapping C-, & C-.; collides with dot-mode
;; dw 09/02/2008 -- goto beginning of buffer
;(global-set-key (kbd "C-,") 'my-beginning-of-buffer)
(define-key prophet-minor-mode-map (kbd "C-x g") 'my-beginning-of-buffer)

;; dw 09/02/2008 -- goto end of buffer
;(define-key prophet-minor-mode-map (kbd "C-.") 'my-end-of-buffer)
(define-key prophet-minor-mode-map (kbd "C-x G") 'my-end-of-buffer)

;; dw 09/02/2008 -- save point to bookmark on buffer save
(define-key prophet-minor-mode-map (kbd "C-x C-s") 'my-save-buffer)

;; dw 09/02/2008 -- manually save point to auto-save bookmark
(define-key prophet-minor-mode-map (kbd "C-x /") 'my-manually-set-auto-save-bookmark)

;; dw 09/02/2008 -- jump to point in auto-save bookmark
(define-key prophet-minor-mode-map (kbd "C-x '") 'my-jump-to-auto-save-bookmark)

;; dw 09/24/2008 -- enlarge current window
(define-key prophet-minor-mode-map (kbd "C-`") 'enlarge-window)

;; dw 09/24/2008 -- shrink current window
(define-key prophet-minor-mode-map (kbd "C-~") 'shrink-window)

;; dw 10/05/2008 -- keyboard shortcuts for compile
(global-unset-key (kbd "C-x m"))
(define-key prophet-minor-mode-map (kbd "C-x m c") 'compile)
(define-key prophet-minor-mode-map (kbd "C-x m r") 'recompile)
(define-key prophet-minor-mode-map (kbd "C-x m k") 'kill-compilation)

;; dw 05/13/2013 -- deprecated in favor of Emacs v24.x "electric-indent-mode"
;; dw 10/09/2008 -- indent new line on 'Enter'
;;~~~(define-key prophet-minor-mode-map (kbd "C-m") 'newline-and-indent)

;; dw 08/25/2009 -- column editing shortcuts
(define-key prophet-minor-mode-map (kbd "C-c i") 'string-insert-rectangle)
(define-key prophet-minor-mode-map (kbd "C-c r") 'kill-rectangle)

;; dw 05/28/2010 -- F4 short-cut to insert debug comment into C/C++ code
(define-key prophet-minor-mode-map (kbd "<f4>") 'my-insert-debug-comment)

;; dw 06/14/2010 -- Ctrl-Tab to switch to most recently used buffer
(define-key prophet-minor-mode-map (kbd "C-<tab>") 'mode-line-other-buffer)
;; dw 03/15/2012 -- Ctrl-Tab not working in iTerm2, SSH to remote host, console Emacs
(define-key prophet-minor-mode-map (kbd "<f7>") 'mode-line-other-buffer)
;; dw 06/14/2010 -- Alias to above for accidental "Ctrl-X"
(define-key prophet-minor-mode-map (kbd "C-x C-<tab>") 'mode-line-other-buffer)
;; dw 02/18/2014 -- Alias to above for mouse usage
(define-key prophet-minor-mode-map (kbd "<mouse-8>") 'mode-line-other-buffer)

;; dw 06/14/2010 -- F6 short-cut to kill current buffer
;; Also re-defining "C-x k" to my "overloaded" kill-buffer
(define-key prophet-minor-mode-map (kbd "<f6>") 'my-kill-buffer)
(define-key prophet-minor-mode-map (kbd "C-x k") 'my-kill-buffer)


;; dw 06/18/2010 -- F1 short-cut to delete-other-windows
;;                  Shift + F1 switch window & then delete
(define-key prophet-minor-mode-map (kbd "<f1>") 'delete-other-windows)
(define-key prophet-minor-mode-map (kbd "<S-f1>")
  (lambda ()
    (interactive)
    (other-window 1)
    (delete-other-windows)))

;; dw 06/21/2010 -- F2 short-cut to split vertically
;;                 resulting in two wide, top-and-bottom panes
;;(define-key prophet-minor-mode-map (kbd "<f2>")
;;  (lambda ()
;;    (interactive)
;;    (split-window-vertically)
;;    (mode-line-other-buffer)))

;; dw 05/28/2013 -- F2 short-cut to clear out current frame configuration
;;                  and re-split the frame into two windows, side-by-side
(define-key prophet-minor-mode-map (kbd "<f2>") 'my-split-window-horizontally)
(define-key prophet-minor-mode-map (kbd "<mouse-9>") 'my-split-window-horizontally)

;;  (lambda ()
;;    (interactive)
;;    (delete-other-windows)
;;    (split-window-horizontally)
;;    (mode-line-other-buffer)))

;; dw 08/22/2011 - F3 short-cut to split horizontally
;;                 resulting in two tall, size-by-side panes
(define-key prophet-minor-mode-map (kbd "<f3>")
  (lambda ()
    (interactive)
    (split-window-horizontally)
    (mode-line-other-buffer)))

;; dw 08/26/2010 -- delete to beginning of line
(define-key prophet-minor-mode-map (kbd "C-S-k")
  (lambda ()
    (interactive)
    (kill-line 0)))

;; dw 11/29/2010 -- insert a JavaDoc function comment
(define-key prophet-minor-mode-map (kbd "C-x j") 'my-insert-javadoc-method-comment)

;; dw 12/01/2010 -- move to top, middle, bottom of currently displayed window
(define-key prophet-minor-mode-map (kbd "C-c h") 'my-move-to-top-of-window)
(define-key prophet-minor-mode-map (kbd "C-c m") 'my-move-to-middle-of-window)
(define-key prophet-minor-mode-map (kbd "C-c l") 'my-move-to-bottom-of-window)

;; dw 01/02/2013 -- remap <M-(left|right)> from org-mode's settings
;;                  to behave as in all other minor modes, go backward
;;                  and forward one word.  Org mode's outdent/indent
;;                  functions are re-mapped to Meta-Shift-(right|left).
;;                  Also move vvb-mode settings into the hook as I had
;;                  been invorrectly trying to set this minor mode in
;;                  the file variables line as a second major mode,
;;                  which doesn't work for Emacs 24.1 on Linux.
(add-hook 'org-mode-hook
  (lambda ()
    (vvb-mode)
    (setq vvb-column 90)
    (define-key org-mode-map (kbd "<M-left>") 'backward-word)
    (define-key org-mode-map (kbd "<M-right>") 'forward-word)
    (define-key org-mode-map (kbd "<M-S-left>") 'org-metaleft)
    (define-key org-mode-map (kbd "<M-S-right>") 'org-metaright)))

;; dw 10/18/2011 -- delete vs backspace when using Emacs over X11 on Mac
(define-key prophet-minor-mode-map (kbd "<delete>") 'delete-char)

;; dw 10/13/2011 -- Map the Mac-centric <cmd>-{Z,X,C,V} for undo,cut,copy,paste
;;                  Useful for annoyance prevention when my brain gets hung up
;;                  on the Mac keyboard shortcuts.
;; command-x
(define-key prophet-minor-mode-map (kbd "≈") 'kill-region)
;; command-c
(define-key prophet-minor-mode-map (kbd "ç") 'kill-ring-save)
;; command-v
(define-key prophet-minor-mode-map (kbd "√") 'yank)
;; command-z
(define-key prophet-minor-mode-map (kbd "Ω") 'undo)

(define-key prophet-minor-mode-map (kbd "M-<left>") 'subword-backward)
(define-key prophet-minor-mode-map (kbd "M-<right>") 'subword-forward)

;;(define-key prophet-minor-mode-map (kbd "M-8") 'pop-tag-mark)
(define-key prophet-minor-mode-map (kbd "M-8") 'gtags-pop-stack)

;; dw 02/26/2010 -- enable my minor mode by default
(prophet-minor-mode 1)

;; dw 02/26/2010 -- disable my minor mode in the minibuffer
(defun my-minibuffer-setup-hook ()
  (prophet-minor-mode 0))
(add-hook 'minibuffer-setup-hook 'my-minibuffer-setup-hook)

;; (defun my-term-mode-hook ()
;;   (prophet-minor-mode 0))
;; (add-hook 'term-mode-hook 'my-term-mode-hook)


;; dw 10/04/2010 -- delete trailing whitespace from lines on save
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; dw 11/07/2012 -- add <return> to select a tag in gtags-select-mode
(define-key gtags-select-mode-map (kbd "<return>") 'gtags-select-tag)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; C/C++ Formatting
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; dw 04/21/2008 -- C/C++ formatting 
(defconst aft-c-mode '(
  (indent-tabs-mode . nil)
  (c-basic-offset . 4)
  (tab-width . 4)
  (default-tab-width 4)
  (c-comment-only-line-offset . 0)
  (c-hanging-braces-alist     . ((substatement-open before after)))
  (c-offsets-alist . (
    (topmost-intro        . 0)
    (inline-open          . 0)
    (topmost-intro-cont   . 0)
    (substatement         . +)
    (case-label           . +)
    (access-label         . -)
    (inclass              . +)
    (innamespace          . 0)
    (statement-block-intro . +)
    (knr-argdecl-intro . 0)
    (substatement-open . 0)
    (label . 0)
    (statement-cont . +)))))

(c-add-style "aft-c-mode" aft-c-mode)

;; dw 11/07/2012 -- add gtags-mode to C++ hook
(add-hook 'c++-mode-hook '(lambda ()
  (c-set-style "aft-c-mode")
  (gtags-mode)))
(add-hook 'c++-mode-hook'(lambda ()
  (add-hook 'write-contents-hooks 'delete-trailing-whitespace)))
(add-hook 'c-mode-hook '(lambda ()
  (c-set-style "aft-c-mode")))
(add-hook 'c-mode-hook '(lambda ()
  (add-hook 'write-contents-hooks 'delete-trailing-whitespace)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Java Formatting
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; dw 03/30/2012 -- Java formatting to accomodate Eclipse's insistence on tabs over spaces
(defconst my-java-mode '(
  (indent-tabs-mode . nil)
  (tab-width . 4)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; VHDL Formatting
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; dw 10/02/2009 -- VHDL formatting, corresponds to Mike Fawcett's VHDL formatting
;;                  which appears to have originated with the Xilinx ISE editor
(defun my-vhdl-mode-hook ()
  (set-variable 'vhdl-basic-offset 3)
  (set-variable 'tab-width 3)
  (set-variable 'standard-indent 3))

(add-hook 'vhdl-mode-hook 'my-vhdl-mode-hook)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Makefile Formatting
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun my-makefile-mode-hook()
   "Weekley's makefile mode hook"
   (setq tab-width 4))

(add-hook 'makefile-mode-hook 'my-makefile-mode-hook)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Shell Script Formatting
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; dw 11/25/2008 -- sh-indent-line error ???; this workaround seems to avoid the issue
(defun my-sh-mode-hook ()
  "Weekley's shell-script mode hook"
  (message "Loading my-sh-mode-hook...")
  (setq tab-width 4)
  (local-set-key (kbd "TAB") 'sh-indent-line)
  (setq indent-tabs-mode nil)
  (message "my-sh-mode-hook loaded"))

(add-hook 'sh-mode-hook 'my-sh-mode-hook)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Trac Wiki Formatting
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun my-trac-wiki-mode-hook ()
  "Weekley's trac-wiki-mode hook"
  (longlines-mode)
  (setq longlines-show-hard-newlines t)
  (setq fill-column 90))

(add-hook 'trac-wiki-mode-hook 'my-trac-wiki-mode-hook)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Faces Customization
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(if (window-system)
  (custom-set-faces
    ;; custom-set-faces was added by Custom.
    ;; If you edit it by hand, you could mess it up, so be careful.
    ;; Your init file should contain only one such instance.
    ;; If there is more than one, they won't work right.
    '(default ((t (:stipple nil :background "#333A3F" :foreground "#999999" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil))))
    '(compilation-info ((((class color) (min-colors 16)) (:foreground "#18B218" :weight bold))))
    '(compilation-warning ((((class color) (min-colors 16)) (:foreground "Orange4" :weight bold))))
    '(cursor ((t (:foreground "white"))))
    '(custom-group-tag ((t (:foreground "#22B2FF" :weight bold))))
    '(diff-added ((t (:foreground "lime green"))))
    '(diff-changed ((nil nil)))
    '(diff-context ((((class color grayscale) (min-colors 88)) nil)))
    '(diff-file-header ((((class color) (min-colors 88) (background dark)) (:weight bold))))
    '(diff-file-header-face ((t (:weight bold))) t)
    '(diff-header ((((class color) (min-colors 88) (background dark)) (:background "grey45" :foreground "black"))))
    '(diff-hunk-header ((t (:foreground "#1C94D5"))))
    '(diff-removed ((t (:foreground "FireBrick"))))
    '(ecb-analyse-face ((((class color) (background dark)) (:inherit ecb-default-highlight-face))))
    '(ecb-default-highlight-face ((((class color) (background dark)) (:background "Orange4" :foreground "black"))))
    '(ecb-directories-general-face ((((class color) (background dark)) (:inherit ecb-default-general-face :height 1.0))))
    '(ecb-directory-face ((((class color) (background dark)) (:inherit ecb-default-highlight-face))))
    '(ecb-history-face ((((class color) (background dark)) (:inherit ecb-default-highlight-face))))
    '(ecb-method-face ((t (:inherit ecb-default-highlight-face))))
    '(ecb-source-face ((((class color) (background dark)) (:inherit ecb-default-highlight-face))))
    '(ecb-tag-header-face ((((class color) (background dark)) (:inherit ecb-default-highlight-face :foreground "black"))))
    '(font-lock-builtin-face ((((class color) (min-colors 88)) (:foreground "#22B2FF"))))
    '(font-lock-comment-delimiter-face ((default (:inherit font-lock-comment-face)) (((class color) (min-colors 8) (background dark)) (:foreground "#18B218"))))
    '(font-lock-comment-face ((((class color) (min-colors 88)) (:foreground "#18B218"))))
    '(font-lock-constant-face ((t nil)))
    '(font-lock-doc-face ((t (:foreground "#18B218"))))
    '(font-lock-function-name-face ((t (:foreground "#1C94D5"))))
    '(font-lock-keyword-face ((t (:foreground "#1C94D5"))))
    '(font-lock-preprocessor-face ((t (:foreground "FireBrick"))))
    '(font-lock-string-face ((t (:foreground "brown"))))
    '(font-lock-type-face ((t (:foreground "#1C94D5" :weight bold))))
    '(font-lock-variable-name-face ((((class color) (min-colors 88) (background light)) (:foreground "#22B2FF"))))
    '(font-lock-warning-face ((t (:foreground "Red" :weight bold))))
    '(fringe ((((class color) (background light)) (:background "grey95"))))
    '(header-line ((((class color grayscale) (background light)) (:inherit mode-line :background "grey90" :foreground "grey20" :box nil))))
    '(highlight ((((class color) (min-colors 88) (background dark)) (:background "darkolivegreen"))))
    '(isearch ((((class color)) (:background "#B26818" :foreground "#333A3F"))))
    '(italic ((t (:slant italic))))
    '(lazy-highlight ((((class color)) (:background "lightgoldenrod" :foreground "black"))))
    '(menu ((((type x-toolkit)) nil)))
    '(mode-line ((((class color) (min-colors 88)) (:background "grey45" :foreground "black" :box (:line-width -1 :style released-button)))))
    '(org-done ((t (:foreground "#899CAA"))))
    '(org-hide ((t (:foreground "#555555"))))
    '(org-level-1 ((t (:foreground "#C41818"))))
    '(org-level-2 ((t (:foreground "#18B218"))))
    '(org-level-3 ((t (:foreground "#1C94D5"))))
    '(org-level-4 ((t nil)))
    '(org-level-5 ((t nil)))
    '(org-level-6 ((t nil)))
    '(org-level-7 ((t nil)))
    '(org-level-8 ((t nil)))
    '(org-link ((((class color) (background light)) (:foreground "#22B2FF" :underline t))))
    '(org-special-keyword ((((class color) (min-colors 16)) (:foreground "#C41818"))))
    '(org-todo ((t (:foreground "FireBrick" :weight bold))))
    '(region ((((class color)) (:background "#B26818" :foreground "#333A3F"))))
    '(rpm-spec-tag-face ((t (:foreground "#1C94D5"))))
    '(scroll-bar ((t nil)))
    '(sh-heredoc ((nil (:inherit font-lock-string-face))))
    '(sh-heredoc-face ((((class color) (background light)) (:foreground "steel blue"))) t)
    '(sh-quoted-exec ((((class color) (background light)) (:foreground "magenta4"))))
    '(shadow ((((class color grayscale) (min-colors 88)) (:foreground "grey40" :slant italic))))
    '(show-paren-match ((((class color)) (:background "DarkMagenta" :foreground "#999999"))))
    '(show-paren-mismatch ((((class color)) (:background "red" :foreground "white"))))
    '(vhdl-font-lock-attribute-face ((((class color) (background light)) (:foreground "DarkOrchid3"))))
    '(vhdl-font-lock-prompt-face ((((class color) (background light)) (:foreground "#18B218" :weight normal)))))

  (custom-set-faces
    ;; custom-set-faces was added by Custom.
    ;; If you edit it by hand, you could mess it up, so be careful.
    ;; Your init file should contain only one such instance.
    ;; If there is more than one, they won't work right.
   '(default ((t (:stipple nil :inverse-video nil :box nil :strike-through nil :overline nil :underline nil))))
   '(compilation-warning ((t (:foreground "red" :weight bold))))
   '(cursor ((t (:foreground "white"))))
   '(custom-group-tag ((t (:foreground "#22B2FF" :weight bold))))
   '(diff-changed ((nil nil)))
   '(diff-context ((((class color grayscale) (min-colors 88)) nil)))
   '(diff-file-header ((((class color) (min-colors 88) (background dark)) (:weight bold))))
   '(diff-file-header-face ((t (:weight bold))) t)
   '(diff-header ((((class color) (min-colors 88) (background dark)) (:background "grey45" :foreground "black"))))
   '(ecb-analyse-face ((((class color) (background dark)) (:inherit ecb-default-highlight-face))))
   '(ecb-default-general-face ((t (:inherit default))))
   '(ecb-default-highlight-face ((t ( :foreground "white"))))
   '(ecb-directories-general-face ((((class color) (background dark)) (:inherit ecb-default-general-face :height 1.0))))
   '(ecb-directory-face ((((class color) (background dark)) (:inherit ecb-default-highlight-face))))
   '(ecb-history-face ((t (:inherit ecb-default-highlight-face))))
   '(ecb-method-face ((t (:inherit ecb-default-highlight-face))))
   '(ecb-source-face ((t (:inherit ecb-default-highlight-face))))
   '(ecb-tag-header-face ((((class color) (background dark)) (:inherit ecb-default-highlight-face :foreground "black"))))
   '(font-lock-builtin-face ((((class color) (min-colors 88)) (:foreground "#22B2FF"))))
   '(font-lock-comment-delimiter-face ((t (:inherit font-lock-comment-face))))
   '(font-lock-comment-face ((t (:foreground "green"))))
   '(font-lock-constant-face ((t nil)))
   '(font-lock-doc-face ((t (:foreground "#18B218"))))
   '(font-lock-function-name-face ((t (:foreground "blue"))))
   '(font-lock-keyword-face ((((class color) (background light)) (:foreground "blue"))))
   '(font-lock-preprocessor-face ((t (:foreground "red"))))
   '(font-lock-string-face ((t (:foreground "red"))))
   '(font-lock-type-face ((t (:foreground "#1C94D5" :weight bold))))
   '(font-lock-variable-name-face ((((class color) (min-colors 88) (background light)) (:foreground "#22B2FF"))))
   '(font-lock-warning-face ((t (:foreground "red" :weight bold))))
   '(fringe ((((class color) (background light)) (:background "grey95"))))
   '(header-line ((((class color grayscale) (background light)) (:inherit mode-line :background "grey90" :foreground "grey20" :box nil))))
   '(highlight ((t (:background "yellow"))))
   '(isearch ((((class color)) (:background "yellow" :foreground "black"))))
   '(italic ((t (:slant italic))))
   '(lazy-highlight ((((class color)) (:background "yellow" :foreground "black"))))
   '(menu ((((type x-toolkit)) nil)))
   '(mode-line ((t ( :foreground "cyan" :box (:line-width -1 :style released-button)))))
   '(org-done ((t (:foreground "#899CAA"))))
   '(org-hide ((t (:foreground "#555555"))))
   '(org-level-1 ((t (:foreground "#C41818"))))
   '(org-level-2 ((t (:foreground "#18B218"))))
   '(org-level-3 ((t (:foreground "#1C94D5"))))
   '(org-level-4 ((t nil)))
   '(org-level-5 ((t nil)))
   '(org-level-6 ((t nil)))
   '(org-level-7 ((t nil)))
   '(org-level-8 ((t nil)))
   '(org-link ((((class color) (background light)) (:foreground "#22B2FF" :underline t))))
   '(org-special-keyword ((((class color) (min-colors 16)) (:foreground "#C41818"))))
   '(org-todo ((t (:foreground "FireBrick" :weight bold))))
   '(region ((((class color)) (:background "yellow" :foreground "black"))))
   '(scroll-bar ((t nil)))
   '(sh-heredoc ((nil (:inherit font-lock-string-face))))
   '(sh-heredoc-face ((((class color) (background light)) (:foreground "steel blue"))) t)
   '(sh-quoted-exec ((((class color) (background light)) (:foreground "magenta4"))))
   '(shadow ((((class color grayscale) (min-colors 88)) (:foreground "grey40" :slant italic))))
   '(show-paren-match ((((class color)) (:background "DarkMagenta" :foreground "#999999"))))
   '(show-paren-mismatch ((((class color)) (:background "red" :foreground "white"))))
   '(vhdl-font-lock-attribute-face ((((class color) (background light)) (:foreground "DarkOrchid3"))))
   '(vhdl-font-lock-prompt-face ((((class color) (background light)) (:foreground "#18B218" :weight normal))))))

;; dw 09/14/2011 -- old settings for GUI, light gray background, dark foreground
;; (custom-set-faces
;;   ;; custom-set-faces was added by Custom.
;;   ;; If you edit it by hand, you could mess it up, so be careful.
;;   ;; Your init file should contain only one such instance.
;;   ;; If there is more than one, they won't work right.
;;  '(default ((t (:stipple nil :background "gray65" :foreground "#000000" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil))))
;;  '(compilation-info ((((class color) (min-colors 16) (background light)) (:foreground "Green4" :weight bold))))
;;  '(compilation-warning ((((class color) (min-colors 16)) (:foreground "Orange4" :weight bold))))
;;  '(cursor ((t (:background "darkgreen"))))
;;  '(custom-group-tag ((t (:foreground "blue" :weight bold))))
;;  '(font-lock-builtin-face ((((class color) (background light)) (:foreground "medium blue"))))
;;  '(font-lock-comment-face ((((class color) (background light)) (:foreground "Dark Green"))))
;;  '(font-lock-constant-face ((t nil)))
;;  '(font-lock-doc-face ((nil (:foreground "DarkGreen"))))
;;  '(font-lock-function-name-face ((t (:foreground "Blue"))))
;;  '(font-lock-keyword-face ((((class color) (background light)) (:foreground "medium blue"))))
;;  '(font-lock-string-face ((((class color) (background light)) (:foreground "brown4"))))
;;  '(font-lock-type-face ((t (:foreground "navy" :weight bold))))
;;  '(font-lock-variable-name-face ((((class color) (background light)) (:foreground "black"))))
;;  '(font-lock-warning-face ((t (:foreground "Dark Magenta"))))
;;  '(fringe ((((class color) (background light)) (:background "grey95"))))
;;  '(header-line ((((class color grayscale) (background light)) (:inherit mode-line :background "grey90" :foreground "grey20" :box nil))))
;;  '(highlight ((((class color) (background light)) (:background "darkseagreen2"))))
;;  '(isearch ((((class color) (background light)) (:background "magenta4" :foreground "lightskyblue1"))))
;;  '(italic ((t (:slant italic))))
;;  '(lazy-highlight ((((class color) (background light)) (:background "paleturquoise"))))
;;  '(menu ((((type x-toolkit)) nil)))
;;  '(mode-line ((((class color) (min-colors 88)) (:background "grey75" :foreground "black" :box (:line-width -1 :style released-button)))))
;;  '(org-done ((t (:foreground "gray30" :weight bold))))
;;  '(org-hide ((((background light)) (:foreground "gray75"))))
;;  '(org-level-1 ((t (:foreground "FireBrick"))))
;;  '(org-level-2 ((t (:foreground "DarkGreen"))))
;;  '(org-level-3 ((t (:foreground "DarkBlue"))))
;;  '(org-level-4 ((t nil)))
;;  '(org-level-5 ((t nil)))
;;  '(org-level-6 ((t nil)))
;;  '(org-level-7 ((t nil)))
;;  '(org-level-8 ((t nil)))
;;  '(org-link ((((class color) (background light)) (:foreground "Blue" :underline t))))
;;  '(org-special-keyword ((((class color) (min-colors 16) (background light)) (:foreground "FireBrick"))))
;;  '(org-todo ((t (:foreground "FireBrick" :weight bold))))
;;  '(region ((((class color) (background light)) (:background "lightgoldenrod2"))))
;;  '(scroll-bar ((t nil)))
;;  '(sh-heredoc ((t (:inherit font-lock-string-face))))
;;  '(sh-heredoc-face ((((class color) (background light)) (:foreground "steel blue"))) t)
;;  '(sh-quoted-exec ((((class color) (background light)) (:foreground "magenta4"))))
;;  '(shadow ((((class color grayscale) (min-colors 88) (background light)) (:foreground "grey20" :slant italic))))
;;  '(show-paren-match ((((class color) (background light)) (:background "lightblue3"))))
;;  '(tool-bar ((((type x w32 mac) (class color)) (:background "grey75" :foreground "black" :box (:line-width 1 :style released-button)))))
;;  '(vhdl-font-lock-attribute-face ((((class color) (background light)) (:foreground "DarkOrchid3"))))
;;  '(vhdl-font-lock-prompt-face ((((class color) (background light)) (:foreground "Dark Green" :weight normal)))))

;; dw 02/15/2009 -- set default font for GTK Emacs
;; dw 05/18/2009 -- re-built Emacs 23 from source for RHEL5.3
;;                  built gtk+2.10, installed to /usr/local/lib
;;                  export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
;;                  configure --with-x-toolkit=gtk --with-fxt --without-gif
;;                  make && sudo make install
;; dw 10/18/2011 -- set different font if using local display vs using
;;                  SSH export X application; Mac X11 requires a smaller
;;                  font size to get an equivalent display
(if (string-match "^:0" (getenv "DISPLAY"))
  (set-default-font "Monospace-9")  ;; local display
  (set-default-font "Monospace-8"))  ;; exported X display

;; dw 02/26/2010 -- disable cursor blink
(blink-cursor-mode -1)
(set-cursor-color "#999999")

;; dw 01/02/2013 -- visual vertical bar mode colors
(unless (window-system)
  (set-face-foreground vvb-face  "#999999")
  (set-face-background vvb-face "#555555"))

(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)


;;~~~(defun my-term-hook ()
;;~~~  (goto-address-mode)
;;~~~  (define-key term-raw-map "\C-y" 'my-term-paste)
;;~~~  (let ((base03  "#002b36")
;;~~~        (base02  "#073642")
;;~~~        (base01  "#586e75")
;;~~~        (base00  "#657b83")
;;~~~        (base0   "#839496")
;;~~~        (base1   "#93a1a1")
;;~~~        (base2   "#eee8d5")
;;~~~        (base3   "#fdf6e3")
;;~~~        (yellow  "#b58900")
;;~~~        (orange  "#cb4b16")
;;~~~        (red     "#dc322f")
;;~~~        (magenta "#d33682")
;;~~~        (violet  "#6c71c4")
;;~~~        (blue    "#268bd2")
;;~~~        (cyan    "#2aa198")
;;~~~        (green   "#859900"))
;;~~~    (setq ansi-term-color-vector
;;~~~          (vconcat `(unspecified ,base02 ,red ,green ,yellow ,blue
;;~~~                                 ,magenta ,cyan ,base2)))))

;; dw 05/13/2013 -- set up colors for ansi-term
;;                  from http://emacs-journey.blogspot.com/2012/06/improving-ansi-term.html
(defun my-term-hook ()
  (goto-address-mode)
  (define-key term-raw-map "\C-y" 'my-term-paste)
  (let ((base03  "#333A3F")
        (base02  "#333A3F")
        (base01  "#586e75")
        (base00  "#657b83")
        (base0   "#839496")
        (base1   "#93a1a1")
        (base2   "#999999")
        (base3   "#fdf6e3")
        (yellow  "#b58900")
        (orange  "#cb4b16")
        (red     "#ff5454")
        (magenta "#d33682")
        (violet  "#6c71c4")
        (blue    "#1c94d5")
        (cyan    "#2aa198")
        (green   "#18B218"))
  (setq ansi-term-color-vector (vconcat `(unspecified ,base02 ,red ,green ,yellow ,blue ,magenta ,cyan ,base2)))))

(add-hook 'term-mode-hook 'my-term-hook)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:stipple nil :background "#333A3F" :foreground "#999999" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil))))
 '(compilation-info ((((class color) (min-colors 16)) (:foreground "#18B218" :weight bold))))
 '(compilation-warning ((((class color) (min-colors 16)) (:foreground "Orange4" :weight bold))))
 '(cursor ((t (:foreground "white"))))
 '(custom-group-tag ((t (:foreground "#22B2FF" :weight bold))))
 '(diff-added ((t (:foreground "lime green"))))
 '(diff-changed ((nil nil)))
 '(diff-context ((((class color grayscale) (min-colors 88)) nil)))
 '(diff-file-header ((((class color) (min-colors 88) (background dark)) (:weight bold))))
 '(diff-file-header-face ((t (:weight bold))) t)
 '(diff-header ((((class color) (min-colors 88) (background dark)) (:background "grey45" :foreground "black"))))
 '(diff-hunk-header ((t (:foreground "#1C94D5"))))
 '(diff-removed ((t (:foreground "FireBrick"))))
 '(ecb-analyse-face ((((class color) (background dark)) (:inherit ecb-default-highlight-face))))
 '(ecb-default-highlight-face ((((class color) (background dark)) (:background "Orange4" :foreground "black"))))
 '(ecb-directories-general-face ((((class color) (background dark)) (:inherit ecb-default-general-face :height 1.0))))
 '(ecb-directory-face ((((class color) (background dark)) (:inherit ecb-default-highlight-face))))
 '(ecb-history-face ((((class color) (background dark)) (:inherit ecb-default-highlight-face))))
 '(ecb-method-face ((t (:inherit ecb-default-highlight-face))))
 '(ecb-source-face ((((class color) (background dark)) (:inherit ecb-default-highlight-face))))
 '(ecb-tag-header-face ((((class color) (background dark)) (:inherit ecb-default-highlight-face :foreground "black"))))
 '(font-lock-builtin-face ((((class color) (min-colors 88)) (:foreground "#22B2FF"))))
 '(font-lock-comment-delimiter-face ((default (:inherit font-lock-comment-face)) (((class color) (min-colors 8) (background dark)) (:foreground "#18B218"))))
 '(font-lock-comment-face ((((class color) (min-colors 88)) (:foreground "#18B218"))))
 '(font-lock-constant-face ((t nil)))
 '(font-lock-doc-face ((t (:foreground "#18B218"))))
 '(font-lock-function-name-face ((t (:foreground "#1C94D5"))))
 '(font-lock-keyword-face ((t (:foreground "#1C94D5"))))
 '(font-lock-preprocessor-face ((t (:foreground "FireBrick"))))
 '(font-lock-string-face ((t (:foreground "brown"))))
 '(font-lock-type-face ((t (:foreground "#1C94D5" :weight bold))))
 '(font-lock-variable-name-face ((((class color) (min-colors 88) (background light)) (:foreground "#22B2FF"))))
 '(font-lock-warning-face ((t (:foreground "Red" :weight bold))))
 '(fringe ((((class color) (background light)) (:background "grey95"))))
 '(header-line ((((class color grayscale) (background light)) (:inherit mode-line :background "grey90" :foreground "grey20" :box nil))))
 '(highlight ((((class color) (min-colors 88) (background dark)) (:background "darkolivegreen"))))
 '(hl-line ((t (:background "LightGoldenrod1"))))
 '(isearch ((((class color)) (:background "#B26818" :foreground "#333A3F"))))
 '(italic ((t (:slant italic))))
 '(lazy-highlight ((((class color)) (:background "lightgoldenrod" :foreground "black"))))
 '(menu ((((type x-toolkit)) nil)))
 '(mode-line ((((class color) (min-colors 88)) (:background "grey45" :foreground "black" :box (:line-width -1 :style released-button)))))
 '(org-done ((t (:foreground "#899CAA"))))
 '(org-hide ((t (:foreground "#555555"))))
 '(org-level-1 ((t (:foreground "#C41818"))))
 '(org-level-2 ((t (:foreground "#18B218"))))
 '(org-level-3 ((t (:foreground "#1C94D5"))))
 '(org-level-4 ((t nil)))
 '(org-level-5 ((t nil)))
 '(org-level-6 ((t nil)))
 '(org-level-7 ((t nil)))
 '(org-level-8 ((t nil)))
 '(org-link ((((class color) (background light)) (:foreground "#22B2FF" :underline t))))
 '(org-special-keyword ((((class color) (min-colors 16)) (:foreground "#C41818"))))
 '(org-todo ((t (:foreground "FireBrick" :weight bold))))
 '(region ((((class color)) (:background "#B26818" :foreground "#333A3F"))))
 '(rpm-spec-tag-face ((t (:foreground "#1C94D5"))))
 '(scroll-bar ((t nil)))
 '(sh-heredoc ((nil (:inherit font-lock-string-face))))
 '(sh-heredoc-face ((((class color) (background light)) (:foreground "steel blue"))) t)
 '(sh-quoted-exec ((((class color) (background light)) (:foreground "magenta4"))))
 '(shadow ((((class color grayscale) (min-colors 88)) (:foreground "grey40" :slant italic))))
 '(show-paren-match ((((class color)) (:background "DarkMagenta" :foreground "#999999"))))
 '(show-paren-mismatch ((((class color)) (:background "red" :foreground "white"))))
 '(vhdl-font-lock-attribute-face ((((class color) (background light)) (:foreground "DarkOrchid3"))))
 '(vhdl-font-lock-prompt-face ((((class color) (background light)) (:foreground "#18B218" :weight normal)))))

(when (window-system) (my-split-frame-fullscreen))
