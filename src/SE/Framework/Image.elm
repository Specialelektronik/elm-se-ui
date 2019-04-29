module SE.Framework.Image exposing
    ( image
    , source
    )

{-| Image lets you create img tags with multiple sources to support responsive images


# Definition

@docs image


# Source

@docs source

-}

import Css exposing (Style, auto, block, pct, relative)
import Css.Global exposing (descendants, typeSelector)
import Html.Styled exposing (Html, styled, text)
import Html.Styled.Attributes exposing (attribute, src)


type alias Source =
    { url : String
    , resolution : Resolution
    }


type alias Resolution =
    Int


type alias Width =
    Int


type alias Height =
    Int


{-| Create and img tag with a list of sources. If the list of sources is empty or hasn't got a single source with the resolution of 1, then this function will output an empty text tag.

    image ( 640, 480 )
        [ source "https://bulma.io/images/placeholders/640x480.png" 1
        , source "https://bulma.io/images/placeholders/1280x960.png" 2
        ] == "<div style="position: relative;display: block;"><img style="display: block;height: auto;width: 100%;" src="https://bulma.io/images/placeholders/640x480.png" width="640" height="480" srcset="https://bulma.io/images/placeholders/640x480.png 1x, https://bulma.io/images/placeholders/1280x960.png 2x"></div>"

-}
image : ( Width, Height ) -> List Source -> Html msg
image ( w, h ) sources =
    let
        maybeFallback =
            List.filter (\a -> a.resolution == 1) sources
                |> List.head
    in
    case maybeFallback of
        Nothing ->
            text ""

        Just fallback ->
            styled Html.Styled.div
                containerStyles
                []
                [ Html.Styled.img
                    [ src fallback.url
                    , Html.Styled.Attributes.width w
                    , Html.Styled.Attributes.height h
                    , attribute "srcset" (srcset sources)
                    ]
                    []
                ]


{-| Create a source with a url and a resolution (1,2,3)
Read more about the srcset attribute at <https://developer.mozilla.org/en-US/docs/Learn/HTML/Multimedia_and_embedding/Responsive_images>

    source "https://bulma.io/images/placeholders/640x480.png" 1

-}
source : String -> Resolution -> Source
source =
    Source


srcset : List Source -> String
srcset sources =
    sources
        |> List.map (\s -> s.url ++ " " ++ String.fromInt s.resolution ++ "x")
        |> List.reverse
        |> List.intersperse ", "
        |> List.foldl (++) ""


containerStyles : List Style
containerStyles =
    [ Css.position relative
    , Css.display block
    , descendants
        [ typeSelector "img"
            [ Css.display block
            , Css.height auto
            , Css.width (pct 100)
            ]
        ]
    ]
