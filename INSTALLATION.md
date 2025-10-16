# Installation Guide for markdown-modern

Complete installation instructions for all methods.

## Prerequisites

**Required:**
- Emacs 29.1 or later
- Tree-sitter support enabled
- Markdown tree-sitter grammar

**Check your setup:**
```elisp
;; Check Emacs version (need 29.1+)
M-x emacs-version

;; Check tree-sitter is available
M-: (treesit-available-p)
;; Should return: t

;; Check if markdown grammar is installed
M-: (treesit-language-available-p 'markdown)
;; Should return: t (if already installed)
```

## Step 1: Install Tree-sitter Grammar

**This is required for all installation methods.**

### Method A: Interactive Installation (Easiest)

```elisp
M-x treesit-install-language-grammar RET markdown RET
```

When prompted, use:
- URL: `https://github.com/tree-sitter-grammars/tree-sitter-markdown`
- Branch: Leave empty (uses default)

### Method B: Using treesit-auto (Automatic)

```elisp
(use-package treesit-auto
  :ensure t
  :config
  (global-treesit-auto-mode))
```

This will automatically install and manage all tree-sitter grammars.

### Method C: Manual Grammar Installation

```bash
# Clone the grammar
cd /tmp
git clone https://github.com/tree-sitter-grammars/tree-sitter-markdown
cd tree-sitter-markdown

# Build (requires C compiler)
cd tree-sitter-markdown/src
cc -shared -o libtree-sitter-markdown.so parser.c scanner.c -I. -fPIC -O2

# Install
mkdir -p ~/.emacs.d/tree-sitter
cp libtree-sitter-markdown.so ~/.emacs.d/tree-sitter/
```

## Step 2: Install markdown-modern Package

Choose the method that fits your workflow:

---

### 🔵 Method 1: straight.el (Recommended for pre-MELPA)

**Best for:** Users already using straight.el

```elisp
(use-package markdown-modern
  :straight (:host github :repo "ahmetus/markdown-modern")
  :hook (markdown-mode . markdown-modern-mode)
  :config
  ;; Optional customizations
  (setq markdown-modern-hide-bold-markup t
        markdown-modern-prettify-checkboxes t))
```

**To update later:**
```elisp
M-x straight-pull-package RET markdown-modern RET
M-x straight-rebuild-package RET markdown-modern RET
```

---

### 🟢 Method 2: use-package with :vc (Emacs 30+)

**Best for:** Emacs 30+ users with built-in `use-package`

```elisp
(use-package markdown-modern
  :vc (:url "https://github.com/ahmetus/markdown-modern"
       :rev :newest)
  :hook (markdown-mode . markdown-modern-mode))
```

**To update later:**
```elisp
M-x package-vc-update RET markdown-modern RET
```

---

### 🟡 Method 3: Manual Git Clone

**Best for:** Users who prefer full control

#### Step 2.1: Clone Repository

```bash
cd ~/.emacs.d
git clone https://github.com/ahmetus/markdown-modern.git
```

#### Step 2.2: Add to Configuration

Add to your `~/.emacs.d/init.el` or `~/.config/emacs/init.el`:

```elisp
;; Add to load path
(add-to-list 'load-path "~/.emacs.d/markdown-modern")

;; Load the package
(require 'markdown-modern)

;; Enable for markdown files
(add-hook 'markdown-mode-hook #'markdown-modern-mode)

;; Optional: Customize
(setq markdown-modern-hide-bold-markup t)
(setq markdown-modern-prettify-checkboxes t)
(setq markdown-modern-hierarchical-indent t)
```

#### Step 2.3: Update Later

```bash
cd ~/.emacs.d/markdown-modern
git pull origin main
```

Then restart Emacs or `M-x eval-buffer` your init file.

---

### 🟠 Method 4: Manual Download

**Best for:** Minimal setup, single-file installation

#### Step 2.1: Download File

Visit: https://github.com/ahmetus/markdown-modern/releases/latest

Download: `markdown-modern.el`

#### Step 2.2: Place File

```bash
# Create directory if needed
mkdir -p ~/.emacs.d/lisp

# Move the downloaded file
mv ~/Downloads/markdown-modern.el ~/.emacs.d/lisp/
```

#### Step 2.3: Add to Configuration

```elisp
;; Add directory to load path
(add-to-list 'load-path "~/.emacs.d/lisp")

;; Load and enable
(require 'markdown-modern)
(add-hook 'markdown-mode-hook #'markdown-modern-mode)
```

---

### 🔴 Method 5: From MELPA (After Approval)

**Best for:** Most users (standard Emacs package management)

**Note:** This method will be available after MELPA approval.

#### Using use-package:

```elisp
(use-package markdown-modern
  :ensure t
  :hook (markdown-mode . markdown-modern-mode))
```

#### Using package.el directly:

```elisp
M-x package-refresh-contents RET
M-x package-install RET markdown-modern RET
```

Then add to init.el:
```elisp
(add-hook 'markdown-mode-hook #'markdown-modern-mode)
```

---

## Step 3: Verify Installation

### Test 1: Check Package Loaded

```elisp
M-: (featurep 'markdown-modern)
;; Should return: t
```

### Test 2: Open Markdown File

```elisp
;; Create test file
C-x C-f ~/test.md RET

;; Add some content (type or paste):
# Header 1
**Bold text** here

- [ ] Todo item
- [x] Done item

## Header 2
Some content here
```

### Test 3: Enable Mode

```elisp
M-x markdown-modern-mode
```

### Test 4: Verify Features

You should see:
- ✅ `# Header 1` displays as `◉ Header 1`
- ✅ `**Bold text**` shows as `Bold text` (no asterisks)
- ✅ `[ ]` displays as `☐`
- ✅ `[x]` displays as `☑`
- ✅ Content is indented hierarchically
- ✅ Mode lighter `✎` appears in mode line

### Test 5: Check Status

```elisp
M-x markdown-modern-status
```

Should show:
```
MDM: ON | Parser: active | Overlays: <number> | TreeSitter: available
```

---

## Troubleshooting

### Issue: "treesit not available"

**Solution:** Your Emacs wasn't built with tree-sitter support.

Check:
```bash
emacs --version
# Should be 29.1 or later

# Check compilation flags
M-: (treesit-available-p)
```

If `nil`, you need to:
- Install tree-sitter library: `sudo apt install libtree-sitter-dev` (Ubuntu/Debian)
- Rebuild Emacs with `--with-tree-sitter` flag
- Or install pre-built Emacs with tree-sitter support

### Issue: "markdown grammar not available"

**Solution:** Grammar not installed or not in load path.

Try:
```elisp
;; Force install
M-x treesit-install-language-grammar RET markdown RET

;; Check path
M-: treesit-extra-load-path
;; Should include ~/.emacs.d/tree-sitter/

;; Verify file exists
M-: (file-exists-p "~/.emacs.d/tree-sitter/libtree-sitter-markdown.so")
;; Should return t
```

### Issue: Mode enables but no visual changes

**Solution:** Check markdown-mode is active first.

```elisp
;; Ensure markdown-mode is loaded
M-x markdown-mode

;; Then enable markdown-modern
M-x markdown-modern-mode

;; Check mode is active
M-: markdown-modern-mode
;; Should return t
```

### Issue: "Package not found" (straight.el)

**Solution:** Check GitHub URL and network.

```elisp
;; Update recipes
M-x straight-pull-all

;; Try rebuilding
M-x straight-rebuild-package RET markdown-modern RET
```

### Issue: Performance problems on large files

**Solution:** Disable some features.

```elisp
;; Disable content indentation
(setq markdown-modern-indent-content nil)

;; Or disable bold hiding
(setq markdown-modern-hide-bold-markup nil)
```

---

## Updating

### straight.el
```elisp
M-x straight-pull-package RET markdown-modern RET
M-x straight-rebuild-package RET markdown-modern RET
```

### use-package :vc
```elisp
M-x package-vc-update RET markdown-modern RET
```

### Manual Git
```bash
cd ~/.emacs.d/markdown-modern
git pull origin main
```
Then restart Emacs.

### MELPA
```elisp
M-x package-refresh-contents
M-x package-reinstall RET markdown-modern RET
```

---

## Uninstalling

### straight.el
```elisp
M-x straight-remove-package RET markdown-modern RET
```

### use-package :vc / MELPA
```elisp
M-x package-delete RET markdown-modern RET
```

### Manual
```bash
rm -rf ~/.emacs.d/markdown-modern  # or ~/.emacs.d/lisp/markdown-modern.el
```

Then remove configuration from init.el.

---

## Next Steps

- Read [README.md](README.md) for features and configuration
- Check [QUICKSTART.md](QUICKSTART.md) for quick examples
- See [CHANGELOG.md](CHANGELOG.md) for version history

---

**Need help?** Open an issue: https://github.com/ahmetus/markdown-modern/issues
