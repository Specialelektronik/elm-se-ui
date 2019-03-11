module SE.Framework.Buttons exposing (ButtonsModifier(..), Modifier(..), button, buttons)

import Css exposing (Style, absolute, active, bold, center, em, flexEnd, flexStart, focus, hover, important, noWrap, none, pointer, pseudoClass, px, rem, rgba, transparent, underline, wrap, zero)
import Css.Global exposing (descendants, typeSelector)
import Css.Transitions
import Html.Styled exposing (Attribute, Html, styled, text)
import Html.Styled.Attributes exposing (class)
import Html.Styled.Events exposing (onClick)
import SE.Framework.Colors as Colors
import SE.Framework.Control exposing (controlStyle)
import SE.Framework.Utils exposing (centerEm, loader, smallRadius)


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


type ButtonsModifier
    = Attached
    | Centered
    | Right


buttonShadow : Style
buttonShadow =
    --Css.boxShadow4 zero (px 2) (px 3) (rgba 135 149 161 0.2)
    Css.boxShadow none


buttonShadowHover : Style
buttonShadowHover =
    --Css.boxShadow4 zero (px 2) (px 3) (rgba 135 149 161 0.2)
    Css.boxShadow none


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


buttons : List ButtonsModifier -> List (Html msg) -> Html msg
buttons mods btns =
    styled Html.Styled.div (buttonsStyles mods) [] btns


buttonStyles : List Modifier -> List Style
buttonStyles modifiers =
    [ controlStyle
    , Css.backgroundColor Colors.white
    , Css.borderColor Colors.light
    , Css.borderWidth (px 1)
    , Css.color Colors.text
    , Css.cursor pointer
    , Css.justifyContent center
    , Css.textAlign center
    , Css.whiteSpace noWrap
    , buttonShadow
    , hover
        [ Css.borderColor Colors.base
        , buttonShadowHover
        , Css.Transitions.transition
            [ Css.Transitions.backgroundColor 250
            , Css.Transitions.boxShadow 250
            ]
        ]
    , active
        [ Css.borderColor Colors.dark
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
                    , Css.backgroundColor Colors.primaryHover
                    , Css.borderColor transparent
                    ]
                , active
                    [ Css.backgroundColor Colors.primaryActive
                    ]
                ]

        Link ->
            Css.batch
                [ Css.color Colors.white
                , Css.backgroundColor Colors.link
                , Css.borderColor transparent
                , hover
                    [ Css.color Colors.white
                    , Css.backgroundColor Colors.linkHover
                    , Css.borderColor transparent
                    ]
                , active
                    [ Css.backgroundColor Colors.linkActive
                    ]
                ]

        Info ->
            Css.batch
                [ Css.color Colors.white
                , Css.backgroundColor Colors.info
                , Css.borderColor transparent
                , hover
                    [ Css.color Colors.white
                    , Css.backgroundColor Colors.infoHover
                    , Css.borderColor transparent
                    ]
                , active
                    [ Css.backgroundColor Colors.infoActive
                    ]
                ]

        Success ->
            Css.batch
                [ Css.color Colors.white
                , Css.backgroundColor Colors.success
                , Css.borderColor transparent
                , hover
                    [ Css.color Colors.white
                    , Css.backgroundColor Colors.successHover
                    , Css.borderColor transparent
                    ]
                , active
                    [ Css.backgroundColor Colors.successActive
                    ]
                ]

        Warning ->
            Css.batch
                [ Css.backgroundColor Colors.warning
                , Css.borderColor transparent
                , hover
                    [ Css.backgroundColor Colors.warningHover
                    , Css.borderColor transparent
                    ]
                , active
                    [ Css.backgroundColor Colors.warningActive
                    ]
                ]

        Danger ->
            Css.batch
                [ Css.color Colors.white
                , Css.backgroundColor Colors.danger
                , Css.borderColor transparent
                , hover
                    [ Css.color Colors.white
                    , Css.backgroundColor Colors.dangerHover
                    , Css.borderColor transparent
                    ]
                , active
                    [ Css.backgroundColor Colors.dangerActive
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
                , active
                    [ Css.backgroundColor Colors.lighter
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
                , active
                    [ Css.backgroundColor Colors.light
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
                , active
                    [ Css.backgroundColor Colors.base
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
                , active
                    [ Css.backgroundColor Colors.dark
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
                , active
                    [ Css.backgroundColor Colors.darkest
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
                , active
                    [ Css.backgroundColor Colors.black
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
                [ Css.textDecoration underline
                , Css.backgroundColor transparent
                , Css.borderColor transparent
                , hover
                    [ Css.backgroundColor Colors.backgroundHover
                    , Css.borderColor transparent
                    ]
                , focus
                    [ Css.backgroundColor Colors.backgroundHover
                    ]
                , active
                    [ Css.backgroundColor Colors.backgroundActive
                    , Css.color Colors.black
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

        Small ->
            Css.batch
                [ Css.borderRadius smallRadius
                , Css.fontSize (rem 0.75)
                ]

        Medium ->
            Css.fontSize (rem 1.25)

        Large ->
            Css.fontSize (rem 1.5)

        _ ->
            Css.batch []


buttonsStyles : List ButtonsModifier -> List Style
buttonsStyles mods =
    [ Css.alignItems center
    , Css.displayFlex
    , Css.flexWrap wrap
    , Css.justifyContent flexStart
    , descendants
        [ typeSelector "button"
            [ Css.marginBottom (rem 0.5)
            , pseudoClass "not(:last-child)"
                [ Css.marginRight (rem 0.5) ]
            ]
        ]
    , pseudoClass
        "last-child"
        [ Css.marginBottom (rem -0.5)
        ]
    , pseudoClass
        "not(:last-child)"
        [ Css.marginBottom (rem 1)
        ]
    , Css.batch (List.map buttonsModifier mods)
    ]


buttonsModifier : ButtonsModifier -> Style
buttonsModifier mod =
    Css.batch
        (case mod of
            Attached ->
                [ descendants
                    [ typeSelector "button"
                        [ pseudoClass "not(:first-child)"
                            [ Css.borderBottomLeftRadius zero
                            , Css.borderTopLeftRadius zero
                            ]
                        , pseudoClass "not(:last-child)"
                            [ Css.borderBottomRightRadius zero
                            , Css.borderTopRightRadius zero
                            , important (Css.marginRight (px -1))
                            ]
                        , pseudoClass ":last-child"
                            [ important (Css.marginRight zero)
                            ]
                        ]
                    ]
                ]

            Centered ->
                [ Css.justifyContent center ]

            Right ->
                [ Css.justifyContent flexEnd ]
        )
