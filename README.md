# Figma Shortcuts Manager

A native macOS app to easily manage keyboard shortcuts for Figma's Auto Layout plugin.

## 🚀 Quick Start

1. **Double-click `FigmaShortcuts.app`** to launch
2. **Choose "🚀 Apply Auto Layout Shortcuts"**
3. **Click "Apply Shortcuts"** in the dialog
4. **Restart Figma** and enjoy your new shortcuts!

## ✨ Features

### 🖱️ **Native macOS App**
- Beautiful native dialogs
- No Terminal knowledge required
- Double-click to run

### ⌨️ **10 Auto Layout Shortcuts**
| Shortcut | Action |
|----------|--------|
| `Ctrl+Shift+S` | Auto gap between items |
| `Cmd+Ctrl+Shift+A` | Fixed gap between items |
| `Ctrl+Shift+W` | Horizontal layout |
| `Ctrl+Shift+Q` | Vertical layout |
| `Ctrl+Shift+X` | Horizontal resizing fill |
| `Ctrl+Shift+V` | Vertical resizing fill |
| `Ctrl+Shift+Z` | Horizontal resizing hug |
| `Ctrl+Shift+C` | Vertical resizing hug |
| `Ctrl+Shift+D` | Move alignment down |
| `Ctrl+Shift+F` | Move alignment right |

### 🛠️ **App Features**
- **🚀 Apply Shortcuts**: One-click setup of all shortcuts
- **🧪 Test & Verify**: Advanced testing with automatic backups
- **🔄 Restore Backups**: Restore previous shortcut configurations
- **📋 View Current**: See what shortcuts are currently active
- **ℹ️ Help**: Built-in documentation

## 📋 Requirements

- **macOS** (tested on macOS 14+)
- **Figma Desktop** app
- **Auto Layout plugin** (install from Figma Community)

## 🎯 How to Use

### 1. **First Time Setup**
1. Launch `FigmaShortcuts.app`
2. Choose "🚀 Apply Auto Layout Shortcuts"
3. Click "Apply Shortcuts"
4. Restart Figma
5. Install the [Auto Layout plugin](https://www.figma.com/community/plugin/734721047393768236/Auto-Layout)

### 2. **Testing Your Setup**
1. In the app, choose "🧪 Test Shortcuts (Advanced)"
2. Follow the Terminal prompts for comprehensive testing
3. This creates automatic backups for safety

### 3. **Using Shortcuts in Figma**
1. Create a frame with some objects
2. Select the objects
3. Try `Ctrl+Shift+S` for auto gap
4. Use other shortcuts for different Auto Layout actions

## 🗂️ Files Included

- **`FigmaShortcuts.app`** - Main macOS application
- **`apply-figma-shortcuts.sh`** - Script to apply shortcuts
- **`test-figma-shortcuts.sh`** - Interactive testing script
- **`restore-figma-shortcuts.sh`** - Backup restoration script
- **`figmashortcuts.md`** - Technical documentation

## 🔧 Technical Details

The app uses macOS `defaults` commands to modify Figma's preferences:
```bash
defaults write com.figma.Desktop NSUserKeyEquivalents -dict-add "Menu Path" "Shortcut"
```

Shortcuts are stored in: `~/Library/Preferences/com.figma.Desktop.plist`

## 🛟 Troubleshooting

### Shortcuts not working?
1. **Restart Figma** completely
2. **Install Auto Layout plugin** from Figma Community
3. **Check plugin is enabled** in Figma preferences
4. **Run test script** from the app for diagnostics

### App won't open?
1. **Right-click** → "Open" (for first run security)
2. **Check permissions** in System Preferences → Security
3. **Run from Terminal**: `open FigmaShortcuts.app`

### Need to restore old shortcuts?
1. Use "🔄 Restore from Backup" in the app
2. Or manually: `defaults delete com.figma.Desktop NSUserKeyEquivalents`

## 🎉 That's It!

Your Figma Auto Layout workflow just got supercharged! 

**Enjoy designing faster with keyboard shortcuts!** ⚡ 