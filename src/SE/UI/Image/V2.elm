module SE.UI.Image.V2 exposing
    ( Image, create, toSimpleHtml, toHtml, source, srcset, toMissingHtml
    , withAspectRatio, withoutLazyLoading, withoutAsyncDecoding
    )

{-| Image component version 2

Much of the inspiration comes from this article:
<https://www.industrialempathy.com/posts/image-optimizations/>


# Example

    SE.UI.Image.V2.create { width = 300, height = 100 }
        |> SE.UI.Image.V2.withAspectRatio ( 16, 9 )
        |> SE.UI.Image.V2.toHtml "Testbild"
            [ SE.UI.Image.V2.source
                [ SE.UI.Image.V2.srcset "https://picsum.photos/300/100" 1
                ]
            ]
    ==

    <figure class="has-aspect-ratio _5e31eb7b">
        <picture>
            <source srcset="https://picsum.photos/300/100 1x">
            <img alt="Testbild" src="https://picsum.photos/300/100" width="300" height="100" decoding="async" loading="lazy">
        </picture>
    </figure>

@docs Image, create, toSimpleHtml, toHtml, source, srcset, toMissingHtml


# Modifiers

@docs withAspectRatio, withoutLazyLoading, withoutAsyncDecoding

-}

import Css exposing (Style)
import Css.Global
import Html.Styled exposing (Attribute, Html, styled)
import Html.Styled.Attributes as Attributes
import List
import SE.UI.Colors as Colors
import SE.UI.Icon.V2 as Icon


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
    (case sources of
        [] ->
            icon

        sources_ ->
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
            Html.Styled.node "picture" [] sourceEls
    )
        |> List.singleton
        |> figure internals


{-| Turn the Image into an img tag, with a container figure tag, provide an alt string and a list is sources. Produces

    <figure>
        <img alt="Alt text" src="https://example.com/image.png" />
    </figure>

Use this if you only have an image with a single resolution and file type

-}
toSimpleHtml : { alt : String, src : String } -> Image -> Html msg
toSimpleHtml altAndSrc (Image internals) =
    figure internals [ img altAndSrc internals ]


figure : Internals -> List (Html msg) -> Html msg
figure internals =
    let
        hasAspectRatio =
            case internals.aspectRatio of
                Nothing ->
                    False

                Just _ ->
                    True
    in
    Html.Styled.node "figure"
        [ Attributes.classList [ ( "has-aspect-ratio", hasAspectRatio ) ]
        , Attributes.css (figureStyles internals)
        ]


img : { alt : String, src : String } -> Internals -> Html msg
img { alt, src } { width, height, async, lazy, aspectRatio } =
    Html.Styled.img
        [ Attributes.alt alt
        , Attributes.src src
        , Attributes.width width
        , Attributes.height height
        , asyncAttribute async
        , lazyAttribute lazy
        ]
        []


boolAttribute : Attribute msg -> Bool -> Attribute msg
boolAttribute attr bool =
    if bool then
        attr

    else
        Attributes.class ""


asyncAttribute : Bool -> Attribute msg
asyncAttribute =
    boolAttribute (Attributes.attribute "decoding" "async")


lazyAttribute : Bool -> Attribute msg
lazyAttribute =
    boolAttribute (Attributes.attribute "loading" "lazy")


{-| Turn the Image into an svg icon, with a container figure tag, Produces

    <figure>
        <span class "icon"><svg...></svg></span>
    </figure>

-}
toMissingHtml : Image -> Html msg
toMissingHtml (Image internals) =
    figure internals [ icon ]


icon : Html msg
icon =
    Icon.images
        |> Icon.toHtml


figureStyles : Internals -> List Style
figureStyles { width, height, aspectRatio } =
    [ Css.textAlign Css.center
    , Css.Global.descendants
        -- figure img
        [ Css.Global.img
            [ Css.property "content-visibility" "auto"
            , Css.display Css.inlineBlock
            ]

        -- figure .icon (without aspect-ratio)
        , Css.Global.class "icon"
            [ Css.width (Css.px (toFloat width))
            , Css.height (Css.px (toFloat height))
            , Colors.color Colors.lighter
            , Css.Global.children
                -- figure .icon > svg
                [ Css.Global.selector "svg"
                    [ Css.width (Css.pct 80)
                    , Css.height (Css.pct 80)
                    ]
                ]
            ]
        ]

    -- figure.has-aspect-ratio
    , Css.Global.withClass "has-aspect-ratio"
        [ Css.Global.descendants
            -- figure.has-aspect-ratio img, figure.has-aspect-ratio .icon
            [ Css.Global.each [ Css.Global.img, Css.Global.class "icon" ]
                [ Css.width (Css.pct 100)
                , Css.height (Css.pct 100)
                , Css.left Css.zero
                , Css.right Css.zero
                , Css.top Css.zero
                , Css.bottom Css.zero
                , Css.position Css.absolute
                ]

            -- figure.has-aspect-ratio img
            , Css.Global.img
                [ Css.property "object-fit" "contain"
                ]
            ]
        ]

    -- optionally apply aspect ratio styles
    , Css.batch
        (case aspectRatio of
            Nothing ->
                []

            Just ( widthRatio, heightRatio ) ->
                [ Css.maxWidth (Css.pct 100)
                , Css.position Css.relative
                , Css.display Css.block
                , Css.overflow Css.hidden
                , Css.paddingBottom (Css.pct (toFloat heightRatio / toFloat widthRatio * 100))
                ]
        )
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
            Html.Styled.source (Attributes.attribute "srcset" (srcsetsToString srcsets) :: attrs) []


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
    Attributes.type_ ("image/" ++ ext)



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
