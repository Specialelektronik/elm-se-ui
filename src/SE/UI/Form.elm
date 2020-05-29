module SE.UI.Form exposing
    ( label, labelRequired
    , field, FieldModifier(..), control, expandedControl
    )

{-| Bulmas Form elements
see <https://bulma.io/documentation/form/>


# General

@docs label, labelRequired


# Fields and Controls

@docs field, FieldModifier, control, expandedControl


# Unsupported features

  - Horizontal form
  - Size modifier (for some elements)
  - .help
  - icons in input, textarea, select .control

-}

import Css exposing (Style, absolute, block, bold, borderBox, em, flexStart, important, int, left, pseudoClass, px, relative, rem, top, zero)
import Css.Global exposing (descendants, each, typeSelector)
import Html.Styled exposing (Html, styled, text)
import Html.Styled.Attributes exposing (class)
import SE.UI.Colors as Colors
import SE.UI.Font as Font
import SE.UI.Utils as Utils


{-| Field Modifier
-}
type FieldModifier
    = Attached
    | Grouped


type alias IsLoading =
    Bool



-- LABEL


{-| `label.label`
-}
label : String -> Html msg
label =
    labelHelper False


{-| `label.label` with a red \* at the end.let
**Notice:** There is not validation connected to this function. The validation has to be carried out on the input function.
in
-}
labelRequired : String -> Html msg
labelRequired =
    labelHelper True


labelHelper : Bool -> String -> Html msg
labelHelper required s =
    let
        star =
            if required then
                styled Html.Styled.span
                    [ Css.color (Colors.danger |> Colors.toCss)
                    ]
                    []
                    [ text " *" ]

            else
                text ""
    in
    styled Html.Styled.label
        [ Css.color (Colors.text |> Colors.toCss)
        , Css.display block
        , Font.bodySizeRem -2
        , Css.textTransform Css.uppercase
        , Css.fontWeight bold
        , pseudoClass "not(:last-child)"
            [ Css.marginBottom (em 0.5)
            ]
        ]
        []
        [ text s, star ]


{-| `div.field`

    field [] [ text "Field" ] == "<div class='field'>Field</div>"

    field [ Attached ] [ text "Attached field" ] = "<div class='field'> Attached field</div>"

    field [ Grouped ] [ text "Grouped field" ] = "<div class='field'>Grouped field</div>"

-}
field : List FieldModifier -> List (Html msg) -> Html msg
field mods =
    styled Html.Styled.div
        [ pseudoClass "not(:last-child)"
            [ Css.marginBottom (rem 0.75)
            ]
        , Css.batch (List.map fieldModifier mods)
        ]
        [ class "field" ]


fieldModifier : FieldModifier -> Style
fieldModifier mod =
    Css.batch
        (case mod of
            Attached ->
                [ Css.displayFlex
                , Css.justifyContent flexStart
                , descendants
                    [ Css.Global.class "control"
                        [ pseudoClass "not(:last-child)"
                            [ Css.marginRight (px -1)
                            ]
                        , pseudoClass "not(:first-child):not(:last-child)"
                            [ descendants
                                [ each
                                    [ typeSelector "button"
                                    , typeSelector "input"
                                    , typeSelector "select"
                                    ]
                                    [ Css.borderRadius zero ]
                                ]
                            ]
                        , pseudoClass "first-child:not(:only-child)"
                            [ descendants
                                [ each
                                    [ typeSelector "button"
                                    , typeSelector "input"
                                    , typeSelector "select"
                                    ]
                                    [ Css.borderBottomRightRadius zero
                                    , Css.borderTopRightRadius zero
                                    ]
                                ]
                            ]
                        , pseudoClass "last-child:not(:only-child)"
                            [ descendants
                                [ each
                                    [ typeSelector "button"
                                    , typeSelector "input"
                                    , typeSelector "select"
                                    ]
                                    [ Css.borderBottomLeftRadius zero
                                    , Css.borderTopLeftRadius zero
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]

            Grouped ->
                [ Css.displayFlex
                , Css.justifyContent flexStart
                , Css.Global.children
                    [ Css.Global.class "control"
                        [ Css.flexShrink zero
                        , pseudoClass "not(:last-child)"
                            [ Css.marginBottom zero
                            , Css.marginRight (rem 0.75)
                            ]
                        ]
                    ]
                ]
        )


{-| `div.control`

    control False [] == "<div class='control'></div>"

    control True [] == "<div class='control is-loading'></div>"

-}
control : IsLoading -> List (Html msg) -> Html msg
control =
    internalControl False


{-| `div.control.is-expanded`

    expandedControl False [] == "<div class='controlis-expanded'></div>"

    expandedControl True [] == "<div class='control is-expanded is-loading'></div>"

-}
expandedControl : IsLoading -> List (Html msg) -> Html msg
expandedControl =
    internalControl True


internalControl : Bool -> Bool -> List (Html msg) -> Html msg
internalControl isExpanded loading =
    let
        loadingStyle =
            if loading then
                [ Css.after
                    [ Utils.loader
                    , important (Css.position absolute)
                    , Css.right (em 0.625)
                    , Css.top (em 0.625)
                    , Css.zIndex (int 4)
                    ]
                ]

            else
                []
    in
    styled Html.Styled.div
        ([ Css.boxSizing borderBox
         , Css.property "clear" "both"
         , Font.bodySizeRem 1
         , Css.position relative
         , Css.textAlign left
         , if isExpanded then
            Css.flexGrow (int 1)

           else
            Css.batch []
         ]
            ++ loadingStyle
        )
        [ class "control" ]
