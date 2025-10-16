# Changelog

All notable changes to `markdown-modern` will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2025-01-16

### Added - Initial Release

#### Core Features
- Beautiful bullet symbols for headings (◉ ○ ◆ ▸ • ·)
- Hierarchical indentation for document structure
- Tree-sitter powered parsing for high performance
- Hidden markup for bold text (`**text**` and `__text__`)
- Checkbox prettification (`[ ]` → ☐, `[x]` → ☑)
- Smart indentation for all content types:
  - Paragraphs
  - Lists (tight and loose)
  - Code blocks (fenced)
  - Tables
  - Thematic breaks (horizontal rules)

#### Performance Features
- Smart scroll caching (zero re-rendering on pure scroll)
- Incremental tree-sitter parsing
- Handles 100k+ line files smoothly
- Constant-time complexity regardless of file size

#### Customization
- 14 customization variables
- Configurable bullet symbols
- Toggle-able features
- Adjustable indentation width
- Per-feature enable/disable

#### Technical Highlights
- 651 lines of code
- 25 functions
- Zero dependencies except tree-sitter grammars
- Clean, maintainable architecture
- Proper error handling with condition-case
- Overlay-based rendering with smart caching

### Architecture

**Tree-sitter Integration**
- Uses Emacs 29+ native tree-sitter support
- Queries: ATX headings, code blocks, paragraphs, lists, tables, thematic breaks
- Incremental parsing automatically handled by tree-sitter

**Overlay Management**
- Type-based overlay preservation (bold, checkbox, structural)
- Smart clearing logic
- Evaporating overlays for automatic cleanup

**Performance Optimizations**
- Buffer modification tick tracking
- Window position caching
- Conditional re-rendering
- Region-specific processing

## Acknowledgments

This package was created with collaboration between:
- **Claude** (Anthropic AI Assistant) - Primary development
- **Ahmet Usal** - Testing, feedback, and design requirements

Inspired by `org-modern` by @minad.

## Migration Notes

This is the first stable release. If you were using the development version
(`markdown-modern-headers-ts.el`), migration is automatic - just update
to the new package name.

### Variable Renames

All variables have been renamed from `markdown-modern-headers-ts-*` to `markdown-modern-*`:

```elisp
;; Old → New
markdown-modern-headers-ts-bullets              → markdown-modern-bullets
markdown-modern-headers-ts-hide-bold-markup     → markdown-modern-hide-bold-markup
markdown-modern-headers-ts-hierarchical-indent  → markdown-modern-hierarchical-indent
markdown-modern-headers-ts-indent-width         → markdown-modern-indent-width
```

## Future Plans

### Version 1.1.0 (Planned)
- Font height scaling per heading level
- Customizable heading faces
- Export-friendly overlay management

### Version 1.2.0 (Planned)
- Setext heading support (underlined headers)
- Quote block styling
- Configurable checkbox symbols

### Version 2.0.0 (Planned)
- Integration with markdown-mode font-lock
- Optional heading folding
- Custom tree-sitter queries via configuration

---

[Unreleased]: https://github.com/ahmetusal/markdown-modern/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/ahmetusal/markdown-modern/releases/tag/v1.0.0
