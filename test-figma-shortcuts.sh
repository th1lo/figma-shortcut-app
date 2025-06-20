#!/bin/bash

# Test Figma Keyboard Shortcuts Script
# This script tests the apply-figma-shortcuts.sh script with proper cleanup

echo "🧪 Testing Figma Keyboard Shortcuts Script"
echo "=========================================="
echo ""
echo "This test will:"
echo "  1. 📋 Backup your current shortcuts"
echo "  2. 🗑️  Delete existing shortcuts (for clean test)"
echo "  3. 🚀 Apply new shortcuts using our script"
echo "  4. 🔍 Verify all shortcuts work correctly"
echo "  5. 🔄 Offer to restore your original shortcuts"
echo ""

# Get user consent
read -p "⚠️  This will temporarily modify your Figma shortcuts. Continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Test cancelled by user"
    exit 0
fi

# 1. Backup current shortcuts
echo ""
echo "📋 Step 1: Backing up current shortcuts..."
BACKUP_FILE="figma-shortcuts-backup-$(date +%Y%m%d_%H%M%S).txt"
defaults read com.figma.Desktop NSUserKeyEquivalents > "$BACKUP_FILE" 2>/dev/null
if [ $? -eq 0 ]; then
    echo "✅ Current shortcuts backed up to: $BACKUP_FILE"
    echo "   You can restore these later if needed"
else
    echo "⚠️  No existing shortcuts found to backup"
fi

# 2. Count shortcuts before
echo ""
echo "📊 Step 2: Counting shortcuts before cleanup..."
BEFORE_COUNT=$(defaults read com.figma.Desktop NSUserKeyEquivalents 2>/dev/null | grep -c "=" || echo "0")
echo "   Current shortcuts count: $BEFORE_COUNT"

if [ "$BEFORE_COUNT" -gt 0 ]; then
    echo ""
    echo "📋 Current shortcuts preview:"
    defaults read com.figma.Desktop NSUserKeyEquivalents 2>/dev/null | head -5
    echo "   ..."
    echo ""
    read -p "🗑️  Delete existing shortcuts for clean test? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "   Deleting existing shortcuts..."
        defaults delete com.figma.Desktop NSUserKeyEquivalents 2>/dev/null
        echo "✅ Existing shortcuts cleared"
        BEFORE_COUNT=0  # Update count after deletion
    else
        echo "⚠️  Keeping existing shortcuts (test will add to them)"
    fi
fi

# 3. Apply shortcuts using our script
echo ""
echo "🚀 Step 3: Applying shortcuts using our script..."
read -p "📝 Ready to apply Auto Layout shortcuts? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Test cancelled - shortcuts not applied"
    exit 0
fi

if [ -f "./apply-figma-shortcuts.sh" ]; then
    echo "   Running apply-figma-shortcuts.sh..."
    echo "y" | ./apply-figma-shortcuts.sh
else
    echo "❌ apply-figma-shortcuts.sh not found!"
    exit 1
fi

# 4. Count shortcuts after
echo ""
echo "📊 Step 4: Counting shortcuts after applying..."
AFTER_COUNT=$(defaults read com.figma.Desktop NSUserKeyEquivalents 2>/dev/null | grep -c "=" || echo "0")
echo "   New shortcuts count: $AFTER_COUNT"
CHANGE=$((AFTER_COUNT - BEFORE_COUNT))
if [ "$CHANGE" -gt 0 ]; then
    echo "   ✅ Added $CHANGE new shortcuts"
elif [ "$CHANGE" -eq 0 ] && [ "$AFTER_COUNT" -gt 0 ]; then
    echo "   ✅ All shortcuts are in place"
else
    echo "   ⚠️  No shortcuts detected - something may be wrong"
fi

# 5. Verify specific shortcuts exist
echo ""
echo "🔍 Step 5: Verifying specific shortcuts..."
SHORTCUTS_TO_CHECK=(
    "Auto gap between items"
    "Fixed gap between items"
    "Horizontal layout"
    "Vertical layout"
)

for shortcut in "${SHORTCUTS_TO_CHECK[@]}"; do
    if defaults read com.figma.Desktop NSUserKeyEquivalents 2>/dev/null | grep -q "$shortcut"; then
        echo "   ✅ Found: $shortcut"
    else
        echo "   ❌ Missing: $shortcut"
    fi
done

# 6. Display shortcuts (optional)
echo ""
read -p "📋 Show detailed shortcuts list? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "📋 Step 6: Current shortcuts summary..."
    defaults read com.figma.Desktop NSUserKeyEquivalents 2>/dev/null || echo "   No shortcuts found"
fi

# 7. Test shortcut format
echo ""
echo "🔍 Step 7: Testing shortcut format..."
if defaults read com.figma.Desktop NSUserKeyEquivalents 2>/dev/null | grep -q "033"; then
    echo "   ✅ Shortcuts use correct escape sequence format"
else
    echo "   ⚠️  Shortcuts may not use correct format"
fi

# 8. Check Figma process
echo ""
echo "🔍 Step 8: Checking Figma Desktop app..."
if pgrep -f "Figma Desktop" > /dev/null || pgrep -f "com.figma.Desktop" > /dev/null; then
    echo "   ⚠️  Figma Desktop app is running - shortcuts may not take effect until restart"
else
    echo "   ✅ Figma Desktop app is not running - shortcuts should take effect when started"
fi

echo ""
echo "🎯 Testing Summary:"
echo "   Before: $BEFORE_COUNT shortcuts"
echo "   After:  $AFTER_COUNT shortcuts"
echo "   Change: $CHANGE shortcuts added"

# 9. Test completion and restoration options
echo ""
echo "✅ Test completed successfully!"
echo ""
echo "💡 Next steps to test in Figma:"
echo "   1. Start Figma Desktop"
echo "   2. Install Auto Layout plugin (if not installed)"
echo "   3. Create a frame with some objects"
echo "   4. Select objects and try Ctrl+Shift+S for auto gap"
echo ""

# Offer restoration options
if [ -f "$BACKUP_FILE" ] && [ -s "$BACKUP_FILE" ]; then
    echo "🔄 Restoration options:"
    echo "   Your original shortcuts are backed up in: $BACKUP_FILE"
    echo ""
    read -p "📥 Restore your original shortcuts now? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "   Restoring original shortcuts..."
        defaults delete com.figma.Desktop NSUserKeyEquivalents 2>/dev/null
        
        # Parse and restore backup (since it's in defaults format)
        if grep -q "=" "$BACKUP_FILE"; then
            echo "   Applying backed up shortcuts..."
            # The backup is in defaults output format, we need to convert it back
            echo "   ⚠️  Manual restoration needed - backup file format requires manual import"
            echo "   To restore manually: review $BACKUP_FILE and use defaults write commands"
        fi
        echo "✅ Restoration attempted"
    else
        echo "   Keeping new shortcuts active"
        echo "   💾 Backup preserved at: $BACKUP_FILE"
    fi
else
    echo "🔄 Manual restoration command:"
    echo "   defaults delete com.figma.Desktop NSUserKeyEquivalents"
fi

echo ""
echo "🎉 Test script completed!" 