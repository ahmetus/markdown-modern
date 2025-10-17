# Badges for markdown-modern

## Current Badges (In README)

### License Badge
```markdown
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
```
- **Status**: ✅ Active now
- **Source**: shields.io (static badge)
- **Purpose**: Shows GPL-3.0 license

### GitHub Release Badge
```markdown
[![GitHub release](https://img.shields.io/github/v/release/ahmetus/markdown-modern)](https://github.com/ahmetus/markdown-modern/releases)
```
- **Status**: ✅ Active after you create v1.0.0 release
- **Source**: shields.io (GitHub API)
- **Purpose**: Shows latest release version

## After MELPA Acceptance

### MELPA Badge
```markdown
[![MELPA](https://melpa.org/packages/markdown-modern-badge.svg)](https://melpa.org/#/markdown-modern)
```
- **Status**: ⏳ Add AFTER MELPA approval
- **Source**: melpa.org (auto-generated)
- **Purpose**: Shows package is on MELPA
- **Timing**: Available ~1 hour after PR merge

### MELPA Stable Badge (Optional)
```markdown
[![MELPA Stable](https://stable.melpa.org/packages/markdown-modern-badge.svg)](https://stable.melpa.org/#/markdown-modern)
```
- **Status**: ⏳ Add after first stable release
- **Source**: stable.melpa.org
- **Purpose**: Shows package is on MELPA Stable
- **Requirement**: Must have tagged release (v1.0.0)

## Optional Additional Badges

### Build Status (If you add CI)
```markdown
[![CI](https://github.com/ahmetus/markdown-modern/workflows/CI/badge.svg)](https://github.com/ahmetus/markdown-modern/actions)
```
- **Requires**: GitHub Actions workflow
- **Purpose**: Shows tests passing

### Emacs Version
```markdown
[![Emacs](https://img.shields.io/badge/Emacs-29.1+-purple.svg)](https://www.gnu.org/software/emacs/)
```
- **Status**: ✅ Can add now
- **Source**: shields.io (static)
- **Purpose**: Shows minimum Emacs version

### Made With
```markdown
[![Made with Tree-sitter](https://img.shields.io/badge/Made%20with-Tree--sitter-orange.svg)](https://tree-sitter.github.io/)
```
- **Status**: ✅ Can add now
- **Source**: shields.io (static)
- **Purpose**: Highlights tree-sitter usage

## How MELPA Badges Work

### Automatic Generation
1. After your PR is merged to MELPA
2. MELPA's build system generates your package
3. Badge SVG is automatically created at:
   - `https://melpa.org/packages/markdown-modern-badge.svg`
4. Usually available within 1 hour of merge

### Badge Updates
- **MELPA badge**: Updates when package version changes
- **No action needed**: Completely automatic

### When to Add
```markdown
# After MELPA acceptance, update README.md:

# Before (current):
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

# After MELPA acceptance:
[![MELPA](https://melpa.org/packages/markdown-modern-badge.svg)](https://melpa.org/#/markdown-modern)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
```

## Recommended Badge Set

### For Now (Before MELPA)
```markdown
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![GitHub release](https://img.shields.io/github/v/release/ahmetus/markdown-modern)](https://github.com/ahmetus/markdown-modern/releases)
[![Emacs](https://img.shields.io/badge/Emacs-29.1+-purple.svg)](https://www.gnu.org/software/emacs/)
```

### After MELPA Acceptance
```markdown
[![MELPA](https://melpa.org/packages/markdown-modern-badge.svg)](https://melpa.org/#/markdown-modern)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![GitHub release](https://img.shields.io/github/v/release/ahmetus/markdown-modern)](https://github.com/ahmetus/markdown-modern/releases)
[![Emacs](https://img.shields.io/badge/Emacs-29.1+-purple.svg)](https://www.gnu.org/software/emacs/)
```

### Full Set (With CI, optional)
```markdown
[![MELPA](https://melpa.org/packages/markdown-modern-badge.svg)](https://melpa.org/#/markdown-modern)
[![MELPA Stable](https://stable.melpa.org/packages/markdown-modern-badge.svg)](https://stable.melpa.org/#/markdown-modern)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![CI](https://github.com/ahmetus/markdown-modern/workflows/CI/badge.svg)](https://github.com/ahmetus/markdown-modern/actions)
[![Emacs](https://img.shields.io/badge/Emacs-29.1+-purple.svg)](https://www.gnu.org/software/emacs/)
```

## Testing Badges

Before committing, test that badge URLs work:

```bash
# Test license badge
curl -I https://img.shields.io/badge/License-GPLv3-blue.svg

# Test GitHub release badge (after creating release)
curl -I https://img.shields.io/github/v/release/ahmetus/markdown-modern

# MELPA badge (after acceptance only)
curl -I https://melpa.org/packages/markdown-modern-badge.svg
```

All should return `200 OK`.

## Badge Placement in README

### Standard Position
Place badges right after the title and description:

```markdown
# markdown-modern.el

Modern, beautiful Markdown editing for Emacs.

[BADGES HERE]

## Features
...
```

### Badge Order Convention
1. MELPA (most important for Emacs packages)
2. License
3. Version/Release
4. CI/Build Status
5. Other metadata (Emacs version, etc.)

## Timeline

```
Now:
  ✅ License badge
  ✅ GitHub release badge (after v1.0.0 release)
  
After GitHub push:
  ✅ All GitHub-based badges work
  
After MELPA acceptance (~1 week):
  ✅ Add MELPA badge
  ✅ Badge auto-updates with package
  
After first stable release:
  ✅ Add MELPA Stable badge (optional)
```

## Summary

**Current README**: License + GitHub Release badges  
**After MELPA**: Add MELPA badge (just update one line)  
**Process**: Completely automatic once on MELPA  
**No custom SVG needed**: MELPA generates it for you
