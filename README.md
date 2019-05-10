# SE-elm-style

# Background

# Intent

# How to use it

# Contribute

# TODO
 - [ ] Form File button
 - [ ] Documentation (type that takes a label, description, code examples)
 - [ ] Refactor Image, add alt text and improve dimensions (figure tag, width and height optional and is should be responsive)

# Maybe TODO
 - [ ] Message (can be useful to insert into a product listing to announce stuff)
 - [ ] Modal card (do we need the card option?)
 - [ ] Box (different styling from Bulma?)
 - [ ] Card, or should be have Card and Box as one unified component?

# Done
 - [x] Columns (started in the columns-branch)
 - [x] Button states
    - [x] Fullwidth
    - [x] Disabled
    - [x] Static
 - [x] Level
 - [x] Form Radio button
 - [x] Form addons
    - [x] Field attached modifier (.has-addons)
    - [x] Control Expanded modifier
    - [x] Control size
 - [x] Image (Picture) with support for different sizes and resolutions
 - [x] Dropdown
 - [x] Modal (To display enlarged product images)
    - [x] Modal (not card)

# Describe intent with this library

Focus is on type checked and correct components, that why every component has it's own modifiers, no global "catch-all" kind of stuff.

Let these 2 mottos guide you:

 - "Don't make me think!" - Steve Krug (Me beeing the developer using this library)
 - "Let's go for the ambitious approach!" - Richard Feldman (Us beeing the developers working on this library)

A good example is the dropdown and table components where each content type has it's own (Opaque) Type and constructor function in order to force the developer to supply everything that is needed for the component to work properly.

Use https://github.com/Skinney/elm-git-install to utilize in application

# Setup npm script support in Windows
https://stackoverflow.com/questions/23243353/how-to-set-shell-for-npm-run-scripts-in-windows

https://github.com/lucamug/style-framework/blob/master/src/Framework.elm
