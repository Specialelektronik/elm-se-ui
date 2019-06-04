module SE.UI.Image exposing
    ( image, noImage
    , source
    )

{-| Image lets you create img tags with multiple sources to support responsive images


# Definition

@docs image, noImage


# Source

@docs source

-}

import Css exposing (Style, auto, block, pct, relative)
import Css.Global exposing (descendants, typeSelector)
import Html.Styled exposing (Html, styled, text)
import Html.Styled.Attributes exposing (attribute, src)
import Svg.Styled as Svg exposing (Attribute, Svg)
import Svg.Styled.Attributes exposing (d, fill, viewBox)


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
            styled Html.Styled.figure
                (containerStyles
                    ++ [ Css.maxWidth (Css.px (toFloat w))
                       , Css.maxHeight (Css.px (toFloat h))
                       ]
                )
                []
                [ Html.Styled.img
                    [ src fallback.url
                    , Html.Styled.Attributes.width w
                    , Html.Styled.Attributes.height h
                    , attribute "srcset" (srcset sources)
                    ]
                    []
                ]


{-| Image placeholder when image is missing
-}
noImage : Html msg
noImage =
    Svg.svg [ viewBox "0 0 576 512", fill "currentColor" ] [ Svg.path [ d "M480 416v16c0 26.51-21.49 48-48 48H48c-26.51 0-48-21.49-48-48V176c0-26.51 21.49-48 48-48h16v208c0 44.112 35.888 80 80 80h336zm96-80V80c0-26.51-21.49-48-48-48H144c-26.51 0-48 21.49-48 48v256c0 26.51 21.49 48 48 48h384c26.51 0 48-21.49 48-48zM256 128c0 26.51-21.49 48-48 48s-48-21.49-48-48 21.49-48 48-48 48 21.49 48 48zm-96 144l55.515-55.515c4.686-4.686 12.284-4.686 16.971 0L272 256l135.515-135.515c4.686-4.686 12.284-4.686 16.971 0L512 208v112H160v-48z" ] [] ]


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
