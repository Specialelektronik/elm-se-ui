module SE.Framework.Button exposing (Modifier(..), button)

import Css exposing (Style, absolute, active, bold, center, em, focus, hover, important, noWrap, none, pointer, px, rem, rgba, transparent, underline, zero)
import Html.Styled exposing (Attribute, Html, styled, text)
import Html.Styled.Events exposing (onClick)
import SE.Framework.Colors as Colors
import SE.Framework.Control exposing (control)
import SE.Framework.Utils exposing (centerEm, loader)


type
    Modifier
    -- Colors
    = Primary
    | Link
    | Info
    | Success
    | Warning
    | Danger
    | White
    | Lightest
    | Lighter
    | Light
    | Dark
    | Darker
    | Darkest
    | Black
    | Text
      -- Sizes
    | Small
    | Normal
    | Medium
    | Large
      -- Misc
    | Fullwidth
    | Loading
    | Static
    | Disabled


{-| A reusable button which has some styles pre-applied to it.
-}
button : List Modifier -> Maybe msg -> List (Html msg) -> Html msg
button modifiers onPress html =
    let
        eventAttribs =
            case onPress of
                Nothing ->
                    []

                Just msg ->
                    [ onClick msg ]
    in
    styled Html.Styled.button
        (buttonStyles modifiers)
        eventAttribs
        html


buttonStyles : List Modifier -> List Style
buttonStyles modifiers =
    [ control
    , Css.backgroundColor Colors.white
    , Css.borderColor Colors.light
    , Css.borderWidth (px 1)
    , Css.color Colors.text
    , Css.cursor pointer
    , Css.justifyContent center
    , Css.textAlign center
    , Css.whiteSpace noWrap
    , Css.boxShadow5 zero (px 2) (px 4) zero (rgba 0 0 0 0.1)
    , Css.marginRight (rem 0.5)
    , hover
        [ Css.borderColor Colors.base
        ]
    , buttonModifiers buttonModifier modifiers
    ]


buttonModifiers : (Modifier -> Style) -> List Modifier -> Style
buttonModifiers callback modifiers =
    Css.batch (List.map callback modifiers)


buttonModifier : Modifier -> Style
buttonModifier modifier =
    case modifier of
        Primary ->
            Css.batch
                [ Css.color Colors.white
                , Css.backgroundColor Colors.primary
                , Css.borderColor transparent
                , hover
                    [ Css.color Colors.white
                    , Css.backgroundColor Colors.primaryDark
                    , Css.borderColor transparent
                    ]
                ]

        Link ->
            Css.batch
                [ Css.color Colors.white
                , Css.backgroundColor Colors.link
                , Css.borderColor transparent
                , hover
                    [ Css.color Colors.white
                    , Css.backgroundColor Colors.linkDark
                    , Css.borderColor transparent
                    ]
                ]

        Info ->
            Css.batch
                [ Css.color Colors.white
                , Css.backgroundColor Colors.info
                , Css.borderColor transparent
                , hover
                    [ Css.color Colors.white
                    , Css.backgroundColor Colors.infoDark
                    , Css.borderColor transparent
                    ]
                ]

        Success ->
            Css.batch
                [ Css.color Colors.white
                , Css.backgroundColor Colors.success
                , Css.borderColor transparent
                , hover
                    [ Css.color Colors.white
                    , Css.backgroundColor Colors.successDark
                    , Css.borderColor transparent
                    ]
                ]

        Warning ->
            Css.batch
                [ Css.backgroundColor Colors.warning
                , Css.borderColor transparent
                , hover
                    [ Css.backgroundColor Colors.warningDark
                    , Css.borderColor transparent
                    ]
                ]

        Danger ->
            Css.batch
                [ Css.color Colors.white
                , Css.backgroundColor Colors.danger
                , Css.borderColor transparent
                , hover
                    [ Css.color Colors.white
                    , Css.backgroundColor Colors.dangerDark
                    , Css.borderColor transparent
                    ]
                ]

        Loading ->
            Css.batch
                [ important (Css.color transparent)
                , Css.pointerEvents none
                , important (Css.position absolute)
                , Css.after
                    [ loader
                    , centerEm 1 1
                    ]
                ]

        White ->
            Css.batch
                [ Css.backgroundColor Colors.white
                , Css.borderColor transparent
                , hover
                    [ Css.backgroundColor Colors.lightest
                    , Css.borderColor transparent
                    ]
                ]

        Lightest ->
            Css.batch
                [ Css.backgroundColor Colors.lightest
                , Css.borderColor transparent
                , hover
                    [ Css.backgroundColor Colors.lighter
                    , Css.borderColor transparent
                    ]
                ]

        Lighter ->
            Css.batch
                [ Css.backgroundColor Colors.lighter
                , Css.borderColor transparent
                , hover
                    [ Css.backgroundColor Colors.light
                    , Css.borderColor transparent
                    ]
                ]

        Light ->
            Css.batch
                [ Css.backgroundColor Colors.light
                , Css.borderColor transparent
                , hover
                    [ Css.backgroundColor Colors.base
                    , Css.borderColor transparent
                    ]
                ]

        Dark ->
            Css.batch
                [ Css.color Colors.white
                , Css.backgroundColor Colors.dark
                , Css.borderColor transparent
                , hover
                    [ Css.backgroundColor Colors.darker
                    , Css.borderColor transparent
                    ]
                ]

        Darker ->
            Css.batch
                [ Css.color Colors.white
                , Css.backgroundColor Colors.darker
                , Css.borderColor transparent
                , hover
                    [ Css.backgroundColor Colors.darkest
                    , Css.borderColor transparent
                    ]
                ]

        Darkest ->
            Css.batch
                [ Css.color Colors.white
                , Css.backgroundColor Colors.darkest
                , Css.borderColor transparent
                , hover
                    [ Css.backgroundColor Colors.black
                    , Css.borderColor transparent
                    ]
                ]

        Black ->
            Css.batch
                [ Css.color Colors.white
                , Css.backgroundColor Colors.black
                , Css.borderColor transparent
                , hover
                    [ Css.backgroundColor Colors.black
                    , Css.borderColor transparent
                    ]
                ]

        Text ->
            Css.batch
                [ Css.color Colors.text
                , Css.backgroundColor transparent
                , Css.borderColor transparent
                , Css.textDecoration underline
                , Css.boxShadow none
                , hover
                    [ Css.backgroundColor Colors.backgroundHover
                    , Css.borderColor transparent
                    , Css.color Colors.text
                    ]
                , focus
                    [ Css.backgroundColor Colors.backgroundHover
                    , Css.color Colors.text
                    ]
                , active
                    [ Css.backgroundColor Colors.backgroundActive
                    , Css.color Colors.black
                    ]
                ]

        _ ->
            Css.batch []
