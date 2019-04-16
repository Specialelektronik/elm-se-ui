module SE.Framework exposing (main)

import Browser
import Css exposing (column, fixed, int, px, relative, rem, vh, zero)
import Html.Styled exposing (Html, article, aside, div, main_, styled, text, toUnstyled)
import SE.Framework.Colors as Colors
import SE.Framework.Section exposing (section)


type alias Introspection =
    { name : String
    , signature : String
    , description : String
    , variations : List Variation
    }


type alias Variation =
    ( String, List SubSection )


type alias SubSection =
    ( Html Msg, String )



-- MODEL


type alias Model =
    ()


initialModel : Model
initialModel =
    ()



-- UPDATE


type Msg
    = NoOp


update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model



-- VIEW


view : Model -> Html Msg
view model =
    styled div
        [ Css.displayFlex ]
        []
        [ viewSidebar
        , styled main_
            [ Css.flexGrow (int 1) ]
            []
            [ article []
                [ section []
                    [ text "Article 1"
                    ]
                ]
            , article []
                [ section []
                    [ text "Article 2"
                    ]
                ]
            , article []
                [ section []
                    [ text "Article 1"
                    ]
                ]
            , article []
                [ section []
                    [ text "Article 2"
                    ]
                ]
            , article []
                [ section []
                    [ text "Article 1"
                    ]
                ]
            , article []
                [ section []
                    [ text "Article 2"
                    ]
                ]
            ]
        ]


viewIntrospection : Introspection -> Html Msg
viewIntrospection introspection =
    text "introspection"


viewSidebar : Html Msg
viewSidebar =
    styled aside
        [ Css.minHeight (vh 100)
        , Css.flex3 zero zero (px 300)
        , Css.position relative
        , Css.backgroundColor Colors.black
        ]
        []
        [ styled div
            [ Css.position fixed
            , Css.margin2 zero (rem 1.5)

            --, Css.width calc (300 px - 3 rem)
            , Css.displayFlex
            , Css.flexDirection column
            ]
            []
            [ text "sidebar"
            ]
        ]



-- MAIN


main : Program () Model Msg
main =
    Browser.sandbox
        { view = view >> toUnstyled
        , update = update
        , init = initialModel
        }
