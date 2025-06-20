#!/bin/bash

# Restore Figma Keyboard Shortcuts from Backup
# This script helps restore shortcuts from backup files created by test-figma-shortcuts.sh

echo "🔄 Figma Shortcuts Restoration Tool"
echo "==================================="

# Find backup files
BACKUP_FILES=($(ls figma-shortcuts-backup-*.txt 2>/dev/null))

if [ ${#BACKUP_FILES[@]} -eq 0 ]; then
    echo "❌ No backup files found in current directory"
    echo "   Looking for files matching: figma-shortcuts-backup-*.txt"
    exit 1
fi

echo "📋 Found backup files:"
for i in "${!BACKUP_FILES[@]}"; do
    SIZE=$(wc -c < "${BACKUP_FILES[$i]}" 2>/dev/null || echo "0")
    SHORTCUTS=$(grep -c "=" "${BACKUP_FILES[$i]}" 2>/dev/null || echo "0")
    echo "   $((i+1)). ${BACKUP_FILES[$i]} ($SHORTCUTS shortcuts, ${SIZE} bytes)"
done

echo ""
if [ ${#BACKUP_FILES[@]} -eq 1 ]; then
    SELECTED_FILE="${BACKUP_FILES[0]}"
    echo "📁 Using: $SELECTED_FILE"
else
    read -p "📁 Select backup file (1-${#BACKUP_FILES[@]}): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[1-9]$ ]] && [ "$REPLY" -le "${#BACKUP_FILES[@]}" ]; then
        SELECTED_FILE="${BACKUP_FILES[$((REPLY-1))]}"
        echo "📁 Selected: $SELECTED_FILE"
    else
        echo "❌ Invalid selection"
        exit 1
    fi
fi

# Preview backup content
echo ""
echo "📋 Backup file preview:"
head -5 "$SELECTED_FILE"
if [ $(wc -l < "$SELECTED_FILE") -gt 5 ]; then
    echo "   ..."
fi

echo ""
read -p "⚠️  This will replace current Figma shortcuts. Continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Restoration cancelled"
    exit 0
fi

# Clear current shortcuts
echo "🗑️  Clearing current shortcuts..."
defaults delete com.figma.Desktop NSUserKeyEquivalents 2>/dev/null
echo "✅ Current shortcuts cleared"

# Note about manual restoration
echo ""
echo "⚠️  Important: Automatic restoration is complex because backup files are in"
echo "   'defaults read' output format, not 'defaults write' input format."
echo ""
echo "📝 To restore manually:"
echo "   1. Review the backup file: $SELECTED_FILE"
echo "   2. For each shortcut line, convert to defaults write format:"
echo "   3. Example conversion:"
echo "      From: \"Menu→Item\" = \"^s\";"
echo "      To:   defaults write com.figma.Desktop NSUserKeyEquivalents -dict-add \"Menu→Item\" \"^s\""
echo ""
echo "🤖 Or re-run apply-figma-shortcuts.sh to restore the Auto Layout shortcuts"

echo ""
read -p "🚀 Run apply-figma-shortcuts.sh now to restore Auto Layout shortcuts? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if [ -f "./apply-figma-shortcuts.sh" ]; then
        echo "   Running apply-figma-shortcuts.sh..."
        ./apply-figma-shortcuts.sh
    else
        echo "❌ apply-figma-shortcuts.sh not found!"
    fi
else
    echo "✅ Restoration tool completed"
    echo "   Backup file preserved: $SELECTED_FILE"
fi 