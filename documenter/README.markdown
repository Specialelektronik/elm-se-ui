# Introduction

This Elm program reads the docs.json file from an Elm package and constructs a design document.

Example:

```elm

section : List (Html msg) -> Html msg
section kids =
    Html.section [] kids
```

The documenter will parser the docs.json and render all exposed functions which at the end returns `Html msg`. It will replace all function parameters with dummy data and provide a UI for changing them.
