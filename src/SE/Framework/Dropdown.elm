module SE.Framework.Dropdown exposing (button, content, dropdown, hr, link)

import Css exposing (Style, absolute, active, auto, block, bold, borderBox, calc, center, deg, em, flexStart, focus, hover, important, initial, inlineBlock, inlineFlex, int, left, middle, minus, noRepeat, noWrap, none, num, pct, pointer, pseudoClass, pseudoElement, px, relative, rem, rgba, rotate, scale, solid, sub, top, transparent, url, vertical, zero)
import Css.Global exposing (adjacentSiblings, descendants, each, typeSelector, withAttribute)
import Css.Transitions
import Html.Styled exposing (Attribute, Html, styled, text)
import Html.Styled.Attributes exposing (class, placeholder)
import Html.Styled.Events exposing (onInput)
import SE.Framework.Buttons as Buttons exposing (button)
import SE.Framework.Colors as Colors exposing (black, danger, darker, info, light, lighter, link, primary, success, warning, white)
import SE.Framework.Control exposing (controlStyle)
import SE.Framework.OuterClick exposing (withId)
import SE.Framework.Utils as Utils exposing (loader, radius)


type alias Url =
    String


type Item msg
    = Link Url (List (Html msg))
    | Content (List (Html msg))
    | Hr


type Button msg
    = Button (List Buttons.Modifier) (Maybe msg) (List (Html msg))


dropdownContentOffset : Css.Px
dropdownContentOffset =
    px 4


dropdownContentShadow : Style
dropdownContentShadow =
    Css.property "box-shadow" "0 2px 3px rgba(34, 41, 47, 0.1), 0 0 0 1px rgba(34, 41, 47, 0.1)"


dropdown : String -> msg -> Bool -> Button msg -> List (Item msg) -> Html msg
dropdown id closeMsg isOpen btn items =
    let
        outerClickAttributes =
            withId id closeMsg
    in
    styled Html.Styled.div
        dropdownStyles
        outerClickAttributes
        [ Html.Styled.div []
            [ buttonToHtml btn
            ]
        , styled Html.Styled.div
            (menuStyles isOpen)
            []
            [ styled Html.Styled.div
                contentStyles
                []
                (List.map itemToHtml items)
            ]
        ]


button : List Buttons.Modifier -> Maybe msg -> List (Html msg) -> Button msg
button =
    Button


link : Url -> List (Html msg) -> Item msg
link =
    Link


content : List (Html msg) -> Item msg
content =
    Content


hr : Item msg
hr =
    Hr


itemToHtml : Item msg -> Html msg
itemToHtml item =
    case item of
        Link url html ->
            styled Html.Styled.a (itemStyles ++ linkStyles) [ Html.Styled.Attributes.href url ] html

        Content html ->
            styled Html.Styled.div itemStyles [] html

        Hr ->
            styled Html.Styled.hr hrStyles [] []


buttonToHtml : Button msg -> Html msg
buttonToHtml (Button modifiers onPress html) =
    Buttons.button modifiers onPress html



-- TODO
--rightDropdown


dropdownStyles : List Style
dropdownStyles =
    [ Css.display inlineFlex
    , Css.position relative
    , Css.verticalAlign top
    , focus
        [ Css.outline none
        ]
    ]


menuStyles : Bool -> List Style
menuStyles isOpen =
    let
        displayStyle =
            if isOpen then
                Css.display block

            else
                Css.display none
    in
    [ displayStyle
    , Css.left zero
    , Css.minWidth (rem 12)
    , Css.paddingTop dropdownContentOffset
    , Css.position absolute
    , Css.top (pct 100)
    , Css.zIndex (int 20)
    ]


contentStyles : List Style
contentStyles =
    [ Css.backgroundColor Colors.white
    , Css.borderRadius radius
    , dropdownContentShadow
    , Css.paddingBottom (rem 0.5)
    , Css.paddingTop (rem 0.5)
    ]


itemStyles : List Style
itemStyles =
    [ Css.color Colors.darker
    , Css.display block
    , Css.fontSize (rem 0.875)
    , Css.lineHeight (num 1.5)
    , Css.padding2 (rem 0.375) (rem 1)
    , Css.position relative
    ]


linkStyles : List Style
linkStyles =
    [ Css.paddingRight (rem 3)
    , Css.textAlign left
    , Css.whiteSpace noWrap
    , Css.width (pct 100)
    , hover
        [ Css.backgroundColor Colors.background
        , Css.color Colors.black
        ]
    ]


hrStyles : List Style
hrStyles =
    [ Css.backgroundColor Colors.border
    , Css.borderStyle none
    , Css.display block
    , Css.height (px 1)
    , Css.margin2 (rem 0.5) zero
    ]
