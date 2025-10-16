# markdown-modern Quick Start

## Installation (Choose One Method)

### Using straight.el (Recommended for pre-MELPA)

```elisp
(use-package markdown-modern
  :straight (:host github :repo "ahmetus/markdown-modern")
  :hook (markdown-mode . markdown-modern-mode))
```

### Using use-package :vc (Emacs 30+)

```elisp
(use-package markdown-modern
  :vc (:url "https://github.com/ahmetus/markdown-modern"
       :rev :newest)
  :hook (markdown-mode . markdown-modern-mode))
```

### Manual (Git Clone)

```bash
cd ~/.emacs.d
git clone https://github.com/ahmetus/markdown-modern.git
```

Then add to init.el:
```elisp
(add-to-list 'load-path "~/.emacs.d/markdown-modern")
(require 'markdown-modern)
(add-hook 'markdown-mode-hook #'markdown-modern-mode)
```

### From MELPA (After Approval)

```elisp
(use-package markdown-modern
  :ensure t
  :hook (markdown-mode . markdown-modern-mode))
```

## Required: Install Tree-sitter Grammar

**One-time setup** (required for all installation methods):

```elisp
M-x treesit-install-language-grammar RET markdown RET
```

## Test It Right Now (2 minutes)

```elisp
;; 1. Load the package
(load-file "~/.emacs.d/markdown-modern/markdown-modern.el")

;; 2. Open test file
(find-file "~/.emacs.d/markdown-modern/test-complete-features.md")

;; 3. Enable the mode
(markdown-modern-mode 1)

;; 4. Check status
(markdown-modern-status)
```

## What You Should See

- `# Header` → `◉ Header` (beautiful bullet)
- Content indented according to heading level
- `**bold text**` → `bold text` (no delimiters)
- `[ ]` → ☐ (unchecked box)
- `[x]` → ☑ (checked box)
- Tables, lists, code blocks all indented
- Smooth scrolling, no flickering

## Add to Your Config

```elisp
;; Add to ~/.emacs.d/init.el
(add-to-list 'load-path "~/.emacs.d/markdown-modern")
(require 'markdown-modern)
(add-hook 'markdown-mode-hook #'markdown-modern-mode)
```

## Customize

```elisp
;; Change bullet symbols
(setq markdown-modern-bullets '("●" "○" "◆" "◇" "▸" "▹"))

;; Adjust indentation
(setq markdown-modern-indent-width 3)

;; Disable features if needed
(setq markdown-modern-hide-bold-markup nil)
(setq markdown-modern-indent-content nil)
```

## Troubleshooting

### Mode doesn't work
- Check Emacs version: `M-x emacs-version` (need 29.1+)
- Check tree-sitter: `M-: (treesit-available-p)` (should return t)
- Install grammar: `M-x treesit-install-language-grammar RET markdown RET`

### Performance issues
```elisp
;; For very large files, disable some features:
(setq markdown-modern-indent-content nil)
```

## Next Steps

1. Test with your own Markdown files
2. Adjust customizations to your taste
3. Report any issues
4. Share feedback!

---

**Enjoy!** ✨
