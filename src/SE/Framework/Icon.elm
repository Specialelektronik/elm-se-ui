module SE.Framework.Icon exposing (Icon(..), icon, largeIcon, mediumIcon, smallIcon)

import Css exposing (Style, center, inlineFlex, rem)
import Html.Styled exposing (Html, styled)
import Html.Styled.Attributes exposing (class)


type Icon
    = Home


type Size
    = Regular
    | Small
    | Medium
    | Large


internalIcon : Size -> Icon -> Html msg
internalIcon size i =
    styled Html.Styled.span
        (containerStyles size)
        []
        [ Html.Styled.i [ class "fas", faClass i ] []
        ]


{-| Renders a 1.5 rem icon
-}
icon : Icon -> Html msg
icon =
    internalIcon Regular


{-| Renders a 1.5 rem icon
-}
smallIcon : Icon -> Html msg
smallIcon =
    internalIcon Small


{-| Renders a 1.5 rem icon
-}
mediumIcon : Icon -> Html msg
mediumIcon =
    internalIcon Medium


{-| Renders a 1.5 rem icon
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


faClass : Icon -> Html.Styled.Attribute msg
faClass i =
    class
        (case i of
            Home ->
                "fa-home"
        )
