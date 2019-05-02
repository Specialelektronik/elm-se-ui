module SE.Framework.Icon exposing
    ( icon
    , smallIcon, mediumIcon, largeIcon
    )

{-| Creates a Bulma Icon element set.

<https://bulma.io/documentation/elements/icon/>


# Definition

@docs icon


# Sizes

@docs smallIcon, mediumIcon, largeIcon

-}

import Css exposing (Style, center, inlineFlex, rem)
import Html.Styled exposing (Html, styled)
import Html.Styled.Attributes exposing (class)


type alias Icon =
    String


type Size
    = Regular
    | Small
    | Medium
    | Large


internalIcon : Size -> Icon -> Html msg
internalIcon size i =
    styled Html.Styled.span
        (containerStyles size)
        [ class "icon" ]
        [ Html.Styled.i [ class ("fas" ++ faClass i) ] []
        ]


{-| Renders a 1.5 rem icon
-}
icon : Icon -> Html msg
icon =
    internalIcon Regular


{-| Renders a 1 rem icon
-}
smallIcon : Icon -> Html msg
smallIcon =
    internalIcon Small


{-| Renders a 2 rem icon
-}
mediumIcon : Icon -> Html msg
mediumIcon =
    internalIcon Medium


{-| Renders a 3 rem icon
-}
largeIcon : Icon -> Html msg
largeIcon =
    internalIcon Large


iconDimensions : Size -> Css.Rem
iconDimensions size =
    rem
        (case size of
            Regular ->
                1.5

            Small ->
                1

            Medium ->
                2

            Large ->
                3
        )


containerStyles : Size -> List Style
containerStyles size =
    [ Css.alignItems center
    , Css.display inlineFlex
    , Css.justifyContent center
    , Css.height (iconDimensions size)
    , Css.width (iconDimensions size)
    , Css.fontSize (faDimensions size)
    ]


faDimensions : Size -> Css.Rem
faDimensions size =
    rem
        (case size of
            Regular ->
                1

            Small ->
                1

            Medium ->
                1.33

            Large ->
                2
        )


faClass : String -> String
faClass str =
    if String.startsWith "fa-" str then
        str

    else
        "fa-" ++ str
