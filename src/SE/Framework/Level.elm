module SE.Framework.Level exposing (centeredLevel, item, level, mobileLevel)

import Css exposing (Style, auto, bold, center, currentColor, em, flexEnd, flexStart, hidden, important, inlineBlock, int, left, num, pct, pseudoClass, px, rem, solid, spaceBetween, top, zero)
import Css.Global exposing (adjacentSiblings, descendants, each, selector, typeSelector)
import Html.Styled exposing (Html, styled, text)
import Html.Styled.Attributes exposing (class)
import SE.Framework.Colors exposing (darker, darkest, light, lighter, lightest, primary, white)
import SE.Framework.Utils exposing (block, mobile, overflowTouch, radius, tablet)


type Item msg
    = Item (List (Html msg))


{-| Takes 2 lists of `item`, the first will be left-aligned, the second right-aligned
-}
level : List (Item msg) -> List (Item msg) -> Html msg
level =
    internalLevel False


mobileLevel : List (Item msg) -> List (Item msg) -> Html msg
mobileLevel =
    internalLevel True


internalLevel : Bool -> List (Item msg) -> List (Item msg) -> Html msg
internalLevel isMobile lfts rgts =
    styled Html.Styled.nav
        (levelStyles isMobile)
        []
        [ styled Html.Styled.div leftStyles [ class "left" ] (List.map (itemToHtml False) lfts)
        , styled Html.Styled.div rightStyles [ class "right" ] (List.map (itemToHtml False) rgts)
        ]


centeredLevel : List (Item msg) -> Html msg
centeredLevel items =
    styled Html.Styled.nav
        (levelStyles False)
        []
        (List.map (itemToHtml True) items)


item : List (Html msg) -> Item msg
item =
    Item


itemToHtml : Bool -> Item msg -> Html msg
itemToHtml isCentered (Item html) =
    styled Html.Styled.div (itemStyles isCentered) [] html


levelStyles : Bool -> List Style
levelStyles isMobile =
    [ block
    , Css.alignItems center
    , Css.justifyContent spaceBetween
    , descendants
        [ typeSelector "code"
            [ Css.borderRadius radius
            ]
        , typeSelector "img"
            [ Css.display inlineBlock
            , Css.verticalAlign top
            ]
        ]
    , tablet
        [ Css.displayFlex
        ]
    , Css.batch
        (if isMobile then
            [ Css.displayFlex
            , Css.Global.children
                -- .level-left, .level-right
                [ Css.Global.selector ".left, .right"
                    [ Css.displayFlex
                    , adjacentSiblings
                        -- .level-left + .level-right
                        [ Css.Global.class ".right"
                            [ Css.marginTop zero
                            ]
                        ]
                    ]

                --.level-item
                , Css.Global.selector
                    ".item:not(:last-child)"
                    [ Css.marginBottom zero
                    , Css.marginRight (rem 0.75)
                    ]
                ]
            ]

         else
            []
        )
    ]


itemStyles : Bool -> List Style
itemStyles isCentered =
    let
        modsStyle =
            if isCentered then
                [ Css.textAlign center, Css.flexGrow (int 1) ]

            else
                []
    in
    [ Css.alignItems center
    , Css.displayFlex
    , Css.flexBasis auto
    , Css.flexGrow zero
    , Css.flexShrink zero
    , Css.justifyContent center
    , tablet
        [ Css.marginRight (rem 0.75)
        ]
    , mobile
        [ pseudoClass "not(:last-child)"
            [ Css.marginBottom (rem 0.75)
            ]
        ]
    , Css.batch modsStyle
    ]


leftStyles : List Style
leftStyles =
    [ leftAndRightStyles
    , Css.justifyContent flexStart

    -- When stacked, make sure "level-right" has margin
    , mobile
        [ adjacentSiblings
            [ typeSelector "div"
                [ Css.marginTop (rem 1.5)
                ]
            ]
        ]
    ]


rightStyles : List Style
rightStyles =
    [ leftAndRightStyles
    , Css.justifyContent flexEnd
    ]


leftAndRightStyles : Style
leftAndRightStyles =
    Css.batch
        [ Css.flexBasis auto
        , Css.flexGrow zero
        , Css.flexShrink zero
        , Css.alignItems center
        , tablet
            [ Css.displayFlex
            ]
        ]
