# markdown-modern.el

Modern, beautiful Markdown editing for Emacs. Like `org-modern`, but for Markdown.

[![MELPA](https://melpa.org/packages/markdown-modern-badge.svg)](https://melpa.org/#/markdown-modern)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

## Features

- **Beautiful Bullets** - Replace `#` marks with elegant symbols (◉ ○ ◆ ▸ • ·)
- **Hierarchical Indentation** - Visual document structure for headers and content
- **Hidden Markup** - Hide `**bold**` and `__bold__` delimiters while keeping text bold
- **Checkbox Prettification** - `[ ]` → ☐, `[x]` → ☑
- **Smart Indentation** - Automatic indentation for paragraphs, lists, tables, code blocks
- **High Performance** - Tree-sitter powered, handles 100k+ line files smoothly
- **Zero Flickering** - Smooth rendering with smart caching

## Requirements

- Emacs 29.1 or later (with tree-sitter support)
- Markdown tree-sitter grammar

### Installing Tree-sitter Grammar

```elisp
M-x treesit-install-language-grammar RET markdown RET
```

Or with `treesit-auto`:
```elisp
(use-package treesit-auto
  :config
  (global-treesit-auto-mode))
```

## Installation

### Requirements

- Emacs 29.1 or later (with tree-sitter support)
- Markdown tree-sitter grammar

### Installing Tree-sitter Grammar

The package requires the markdown tree-sitter grammar. Install it with:

```elisp
M-x treesit-install-language-grammar RET markdown RET
```

Or automatically with `treesit-auto`:
```elisp
(use-package treesit-auto
  :ensure t
  :config
  (global-treesit-auto-mode))
```

### Method 1: From MELPA (Recommended, after approval)

Once approved on MELPA:

```elisp
(use-package markdown-modern
  :ensure t
  :hook (markdown-mode . markdown-modern-mode))
```

### Method 2: Using straight.el

```elisp
(use-package markdown-modern
  :straight (:host github :repo "ahmetus/markdown-modern")
  :hook (markdown-mode . markdown-modern-mode))
```

### Method 3: Using use-package with :vc (Emacs 30+)

For Emacs 30+ with built-in `use-package`:

```elisp
(use-package markdown-modern
  :vc (:url "https://github.com/ahmetus/markdown-modern"
       :rev :newest)
  :hook (markdown-mode . markdown-modern-mode))
```

### Method 4: Manual Installation from Git

1. Clone the repository:
```bash
cd ~/.emacs.d
git clone https://github.com/ahmetus/markdown-modern.git
```

2. Add to your Emacs configuration:
```elisp
(add-to-list 'load-path "~/.emacs.d/markdown-modern")
(require 'markdown-modern)
(add-hook 'markdown-mode-hook #'markdown-modern-mode)
```

### Method 5: Manual Installation (Download)

1. Download `markdown-modern.el` from the [latest release](https://github.com/ahmetus/markdown-modern/releases)

2. Place it in your Emacs load path (e.g., `~/.emacs.d/lisp/` or `~/.emacs.d/site-lisp/`)

3. Add to your configuration:
```elisp
(add-to-list 'load-path "~/.emacs.d/lisp")  ; or your chosen directory
(require 'markdown-modern)
(add-hook 'markdown-mode-hook #'markdown-modern-mode)
```

### Verifying Installation

After installation, verify everything works:

```elisp
;; Check Emacs version (need 29.1+)
M-x emacs-version

;; Check tree-sitter support
M-: (treesit-available-p)  ; Should return t

;; Check markdown grammar
M-: (treesit-language-available-p 'markdown)  ; Should return t

;; Test the mode
M-x markdown-mode
M-x markdown-modern-mode
```

If you see the mode lighter "✎" in the mode line, you're all set!

## Quick Start

After installation, open any Markdown file and enable the mode:

```elisp
M-x markdown-modern-mode
```

Or enable it automatically for all Markdown files:

```elisp
(add-hook 'markdown-mode-hook #'markdown-modern-mode)
```

### First Time Setup

1. **Install tree-sitter grammar** (one-time):
   ```elisp
   M-x treesit-install-language-grammar RET markdown RET
   ```

2. **Load the package** (add to your init.el):
   ```elisp
   ;; Using use-package
   (use-package markdown-modern
     :hook (markdown-mode . markdown-modern-mode))
   
   ;; Or manually
   (require 'markdown-modern)
   (add-hook 'markdown-mode-hook #'markdown-modern-mode)
   ```

3. **Open a Markdown file** and enjoy the modern view!

## Configuration

### Basic Setup

```elisp
(use-package markdown-modern
  :hook (markdown-mode . markdown-modern-mode)
  :config
  ;; Customize bullet symbols
  (setq markdown-modern-bullets '("◉" "○" "◆" "▸" "•" "·"))
  
  ;; Enable all features
  (setq markdown-modern-hide-bold-markup t)
  (setq markdown-modern-prettify-checkboxes t)
  (setq markdown-modern-hierarchical-indent t))
```

### Customization Options

| Variable | Default | Description |
|----------|---------|-------------|
| `markdown-modern-bullets` | `'("◉" "○" "◆" "▸" "•" "·")` | Bullet symbols for heading levels |
| `markdown-modern-hide-bold-markup` | `t` | Hide `**bold**` delimiters |
| `markdown-modern-prettify-checkboxes` | `t` | Prettify task list checkboxes |
| `markdown-modern-hierarchical-indent` | `t` | Enable hierarchical indentation |
| `markdown-modern-indent-width` | `2` | Indentation width per level |
| `markdown-modern-indent-code-blocks` | `t` | Indent code blocks |
| `markdown-modern-indent-content` | `t` | Indent paragraphs and lists |

### Performance Tuning

For very large files (100k+ lines):

```elisp
;; Disable content indentation for maximum speed
(setq markdown-modern-indent-content nil)
```

## Usage

Once enabled, `markdown-modern-mode` automatically enhances your Markdown buffers:

```markdown
# Level 1 Heading          →  ◉ Level 1 Heading
  Content indented              Content indented
  
  ## Level 2 Heading       →    ○ Level 2 Heading
    More content                  More content indented
    
    **bold text**          →      bold text (no delimiters)
    
    - [ ] Todo item        →      - ☐ Todo item
    - [x] Done item        →      - ☑ Done item
```

### Interactive Commands

- `M-x markdown-modern-mode` - Toggle the mode
- `M-x markdown-modern-refresh` - Force buffer refresh
- `M-x markdown-modern-status` - Show current status

## Comparison with org-modern

| Feature | org-modern | markdown-modern |
|---------|------------|-----------------|
| Target | Org files | Markdown files |
| Bullets | ✓ | ✓ |
| Hide markup | ✓ | ✓ |
| Checkboxes | ✓ | ✓ |
| Indentation | ✓ | ✓ |
| Performance | High | High (tree-sitter) |

## Troubleshooting

### Mode doesn't enable

Check requirements:
```elisp
M-x emacs-version  ; Should be 29.1+
M-: (treesit-available-p)  ; Should return t
M-: (treesit-language-available-p 'markdown)  ; Should return t
```

### Performance issues

1. Disable content indentation: `(setq markdown-modern-indent-content nil)`
2. Reduce features: `(setq markdown-modern-hide-bold-markup nil)`
3. Check for conflicting modes

## Contributing

Contributions welcome! Please:

1. Check existing issues
2. Open an issue to discuss major changes
3. Follow existing code style
4. Add tests if applicable
5. Update documentation

## License

GPL-3.0 - See LICENSE file

## Credits

- **Author**: Claude (Anthropic AI Assistant)
- **Maintainer**: Ahmet Usal
- **Inspiration**: `org-modern` by @minad
- **Technology**: Emacs tree-sitter (Emacs 29+)

## Related Packages

- [markdown-mode](https://github.com/jrblevin/markdown-mode) - Major mode for Markdown
- [org-modern](https://github.com/minad/org-modern) - Modern Org styling (inspiration)
- [markdown-toc](https://github.com/ardumont/markdown-toc) - Table of contents generation

---

**Enjoy beautiful, modern Markdown editing in Emacs!** ✨
