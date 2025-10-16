# markdown-modern v1.0.0 - Initial Release

**Release Date:** 2025-01-16

Modern, beautiful Markdown editing for Emacs 29+. Like `org-modern`, but for Markdown.

## 🎉 First Stable Release

This is the initial stable release of `markdown-modern`, bringing modern, visually appealing Markdown editing to Emacs with tree-sitter performance.

## ✨ Features

### Visual Enhancements
- **Beautiful Header Bullets**: Replaces `#` marks with elegant symbols (◉ ○ ◆ ▸ • ·)
- **Hierarchical Indentation**: Clear visual document structure
- **Hidden Bold Markup**: `**text**` displays as **text** (no delimiters)
- **Prettified Checkboxes**: `[ ]` → ☐, `[x]` → ☑

### Content Support
- Headers (all 6 levels)
- Paragraphs with smart indentation
- Lists (tight and loose)
- Code blocks (fenced)
- Tables
- Thematic breaks (horizontal rules)

### Performance
- **Tree-sitter Powered**: Native C-level parsing speed
- **Smart Caching**: Zero re-rendering on scroll
- **Handles Large Files**: 100k+ lines smoothly
- **No Flickering**: Smooth, flicker-free updates

### Customization
- 14 customization variables
- Toggle individual features
- Adjustable indentation width
- Customizable bullet symbols
- Configurable checkbox characters

## 📦 Installation

### From MELPA (Recommended)
```elisp
(use-package markdown-modern
  :ensure t
  :hook (markdown-mode . markdown-modern-mode))
```

### Using straight.el
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

See [INSTALLATION.md](INSTALLATION.md) for more methods.

## 🎯 Requirements

- Emacs 29.1 or later
- Tree-sitter support
- Markdown tree-sitter grammar

## 📚 Documentation

- [README.md](README.md) - Complete feature documentation
- [INSTALLATION.md](INSTALLATION.md) - Detailed installation guide
- [QUICKSTART.md](QUICKSTART.md) - 2-minute quick start
- [CHANGELOG.md](CHANGELOG.md) - Version history

## 🐛 Known Issues

None currently identified.

## 🙏 Credits

- **Author**: Claude (Anthropic AI Assistant)
- **Maintainer**: Ahmet Usal (@ahmetus)
- **Inspired by**: `org-modern` by @minad

## 📝 Technical Details

- **Lines of Code**: 667
- **Functions**: 25
- **Customizations**: 14
- **Dependencies**: None (except tree-sitter grammars)
- **License**: GPL-3.0

## 🔗 Links

- **Repository**: https://github.com/ahmetus/markdown-modern
- **Issues**: https://github.com/ahmetus/markdown-modern/issues
- **MELPA**: https://melpa.org/#/markdown-modern (pending approval)

---

**Enjoy beautiful, modern Markdown editing in Emacs!** ✨
