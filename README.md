# Special-Elektronik Elm UI

Private Elm UI library for beautiful, coherent, SE flavored UI.

While this library is MIT, there aren't many other use cases for this library besides Special-Elektroniks applications, thus the "private" flag.

We draw inspiration from [Bulma](https://bulma.io/), [Tailwind CSS](https://tailwindcss.com/), [NSB Pattern Library](https://youtu.be/yE9PKFI19RM?t=543) and [NoRedInk/noredink-ui](https://github.com/NoRedInk/noredink-ui).

# Intent

With Elm we don't not have go through all of CSS ordinary problems like global scope, unused styles and specificity wars. Instead we get typed CSS using [Elm CSS](https://package.elm-lang.org/packages/rtfeldman/elm-css/latest) that compiles to inline styles at runtime.

This library has the same goals. We focus on type checked and correct components, that's why every component has it's own modifiers, no global "catch-all" kind of stuff.

Let these 2 mottos guide you:

 - "Don't make me think!" - Steve Krug (Me beeing the developer using this library, but also the end user)
 - "Let's go for the ambitious approach!" - Richard Feldman (Us beeing the developers working on this library)

A good example is the [Dropdown](/SE-Framework-Dropdown) and [Table](/SE-Framework-Table) components where each content type has it's own (Opaque) type and constructor function in order to force the developer to supply everything that is needed for the component to work properly.

# How to use it

You need elm-live installed globally.

Unix style terminal:

`elm-live -s .\docs\index.html .\src\SE\UI.elm -- --output=app.js`

Powershell:

`elm-live -s .\docs\index.html .\src\SE\UI.elm "--" --output=app.js`

More information to come

# Installation and help

Use https://github.com/Skinney/elm-git-install to utilize in application

## Setup npm script support in Windows

https://stackoverflow.com/questions/23243353/how-to-set-shell-for-npm-run-scripts-in-windows

## Other resources

 - https://github.com/dillonkearns/idiomatic-elm-package-guide

# TODO
 - [ ] Form File button
 - [ ] Documentation (type that takes a label, description, code examples)
 - [x] Refactor Image, add alt text and improve dimensions (figure tag, width and height optional and is should be responsive)

# Maybe TODO
 - [x] Consider using [NoRedInks Versioning policy](https://package.elm-lang.org/packages/NoRedInk/noredink-ui/latest/)
 - [ ] Message (can be useful to insert into a product listing to announce stuff)
 - [ ] Modal card (do we need the card option?)
 - [ ] Box (different styling from Bulma?)
 - [x] Card, or should be have Card and Box as one unified component?
