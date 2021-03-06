module SE.UI.Tag exposing
    ( tag, deleteTag
    , TagModifier(..)
    , tags, TagsModifier(..)
    )

{-| Bulmas tag element
see <https://bulma.io/documentation/elements/tag/>


# Tag

@docs tag, deleteTag


# Modifiers

@docs TagModifier


# Tags container

@docs tags, TagsModifier

-}

import Css exposing (Style, absolute, active, after, before, block, center, currentColor, deg, em, flexStart, focus, hover, important, inlineFlex, noWrap, num, pct, pointer, pseudoClass, px, relative, rem, rotate, translateX, translateY, wrap, zero)
import Css.Global exposing (class, descendants)
import Css.Transitions
import Html.Styled exposing (Html, styled, text)
import Html.Styled.Attributes
import Html.Styled.Events exposing (onClick)
import SE.UI.Colors as Colors
import SE.UI.Utils exposing (radius)


{-| Supported modifiers are colors (all colors are supported) and sizes
-}
type
    TagModifier
    -- Colors
    = Color Colors.Color
      -- Sizes
    | Normal
    | Medium
    | Large


{-| Tags can be attached using the Addons modifier
-}
type TagsModifier
    = Addons


{-| Colors and sizes is supported modifiers, `rounded` also, there is no way to attach a delete button to a tag, use `tags [Addons]` with a regular `tag` and `deleteTag`.
-}
tag : List TagModifier -> String -> Html msg
tag mods t =
    styled Html.Styled.span
        [ tagStyle, tagModifiers mods ]
        [ Html.Styled.Attributes.class "tag" ]
        [ text t ]


{-| The delete modifier is supported using this function.
-}
deleteTag : msg -> Html msg
deleteTag clickMsg =
    styled Html.Styled.span
        [ tagStyle, deleteTagStyle ]
        [ Html.Styled.Attributes.class "tag", onClick clickMsg ]
        []


{-| List of tags
see <https://bulma.io/documentation/elements/tag/#list-of-tags>
-}
tags : List TagsModifier -> List (Html msg) -> Html msg
tags mods ts =
    styled Html.Styled.div
        [ tagsStyle, tagsModifiers mods ]
        []
        ts


tagModifiers : List TagModifier -> Style
tagModifiers mods =
    Css.batch (List.map tagModifier mods)


tagModifier : TagModifier -> Style
tagModifier m =
    Css.batch
        (case m of
            Color color ->
                [ Colors.backgroundColor (color |> Colors.toHsla)
                , Colors.color (color |> Colors.toHsla |> Colors.invert)
                ]

            -- Sizes
            Normal ->
                [ Css.fontSize (rem 0.75)
                ]

            Medium ->
                [ Css.fontSize (rem 1)
                ]

            Large ->
                [ Css.fontSize (rem 1.25)
                ]
        )


tagsModifiers : List TagsModifier -> Style
tagsModifiers mods =
    Css.batch (List.map tagsModifier mods)


tagsModifier : TagsModifier -> Style
tagsModifier m =
    Css.batch
        (case m of
            Addons ->
                [ descendants
                    [ class "tag"
                        [ important (Css.marginRight zero)
                        , pseudoClass "not(:first-child)"
                            [ Css.borderBottomLeftRadius zero
                            , Css.borderTopLeftRadius zero
                            ]
                        , pseudoClass "not(:last-child)"
                            [ Css.borderBottomRightRadius zero
                            , Css.borderTopRightRadius zero
                            ]
                        ]
                    ]
                ]
        )


tagStyle : Style
tagStyle =
    Css.batch
        [ Css.alignItems center
        , Colors.backgroundColor Colors.background
        , Css.borderRadius radius
        , Colors.color Colors.text
        , Css.display inlineFlex
        , Css.fontSize (rem 0.75)
        , Css.height (em 2)
        , Css.justifyContent center
        , Css.lineHeight (num 1.5)
        , Css.paddingLeft (em 0.75)
        , Css.paddingRight (em 0.75)
        , Css.whiteSpace noWrap
        ]


tagsStyle : Style
tagsStyle =
    Css.batch
        [ Css.alignItems center
        , Css.displayFlex
        , Css.flexWrap wrap
        , Css.justifyContent flexStart
        , descendants
            [ class "tag"
                [ Css.marginBottom (rem 0.5)
                , pseudoClass "not(:last-child)"
                    [ Css.marginRight (rem 0.5)
                    ]
                ]
            ]
        , pseudoClass "last-child"
            [ Css.marginBottom (rem -0.5)
            ]
        , pseudoClass "not(:last-child)"
            [ Css.marginBottom (rem 1)
            ]
        ]


deleteTagStyle : Style
deleteTagStyle =
    Css.batch
        [ Css.padding zero
        , Css.position relative
        , Css.width (em 2)
        , Css.cursor pointer
        , before
            [ deleteTagStyleBeforeAndAfter
            , Css.height (px 1)
            , Css.width (pct 50)
            ]
        , after
            [ deleteTagStyleBeforeAndAfter
            , Css.height (pct 50)
            , Css.width (px 1)
            ]
        , hover
            [ Colors.backgroundColor (Colors.background |> Colors.hover)
            ]
        , focus
            [ Colors.backgroundColor (Colors.background |> Colors.hover)
            ]
        , active
            [ Colors.backgroundColor (Colors.background |> Colors.active)
            ]
        ]


deleteTagStyleBeforeAndAfter : Style
deleteTagStyleBeforeAndAfter =
    Css.batch
        [ Css.backgroundColor currentColor
        , Css.property "content" "\"\""
        , Css.display block
        , Css.left (pct 50)
        , Css.position absolute
        , Css.top (pct 50)
        , Css.transforms [ translateX (pct -50), translateY (pct -50), rotate (deg 45) ]
        , Css.Transitions.transition [ Css.Transitions.transformOrigin 50 ]
        ]



--     &:hover,
--     &:focus
--       background-color: darken($tag-background-color, 5%)
--     &:active
--       background-color: darken($tag-background-color, 10%)
