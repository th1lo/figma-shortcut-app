-- Figma Shortcuts Diagnostic Tool
-- Helps identify why shortcuts might not be working for some users

on run
	try
		-- Main diagnostic menu
		set userChoice to choose from list {"🔍 Run Diagnostics", "🚀 Apply Shortcuts", "📋 View Current Shortcuts", "ℹ️ Help"} with title "Figma Shortcuts Diagnostic" with prompt "Having trouble? Let's diagnose the issue:" default items {"🔍 Run Diagnostics"} OK button name "Continue" cancel button name "Quit"
		
		if userChoice is false then
			return -- User cancelled
		end if
		
		set selectedAction to item 1 of userChoice
		
		if selectedAction is "🔍 Run Diagnostics" then
			runDiagnostics()
		else if selectedAction is "🚀 Apply Shortcuts" then
			applyShortcuts()
		else if selectedAction is "📋 View Current Shortcuts" then
			viewCurrentShortcuts()
		else if selectedAction is "ℹ️ Help" then
			showHelp()
		end if
		
	on error errMsg
		display alert "Error" message "Something went wrong: " & errMsg as critical
	end try
end run

-- Diagnostic function
on runDiagnostics()
	try
		set diagnosticReport to "🔍 FIGMA SHORTCUTS DIAGNOSTIC REPORT" & return & return
		
		-- Check macOS version
		set osVersion to do shell script "sw_vers -productVersion"
		set diagnosticReport to diagnosticReport & "💻 macOS Version: " & osVersion & return
		
		-- Check for different Figma installations
		set figmaInstalls to ""
		try
			set figmaDesktop to do shell script "find /Applications -name '*Figma*' -type d 2>/dev/null || echo 'Not found'"
			set figmaInstalls to figmaInstalls & "Desktop App: " & figmaDesktop & return
		end try
		
		-- Check Figma preferences exist
		set prefStatus to ""
		try
			do shell script "defaults read com.figma.Desktop >/dev/null 2>&1"
			set prefStatus to "✅ com.figma.Desktop preferences found"
		on error
			set prefStatus to "❌ com.figma.Desktop preferences NOT found"
		end try
		
		-- Check Figma Beta preferences 
		set betaPrefStatus to ""
		try
			do shell script "defaults read com.figma.DesktopBeta >/dev/null 2>&1"
			set betaPrefStatus to "✅ com.figma.DesktopBeta preferences found"
		on error
			set betaPrefStatus to "❌ com.figma.DesktopBeta preferences NOT found"
		end try
		
		-- Check current shortcuts
		set shortcutStatus to ""
		try
			set currentShortcuts to do shell script "defaults read com.figma.Desktop NSUserKeyEquivalents 2>/dev/null || echo 'none'"
			if currentShortcuts is "none" then
				set shortcutStatus to "❌ No custom shortcuts found"
			else
				set shortcutCount to do shell script "defaults read com.figma.Desktop NSUserKeyEquivalents 2>/dev/null | grep -c '=' || echo '0'"
				set shortcutStatus to "✅ Found " & shortcutCount & " custom shortcuts"
			end if
		on error
			set shortcutStatus to "❌ Cannot read shortcuts"
		end try
		
		-- Check if Figma is running
		set figmaRunning to ""
		try
			do shell script "pgrep -f 'Figma Desktop' || pgrep -f 'com.figma.Desktop'"
			set figmaRunning to "⚠️ Figma Desktop is currently running"
		on error
			set figmaRunning to "✅ Figma Desktop is not running"
		end try
		
		-- Compile report
		set diagnosticReport to diagnosticReport & "🎯 Figma Installation:" & return & figmaInstalls & return
		set diagnosticReport to diagnosticReport & "📋 Preference Files:" & return & prefStatus & return & betaPrefStatus & return & return
		set diagnosticReport to diagnosticReport & "⌨️ Current Shortcuts:" & return & shortcutStatus & return & return
		set diagnosticReport to diagnosticReport & "🔄 Figma Status:" & return & figmaRunning & return & return
		
		-- Recommendations
		set diagnosticReport to diagnosticReport & "💡 RECOMMENDATIONS:" & return
		if prefStatus contains "NOT found" and betaPrefStatus contains "found" then
			set diagnosticReport to diagnosticReport & "• You have Figma Beta - try the Beta version of our app" & return
		else if prefStatus contains "NOT found" and betaPrefStatus contains "NOT found" then
			set diagnosticReport to diagnosticReport & "• Figma preferences not found - make sure Figma is installed and has been run at least once" & return
		else if figmaRunning contains "running" then
			set diagnosticReport to diagnosticReport & "• Quit Figma completely before applying shortcuts" & return
		else if shortcutStatus contains "0 custom shortcuts" then
			set diagnosticReport to diagnosticReport & "• Try applying shortcuts and restart Figma" & return
		else
			set diagnosticReport to diagnosticReport & "• Everything looks good! Make sure Auto Layout Keyboard Shortcuts plugin is installed" & return
		end if
		
		display alert "Diagnostic Complete" message diagnosticReport buttons {"Copy Report", "Try Beta App", "Apply Shortcuts"} default button "Apply Shortcuts"
		set buttonPressed to button returned of result
		
		if buttonPressed is "Copy Report" then
			set the clipboard to diagnosticReport
			display alert "Report Copied" message "Diagnostic report copied to clipboard. You can paste this when asking for help."
		else if buttonPressed is "Try Beta App" then
			applyShortcutsBeta()
		else if buttonPressed is "Apply Shortcuts" then
			applyShortcuts()
		end if
		
	on error errMsg
		display alert "Diagnostic Error" message "Error running diagnostics: " & errMsg as critical
	end try
end runDiagnostics

-- Apply shortcuts for regular Figma
on applyShortcuts()
	try
		applyShortcutsToApp("com.figma.Desktop", "Figma Desktop")
	on error errMsg
		display alert "Error" message "Failed to apply shortcuts to Figma Desktop: " & errMsg as critical
	end try
end applyShortcuts

-- Apply shortcuts for Figma Beta
on applyShortcutsBeta()
	try
		applyShortcutsToApp("com.figma.DesktopBeta", "Figma Beta")
	on error errMsg
		display alert "Error" message "Failed to apply shortcuts to Figma Beta: " & errMsg as critical
	end try
end applyShortcutsBeta

-- Generic function to apply shortcuts to any Figma version
on applyShortcutsToApp(bundleId, appName)
	try
		set confirmApply to display alert "Apply Shortcuts to " & appName message "This will apply 10 Auto Layout shortcuts to " & appName & ":

• Auto gap between items: Ctrl+Shift+S
• Fixed gap between items: Cmd+Ctrl+Shift+A
• And 8 more shortcuts...

Continue?" buttons {"Apply Shortcuts", "Cancel"} default button "Apply Shortcuts"
		
		if button returned of confirmApply is "Apply Shortcuts" then
			-- Apply shortcuts using the provided bundle ID
			set shortcutCommands to {¬
				"defaults write " & bundleId & " NSUserKeyEquivalents -dict-add $'\\033Plugins\\033Saved plugins\\033Auto Layout Keyboard Shortcuts\\033Auto gap between items' '^$s'", ¬
				"defaults write " & bundleId & " NSUserKeyEquivalents -dict-add $'\\033Plugins\\033Saved plugins\\033Auto Layout Keyboard Shortcuts\\033Fixed gap between items' '@^$a'", ¬
				"defaults write " & bundleId & " NSUserKeyEquivalents -dict-add $'\\033Plugins\\033Saved plugins\\033Auto Layout Keyboard Shortcuts\\033Horizontal layout' '^$w'", ¬
				"defaults write " & bundleId & " NSUserKeyEquivalents -dict-add $'\\033Plugins\\033Saved plugins\\033Auto Layout Keyboard Shortcuts\\033Horizontal resizing fill' '^$x'", ¬
				"defaults write " & bundleId & " NSUserKeyEquivalents -dict-add $'\\033Plugins\\033Saved plugins\\033Auto Layout Keyboard Shortcuts\\033Horizontal resizing hug' '^$z'", ¬
				"defaults write " & bundleId & " NSUserKeyEquivalents -dict-add $'\\033Plugins\\033Saved plugins\\033Auto Layout Keyboard Shortcuts\\033Move alignment down' '^$d'", ¬
				"defaults write " & bundleId & " NSUserKeyEquivalents -dict-add $'\\033Plugins\\033Saved plugins\\033Auto Layout Keyboard Shortcuts\\033Move alignment right' '^$f'", ¬
				"defaults write " & bundleId & " NSUserKeyEquivalents -dict-add $'\\033Plugins\\033Saved plugins\\033Auto Layout Keyboard Shortcuts\\033Vertical layout' '^$q'", ¬
				"defaults write " & bundleId & " NSUserKeyEquivalents -dict-add $'\\033Plugins\\033Saved plugins\\033Auto Layout Keyboard Shortcuts\\033Vertical resizing fill' '^$v'", ¬
				"defaults write " & bundleId & " NSUserKeyEquivalents -dict-add $'\\033Plugins\\033Saved plugins\\033Auto Layout Keyboard Shortcuts\\033Vertical resizing hug' '^$c'"}
			
			-- Execute each command
			repeat with cmd in shortcutCommands
				do shell script cmd
			end repeat
			
			display alert "Success!" message "Shortcuts applied to " & appName & "!

✅ Applied 10 Auto Layout shortcuts
⚠️ Restart " & appName & " for changes to take effect
🔌 Make sure Auto Layout Keyboard Shortcuts plugin is installed

Test with Ctrl+Shift+S for auto gap!"
		end if
		
	on error errMsg
		display alert "Error Applying Shortcuts" message errMsg as critical
	end try
end applyShortcutsToApp

-- View current shortcuts
on viewCurrentShortcuts()
	try
		set currentShortcuts to do shell script "defaults read com.figma.Desktop NSUserKeyEquivalents 2>/dev/null || echo 'No custom shortcuts found'"
		
		if currentShortcuts contains "No custom shortcuts found" then
			display alert "No Custom Shortcuts" message "No custom shortcuts found for Figma Desktop.

Try running diagnostics to check for other Figma versions." buttons {"Run Diagnostics", "OK"} default button "Run Diagnostics"
			if button returned of result is "Run Diagnostics" then
				runDiagnostics()
			end if
		else
			set shortcutCount to do shell script "defaults read com.figma.Desktop NSUserKeyEquivalents 2>/dev/null | grep -c '=' || echo '0'"
			display alert "Found " & shortcutCount & " Shortcuts" message "Found " & shortcutCount & " custom shortcuts in Figma Desktop preferences.

To see details:
defaults read com.figma.Desktop NSUserKeyEquivalents" buttons {"OK"} default button "OK"
		end if
		
	on error errMsg
		display alert "Error Reading Shortcuts" message errMsg as critical
	end try
end viewCurrentShortcuts

-- Help function
on showHelp()
	display alert "Figma Shortcuts Diagnostic Help" message "This diagnostic tool helps identify why shortcuts might not work:

🔍 Run Diagnostics
   Checks your system and Figma installation

Common Issues:
• Figma Beta vs Desktop (different apps)
• Figma not installed or never opened
• Need to restart Figma after applying shortcuts
• Auto Layout Keyboard Shortcuts plugin not installed

If diagnostics show issues, follow the recommendations provided." buttons {"Got it!"} default button "Got it!"
end showHelp 