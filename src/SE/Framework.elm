module SE.Framework exposing (main)

import Browser
import Css exposing (block, calc, column, em, fixed, hover, int, minus, px, relative, rem, rgba, vh, zero)
import Html.Styled exposing (Html, a, article, aside, div, li, main_, span, styled, text, toUnstyled, ul)
import Html.Styled.Attributes exposing (href, id)
import SE.Framework.Buttons as Buttons
import SE.Framework.Colors as Colors
import SE.Framework.Columns as Columns
import SE.Framework.Form as Form
import SE.Framework.Icon as Icon
import SE.Framework.Section exposing (section)
import SE.Framework.Title as Title
import SE.Framework.Utils exposing (radius, smallRadius)


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
            [ article [ id "Breadcrumb" ]
                [ section []
                    [ Title.title3 "Breadcrumb"
                    ]
                ]
            , article [ id "Buttons" ]
                [ section []
                    [ Title.title3 "Samsung QM75N UHD"
                    , div []
                        [ Title.title6 "Artikelnummer"
                        , span [] [ text "LH75QMREBGCXEN" ]
                        ]
                    , Columns.columns
                        [ Columns.column [ ( Columns.All, Columns.Narrow ) ] [ text "images" ]
                        , Columns.defaultColumn
                            [ Form.field [ Form.Attached ]
                                [ Form.control False
                                    [ Form.input
                                        { value = ""
                                        , placeholder = "Ange antal"
                                        , modifiers = []
                                        , onInput = \_ -> NoOp
                                        }
                                    ]
                                , Form.control False
                                    [ Buttons.staticButton [] [ text "st" ]
                                    ]
                                ]
                            ]
                        , Columns.defaultColumn
                            [ Form.field
                                []
                                [ Buttons.button [ Buttons.CallToAction, Buttons.Fullwidth ]
                                    (Just NoOp)
                                    [ Icon.icon "shopping-cart"
                                    , span [] [ text "Lägg i varukorg" ]
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ]


viewIntrospection : Introspection -> Html Msg
viewIntrospection introspection =
    text "introspection"


viewSidebar : Html Msg
viewSidebar =
    text ""



-- styled aside
--     [ Css.minHeight (vh 100)
--     , Css.flex3 zero zero (px 300)
--     , Css.position relative
--     , Css.backgroundColor Colors.primary
--     , Css.color Colors.white
--     ]
--     []
--     [ styled div
--         [ Css.position fixed
--         , Css.margin2 (rem 3) (rem 1.5)
--         , Css.width (calc (px 300) minus (rem 3))
--         , Css.displayFlex
--         , Css.flexDirection column
--         ]
--         []
--         [ sidebarMenu
--         ]
--     ]


sidebarMenu : Html Msg
sidebarMenu =
    ul []
        [ sidebarItem True "Breadcrumb" "Breadcrumb"
        , sidebarItem False "Buttons" "Buttons"
        ]



{- name = Name of the file
   Label = Label of the menu item
-}


sidebarItem : Bool -> String -> String -> Html Msg
sidebarItem isActive name label =
    styled li
        []
        []
        [ styled a
            [ Css.display block
            , Css.padding2 (em 0.5) (em 0.75)
            , Css.color Colors.white
            , Css.borderRadius smallRadius
            , hover
                [ Css.backgroundColor (rgba 0 0 0 0.2)
                , Css.color Colors.white
                ]
            , Css.batch <|
                if isActive then
                    [ Css.backgroundColor (rgba 0 0 0 0.1)
                    ]

                else
                    []
            ]
            [ href <| "#" ++ name ]
            [ text label ]
        ]



-- MAIN


main : Program () Model Msg
main =
    Browser.sandbox
        { view = view >> toUnstyled
        , update = update
        , init = initialModel
        }
