# Figma Auto Layout Shortcuts - Terminal Commands

```bash
# Apply all 10 Auto Layout shortcuts
defaults write com.figma.Desktop NSUserKeyEquivalents -dict-add "$(printf '\033Plugins\033Saved plugins\033Auto Layout Keyboard Shortcuts\033Auto gap between items')" "^s"

defaults write com.figma.Desktop NSUserKeyEquivalents -dict-add $'\033Plugins\033Saved plugins\033Auto Layout Keyboard Shortcuts\033Fixed gap between items' '@^$a'

defaults write com.figma.Desktop NSUserKeyEquivalents -dict-add $'\033Plugins\033Saved plugins\033Auto Layout Keyboard Shortcuts\033Horizontal layout' '^$w'

defaults write com.figma.Desktop NSUserKeyEquivalents -dict-add $'\033Plugins\033Saved plugins\033Auto Layout Keyboard Shortcuts\033Horizontal resizing fill' '^$x'

defaults write com.figma.Desktop NSUserKeyEquivalents -dict-add $'\033Plugins\033Saved plugins\033Auto Layout Keyboard Shortcuts\033Horizontal resizing hug' '^$z'

defaults write com.figma.Desktop NSUserKeyEquivalents -dict-add $'\033Plugins\033Saved plugins\033Auto Layout Keyboard Shortcuts\033Move alignment down' '^$d'

defaults write com.figma.Desktop NSUserKeyEquivalents -dict-add $'\033Plugins\033Saved plugins\033Auto Layout Keyboard Shortcuts\033Move alignment right' '^$f'

defaults write com.figma.Desktop NSUserKeyEquivalents -dict-add $'\033Plugins\033Saved plugins\033Auto Layout Keyboard Shortcuts\033Vertical layout' '^$q'

defaults write com.figma.Desktop NSUserKeyEquivalents -dict-add $'\033Plugins\033Saved plugins\033Auto Layout Keyboard Shortcuts\033Vertical resizing fill' '^$v'

defaults write com.figma.Desktop NSUserKeyEquivalents -dict-add $'\033Plugins\033Saved plugins\033Auto Layout Keyboard Shortcuts\033Vertical resizing hug' '^$c'
```

## Remove shortcuts

```bash
defaults delete com.figma.Desktop NSUserKeyEquivalents
```

## View current shortcuts

```bash
defaults read com.figma.Desktop NSUserKeyEquivalents
```
