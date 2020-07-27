module SE.UI.Global exposing (global)

{-| Global reset and base styles, based on Bulmas minireset.sass and generic.sass


# Definition

@docs global

-}

import Css
import Css.Global
import Html.Styled exposing (Html)
import SE.UI.Colors as Colors
import SE.UI.Font as Font
import SE.UI.Utils as Utils


{-| Add this constant as a plain html element, preferably as high in the hierarchy as possible

    div []
        [ global
        , h1 [] [ text "Hello World!" ]
        ]

-}
global : Html msg
global =
    Css.Global.global
        (reset ++ base)



-- RESET


reset : List Css.Global.Snippet
reset =
    [ blocks
    , headings
    , lists
    , form
    , boxSizing
    , media
    , audio
    , iframe
    , table
    ]


blocks : Css.Global.Snippet
blocks =
    Css.Global.each
        [ Css.Global.html
        , Css.Global.body
        , Css.Global.p
        , Css.Global.ol
        , Css.Global.ul
        , Css.Global.li
        , Css.Global.dl
        , Css.Global.dt
        , Css.Global.dd
        , Css.Global.blockquote
        , Css.Global.typeSelector "figure"
        , Css.Global.fieldset
        , Css.Global.legend
        , Css.Global.textarea
        , Css.Global.pre
        , Css.Global.typeSelector "iframe"
        , Css.Global.hr
        , Css.Global.h1
        , Css.Global.h2
        , Css.Global.h3
        , Css.Global.h4
        , Css.Global.h5
        , Css.Global.h6
        ]
        [ Css.margin Css.zero
        , Css.padding Css.zero
        ]


headings : Css.Global.Snippet
headings =
    Css.Global.each
        [ Css.Global.h1
        , Css.Global.h2
        , Css.Global.h3
        , Css.Global.h4
        , Css.Global.h5
        , Css.Global.h6
        ]
        [ Css.fontSize (Css.pct 100)
        , Css.fontWeight (Css.int 600)
        ]


lists : Css.Global.Snippet
lists =
    Css.Global.each
        [ Css.Global.ul
        ]
        [ Css.listStyle Css.none
        ]


form : Css.Global.Snippet
form =
    Css.Global.each
        [ Css.Global.form
        , Css.Global.button
        , Css.Global.input
        , Css.Global.select
        , Css.Global.textarea
        ]
        [ Css.margin Css.zero ]


boxSizing : Css.Global.Snippet
boxSizing =
    Css.Global.html
        [ Css.boxSizing Css.borderBox
        , Css.Global.descendants
            [ Css.Global.each
                [ Css.Global.everything
                , Css.Global.selector "*::before"
                , Css.Global.selector "*::after"
                ]
                [ Css.boxSizing Css.inherit
                ]
            ]
        ]


media : Css.Global.Snippet
media =
    Css.Global.each
        [ Css.Global.selector "img:not([height])"
        , Css.Global.selector "embed:not([height])"
        , Css.Global.selector "iframe:not([height])"
        , Css.Global.selector "object:not([height])"
        , Css.Global.selector "video:not([height])"
        ]
        [ Css.height Css.auto
        , Css.maxWidth (Css.pct 100)
        ]


audio : Css.Global.Snippet
audio =
    Css.Global.audio
        [ Css.maxWidth (Css.pct 100)
        ]


iframe : Css.Global.Snippet
iframe =
    Css.Global.typeSelector "iframe"
        [ Css.border Css.zero
        ]


table : Css.Global.Snippet
table =
    Css.Global.table
        [ Css.borderCollapse Css.collapse
        , Css.borderSpacing Css.zero
        , Css.Global.descendants
            [ Css.Global.each
                [ Css.Global.td
                , Css.Global.th
                ]
                [ Css.padding Css.zero
                , Css.textAlign Css.left
                ]
            ]
        ]



-- BASE


base : List Css.Global.Snippet
base =
    [ html, block, fonts, code, body, inlineAndBlock ]


html : Css.Global.Snippet
html =
    Css.Global.html
        [ Css.fontSize Font.mobileBaseSize
        , Css.property "-moz-osx-font-smoothing" "grayscale"
        , Css.property "-webkit-font-smoothing" "antialiased"
        , Css.minWidth (Css.px 300)
        , Css.overflowX Css.hidden
        , Css.overflowY Css.scroll
        , Css.textRendering Css.optimizeLegibility
        , Css.property "textSizeAdjust" "100%"
        , Utils.desktop
            [ Css.fontSize Font.desktopBaseSize
            ]
        ]


block : Css.Global.Snippet
block =
    Css.Global.each
        [ Css.Global.article
        , Css.Global.aside
        , Css.Global.typeSelector "figure"
        , Css.Global.footer
        , Css.Global.header
        , Css.Global.typeSelector "hgroup"
        , Css.Global.section
        ]
        [ Css.display Css.block
        ]


fonts : Css.Global.Snippet
fonts =
    Css.Global.each
        [ Css.Global.body
        , Css.Global.button
        , Css.Global.input
        , Css.Global.select
        , Css.Global.textarea
        ]
        [ Css.property "font-family" Font.family
        ]


code : Css.Global.Snippet
code =
    Css.Global.each
        [ Css.Global.code
        , Css.Global.pre
        ]
        [ Css.property "-moz-osx-font-smoothing" "auto"
        , Css.property "-webkit-font-smoothing" "auto"
        , Css.property "font-family" Font.codeFamily
        ]


body : Css.Global.Snippet
body =
    Css.Global.body
        [ Colors.color Colors.darkest
        , Css.fontWeight Css.normal
        , Css.lineHeight (Css.num 1.5)
        ]


inlineAndBlock : Css.Global.Snippet
inlineAndBlock =
    Css.Global.html
        [ Css.Global.descendants
            [ Css.Global.a
                [ Css.color (Colors.link |> Colors.toCss)
                , Css.cursor Css.pointer
                , Css.textDecoration Css.none
                , Css.Global.descendants
                    [ Css.Global.strong
                        [ Css.color Css.currentColor
                        ]
                    ]
                , Css.hover
                    [ Css.color (Colors.link |> Colors.hover |> Colors.toCss)
                    ]
                ]
            , Css.Global.code
                [ Colors.backgroundColor Colors.background
                , Colors.color Colors.danger
                , Font.bodySizeEm -1
                , Css.fontWeight Css.normal
                , Css.padding3 (Css.em 0.25) (Css.em 0.5) (Css.em 0.25)
                ]
            , Css.Global.hr
                [ Colors.backgroundColor Colors.background
                , Css.border Css.zero
                , Css.display Css.block
                , Css.height (Css.px 2)
                , Css.margin2 (Css.rem 1.5) Css.zero
                ]

            -- , Css.Global.each
            --     [ Css.Global.selector "input[type=\"checkbox\"]"
            --     , Css.Global.selector "input[type=\"radio\"]"
            --     ]
            --     [ Css.verticalAlign Css.baseline
            --     ]
            , Css.Global.small
                [ Font.bodySizeEm -1
                ]
            , Css.Global.span
                [ Css.fontStyle Css.inherit
                , Css.fontWeight Css.inherit
                ]
            , Css.Global.strong
                [ Css.fontWeight (Css.int 600)
                ]
            , Css.Global.fieldset
                [ Css.border Css.zero
                ]
            , Css.Global.pre
                [ Css.property "-webkit-overflow-scrolling" "touch"
                , Colors.backgroundColor Colors.background
                , Colors.color Colors.darkest
                , Font.bodySizeEm -1
                , Css.overflowX Css.auto
                , Css.padding2 (Css.rem 1.25) (Css.rem 1.5)
                , Css.whiteSpace Css.pre
                , Css.property "word-wrap" "normal"
                , Css.Global.descendants
                    [ Css.Global.code
                        [ Css.backgroundColor Css.transparent
                        , Colors.color Colors.danger
                        , Font.bodySizeEm 1
                        , Css.padding Css.zero
                        ]
                    ]
                ]
            , Css.Global.table
                [ Css.Global.descendants
                    [ Css.Global.each [ Css.Global.td, Css.Global.th ]
                        [ Css.textAlign Css.left
                        , Css.verticalAlign Css.top
                        ]
                    , Css.Global.th
                        [ Colors.color Colors.darkest
                        ]
                    ]
                ]
            ]
        ]
