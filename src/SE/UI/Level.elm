module SE.UI.Level exposing
    ( level, mobileLevel, centeredLevel
    , Item, item
    )

{-| Bulmas level component
see <https://bulma.io/documentation/layout/level/>

This module is divided levels and items.


# Levels

@docs level, mobileLevel, centeredLevel


# Item

@docs Item, item

-}

import Css exposing (Style)
import Css.Global
import Html.Styled exposing (Html, styled)
import Html.Styled.Attributes as Attributes
import SE.UI.Utils as Utils


{-| Use the `item` function to create a level item
-}
type Item msg
    = Item (List (Html msg))



-- LEVEL


{-| Takes 2 lists of `item`, the first will be left-aligned, the second right-aligned
-}
level : List (Item msg) -> List (Item msg) -> Html msg
level =
    internalLevel False


{-| Same as the standard level, except that the level will maintain its horizontal layout on mobile size.
-}
mobileLevel : List (Item msg) -> List (Item msg) -> Html msg
mobileLevel =
    internalLevel True


{-| Centered level, takes 1 list of `item`
-}
centeredLevel : List (Item msg) -> Html msg
centeredLevel items =
    styled Html.Styled.nav
        (levelStyles False)
        []
        (List.map (itemToHtml True) items)


internalLevel : Bool -> List (Item msg) -> List (Item msg) -> Html msg
internalLevel isMobile lfts rgts =
    styled Html.Styled.nav
        (levelStyles isMobile)
        [ Attributes.classList [ ( "level", True ) ] ]
        [ styled Html.Styled.div leftStyles [ Attributes.classList [ ( "left", True ) ] ] (List.map (itemToHtml False) lfts)
        , styled Html.Styled.div rightStyles [ Attributes.classList [ ( "right", True ) ] ] (List.map (itemToHtml False) rgts)
        ]


levelStyles : Bool -> List Style
levelStyles isMobile =
    [ Utils.block
    , Css.alignItems Css.center
    , Css.justifyContent Css.spaceBetween
    , Css.Global.descendants
        [ Css.Global.typeSelector "code"
            [ Css.borderRadius Utils.radius
            ]
        , Css.Global.typeSelector "img"
            [ Css.display Css.inlineBlock
            , Css.verticalAlign Css.top
            ]
        ]
    , Utils.tablet
        [ Css.displayFlex
        ]
    , Css.batch
        (if isMobile then
            [ Css.displayFlex
            , Css.Global.children
                -- .level-left, .level-right
                [ Css.Global.selector ".left, .right"
                    [ Css.displayFlex
                    , Css.Global.adjacentSiblings
                        -- .level-left + .level-right
                        [ Css.Global.class ".right"
                            [ Css.marginTop Css.zero
                            ]
                        ]
                    ]

                --.level-item
                , Css.Global.selector
                    ".item:not(:last-child)"
                    [ Css.marginBottom Css.zero
                    , Css.marginRight (Css.rem 0.75)
                    ]
                ]
            ]

         else
            []
        )
    ]


leftStyles : List Style
leftStyles =
    [ leftAndRightStyles
    , Css.justifyContent Css.flexStart

    -- When stacked, make sure "level-right" has margin
    , Utils.mobile
        [ Css.Global.adjacentSiblings
            [ Css.Global.typeSelector "div"
                [ Css.marginTop (Css.rem 1.5)
                ]
            ]
        ]
    ]


rightStyles : List Style
rightStyles =
    [ leftAndRightStyles
    , Css.justifyContent Css.flexEnd
    ]


leftAndRightStyles : Style
leftAndRightStyles =
    Css.batch
        [ Css.flexBasis Css.auto
        , Css.flexGrow Css.zero
        , Css.flexShrink Css.zero
        , Css.alignItems Css.center
        , Utils.tablet
            [ Css.displayFlex
            ]
        ]



-- ITEM


{-| Item
-}
item : List (Html msg) -> Item msg
item =
    Item


itemToHtml : Bool -> Item msg -> Html msg
itemToHtml isCentered (Item html) =
    styled Html.Styled.div (itemStyles isCentered) [] html


itemStyles : Bool -> List Style
itemStyles isCentered =
    let
        modsStyle =
            if isCentered then
                [ Css.textAlign Css.center, Css.flexGrow (Css.int 1) ]

            else
                []
    in
    [ Css.alignItems Css.center
    , Css.displayFlex
    , Css.flexBasis Css.auto
    , Css.flexGrow Css.zero
    , Css.flexShrink Css.zero
    , Css.justifyContent Css.center
    , Utils.tablet
        [ Css.marginRight (Css.rem 0.75)
        ]
    , Utils.mobile
        [ Css.pseudoClass "not(:last-child)"
            [ Css.marginBottom (Css.rem 0.75)
            ]
        ]
    , Css.batch modsStyle
    ]
