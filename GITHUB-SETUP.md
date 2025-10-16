# GitHub Repository Setup Guide

## Step 1: Create Repository on GitHub

1. Go to: https://github.com/new
2. Fill in:
   - **Repository name**: `markdown-modern`
   - **Description**: `Modern, beautiful Markdown editing for Emacs. Like org-modern, but for Markdown.`
   - **Visibility**: Public
   - **DON'T** initialize with README, .gitignore, or license (we already have them)
3. Click "Create repository"

## Step 2: Push to GitHub

```bash
cd ~/.emacs.d/markdown-modern

# Add remote
git remote add origin https://github.com/ahmetus/markdown-modern.git

# Push
git push -u origin main
```

## Step 3: Add Repository Topics

On GitHub repository page:
1. Click ⚙️ (Settings) next to "About"
2. Add topics:
   - `emacs`
   - `markdown`
   - `tree-sitter`
   - `emacs-package`
   - `markdown-mode`
   - `org-modern`
   - `elisp`
3. Save changes

## Step 4: Create v1.0.0 Release

1. Go to: https://github.com/ahmetus/markdown-modern/releases/new
2. Fill in:
   - **Tag**: `v1.0.0`
   - **Release title**: `markdown-modern v1.0.0 - Initial Release`
   - **Description**: Copy from `RELEASE-NOTES-v1.0.0.md`
3. Click "Publish release"

## Step 5: Add Screenshots (Optional but Recommended)

### Taking Screenshots

1. Open `demo.md` in Emacs:
   ```elisp
   C-x C-f ~/.emacs.d/markdown-modern/demo.md
   ```

2. Take "Before" screenshot (without mode):
   - Standard markdown view
   - Save as `screenshots/before.png`

3. Enable mode and take "After" screenshot:
   ```elisp
   M-x markdown-modern-mode
   ```
   - Save as `screenshots/after.png`

4. Create comparison (using ImageMagick):
   ```bash
   mkdir -p screenshots
   convert before.png after.png +append screenshots/comparison.png
   ```

5. Add to repository:
   ```bash
   git add screenshots/
   git commit -m "Add screenshots"
   git push
   ```

6. Update README.md to include screenshots:
   ```markdown
   ## Screenshots

   ### Before and After

   ![Comparison](screenshots/comparison.png)

   *Left: Standard markdown view | Right: With markdown-modern*
   ```

## Step 6: Verify Repository

Check that everything is visible:
- ✅ README.md renders correctly
- ✅ LICENSE file shows GPL-3.0
- ✅ All documentation files visible
- ✅ Topics are added
- ✅ v1.0.0 release is published

## Step 7: Update Repository Settings (Optional)

### Enable Discussions
1. Go to Settings → General
2. Check "Discussions"
3. Save changes

### Add Website
1. Go to Settings → General  
2. Website: `https://github.com/ahmetus/markdown-modern`
3. Save changes

## Next: MELPA Submission

See `MELPA-SUBMISSION-GUIDE.md` for detailed MELPA submission instructions.
