module SE.Framework.Image exposing (image, source)

-- import Css.Transitions

import Css exposing (Style, auto, block, pct, relative)
import Css.Global exposing (descendants, typeSelector)
import Html.Styled exposing (Html, styled, text)
import Html.Styled.Attributes exposing (attribute, src)



-- import SE.Framework.Colors exposing (background, white)
-- import SE.Framework.Utils exposing (block, desktop, radius, tablet, unselectable)


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
