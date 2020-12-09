module SE.UI.Buttons exposing
    ( buttons, ButtonsModifier(..)
    , button, staticButton, Modifier(..)
    , buttonStyles
    )

{-| Buttons from Bulma with some small design adjustments. Supports all colors and the `buttons` container.

see <https://bulma.io/documentation/elements/button/>


# Grouping

@docs buttons, ButtonsModifier


# Buttons

@docs button, staticButton, Modifier


# Styles

@docs buttonStyles

-}

import Css exposing (Style, absolute, calc, center, disabled, em, flexEnd, flexStart, focus, important, minus, noWrap, none, num, pct, pointer, pseudoClass, px, rem, transparent, underline, wrap, zero)
import Css.Global exposing (children, descendants, typeSelector)
import Css.Transitions
import Html.Styled exposing (Html, styled, text)
import Html.Styled.Attributes
import Html.Styled.Events exposing (onClick)
import SE.UI.Colors as Colors
import SE.UI.Control as Control exposing (controlStyle)
import SE.UI.Utils as Utils exposing (centerEm, loader)


{-| Modify the button, support all modifiers in Bulma except the Disabled. To disable a button, use `Nothing` as the Maybe msg.
-}
type
    Modifier
    -- Colors
    = Color Colors.Color
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


{-| Use this if you need a custom button with our styling
-}
buttonStyles : List Modifier -> HasIcon -> List Style
buttonStyles mods hasIcon =
    let
        size =
            extractControlSize mods
    in
    [ -- Override padding left and right on buttons
      Css.property "padding" "calc(0.5em - 1px) calc(1.5em - 1px)"
    , Utils.desktop
        [ Css.property "padding" "calc(0.75em - 1px) calc(1.5em - 1px)"
        ]
    , controlStyle size
    , Colors.backgroundColor Colors.white
    , Colors.borderColor Colors.border
    , Css.borderWidth (px 1)
    , Colors.color Colors.text
    , Css.cursor pointer
    , Css.justifyContent center
    , Css.textAlign center
    , Css.whiteSpace noWrap
    , buttonShadow
    , Css.hover
        [ Colors.borderColor (Colors.border |> Colors.hover)
        , buttonShadowHover
        , Css.Transitions.transition
            [ Css.Transitions.backgroundColor 250
            , Css.Transitions.boxShadow 250
            ]
        , Css.pseudoClass "not(disabled)"
            [ Css.zIndex (Css.int 2)
            ]
        ]
    , Css.active
        [ Colors.borderColor (Colors.border |> Colors.active)
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
                [ --Css.marginLeft (calc (em -0.375) minus (px 1))
                  Css.marginRight (em 0.1875)
                ]
            , pseudoClass "last-child:not(:first-child)"
                [ Css.marginRight (calc (em -0.375) minus (px 1))
                , Css.marginLeft (em 0.1875)
                ]
            , pseudoClass "first-child:last-child"
                [ --Css.marginLeft (calc (em -0.375) minus (px 1))
                  Css.marginRight (calc (em -0.375) minus (px 1))
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
        ++ [ important (Css.backgroundColor (Colors.lightest |> Colors.toCss))
           , important (Css.color (Colors.dark |> Colors.toCss))
           , important (Css.pointerEvents none)
           ]


buttonModifiers : (Modifier -> Style) -> List Modifier -> Style
buttonModifiers callback mods =
    Css.batch (List.map callback mods)


buttonModifier : Modifier -> Style
buttonModifier modifier =
    case modifier of
        Color color ->
            let
                hsla =
                    color |> Colors.toHsla

                hover =
                    hsla |> Colors.hover

                active =
                    hsla |> Colors.active
            in
            Css.batch
                [ Css.fontWeight (Css.int 600)
                , Colors.color (hsla |> Colors.invert)
                , Colors.backgroundColor hsla
                , Css.borderColor transparent
                , Css.hover
                    [ Colors.color (hover |> Colors.invert)
                    , Colors.backgroundColor hover
                    , Css.borderColor transparent
                    ]
                , Css.active
                    [ Colors.color (active |> Colors.invert)
                    , Colors.backgroundColor active
                    ]
                , disabled
                    [ important (Colors.backgroundColor hsla)
                    ]
                ]

        Text ->
            Css.batch
                [ Css.backgroundColor transparent
                , Css.borderColor transparent
                , Css.hover
                    [ Colors.backgroundColor (Colors.background |> Colors.hover)
                    , Css.borderColor transparent
                    ]
                , Css.focus
                    [ Colors.backgroundColor (Colors.background |> Colors.hover)
                    ]
                , Css.active
                    [ Colors.backgroundColor (Colors.background |> Colors.active)
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
