# MELPA Submission Guide

Complete guide to submitting markdown-modern to MELPA.

## Prerequisites

✅ GitHub repository published: https://github.com/ahmetus/markdown-modern  
✅ v1.0.0 release created  
✅ Package tested and working  
✅ All files committed

## Step 1: Fork MELPA Repository

1. Go to: https://github.com/melpa/melpa
2. Click "Fork" button (top right)
3. Wait for fork to complete

## Step 2: Clone Your Fork

```bash
cd ~/projects  # or your preferred location
git clone https://github.com/ahmetus/melpa.git
cd melpa
```

## Step 3: Create Recipe File

```bash
# Create the recipe
cat > recipes/markdown-modern << 'RECIPE'
(markdown-modern :fetcher github
                 :repo "ahmetus/markdown-modern"
                 :files ("*.el"))
RECIPE
```

### Recipe Explanation

- `markdown-modern` - Package name
- `:fetcher github` - Use GitHub as source
- `:repo "ahmetus/markdown-modern"` - Your repository
- `:files ("*.el")` - Include all .el files

## Step 4: Test Recipe Locally

```bash
# From melpa directory
make recipes/markdown-modern
```

Expected output:
```
Wrote /tmp/markdown-modern-.../*.el
```

If you see errors, fix them before proceeding.

## Step 5: Commit Recipe

```bash
git add recipes/markdown-modern
git commit -m "Add markdown-modern recipe

Modern, beautiful Markdown editing for Emacs.

Like org-modern, but for Markdown files. Features beautiful header
bullets, hierarchical indentation, hidden bold markup, and checkbox
prettification with high-performance tree-sitter parsing."

git push origin master
```

## Step 6: Create Pull Request

1. Go to: https://github.com/ahmetus/melpa
2. Click "Pull requests" → "New pull request"
3. Base repository: `melpa/melpa` base: `master`
4. Head repository: `ahmetus/melpa` compare: `master`
5. Click "Create pull request"

### PR Title
```
Add markdown-modern
```

### PR Description
```markdown
# markdown-modern

Modern, beautiful Markdown editing for Emacs 29+. Like `org-modern`, but for Markdown.

## Package Information

- **Repository**: https://github.com/ahmetus/markdown-modern
- **License**: GPL-3.0
- **Dependencies**: Emacs 29.1+ (tree-sitter support)
- **Version**: 1.0.0

## Features

- Beautiful header bullets (◉ ○ ◆ ▸ • ·)
- Hierarchical indentation for document structure
- Hidden bold markup (`**text**` displays as **text**)
- Prettified checkboxes (`[ ]` → ☐, `[x]` → ☑)
- High performance via tree-sitter
- Smart caching with zero flickering
- Handles 100k+ line files smoothly

## Testing

```elisp
(use-package markdown-modern
  :straight (:host github :repo "ahmetus/markdown-modern")
  :hook (markdown-mode . markdown-modern-mode))
```

Package has been thoroughly tested on:
- Small files (< 1k lines)
- Medium files (1-10k lines)
- Large files (10-100k lines)
- Various markdown syntax (headers, bold, lists, tables, code blocks)

## Documentation

- Complete README with installation instructions
- Comprehensive troubleshooting guide
- Example usage and configuration
- CHANGELOG with version history

## Checklist

- [x] Package-Requires specifies minimum Emacs version (29.1)
- [x] All functions have docstrings
- [x] Proper autoload cookies
- [x] Uses `defcustom` for user options
- [x] Commentary section with usage instructions
- [x] No byte-compile warnings
- [x] GPL-compatible license (GPL-3.0)
- [x] Works with latest stable Emacs (29.1+)
```

6. Click "Create pull request"

## Step 7: Wait for Review

MELPA maintainers will:
- Check recipe format
- Test package building
- Review code quality
- Verify licensing
- Ask for changes if needed

**Typical review time**: 1-7 days

## Step 8: Address Feedback (if any)

If maintainers request changes:

1. Make changes to your **package repository** (not MELPA)
2. Push changes: `git push origin main`
3. Comment on PR that changes are made
4. MELPA will automatically test new commits

For **recipe changes**:
1. Update in your MELPA fork
2. Push: `git push origin master`
3. Changes appear automatically in PR

## Step 9: Approval and Merge

Once approved:
- ✅ Maintainer merges PR
- ✅ Package appears on MELPA within ~1 hour
- ✅ Users can install via `M-x package-install`

## Step 10: Post-Submission

### Update README Badges

Add to README.md:
```markdown
[![MELPA](https://melpa.org/packages/markdown-modern-badge.svg)](https://melpa.org/#/markdown-modern)
```

### Announce Release

Share on:
- Reddit: r/emacs
- Mastodon: #emacs hashtag
- Emacs mailing lists
- Your blog/social media

### Monitor Issues

Watch for:
- Bug reports: https://github.com/ahmetus/markdown-modern/issues
- MELPA build failures (rare)
- User feedback

## Troubleshooting

### Recipe Test Fails

**Error**: "Package doesn't build"

**Solution**: Check that:
- `markdown-modern.el` has proper headers
- Package-Requires is correct
- No syntax errors

### PR Gets No Response

**Solution**: 
- Wait at least 7 days
- Ping maintainers politely
- Check MELPA's current PR queue

### Build Warnings

**Solution**:
- Fix in your package repository
- Push changes
- Comment on PR

## Additional Resources

- MELPA Contributing Guide: https://github.com/melpa/melpa/blob/master/CONTRIBUTING.org
- Package Development: https://www.gnu.org/software/emacs/manual/html_node/elisp/Packaging.html
- MELPA Discourse: https://github.com/melpa/melpa/discussions

---

**Good luck with your submission!** 🎉
