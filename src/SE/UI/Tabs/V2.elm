module SE.UI.Tabs.V2 exposing
    ( tabs, toHtml
    , isSmall, isMedium, isLarge, isToggled, isBoxed, isCentered, isRight, isFullwidth
    , link, button
    , Tabs
    )

{-| Bulmas Tags component
see <https://bulma.io/documentation/components/tabs/>


# Container

@docs tabs, toHtml


# With\* pattern (pron. With start pattern)

The inspiration to this module and its API comes from Brian Hicks talk about Robot Buttons from Mars (<https://youtu.be/PDyWP-0H4Zo?t=1467>). (Please view the entire talk).

@docs isSmall, isMedium, isLarge, isToggled, isBoxed, isCentered, isRight, isFullwidth


# Links or Buttons

Bulma only styles anchor tags as links, but sometimes we may want to trigger a msg instead of navigating to another page on click. An anchor tag without href attribute will trigger a reload in Elm. To overcome this, use `link` when you have a url and the `button` when you have a Msg.

@docs link, button

-}

import Css
import Css.Global
import Html.Styled exposing (Html, styled, text)
import Html.Styled.Attributes as Attributes
import Html.Styled.Events as Events
import SE.UI.Colors as Colors
import SE.UI.Font as Font
import SE.UI.Utils as Utils exposing (block, overflowTouch, unselectable)


type Tabs msg
    = Tabs Internals (List (LinkOrButton msg))


type LinkOrButton msg
    = Link IsActive String (List (Html msg))
    | Button IsActive msg (List (Html msg))


type alias IsActive =
    Bool


type alias Internals =
    { size : Size
    , style : Style
    , alignment : Alignment
    , fullwidth : Bool
    }


type Size
    = Normal
    | Small
    | Medium
    | Large


type Style
    = Unstyled
    | Boxed
    | Toggled


type Alignment
    = Left
    | Centered
    | Right


defaultInternals : Internals
defaultInternals =
    { size = Normal
    , style = Unstyled
    , alignment = Left
    , fullwidth = False
    }



-- TABS


{-| Currently, only the Medium size modifier is supported, no boxed, fullwidth or anything else.
-}
tabs : List (LinkOrButton msg) -> Tabs msg
tabs linkOrButtons =
    Tabs defaultInternals linkOrButtons


toHtml : Tabs msg -> Html msg
toHtml (Tabs internals linkOrButtons) =
    styled Html.Styled.nav
        navStyle
        [ Attributes.classList (( "tabs", True ) :: internalsToClasses internals) ]
        [ Html.Styled.ul [] (List.map linkOrButtonToHtml linkOrButtons)
        ]


internalsToClasses : Internals -> List ( String, Bool )
internalsToClasses ({ size, style, alignment, fullwidth } as internals) =
    [ sizeToClass size
    , styleToClass style
    , alignmentToClass alignment
    , if fullwidth then
        "is-fullwidth"

      else
        ""
    ]
        |> List.filter (not << String.isEmpty)
        |> List.map (\a -> ( a, True ))


sizeToClass : Size -> String
sizeToClass size =
    case size of
        Normal ->
            ""

        Small ->
            "is-small"

        Medium ->
            "is-medium"

        Large ->
            "is-large"


styleToClass : Style -> String
styleToClass style =
    case style of
        Unstyled ->
            ""

        Toggled ->
            "is-toggle"

        Boxed ->
            "is-boxed"


alignmentToClass : Alignment -> String
alignmentToClass alignment =
    case alignment of
        Left ->
            ""

        Centered ->
            "is-centered"

        Right ->
            "is-right"



-- LINK


{-| An active link is rendered as a blue link, non-active are rendered av dark text.

    link False "https://example.com/" [ text "Go to example.com" ]

-}
link : IsActive -> String -> List (Html msg) -> LinkOrButton msg
link =
    Link


button : IsActive -> msg -> List (Html msg) -> LinkOrButton msg
button =
    Button


linkOrButtonToHtml : LinkOrButton msg -> Html msg
linkOrButtonToHtml linkOrButton =
    let
        { el, attrs, kids, isActive } =
            case linkOrButton of
                Link isActive_ url_ html_ ->
                    { el = Html.Styled.a, attrs = [ Attributes.href url_, Attributes.classList [ ( "link", True ) ] ], kids = html_, isActive = isActive_ }

                Button isActive_ onClickMsg_ html_ ->
                    { el = Html.Styled.span, attrs = [ Events.onClick onClickMsg_, Attributes.classList [ ( "link", True ) ] ], kids = html_, isActive = isActive_ }
    in
    Html.Styled.li
        [ Attributes.classList [ ( "is-active", isActive ) ] ]
        [ el attrs kids
        ]



-- MODIFIERS


{-| Not exposed, isSmall, isMedium and isLarge is exposed
-}
withSize : Size -> Tabs msg -> Tabs msg
withSize size (Tabs internals links) =
    Tabs { internals | size = size } links


isSmall : Tabs msg -> Tabs msg
isSmall =
    withSize Small


isMedium : Tabs msg -> Tabs msg
isMedium =
    withSize Medium


isLarge : Tabs msg -> Tabs msg
isLarge =
    withSize Large


withStyle : Style -> Tabs msg -> Tabs msg
withStyle style (Tabs internals links) =
    Tabs { internals | style = style } links


isToggled : Tabs msg -> Tabs msg
isToggled =
    withStyle Toggled


isBoxed : Tabs msg -> Tabs msg
isBoxed =
    withStyle Boxed


withAlignment : Alignment -> Tabs msg -> Tabs msg
withAlignment alignment (Tabs internals links) =
    Tabs { internals | alignment = alignment } links


isCentered : Tabs msg -> Tabs msg
isCentered =
    withAlignment Centered


isRight : Tabs msg -> Tabs msg
isRight =
    withAlignment Right


isFullwidth : Tabs msg -> Tabs msg
isFullwidth (Tabs internals links) =
    Tabs { internals | fullwidth = True } links



-- STYLES


navStyle : List Css.Style
navStyle =
    [ block
    , unselectable
    , overflowTouch
    , Css.alignItems Css.stretch
    , Css.displayFlex
    , Css.fontSize (Css.rem 1)
    , Css.justifyContent Css.spaceBetween
    , Css.overflow Css.hidden
    , Css.overflowX Css.auto
    , Css.whiteSpace Css.noWrap
    , Css.Global.children
        [ Css.Global.typeSelector "ul" ulStyles
        ]

    -- MODIFIERS
    -- SIZE
    , Css.Global.withClass "is-small"
        [ Font.bodySizeRem -2
        ]
    , Css.Global.withClass "is-medium"
        [ Font.bodySizeRem 3
        ]
    , Css.Global.withClass "is-large"
        [ Font.bodySizeRem 5
        ]

    -- STYLE
    , Css.Global.withClass "is-toggle"
        [ Css.Global.children
            [ Css.Global.typeSelector "ul" ulToggledStyles
            ]
        ]
    , Css.Global.withClass "is-boxed"
        [ Css.Global.children
            [ Css.Global.typeSelector "ul" ulBoxedStyles
            ]
        ]

    -- ALIGNMENT
    , Css.Global.withClass "is-centered"
        [ Css.Global.children
            [ Css.Global.typeSelector "ul"
                [ Css.justifyContent Css.center
                ]
            ]
        ]
    , Css.Global.withClass "is-right"
        [ Css.Global.children
            [ Css.Global.typeSelector "ul"
                [ Css.justifyContent Css.flexEnd
                ]
            ]
        ]

    -- FULLWIDTH
    , Css.Global.withClass "is-fullwidth"
        [ Css.Global.descendants
            [ Css.Global.typeSelector "li"
                [ Css.flexGrow (Css.int 1)
                , Css.flexShrink Css.zero
                ]
            ]
        ]
    ]


ulStyles : List Css.Style
ulStyles =
    [ Css.alignItems Css.center
    , Css.borderBottomColor (Colors.border |> Colors.toCss)
    , Css.borderBottomStyle Css.solid
    , Css.borderBottomWidth (Css.px 1)
    , Css.displayFlex
    , Css.flexGrow (Css.int 1)
    , Css.flexShrink Css.zero
    , Css.justifyContent Css.flexStart
    , Css.Global.children
        [ Css.Global.typeSelector "li"
            [ Css.batch liStyles
            , Css.Global.withClass "is-active" liActiveStyles
            ]
        ]
    ]


ulToggledStyles : List Css.Style
ulToggledStyles =
    [ Css.borderBottom Css.zero
    , Css.Global.children
        [ Css.Global.typeSelector "li"
            -- li + li
            [ Css.Global.adjacentSiblings
                [ Css.Global.typeSelector "li"
                    [ Css.marginLeft (Css.px -1)
                    ]
                ]

            -- li:firstchild
            , Css.firstChild
                [ Css.Global.children
                    [ Css.Global.each
                        [ Css.Global.typeSelector "a"
                        , Css.Global.typeSelector "span"
                        ]
                        [ Css.borderTopLeftRadius Utils.radius
                        , Css.borderBottomLeftRadius Utils.radius
                        ]
                    ]
                ]
            , Css.lastChild
                [ Css.Global.children
                    [ Css.Global.each
                        [ Css.Global.typeSelector "a"
                        , Css.Global.typeSelector "span"
                        ]
                        [ Css.borderTopRightRadius Utils.radius
                        , Css.borderBottomRightRadius Utils.radius
                        ]
                    ]
                ]
            , Css.Global.children
                [ Css.Global.each
                    [ Css.Global.typeSelector "a"
                    , Css.Global.typeSelector "span"
                    ]
                    [ Colors.borderColor Colors.border
                    , Css.borderStyle Css.solid
                    , Css.borderWidth (Css.px 1)
                    , Css.position Css.relative
                    , Css.important (Css.marginBottom Css.zero)
                    , Css.hover
                        [ Colors.backgroundColor (Colors.white |> Colors.hover)
                        , Colors.borderColor (Colors.border |> Colors.hover)
                        , Css.zIndex (Css.int 2)
                        ]

                    --       border-style: $tabs-toggle-link-border-style
                    --       border-width: $tabs-toggle-link-border-width
                    --       margin-bottom: 0
                    --       position: relative
                    ]
                ]
            , Css.Global.withClass "is-active"
                [ Css.Global.children
                    [ Css.Global.each
                        [ Css.Global.typeSelector "a"
                        , Css.Global.typeSelector "span"
                        ]
                        [ Css.pseudoClass "not(:hover)"
                            [ Colors.backgroundColor Colors.link
                            , Colors.borderColor (Colors.link |> Colors.active)
                            , Colors.color (Colors.link |> Colors.invert)
                            , Css.zIndex (Css.int 1)
                            ]
                        ]
                    ]
                ]
            ]
        ]
    ]


ulBoxedStyles : List Css.Style
ulBoxedStyles =
    [ Css.Global.descendants
        [ -- ul.is-boxed .link
          Css.Global.class "link"
            [ Css.border3 (Css.px 1) Css.solid Css.transparent
            , Css.borderRadius4 Utils.radius Utils.radius Css.zero Css.zero
            , Css.borderBottomColor (Colors.border |> Colors.toCss)
            , Css.hover
                [ Colors.backgroundColor (Colors.white |> Colors.hover)
                ]
            ]

        -- ul.is-boxed li .link
        , Css.Global.typeSelector "li"
            [ Css.Global.withClass "is-active"
                [ Css.Global.children
                    [ Css.Global.class "link"
                        [ -- background-color: $tabs-boxed-link-active-background-color
                          Colors.backgroundColor Colors.white
                        , Colors.borderColor Colors.border
                        , Colors.color Colors.link
                        , Css.fontWeight (Css.int 600)
                        , Css.important (Css.borderBottomColor (Colors.white |> Colors.toCss))

                        --           border-bottom-color: $tabs-boxed-link-active-border-bottom-color !important
                        ]
                    ]
                ]
            ]
        ]
    ]



-- a
--       border: 1px solid transparent
--       +ltr
--         border-radius: $tabs-boxed-link-radius $tabs-boxed-link-radius 0 0
--       &:hover
--         background-color: $tabs-boxed-link-hover-background-color
--         border-bottom-color: $tabs-boxed-link-hover-border-bottom-color
--     li
--       &.is-active
--         a
--           background-color: $tabs-boxed-link-active-background-color
--           border-color: $tabs-boxed-link-active-border-color
--           border-bottom-color: $tabs-boxed-link-active-border-bottom-color !important


liStyles : List Css.Style
liStyles =
    [ Css.display Css.block
    , Css.Global.children
        [ Css.Global.each
            [ Css.Global.typeSelector "a"
            , Css.Global.typeSelector "span"
            ]
            linkStyles
        ]
    ]


liActiveStyles : List Css.Style
liActiveStyles =
    [ Css.Global.children
        [ Css.Global.each
            [ Css.Global.typeSelector "a"
            , Css.Global.typeSelector "span"
            ]
            linkActiveStyles
        ]
    ]


linkStyles : List Css.Style
linkStyles =
    [ Css.alignItems Css.center
    , Css.borderBottomColor (Colors.border |> Colors.toCss)
    , Css.borderBottomStyle Css.solid
    , Css.borderBottomWidth (Css.px 1)
    , Colors.color Colors.text
    , Css.displayFlex
    , Css.justifyContent Css.center
    , Css.marginBottom (Css.px -1)
    , Css.padding2 (Css.em 0.5) (Css.em 1)
    , Css.verticalAlign Css.top
    , Css.hover
        [ Colors.color (Colors.text |> Colors.hover)
        , Css.borderBottomColor (Colors.text |> Colors.hover |> Colors.toCss)
        ]
    ]


linkActiveStyles : List Css.Style
linkActiveStyles =
    [ Css.borderBottomColor (Colors.link |> Colors.hover |> Colors.toCss)
    , Colors.color Colors.link
    ]
