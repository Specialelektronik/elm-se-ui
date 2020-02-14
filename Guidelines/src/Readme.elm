module Readme exposing (about,intent, toMarkdown)

import Html
import Html.Attributes exposing (class)
import Markdown


toMarkdown : String -> Html.Html msg
toMarkdown text =
    Markdown.toHtml [ class "content" ] text


about : String
about =
    """
Private Elm UI library for beautiful, coherent, SE flavored UI.

While this library is MIT, there aren't many other use cases for this library besides Special-Elektroniks applications, thus the "private" flag.

We draw inspiration from [Bulma](https://bulma.io/), [Tailwind CSS](https://tailwindcss.com/), [NSB Pattern Library](https://youtu.be/yE9PKFI19RM?t=543) and [NoRedInk/noredink-ui](https://github.com/NoRedInk/noredink-ui).
"""

intent : String
intent =
    """
With Elm we don't not have go through all of CSS ordinary problems like global scope, unused styles and specificity wars. Instead we get typed CSS using [Elm CSS](https://package.elm-lang.org/packages/rtfeldman/elm-css/latest) that compiles to inline styles at runtime.

This library has the same goals. We focus on type checked and correct components, that's why every component has it's own modifiers, no global "catch-all" kind of stuff.

Let these 2 mottos guide you:

 - "Don't make me think!" - Steve Krug (Me beeing the developer using this library, but also the end user)
 - "Let's go for the ambitious approach!" - Richard Feldman (Us beeing the developers working on this library)

A good example is the [Dropdown](/SE-Framework-Dropdown) and [Table](/SE-Framework-Table) components where each content type has it's own (Opaque) type and constructor function in order to force the developer to supply everything that is needed for the component to work properly.
    """