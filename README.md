# Mate Subword Navigation
###### An Atom Package - [Atom.io](https://atom.io/packages/mate-subword-navigation) : [Github](https://github.com/mendab1e/atom-mate-subword-navigation) : [![Build Status](https://travis-ci.org/mendab1e/atom-mate-subword-navigation.svg?branch=master)](https://travis-ci.org/mendab1e/atom-mate-subword-navigation)

This package is a fork of the [atom-subword-navigation](https://github.com/dsandstrom/atom-subword-navigation).
Navigate between subwords in Textmate way: ctrl <- or ctrl ->. The only difference from Textmate keybindings is in the delete subword hotkey. Atom shipped with the Bracket Matcher package, which use ctrl+backspace to delete matching brackets, so I have decided to map delete subword to ctrl+shift+backspace.

Also I have added missing Linux/win bindings to delete subwords.

**Harness the power of ALT as you battle the mighty camelCase and treacherous snake_case.**

This package allows you to move the cursor(s) to beginning and end of words, but also it stops at subwords (camelCase and snake_case).

- Holding `shift` will highlight as you move left and right.

- Along with highlight, you can delete to the previous/next subword. Command names are at the bottom of the page.

- Issues and pull requests are welcome.

### Instructions

|     Mac     |            |            |
|-------------|----------------|-----------------|
| Move around | `ctrl-left`  | `ctrl-right`       |
| Highlight   | `ctrl-shift-left` | `ctrl-shift-right` |
| Delete      | `ctrl-shift-backspace` | `ctrl-delete` |

|  Linux/Win  |            |            |
|-------------|----------------|-----------------|
| Move around | `alt-left`       | `alt-right `   |
| Highlight   | `alt-shift-left` | `alt-shift-right` |
| Delete      | `alt-backspace` | `alt-delete` |

### Dependencies
Requires Atom v0.145 and up


### Commands
```coffee
'subword-navigation:move-right'
'subword-navigation:move-left'
'subword-navigation:select-right'
'subword-navigation:select-left'
'subword-navigation:delete-right'
'subword-navigation:delete-left'
```
