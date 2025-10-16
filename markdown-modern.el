;;; markdown-modern.el --- Modern, beautiful Markdown mode with tree-sitter support -*- lexical-binding: t; -*-

;; Copyright (C) 2025 Free Software Foundation, Inc.
;; Author: Claude (Anthropic AI Assistant) <anthropic.ai>
;; Maintainer: Ahmet Usal <ahmetusal@gmail.com>
;; Version: 1.0.0
;; Package-Requires: ((emacs "29.1"))
;; Keywords: markdown, languages, faces, wp
;; URL: https://github.com/ahmetus/markdown-modern

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;;; Commentary:
;;
;; Modern, beautiful Markdown editing experience for Emacs 29+.
;; Like `org-modern`, but for Markdown files.
;;
;; This package enhances Markdown buffers with:
;;
;; - Beautiful bullet symbols (◉ ○ ◆ ▸ • ·) instead of # marks
;; - Hierarchical indentation showing document structure
;; - Hidden markup for **bold** and __bold__ text
;; - Prettified checkboxes: [ ] → ☐, [x] → ☑
;; - Automatic indentation of content, code blocks, tables, lists
;; - Smooth, flicker-free rendering
;; - High performance via tree-sitter (handles 100k+ line files)
;;
;; Requirements:
;; - Emacs 29.1 or later with tree-sitter support
;; - Markdown tree-sitter grammar installed
;;
;; Installation:
;;
;;   (use-package markdown-modern
;;     :hook (markdown-mode . markdown-modern-mode))
;;
;; For more information, see the README at:
;; https://github.com/ahmetusal/markdown-modern

;;; Code:

(require 'treesit)
(eval-and-compile (require 'cl-lib))

;;; Customization

(defgroup markdown-modern nil
  "Tree-sitter powered visual enhancements for Markdown headers.
Requires Emacs 29+ with markdown tree-sitter grammar installed."
  :group 'markdown
  :prefix "markdown-modern-")

(defcustom markdown-modern-bullets
  '("◉" "○" "◆" "▸" "•" "·")
  "List of bullet symbols for Markdown heading levels 1 through 6."
  :type '(repeat string)
  :group 'markdown-modern)

(defcustom markdown-modern-heights
  '(1.4 1.2 1.15 1.11 1.05 1)
  "Font height scaling factors for heading levels 1 through 6."
  :type '(repeat number)
  :group 'markdown-modern)

(defcustom markdown-modern-hierarchical-indent t
  "When non-nil, indent headers based on their hierarchical level."
  :type 'boolean
  :group 'markdown-modern)

(defcustom markdown-modern-indent-width 2
  "Number of spaces to indent per heading level."
  :type 'integer
  :group 'markdown-modern)

(defcustom markdown-modern-indent-code-blocks t
  "When non-nil, indent code blocks to match their parent heading level."
  :type 'boolean
  :group 'markdown-modern)

(defcustom markdown-modern-indent-content t
  "When non-nil, indent paragraphs and lists to match their parent heading.
Set to nil if experiencing performance issues or flickering."
  :type 'boolean
  :group 'markdown-modern)

(defcustom markdown-modern-hide-bold-markup t
  "When non-nil, hide bold delimiters (**text** and __text__)."
  :type 'boolean
  :group 'markdown-modern)

(defcustom markdown-modern-prettify-checkboxes t
  "When non-nil, prettify task list checkboxes.
Replaces [ ] with ☐ and [x]/[X] with ☑."
  :type 'boolean
  :group 'markdown-modern)

(defcustom markdown-modern-checkbox-unchecked "☐"
  "Character to display for unchecked task list items [ ]."
  :type 'string
  :group 'markdown-modern)

(defcustom markdown-modern-checkbox-checked "☑"
  "Character to display for checked task list items [x] or [X]."
  :type 'string
  :group 'markdown-modern)

(defcustom markdown-modern-bottom-spacing 0.2
  "Additional vertical space below heading lines."
  :type 'number
  :group 'markdown-modern)

(defcustom markdown-modern-prettify-list-bullets nil
  "When non-nil, replace leading asterisk (*) list markers with bullets."
  :type 'boolean
  :group 'markdown-modern)

(defcustom markdown-modern-list-bullet "•"
  "Bullet character to display for asterisk (*) list items."
  :type 'string
  :group 'markdown-modern)

(defface markdown-modern-face
  '((t :weight bold))
  "Base face applied to Markdown heading text."
  :group 'markdown-modern)

;;; Internal variables

(defvar-local markdown-modern--parser nil
  "Tree-sitter parser for current buffer (markdown grammar).")

(defvar-local markdown-modern--overlays nil
  "List of all active overlays.")

(defvar-local markdown-modern--last-tick nil
  "Last buffer modification tick when overlays were updated.")

(defvar-local markdown-modern--last-window-start nil
  "Last `window-start' position when visible region was rendered.")

(defvar-local markdown-modern--last-window-end nil
  "Last `window-end' position when visible region was rendered.")

(defvar-local markdown-modern--inhibit-updates nil
  "When non-nil, suppress all overlay updates.")

;;; Tree-sitter queries

(defconst markdown-modern--atx-heading-query
  '((atx_heading) @heading)
  "Tree-sitter query to capture ATX headings (# syntax).")

(defconst markdown-modern--fenced-code-query
  '((fenced_code_block) @code)
  "Tree-sitter query to capture fenced code blocks.")

(defconst markdown-modern--paragraph-query
  '((paragraph) @para)
  "Tree-sitter query to capture paragraphs.")

(defconst markdown-modern--list-query
  '([(tight_list) (loose_list)] @list)
  "Tree-sitter query to capture lists (both tight and loose).")

(defconst markdown-modern--thematic-break-query
  '((thematic_break) @break)
  "Tree-sitter query to capture thematic breaks (horizontal rules).")

(defconst markdown-modern--table-query
  '((table) @table)
  "Tree-sitter query to capture tables.")

;;; Utility functions

(defun markdown-modern--ensure-parser ()
  "Ensure tree-sitter parser exists for current buffer."
  (unless markdown-modern--parser
    (condition-case err
        (setq markdown-modern--parser
              (treesit-parser-create 'markdown))
      (error
       (message "markdown-modern: Failed to create markdown parser: %S" err)
       nil)))
  markdown-modern--parser)

(defun markdown-modern--clear-overlays ()
  "Remove all overlays created by this mode."
  (mapc #'delete-overlay markdown-modern--overlays)
  (setq markdown-modern--overlays nil))

(defun markdown-modern--add-overlay (ov)
  "Register overlay OV for tracking."
  (push ov markdown-modern--overlays))

;;; Header processing

(defun markdown-modern--process-heading (node)
  "Apply overlays to heading NODE."
  (condition-case nil
      (let* ((start (treesit-node-start node))
             (end (treesit-node-end node))
             (text (treesit-node-text node t))
             ;; Extract level from ATX heading
             (level (if (string-match "^\\(#+\\)" text)
                        (min 6 (max 1 (length (match-string 1 text))))
                      1))
             (hash-end (if (string-match "^#+\\s-*" text)
                           (+ start (match-end 0))
                         start))
             (bullet (or (nth (1- level) markdown-modern-bullets) "•"))
             (indent (if markdown-modern-hierarchical-indent
                         (make-string (* (1- level) markdown-modern-indent-width) ?\s)
                       ""))
             (prefix (concat indent bullet " ")))

        ;; Replace hash marks with bullet
        (let ((ov (make-overlay start hash-end)))
          (overlay-put ov 'display prefix)
          (overlay-put ov 'evaporate t)
          (overlay-put ov 'mdh-ts t)
          (markdown-modern--add-overlay ov))

        ;; Apply indentation to heading text
        (when markdown-modern-hierarchical-indent
          (let ((ov (make-overlay hash-end end)))
            (overlay-put ov 'line-prefix indent)
            (overlay-put ov 'wrap-prefix indent)
            (overlay-put ov 'evaporate t)
            (overlay-put ov 'mdh-ts t)
            (markdown-modern--add-overlay ov)))

        ;; Apply bold face to heading text
        (let ((ov (make-overlay hash-end end)))
          (overlay-put ov 'face 'markdown-modern-face)
          (overlay-put ov 'evaporate t)
          (overlay-put ov 'mdh-ts t)
          (markdown-modern--add-overlay ov))

        ;; Bottom spacing
        (when (numberp markdown-modern-bottom-spacing)
          (save-excursion
            (goto-char end)
            (let* ((eol (line-end-position))
                   (nl (and (< eol (point-max)) (1+ eol))))
              (when nl
                (let ((ov (make-overlay eol nl)))
                  (overlay-put ov 'line-spacing markdown-modern-bottom-spacing)
                  (overlay-put ov 'evaporate t)
                  (overlay-put ov 'mdh-ts t)
                  (markdown-modern--add-overlay ov))))))

        level) ; Return level for use by content indentation
    (error nil)))

;;; Content indentation using tree-sitter structure

(defun markdown-modern--get-parent-heading-level (pos)
  "Get the level of the heading that contains POS, or 0 if none."
  (when-let* ((parser (markdown-modern--ensure-parser))
              (root (treesit-parser-root-node parser)))
    (let ((level 0))
      ;; Scan backward from pos to find the most recent heading
      (save-excursion
        (goto-char pos)
        (beginning-of-line)
        (let ((search-limit (max (point-min) (- pos 100000)))) ; Search back 100k chars max
          (while (and (>= (point) search-limit)
                      (not (bobp))
                      (= level 0))
            (when (looking-at "^[ \t]*\\(#+\\)[ \t]*")
              (setq level (min 6 (max 1 (length (match-string 1))))))
            (when (= level 0)
              (forward-line -1)))))
      level)))

(defun markdown-modern--indent-region (start end level)
  "Apply indentation to region START to END based on heading LEVEL."
  (when (and markdown-modern-hierarchical-indent (> level 0))
    (let ((indent-str (make-string (* (1- level) markdown-modern-indent-width) ?\s)))
      (save-excursion
        (goto-char start)
        (while (< (point) end)
          (let ((line-start (line-beginning-position))
                (line-end (line-end-position)))
            ;; Skip blank lines
            (unless (looking-at "^[ \t]*$")
              (let ((ov (make-overlay line-start line-end)))
                (overlay-put ov 'line-prefix indent-str)
                (overlay-put ov 'wrap-prefix indent-str)
                (overlay-put ov 'evaporate t)
                (overlay-put ov 'mdh-ts t)
                (markdown-modern--add-overlay ov)))
            (forward-line 1)))))))

(defun markdown-modern--process-code-block (node)
  "Apply indentation to code block NODE if enabled."
  (when markdown-modern-indent-code-blocks
    (let* ((start (treesit-node-start node))
           (end (treesit-node-end node))
           (level (markdown-modern--get-parent-heading-level start)))
      (markdown-modern--indent-region start end level))))

(defun markdown-modern--process-paragraph (node)
  "Apply indentation to paragraph NODE based on parent heading."
  (let* ((start (treesit-node-start node))
         (end (treesit-node-end node))
         (level (markdown-modern--get-parent-heading-level start)))
    (markdown-modern--indent-region start end level)))

(defun markdown-modern--process-list (node)
  "Apply indentation to list NODE based on parent heading."
  (let* ((start (treesit-node-start node))
         (end (treesit-node-end node))
         (level (markdown-modern--get-parent-heading-level start)))
    (markdown-modern--indent-region start end level)))

(defun markdown-modern--process-thematic-break (node)
  "Apply indentation to break NODE (horizontal rule) based on parent heading."
  (let* ((start (treesit-node-start node))
         (end (treesit-node-end node))
         (level (markdown-modern--get-parent-heading-level start)))
    (markdown-modern--indent-region start end level)))

(defun markdown-modern--process-table (node)
  "Apply indentation to table NODE based on parent heading."
  (let* ((start (treesit-node-start node))
         (end (treesit-node-end node))
         (level (markdown-modern--get-parent-heading-level start)))
    (markdown-modern--indent-region start end level)))

;;; Bold markup hiding (using regex like original - more reliable than tree-sitter inline)

(defun markdown-modern--in-inline-code-p (pos)
  "Check if POS is inside inline code (`code`)."
  (condition-case nil
      (save-excursion
        (goto-char pos)
        (let ((bol (line-beginning-position))
              (eol (line-end-position)))
          (save-excursion
            (goto-char bol)
            (when (re-search-forward "```" eol t)
              (cl-return-from markdown-modern--in-inline-code-p t)))
          (let ((count 0))
            (while (re-search-backward "`" bol t)
              (setq count (1+ count)))
            (cl-oddp count))))
    (error nil)))

(defun markdown-modern--hide-bold-delim (bol eol delim)
  "Hide DELIM pairs between BOL and EOL."
  (save-excursion
    (goto-char bol)
    (let ((delim-len (length delim))
          (pair-count 0))
      (while (and (search-forward delim eol t)
                  (< pair-count 50)) ; Safety limit
        (let ((open (- (point) delim-len)))
          (unless (or (and (> open (point-min))
                           (eq (char-before open) ?\\))
                      (markdown-modern--in-inline-code-p open))
            (when (search-forward delim eol t)
              (let* ((close (- (point) delim-len))
                     (ov1 (make-overlay open (+ open delim-len)))
                     (ov2 (make-overlay close (+ close delim-len))))
                (overlay-put ov1 'display "")
                (overlay-put ov2 'display "")
                (overlay-put ov1 'evaporate t)
                (overlay-put ov2 'evaporate t)
                (overlay-put ov1 'mdh-ts t)
                (overlay-put ov2 'mdh-ts t)
                (overlay-put ov1 'mdh-ts-bold t)  ; Mark as bold overlay
                (overlay-put ov2 'mdh-ts-bold t)  ; Mark as bold overlay
                (markdown-modern--add-overlay ov1)
                (markdown-modern--add-overlay ov2)
                (setq pair-count (1+ pair-count))))))))))

(defun markdown-modern--hide-bold-in-region (start end)
  "Hide bold delimiters (**text** and __text__) in region START to END.
Uses proven regex approach from original package for reliability."
  (when markdown-modern-hide-bold-markup
    (condition-case nil
        (save-excursion
          (goto-char start)
          (let ((line-count 0))
            (while (and (< (point) end)
                        (< line-count 1000)) ; Safety limit
              (let ((bol (line-beginning-position))
                    (eol (line-end-position)))
                ;; Skip code fences
                (unless (save-excursion
                          (goto-char bol)
                          (looking-at "^[ \t]*```"))
                  ;; Hide **...**
                  (markdown-modern--hide-bold-delim bol eol "**")
                  ;; Hide __...__
                  (markdown-modern--hide-bold-delim bol eol "__")))
              (setq line-count (1+ line-count))
              (goto-char (1+ (line-end-position))))))
      (error nil))))

;;; Checkbox prettification

(defun markdown-modern--prettify-checkboxes-in-region (start end)
  "Prettify task list checkboxes in region START to END."
  (when markdown-modern-prettify-checkboxes
    (condition-case nil
        (save-excursion
          (goto-char start)
          (while (re-search-forward "^[ \t]*-[ \t]+\\(\\[[ xX]\\]\\)" end t)
            (let* ((checkbox-start (match-beginning 1))
                   (checkbox-end (match-end 1))
                   (checkbox-text (match-string 1))
                   (is-checked (string-match-p "[xX]" checkbox-text))
                   (replacement (if is-checked
                                    markdown-modern-checkbox-checked
                                  markdown-modern-checkbox-unchecked))
                   (ov (make-overlay checkbox-start checkbox-end)))
              (overlay-put ov 'display replacement)
              (overlay-put ov 'evaporate t)
              (overlay-put ov 'mdh-ts t)
              (overlay-put ov 'mdh-ts-checkbox t)  ; Mark as checkbox overlay
              (markdown-modern--add-overlay ov))))
      (error nil))))

;;; Main update function

(defun markdown-modern--update-visible ()
  "Update overlays for visible region using tree-sitter queries.
Uses smart caching to avoid re-rendering on scroll when content hasn't changed."
  (when (and (not markdown-modern--inhibit-updates)
             (markdown-modern--ensure-parser))
    (let* ((start (window-start))
           (end (window-end nil t))
           (current-tick (buffer-modified-tick))
           (root (treesit-parser-root-node markdown-modern--parser)))

      ;; Only re-render if buffer changed OR we scrolled to a new region
      (when (or (not (eq current-tick markdown-modern--last-tick))
                (not (eq start markdown-modern--last-window-start))
                (not (eq end markdown-modern--last-window-end)))

        (condition-case err
            (progn
              ;; Only clear overlays if buffer changed, not on pure scroll
              ;; Preserve bold and checkbox overlays during clear (they're region-specific)
              (when (not (eq current-tick markdown-modern--last-tick))
                (dolist (ov markdown-modern--overlays)
                  (when (and (overlay-buffer ov)
                             (>= (overlay-end ov) start)
                             (<= (overlay-start ov) end)
                             ;; Don't clear bold/checkbox overlays - they'll be recreated
                             (not (overlay-get ov 'mdh-ts-bold))
                             (not (overlay-get ov 'mdh-ts-checkbox)))
                    (delete-overlay ov)))
                (setq markdown-modern--overlays
                      (cl-remove-if-not #'overlay-buffer markdown-modern--overlays)))

              ;; Process headings
              (dolist (node (treesit-query-capture root markdown-modern--atx-heading-query start end))
                (when (eq (car node) 'heading)
                  (markdown-modern--process-heading (cdr node))))

              ;; Process code blocks
              (when markdown-modern-indent-code-blocks
                (dolist (node (treesit-query-capture root markdown-modern--fenced-code-query start end))
                  (when (eq (car node) 'code)
                    (markdown-modern--process-code-block (cdr node)))))

              ;; Process paragraphs, lists, thematic breaks, and tables (only if content indentation enabled)
              (when (and markdown-modern-hierarchical-indent
                         markdown-modern-indent-content)
                (condition-case nil
                    (progn
                      (dolist (node (treesit-query-capture root markdown-modern--paragraph-query start end))
                        (when (eq (car node) 'para)
                          (markdown-modern--process-paragraph (cdr node))))

                      (dolist (node (treesit-query-capture root markdown-modern--list-query start end))
                        (when (eq (car node) 'list)
                          (markdown-modern--process-list (cdr node))))

                      (dolist (node (treesit-query-capture root markdown-modern--thematic-break-query start end))
                        (when (eq (car node) 'break)
                          (markdown-modern--process-thematic-break (cdr node))))

                      (dolist (node (treesit-query-capture root markdown-modern--table-query start end))
                        (when (eq (car node) 'table)
                          (markdown-modern--process-table (cdr node)))))
                  (error nil)))

              ;; Update cache
              (setq markdown-modern--last-tick current-tick)
              (setq markdown-modern--last-window-start start)
              (setq markdown-modern--last-window-end end)

              ;; Process bold markup hiding and checkbox prettification
              (markdown-modern--hide-bold-in-region start end)
              (markdown-modern--prettify-checkboxes-in-region start end))

          (error
           (message "markdown-modern: Error updating: %S" err)))))))

(defun markdown-modern--update-full ()
  "Update overlays for entire buffer."
  (when (and (not markdown-modern--inhibit-updates)
             (markdown-modern--ensure-parser))
    (condition-case err
        (progn
          (markdown-modern--clear-overlays)
          (let ((root (treesit-parser-root-node markdown-modern--parser)))
            ;; Process all headings
            (dolist (node (treesit-query-capture root markdown-modern--atx-heading-query))
              (when (eq (car node) 'heading)
                (markdown-modern--process-heading (cdr node))))

            ;; Process all code blocks
            (when markdown-modern-indent-code-blocks
              (dolist (node (treesit-query-capture root markdown-modern--fenced-code-query))
                (when (eq (car node) 'code)
                  (markdown-modern--process-code-block (cdr node)))))

            ;; Process all paragraphs, lists, thematic breaks, and tables (only if content indentation enabled)
            (when (and markdown-modern-hierarchical-indent
                       markdown-modern-indent-content)
              (condition-case nil
                  (progn
                    (dolist (node (treesit-query-capture root markdown-modern--paragraph-query))
                      (when (eq (car node) 'para)
                        (markdown-modern--process-paragraph (cdr node))))

                    (dolist (node (treesit-query-capture root markdown-modern--list-query))
                      (when (eq (car node) 'list)
                        (markdown-modern--process-list (cdr node))))

                    (dolist (node (treesit-query-capture root markdown-modern--thematic-break-query))
                      (when (eq (car node) 'break)
                        (markdown-modern--process-thematic-break (cdr node))))

                    (dolist (node (treesit-query-capture root markdown-modern--table-query))
                      (when (eq (car node) 'table)
                        (markdown-modern--process-table (cdr node)))))
                (error nil))))

          ;; Update cache
          (setq markdown-modern--last-tick (buffer-modified-tick))

          ;; Process bold markup hiding and checkbox prettification for full buffer
          (markdown-modern--hide-bold-in-region (point-min) (point-max))
          (markdown-modern--prettify-checkboxes-in-region (point-min) (point-max)))
      (error
       (message "markdown-modern: Error updating full: %S" err)))))

;;; Change tracking

(defun markdown-modern--after-change (&rest _)
  "Handle buffer change with incremental tree-sitter update."
  (when (and (not markdown-modern--inhibit-updates)
             markdown-modern--parser)
    ;; Tree-sitter automatically re-parses incrementally
    ;; Invalidate cache so next scroll will refresh
    (setq markdown-modern--last-tick nil)
    ;; We just need to update visible overlays
    (run-with-idle-timer 0.1 nil
                         (lambda (buf)
                           (when (buffer-live-p buf)
                             (with-current-buffer buf
                               (markdown-modern--update-visible))))
                         (current-buffer))))

(defun markdown-modern--on-scroll (&rest _)
  "Handle window scroll events."
  (when markdown-modern--parser
    (run-with-idle-timer 0.05 nil
                         (lambda (buf)
                           (when (buffer-live-p buf)
                             (with-current-buffer buf
                               (markdown-modern--update-visible))))
                         (current-buffer))))

;;; Interactive commands

(defvar markdown-modern-mode)  ; Forward declaration for interactive commands

(defun markdown-modern-refresh ()
  "Force full buffer refresh."
  (interactive)
  (when markdown-modern-mode
    (markdown-modern--update-full)))

(defun markdown-modern-status ()
  "Show current status."
  (interactive)
  (message "MDM: %s | Parser: %s | Overlays: %d | TreeSitter: %s"
           (if markdown-modern-mode "ON" "OFF")
           (if markdown-modern--parser "active" "none")
           (length markdown-modern--overlays)
           (if (treesit-available-p) "available" "not available")))

;;; Minor mode definition

(defun markdown-modern--setup ()
  "Setup mode."
  (when (treesit-available-p)
    (condition-case err
        (progn
          (setq markdown-modern--inhibit-updates nil)
          (markdown-modern--ensure-parser)
          ;; No need for inline parser anymore - using regex for bold
          (markdown-modern--update-full)
          (add-hook 'after-change-functions #'markdown-modern--after-change nil t)
          (add-hook 'window-scroll-functions #'markdown-modern--on-scroll nil t))
      (error
       (message "markdown-modern: Setup error: %S" err)))))

(defun markdown-modern--teardown ()
  "Teardown mode."
  (setq markdown-modern--inhibit-updates t)
  (remove-hook 'after-change-functions #'markdown-modern--after-change t)
  (remove-hook 'window-scroll-functions #'markdown-modern--on-scroll t)
  (markdown-modern--clear-overlays)
  (when markdown-modern--parser
    (condition-case nil
        (treesit-parser-delete markdown-modern--parser)
      (error nil))
    (setq markdown-modern--parser nil)))

;;;###autoload
(define-minor-mode markdown-modern-mode
  "Modern, beautiful Markdown editing with tree-sitter.
Enhances Markdown buffers with beautiful bullets, hierarchical indentation,
hidden markup, and prettified elements.  Like `org-modern` for Markdown.

Requires Emacs 29+ with markdown tree-sitter grammar installed."
  :lighter " ✎"
  :group 'markdown-modern
  (if markdown-modern-mode
      (if (not (treesit-available-p))
          (progn
            (setq markdown-modern-mode nil)
            (message "markdown-modern requires Emacs 29+ with tree-sitter support"))
        (if (not (treesit-language-available-p 'markdown))
            (progn
              (setq markdown-modern-mode nil)
              (message "markdown-modern requires markdown tree-sitter grammar"))
          (markdown-modern--setup)))
    (markdown-modern--teardown)))

;;; Setup helper for markdown-mode

;;;###autoload
(defun markdown-modern-setup ()
  "Recommended setup for markdown-mode."
  (interactive)
  (when (and (derived-mode-p 'markdown-mode)
             (treesit-available-p)
             (treesit-language-available-p 'markdown))
    (markdown-modern-mode 1)))

;; Auto-enable in markdown-mode if desired
;; (add-hook 'markdown-mode-hook #'markdown-modern-setup)

(provide 'markdown-modern)
;;; markdown-modern.el ends here
