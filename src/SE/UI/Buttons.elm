module SE.UI.Buttons exposing
    ( buttons, ButtonsModifier(..)
    , button, staticButton, Modifier(..)
    )

{-| Buttons from Bulma with some small design adjustments. Supports all colors and the `buttons` container.

see <https://bulma.io/documentation/elements/button/>


# Grouping

@docs buttons, ButtonsModifier


# Buttons

@docs button, staticButton, Modifier

-}

import Css exposing (Style, absolute, active, bold, calc, center, disabled, em, flexEnd, flexStart, focus, hover, important, minus, noWrap, none, num, pct, pointer, pseudoClass, px, rem, rgba, transparent, underline, wrap, zero)
import Css.Global exposing (children, descendants, typeSelector)
import Css.Transitions
import Html.Styled exposing (Attribute, Html, styled, text)
import Html.Styled.Attributes exposing (class)
import Html.Styled.Events exposing (onClick)
import SE.UI.Colors as Colors
import SE.UI.Control as Control exposing (controlStyle)
import SE.UI.Icon as Icon
import SE.UI.Utils exposing (centerEm, loader, smallRadius)


{-| Modify the button, support all modifiers in Bulma except the Disabled. To disable a button, use `Nothing` as the Maybe msg.
-}
type
    Modifier
    -- Colors
    = Primary
    | Link
    | Info
    | Success
    | Warning
    | CallToAction
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
    | Size Control.Size
      -- Misc
    | Fullwidth
    | Loading


{-| Modifiers for the buttons container.
-}
type ButtonsModifier
    = Attached
    | Centered
    | Right


type alias HasIcon =
    Bool


buttonShadow : Style
buttonShadow =
    --Css.boxShadow4 zero (px 2) (px 3) (rgba 135 149 161 0.2)
    Css.boxShadow none


buttonShadowHover : Style
buttonShadowHover =
    --Css.boxShadow4 zero (px 2) (px 3) (rgba 135 149 161 0.2)
    Css.boxShadow none


{-| A reusable button which has some styles pre-applied to it.
If onPress is Nothing, then the button will show as disabled
-}
button : List Modifier -> Maybe msg -> List (Html msg) -> Html msg
button mods onPress html =
    let
        eventAttribs =
            case onPress of
                Nothing ->
                    [ Html.Styled.Attributes.disabled True ]

                Just msg ->
                    [ onClick msg ]
    in
    styled Html.Styled.button
        (buttonStyles mods False)
        eventAttribs
        html


{-| Static button without onclick message
-}
staticButton : List Modifier -> String -> Html msg
staticButton mods label =
    styled Html.Styled.span
        (staticButtonStyles mods)
        []
        [ text label ]


{-| A "List of buttons" container.
see <https://bulma.io/documentation/elements/button/#list-of-buttons>
-}
buttons : List ButtonsModifier -> List (Html msg) -> Html msg
buttons mods btns =
    styled Html.Styled.div (buttonsStyles mods) [] btns


buttonStyles : List Modifier -> HasIcon -> List Style
buttonStyles mods hasIcon =
    let
        size =
            extractControlSize mods
    in
    [ controlStyle size
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
    , buttonModifiers buttonModifier mods
    , disabled
        [ Css.backgroundColor transparent
        , Css.borderColor transparent
        , Css.boxShadow none
        , Css.opacity (num 0.5)
        ]
    , descendants
        [ Css.Global.selector ".icon"
            [ pseudoClass "first-child:not(:last-child)"
                [ Css.marginLeft (calc (em -0.375) minus (px 1))
                , Css.marginRight (em 0.1875)
                ]
            , pseudoClass "last-child:not(:first-child)"
                [ Css.marginRight (calc (em -0.375) minus (px 1))
                , Css.marginLeft (em 0.1875)
                ]
            , pseudoClass "first-child:last-child"
                [ Css.marginLeft (calc (em -0.375) minus (px 1))
                , Css.marginRight (calc (em -0.375) minus (px 1))
                ]
            ]
        ]
    , if hasIcon then
        important (Css.paddingLeft (em 3.25))

      else
        Css.batch []
    ]


staticButtonStyles : List Modifier -> List Style
staticButtonStyles mods =
    buttonStyles mods False
        ++ [ important (Css.backgroundColor Colors.lightest)
           , important (Css.borderColor Colors.base)
           , important (Css.color Colors.dark)
           , important (Css.pointerEvents none)
           ]


buttonModifiers : (Modifier -> Style) -> List Modifier -> Style
buttonModifiers callback mods =
    Css.batch (List.map callback mods)


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
                , disabled
                    [ important (Css.backgroundColor Colors.primary)
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
                , disabled
                    [ important (Css.backgroundColor Colors.link)
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
                , disabled
                    [ important (Css.backgroundColor Colors.info)
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
                , disabled
                    [ important (Css.backgroundColor Colors.success)
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
                , disabled
                    [ important (Css.backgroundColor Colors.warning)
                    ]
                ]

        CallToAction ->
            Css.batch
                [ Css.color Colors.white
                , Css.backgroundColor Colors.callToAction
                , Css.borderColor transparent
                , hover
                    [ Css.color Colors.white
                    , Css.backgroundColor Colors.callToActionHover
                    , Css.borderColor transparent
                    ]
                , active
                    [ Css.backgroundColor Colors.callToActionActive
                    ]
                , disabled
                    [ important (Css.backgroundColor Colors.callToAction)
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
                , disabled
                    [ important (Css.backgroundColor Colors.danger)
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
                , disabled
                    [ important (Css.backgroundColor Colors.white)
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
                , disabled
                    [ important (Css.backgroundColor Colors.lightest)
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
                , disabled
                    [ important (Css.backgroundColor Colors.lighter)
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
                , disabled
                    [ important (Css.backgroundColor Colors.light)
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
                , disabled
                    [ important (Css.backgroundColor Colors.dark)
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
                , disabled
                    [ important (Css.backgroundColor Colors.darker)
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
                , disabled
                    [ important (Css.backgroundColor Colors.darkest)
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
                , disabled
                    [ important (Css.backgroundColor Colors.black)
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

        Size _ ->
            Css.batch []

        Fullwidth ->
            Css.batch
                [ Css.displayFlex
                , Css.width (pct 100)
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


extractControlSize : List Modifier -> Control.Size
extractControlSize mods =
    List.foldl
        (\m init ->
            case m of
                Size s ->
                    s

                _ ->
                    init
        )
        Control.Regular
        mods


buttonsStyles : List ButtonsModifier -> List Style
buttonsStyles mods =
    [ Css.alignItems center
    , Css.displayFlex
    , Css.flexWrap wrap
    , Css.justifyContent flexStart
    , children
        [ typeSelector "*"
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
                    [ typeSelector "*"
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