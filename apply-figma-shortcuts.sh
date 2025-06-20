#!/bin/bash

# Apply Figma Auto Layout Keyboard Shortcuts
# This script sets up custom keyboard shortcuts for Figma's Auto Layout plugin

echo "🚀 Applying Figma Auto Layout keyboard shortcuts..."

# Check if Figma Desktop app is running and warn user
if pgrep -f "Figma Desktop" > /dev/null || pgrep -f "com.figma.Desktop" > /dev/null; then
    echo "⚠️  Warning: Figma Desktop app is currently running. Please quit Figma first for changes to take effect."
    read -p "Press Enter to continue anyway, or Ctrl+C to cancel..."
fi

# Apply Auto Layout Plugin Shortcuts using defaults write
defaults write com.figma.Desktop NSUserKeyEquivalents -dict-add \
    $'\033Plugins\033Saved plugins\033Auto Layout Keyboard Shortcuts\033Auto gap between items' "^\$s" \
    $'\033Plugins\033Saved plugins\033Auto Layout Keyboard Shortcuts\033Fixed gap between items' "@^\$a" \
    $'\033Plugins\033Saved plugins\033Auto Layout Keyboard Shortcuts\033Horizontal layout' "^\$w" \
    $'\033Plugins\033Saved plugins\033Auto Layout Keyboard Shortcuts\033Horizontal resizing fill' "^\$x" \
    $'\033Plugins\033Saved plugins\033Auto Layout Keyboard Shortcuts\033Horizontal resizing hug' "^\$z" \
    $'\033Plugins\033Saved plugins\033Auto Layout Keyboard Shortcuts\033Move alignment down' "^\$d" \
    $'\033Plugins\033Saved plugins\033Auto Layout Keyboard Shortcuts\033Move alignment right' "^\$f" \
    $'\033Plugins\033Saved plugins\033Auto Layout Keyboard Shortcuts\033Vertical layout' "^\$q" \
    $'\033Plugins\033Saved plugins\033Auto Layout Keyboard Shortcuts\033Vertical resizing fill' "^\$v" \
    $'\033Plugins\033Saved plugins\033Auto Layout Keyboard Shortcuts\033Vertical resizing hug' "^\$c"

echo "✅ Applied keyboard shortcuts:"
echo "   • Auto gap between items: Ctrl+Shift+S"
echo "   • Fixed gap between items: Cmd+Ctrl+Shift+A"
echo "   • Horizontal layout: Ctrl+Shift+W"
echo "   • Horizontal resizing fill: Ctrl+Shift+X"
echo "   • Horizontal resizing hug: Ctrl+Shift+Z"
echo "   • Move alignment down: Ctrl+Shift+D"
echo "   • Move alignment right: Ctrl+Shift+F"
echo "   • Vertical layout: Ctrl+Shift+Q"
echo "   • Vertical resizing fill: Ctrl+Shift+V"
echo "   • Vertical resizing hug: Ctrl+Shift+C"

echo ""
echo "🔄 Please restart Figma for the shortcuts to take effect."

# Optional: Verify the shortcuts were applied
echo ""
echo "📋 Verifying shortcuts were applied..."
if defaults read com.figma.Desktop NSUserKeyEquivalents > /dev/null 2>&1; then
    echo "✅ Shortcuts successfully written to Figma preferences"
else
    echo "❌ Error: Could not verify shortcuts were applied"
fi

echo ""
echo "🎉 Done! Your Figma Auto Layout shortcuts are now configured." 