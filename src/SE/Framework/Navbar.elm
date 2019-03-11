module SE.Framework.Navbar exposing (brand, led, link, navbar, noBrand)

import Css exposing (Style, block, center, displayFlex, flex, hex, int, ms, none, px, relative, rem, stretch, zero)
import Css.Animations exposing (Keyframes, keyframes)
import Html.Styled exposing (Attribute, Html, styled, text)
import Html.Styled.Attributes exposing (href)
import SE.Framework.Colors exposing (black, lightest, linkHover, primary, white)
import SE.Framework.Utils exposing (desktop)


type alias Url =
    String


type alias Label =
    String


type Brand msg
    = NoBrand
    | Brand Url (List (Html msg))


type Link
    = Link Url Label



-- <div class="navbar-brand">
--     <a class="navbar-item" href="https://bulma.io">
--       <img src="https://bulma.io/images/bulma-logo.png" width="112" height="28">
--     </a>
--     <a role="button" class="navbar-burger burger" aria-label="menu" aria-expanded="false" data-target="navbarBasicExample">
--       <span aria-hidden="true"></span>
--       <span aria-hidden="true"></span>
--       <span aria-hidden="true"></span>
--     </a>
--   </div>


navbarHeight : Css.Rem
navbarHeight =
    rem 3.25


navbarItem : List Style
navbarItem =
    [ Css.displayFlex
    , Css.flexGrow zero
    , Css.flexShrink zero
    , Css.lineHeight (rem 1.5)
    , Css.padding2 (rem 0.5) (rem 0.75)
    , Css.position relative
    , Css.alignItems center
    , Css.color black
    , Css.hover
        [ Css.color linkHover
        , Css.backgroundColor lightest
        ]
    ]


brand : Url -> List (Html msg) -> Brand msg
brand =
    Brand


noBrand : Brand msg
noBrand =
    NoBrand


brandToElement : Brand msg -> Html msg
brandToElement b =
    case b of
        NoBrand ->
            text ""

        Brand url children ->
            styled Html.Styled.div
                [ Css.alignItems stretch
                , Css.displayFlex
                , Css.flexShrink zero
                , Css.minHeight navbarHeight
                ]
                []
                [ styled Html.Styled.a navbarItem [ href url ] children
                ]


link : Url -> Label -> Link
link =
    Link


linkToElement (Link url label) =
    styled Html.Styled.a navbarItem [ href url ] [ text label ]


navbarMenu : List Link -> Html msg
navbarMenu links =
    styled Html.Styled.div
        [ Css.display none
        , desktop
            [ Css.displayFlex
            , Css.alignItems stretch
            , Css.flexGrow (int 1)
            , Css.flexShrink zero
            ]
        ]
        []
        (List.map linkToElement links)


navbar : Brand msg -> List Link -> Html msg
navbar b links =
    styled Html.Styled.nav
        [ Css.backgroundColor white
        , Css.minHeight navbarHeight
        , Css.position relative
        , Css.zIndex (int 30)
        , desktop
            [ Css.displayFlex
            , Css.alignItems stretch
            ]
        ]
        []
        [ brandToElement b
        , navbarMenu links
        ]


{-| Makes a color look more "neon"
-}
neonize : Css.Color -> Css.Color
neonize input =
    hex neonGreen


neonGreen : String
neonGreen =
    "#00ff10"


led : Bool -> Html msg
led lit =
    let
        color =
            case lit of
                True ->
                    ledOnColor

                False ->
                    Css.backgroundColor primary
    in
    styled Html.Styled.hr
        [ Css.margin zero
        , color
        ]
        []
        []


ledOnColor : Style
ledOnColor =
    Css.batch
        [ Css.backgroundColor (hex neonGreen)
        , Css.property "box-shadow" (ledBoxShadow neonGreen)
        , Css.animationName (neonAnimation "#359D37" neonGreen)
        , Css.animationDuration (ms 1000)
        ]


ledBoxShadow : String -> String
ledBoxShadow c =
    "0 0 5px rgba(53, 157, 55, 0.8), 0 0 15px rgba(53, 157, 55, 0.6)"


neonAnimation : String -> String -> Keyframes {}
neonAnimation start end =
    keyframes
        [ ( 0
          , [ Css.Animations.backgroundColor (hex start)
            , Css.Animations.property "box-shadow" "none"
            ]
          )
        , ( 40
          , [ Css.Animations.backgroundColor (hex start)
            ]
          )
        , ( 45
          , [ Css.Animations.backgroundColor (hex end)
            ]
          )
        , ( 50
          , [ Css.Animations.backgroundColor (hex start)
            ]
          )
        , ( 55
          , [ Css.Animations.backgroundColor (hex end)
            , Css.Animations.property "box-shadow" "none"
            ]
          )
        , ( 100
          , [ Css.Animations.backgroundColor (hex end)
            , Css.Animations.property "box-shadow" (ledBoxShadow end)
            ]
          )
        ]
