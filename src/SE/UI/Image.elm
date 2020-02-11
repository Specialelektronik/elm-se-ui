module SE.UI.Image exposing
    ( picture, image, noImage
    , source, srcset, alt
    )

{-| Image lets you create img tags with multiple sources to support responsive images


# Definition

@docs picture, image, noImage


# Source and Srcset

@docs source, srcset, alt

-}

import Css exposing (Style, auto, block, pct, relative)
import Css.Global exposing (descendants, each, typeSelector)
import Html.Styled exposing (Html, styled, text)
import Html.Styled.Attributes exposing (attribute, src)
import Svg.Styled as Svg exposing (Attribute)
import Svg.Styled.Attributes exposing (d, fill, viewBox)


type Source
    = Source (List Srcset)


type alias Srcset =
    { url : String
    , resolution : Resolution
    }


type alias Resolution =
    Int


type alias Width =
    Int


type alias Height =
    Int


type Alt
    = Alt String


type MimeType
    = WebP
    | Jpeg
    | Gif
    | Png


figure : ( Width, Height ) -> List (Html msg) -> Html msg
figure ( w, h ) =
    styled Html.Styled.figure
        (containerStyles
            ++ [ Css.maxWidth (Css.px (toFloat w))
               , Css.maxHeight (Css.px (toFloat h))
               ]
        )
        []


{-| Create and img tag with a list of srcsets. If the list of srcsets is empty or hasn't got a single srcset with the resolution of 1, then this function will output an empty text tag.

    image ( 640, 480 )
        [ srcset "https://bulma.io/images/placeholders/640x480.png" 1
        , srcset "https://bulma.io/images/placeholders/1280x960.png" 2
        ] == "<figure style="position: relative;display: block;"><img style="display: block;height: auto;width: 100%;" src="https://bulma.io/images/placeholders/640x480.png" width="640" height="480" srcset="https://bulma.io/images/placeholders/640x480.png 1x, https://bulma.io/images/placeholders/1280x960.png 2x"></figure>"

-}
image : ( Width, Height ) -> List Srcset -> Html msg
image ( w, h ) srcsets =
    let
        maybeFallback =
            List.filter (\a -> a.resolution == 1) srcsets
                |> List.head
    in
    case maybeFallback of
        Nothing ->
            text ""

        Just fallback ->
            figure ( w, h )
                [ Html.Styled.img
                    [ src fallback.url
                    , Html.Styled.Attributes.width w
                    , Html.Styled.Attributes.height h
                    , attribute "srcset" (srcsetsToString srcsets)
                    ]
                    []
                ]


{-| Creates a picture element with a list of sources. Each source must contain a list of srcsets. The mimetype is extracted from the first srcset of each source, webp images is sorted first and the last source with the lowest resolution is inserted as a fallback img element.

Only use the picture element if you have multiple identical images in different file formats. If you only have 1 format, use the `image` function instead.

    picture (alt "A fallback text if the images cannot be loaded") (640, 480)
        [
            source [
                srcset "https://bulma.io/images/placeholders/640x480.webp" 1
                srcset "https://bulma.io/images/placeholders/1280x960.webp" 2
            ],
            source [
                srcset "https://bulma.io/images/placeholders/640x480.png" 1
                srcset "https://bulma.io/images/placeholders/1280x960.png" 2
            ]
        ] == "<figure style='position: relative;display: block;'>
                <picture style='display: block;height: auto;width: 100%;' width='640' height='480'>
                    <source srcset='https://bulma.io/images/placeholders/640x480.webp 1x, https://bulma.io/images/placeholders/1280x960.webp 2x' type='image/webp'>
                    <source srcset='https://bulma.io/images/placeholders/640x480.png 1x, https://bulma.io/images/placeholders/1280x960.png 2x' type='image/png'>
                </picture>
            </figure>"

-}
picture : Alt -> ( Width, Height ) -> List Source -> Html msg
picture (Alt alt_) ( w, h ) sources =
    let
        sortedSources =
            sortSources sources

        fallbackImg =
            sortedSources
                |> List.reverse
                |> List.head
                |> Maybe.andThen (\(Source srcsets) -> List.head srcsets)
                |> Maybe.map
                    (\srcset_ ->
                        Html.Styled.img
                            [ Html.Styled.Attributes.alt alt_
                            , src srcset_.url
                            ]
                            []
                    )

        sourceEls =
            List.map sourceToHtml sortedSources
                ++ (Maybe.map List.singleton fallbackImg |> Maybe.withDefault [])
    in
    case fallbackImg of
        Nothing ->
            text ""

        Just _ ->
            figure ( w, h )
                [ Html.Styled.node "picture"
                    []
                    sourceEls
                ]


{-| Image placeholder when image is missing
-}
noImage : Html msg
noImage =
    Svg.svg [ viewBox "0 0 576 512", fill "currentColor" ] [ Svg.path [ d "M480 416v16c0 26.51-21.49 48-48 48H48c-26.51 0-48-21.49-48-48V176c0-26.51 21.49-48 48-48h16v208c0 44.112 35.888 80 80 80h336zm96-80V80c0-26.51-21.49-48-48-48H144c-26.51 0-48 21.49-48 48v256c0 26.51 21.49 48 48 48h384c26.51 0 48-21.49 48-48zM256 128c0 26.51-21.49 48-48 48s-48-21.49-48-48 21.49-48 48-48 48 21.49 48 48zm-96 144l55.515-55.515c4.686-4.686 12.284-4.686 16.971 0L272 256l135.515-135.515c4.686-4.686 12.284-4.686 16.971 0L512 208v112H160v-48z" ] [] ]


{-| Create a source tag with multiple srcset values, it compiles to a source-tag with srcset attribute and a type attribute containing the mimetype. The mimetype is based on the first url of the first srcset. Only images with WebP, Jpg (also Jpeg), Gif and Png are allowed.

Only used in combination with `picture`.

    source [
        srcset "https://bulma.io/images/placeholders/640x480.png" 1
        , srcset "https://bulma.io/images/placeholders/1280x960.png" 2
    ] == "<source srcset='https://bulma.io/images/placeholders/640x480.png 1x, https://bulma.io/images/placeholders/1280x960.png 2x' type='image/png'>"

-}
source : List Srcset -> Source
source =
    Source


{-| Create a srcset attribute with a url and a resolution (1,2,3)
Read more about the srcset attribute at <https://developer.mozilla.org/en-US/docs/Learn/HTML/Multimedia_and_embedding/Responsive_images>

    srcset "https://bulma.io/images/placeholders/640x480.png" 1

-}
srcset : String -> Resolution -> Srcset
srcset =
    Srcset


{-| Fallback description if image cannot be loaded
-}
alt : String -> Alt
alt =
    Alt


sortSources : List Source -> List Source
sortSources =
    List.sortWith sortSourcesHelper


sortSourcesHelper : Source -> Source -> Order
sortSourcesHelper (Source a) (Source b) =
    case ( a, b ) of
        ( [], [] ) ->
            EQ

        ( _, [] ) ->
            EQ

        ( [], _ ) ->
            EQ

        ( aHead :: _, bHead :: _ ) ->
            case ( extractExtension aHead.url, extractExtension bHead.url ) of
                ( "webp", "webp" ) ->
                    EQ

                ( "webp", _ ) ->
                    LT

                ( _, "webp" ) ->
                    GT

                ( _, _ ) ->
                    EQ


sourceToHtml : Source -> Html msg
sourceToHtml (Source srcsets) =
    case srcsets of
        [] ->
            text ""

        head :: _ ->
            let
                attrs =
                    head.url
                        |> extractExtension
                        |> extensionToMimeType
                        |> Maybe.map mimeTypeToAttribute
                        |> Maybe.map List.singleton
                        |> Maybe.withDefault []
            in
            Html.Styled.source (attribute "srcset" (srcsetsToString srcsets) :: attrs) []


srcsetsToString : List Srcset -> String
srcsetsToString lst =
    lst
        |> List.map (\s -> s.url ++ " " ++ String.fromInt s.resolution ++ "x")
        |> List.reverse
        |> List.intersperse ", "
        |> List.foldl (++) ""


extensionToMimeType : String -> Maybe MimeType
extensionToMimeType ext =
    case String.toLower ext of
        "webp" ->
            Just WebP

        "jpg" ->
            Just Jpeg

        "jpeg" ->
            Just Jpeg

        "gif" ->
            Just Gif

        "png" ->
            Just Png

        _ ->
            Nothing


mimeTypeToAttribute : MimeType -> Attribute msg
mimeTypeToAttribute mimeType =
    let
        ext =
            case mimeType of
                WebP ->
                    "webp"

                Jpeg ->
                    "jpeg"

                Gif ->
                    "gif"

                Png ->
                    "png"
    in
    Html.Styled.Attributes.type_ ("image/" ++ ext)



{- ! Extract the extension from a url *if* it's an image. It only looks at the last 5 chars -}


extractExtension : String -> String
extractExtension str =
    case String.right 4 str of
        "webp" ->
            "webp"

        ".jpg" ->
            "jpg"

        "jpeg" ->
            "jpg"

        ".gif" ->
            "gif"

        ".png" ->
            "png"

        _ ->
            ""



-- STYLES


containerStyles : List Style
containerStyles =
    [ Css.position relative
    , Css.display block
    , descendants
        [ each [ typeSelector "img", typeSelector "picture" ]
            [ Css.display block
            , Css.height auto
            , Css.width (pct 100)
            ]
        ]
    ]
