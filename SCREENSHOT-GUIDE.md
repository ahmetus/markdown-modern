# Screenshot Guide for markdown-modern

Perfect screenshots to showcase your package!

## Quick Method (5 minutes)

### Step 1: Open Demo File

```elisp
C-x C-f ~/.emacs.d/markdown-modern/demo.md
```

### Step 2: Take "Before" Screenshot

**Without markdown-modern-mode:**
1. Make sure mode is OFF
2. Take full window screenshot
3. Save as `before.png`

**What to capture:**
- Raw `#` symbols visible
- `**bold**` with asterisks visible
- `[ ]` and `[x]` checkbox syntax visible
- No indentation

### Step 3: Enable Mode

```elisp
M-x markdown-modern-mode
```

### Step 4: Take "After" Screenshot

**With markdown-modern-mode:**
1. Wait for rendering to complete
2. Take full window screenshot (same size as before!)
3. Save as `after.png`

**What to capture:**
- `◉` bullet instead of `#`
- Bold text without `**` delimiters
- `☐` and `☑` instead of `[ ]` and `[x]`
- Beautiful hierarchical indentation

### Step 5: Create Comparison

Using ImageMagick (if installed):
```bash
cd ~/.emacs.d/markdown-modern
mkdir -p screenshots
convert before.png after.png +append screenshots/comparison.png
```

Or manually:
- Open both images in GIMP/Photoshop
- Place side-by-side
- Add labels: "Before" and "After"
- Save as `screenshots/comparison.png`

## Recommended Screenshots

### 1. Main Comparison (Required)

**Name**: `comparison.png` or `before-after.png`

**Content**:
- Full demo.md visible
- Side-by-side: left=before, right=after
- Clear difference in readability
- ~1200-1600px wide total

### 2. Header Showcase (Optional, Recommended)

**Name**: `headers.png`

**Content**:
- All 6 header levels visible
- Shows bullet progression: ◉ ○ ◆ ▸ • ·
- Demonstrates hierarchical indentation

**Example content**:
```markdown
# Level 1
Content under level 1

## Level 2
Content under level 2

### Level 3
Content under level 3

#### Level 4
Content under level 4

##### Level 5
Content under level 5

###### Level 6
Content under level 6
```

### 3. Features Showcase (Optional)

**Name**: `features.png`

**Content**:
- Bold text (hidden markup)
- Checkboxes (prettified)
- Tables (indented)
- Code blocks (indented)

## Screenshot Tips

### Window Size
- Use consistent size for before/after
- Recommend: 800-1000px wide per panel
- Show enough content to demonstrate features
- Not too small (hard to see), not too large (file size)

### Emacs Theme
- Use a popular, readable theme
- Light themes work well for documentation
- Suggestions:
  - `modus-operandi` (light, built-in Emacs 28+)
  - `ef-themes` (modern, readable)
  - `doom-one-light` (popular)
- Avoid very dark themes (hard to see in docs)

### Font
- Use a readable monospace font
- Increase font size slightly for screenshots
- Suggestions:
  - `Fira Code`
  - `JetBrains Mono`
  - `Iosevka`

```elisp
;; Temporarily increase font size for screenshots
(set-face-attribute 'default nil :height 140)

;; After screenshots, reset:
(set-face-attribute 'default nil :height 120)
```

### Content
- Show realistic example (not hello world)
- Demonstrate multiple features in one shot
- Keep text professional/neutral
- No offensive or inappropriate content

### Framing
- Show just the buffer content (or with mode line)
- Don't include menu bar or title bar unless relevant
- Focus on the markdown content transformation

## Adding to README

Once you have screenshots:

### Upload to Repository

```bash
cd ~/.emacs.d/markdown-modern
git add screenshots/
git commit -m "Add screenshots"
git push
```

### Update README.md

Add after the Features section:

```markdown
## Screenshots

### Before and After

![Comparison](screenshots/comparison.png)

*Left: Standard Markdown view | Right: With markdown-modern enabled*

### Features in Action

![Features](screenshots/features.png)

*Beautiful bullets, hidden markup, prettified checkboxes, and hierarchical indentation*
```

### Alternative: GIF Animation

For extra impact, create an animated GIF showing the transformation:

```bash
# Using ffmpeg or gifsicle
# Record sequence: open file → enable mode → scroll
# Tools: peek, gifcap, or SimpleScreenRecorder
```

## Example Terminal Command Workflow

```bash
# 1. Take screenshots using scrot (Linux)
sleep 3 && scrot before.png  # Click on Emacs window within 3 sec
# Enable markdown-modern-mode
sleep 3 && scrot after.png

# 2. Create comparison
mkdir -p ~/.emacs.d/markdown-modern/screenshots
cd ~/.emacs.d/markdown-modern
convert before.png after.png +append screenshots/comparison.png

# 3. Add label overlay (optional)
convert screenshots/comparison.png \
  -gravity North -pointsize 24 -annotate +0+10 "Before                                 After" \
  screenshots/comparison.png

# 4. Optimize
optipng screenshots/comparison.png  # Or use pngquant

# 5. Commit
git add screenshots/
git commit -m "Add before/after comparison screenshot"
git push
```

## Screenshot Dimensions Guide

### For GitHub README
- **Width**: 800-1200px (GitHub auto-scales larger images)
- **Height**: No limit, but keep reasonable (800-1000px max)
- **Format**: PNG (for sharp text) or JPG (for photos)
- **File size**: Keep under 1MB

### For Comparison
- **Total width**: 1600px (800px × 2 panels)
- **Height**: Match both panels (800px typical)
- **Add 2-5px border between panels** for clarity

## Quality Checklist

Before publishing screenshots:

- [ ] Both screenshots same size
- [ ] Features clearly visible
- [ ] Text readable (not too small)
- [ ] Professional appearance
- [ ] Represents actual package behavior
- [ ] No UI glitches or artifacts
- [ ] Optimized file size (< 1MB)
- [ ] Clear before/after labels
