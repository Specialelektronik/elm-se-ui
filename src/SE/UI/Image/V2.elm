module SE.UI.Image.V2 exposing
    ( Image, create, toSimpleHtml, toHtml, source, srcset
    , withAspectRatio, withoutLazyLoading, withoutAsyncDecoding
    )

{-| Image component version 2

Much of the inspiration comes from this article:
<https://www.industrialempathy.com/posts/image-optimizations/>

@docs Image, create, toSimpleHtml, toHtml, source, srcset


# Modifiers

@docs withAspectRatio, withoutLazyLoading, withoutAsyncDecoding

-}

import Css exposing (Style)
import Html.Styled exposing (Attribute, Html, styled)
import Html.Styled.Attributes


{-| The internal type, it is exposed to help with type annotations
-}
type Image
    = Image Internals


type alias Internals =
    { width : Int
    , height : Int
    , aspectRatio : Maybe ( Int, Int )
    , lazy : Bool
    , async : Bool
    }


type Source
    = Source (List Srcset)


type alias Srcset =
    { url : String
    , resolution : Int
    }


type MimeType
    = WebP
    | Jpeg
    | Gif
    | Png
    | Avif


{-| Create an Image type with mandatory width and height
-}
create : { width : Int, height : Int } -> Image
create { width, height } =
    Image
        { width = width
        , height = height
        , aspectRatio = Nothing
        , lazy = True
        , async = True
        }


{-| Add aspect ratio

    ( 16, 9 ) => 16 / 9

-}
withAspectRatio : ( Int, Int ) -> Image -> Image
withAspectRatio ratio (Image internals) =
    Image { internals | aspectRatio = Just ratio }


{-| Remove default lazy loading
-}
withoutLazyLoading : Image -> Image
withoutLazyLoading (Image internals) =
    Image { internals | lazy = False }


{-| Remove default async decoding
-}
withoutAsyncDecoding : Image -> Image
withoutAsyncDecoding (Image internals) =
    Image { internals | async = False }


{-| Create a source tag with multiple srcset values, it compiles to a source-tag with srcset attribute and a type attribute containing the mimetype. The mimetype is based on the first url of the first srcset. Only images with WebP, Jpg (also Jpeg), Gif and Png are allowed.

Only used in combination with `toHtml`.

    source
        [ srcset "https://bulma.io/images/placeholders/640x480.png" 1
        , srcset "https://bulma.io/images/placeholders/1280x960.png" 2
        ]
        == "<source srcset='https://bulma.io/images/placeholders/640x480.png 1x, https://bulma.io/images/placeholders/1280x960.png 2x' type='image/png'>"

-}
source : List Srcset -> Source
source =
    Source


{-| Create a srcset attribute with a url and a resolution (1,2,3)
Read more about the srcset attribute at <https://developer.mozilla.org/en-US/docs/Learn/HTML/Multimedia_and_embedding/Responsive_images>

    srcset "https://bulma.io/images/placeholders/640x480.png" 1

-}
srcset : String -> Int -> Srcset
srcset =
    Srcset


{-| Turn the Image into Html, provide an alt string and a list is sources. Produces

    <figure>
        <picture>
            <source srcset="https://example.com/image.png 1x">
            <img alt="Alt text" src="https://example.com/image.png" />
        </picture>
    </figure>

-}
toHtml : String -> List Source -> Image -> Html msg
toHtml alt sources (Image internals) =
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
                        img { alt = alt, src = srcset_.url } internals
                    )

        sourceEls =
            List.map sourceToHtml sortedSources
                ++ (Maybe.map List.singleton fallbackImg |> Maybe.withDefault [])
    in
    styled (Html.Styled.node "figure") (figureStyles internals.aspectRatio) [] [ Html.Styled.node "picture" [] sourceEls ]


{-| Turn the Image into an img tag, with a container figure tag, provide an alt string and a list is sources. Produces

    <figure>
        <img alt="Alt text" src="https://example.com/image.png" />
    </figure>

Use this if you only have an image with a single resolution and file type

-}
toSimpleHtml : { alt : String, src : String } -> Image -> Html msg
toSimpleHtml altAndSrc (Image internals) =
    styled (Html.Styled.node "figure") (figureStyles internals.aspectRatio) [] [ img altAndSrc internals ]


img : { alt : String, src : String } -> Internals -> Html msg
img { alt, src } { width, height, async, lazy, aspectRatio } =
    Html.Styled.img
        [ Html.Styled.Attributes.alt alt
        , Html.Styled.Attributes.src src
        , Html.Styled.Attributes.width width
        , Html.Styled.Attributes.height height
        , asyncAttribute async
        , lazyAttribute lazy
        , Html.Styled.Attributes.css (imgStyles aspectRatio)
        ]
        []


boolAttribute : Attribute msg -> Bool -> Attribute msg
boolAttribute attr bool =
    if bool then
        attr

    else
        Html.Styled.Attributes.class ""


asyncAttribute : Bool -> Attribute msg
asyncAttribute =
    boolAttribute (Html.Styled.Attributes.attribute "decoding" "async")


lazyAttribute : Bool -> Attribute msg
lazyAttribute =
    boolAttribute (Html.Styled.Attributes.attribute "loading" "lazy")


imgStyles : Maybe ( Int, Int ) -> List Style
imgStyles maybeAspectRatio =
    Css.property "content-visibility" "auto"
        :: (Maybe.map imgAspectRatioStyles maybeAspectRatio |> Maybe.withDefault [])


figureStyles : Maybe ( Int, Int ) -> List Style
figureStyles maybeAspectRatio =
    Maybe.map aspectRatioStyles maybeAspectRatio |> Maybe.withDefault []


aspectRatioStyles : ( Int, Int ) -> List Style
aspectRatioStyles ( width, height ) =
    [ Css.maxWidth (Css.pct 100)
    , Css.position Css.relative
    , Css.display Css.block
    , Css.overflow Css.hidden
    , Css.paddingBottom (Css.pct (toFloat height / toFloat width * 100))
    ]


imgAspectRatioStyles : ( Int, Int ) -> List Style
imgAspectRatioStyles _ =
    [ Css.width (Css.pct 100)
    , Css.height (Css.pct 100)
    , Css.property "object-fit" "contain"
    , Css.left Css.zero
    , Css.right Css.zero
    , Css.top Css.zero
    , Css.bottom Css.zero
    , Css.position Css.absolute
    ]


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
                ( "avif", "avif" ) ->
                    EQ

                ( "avif", _ ) ->
                    LT

                ( _, "avif" ) ->
                    GT

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
            Html.Styled.text ""

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
            Html.Styled.source (Html.Styled.Attributes.attribute "srcset" (srcsetsToString srcsets) :: attrs) []


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

        "avif" ->
            Just Avif

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

                Avif ->
                    "avif"
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

        "avif" ->
            "avif"

        _ ->
            ""
