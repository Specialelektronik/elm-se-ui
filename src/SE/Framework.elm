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



-- MODEL


type alias Model =
    { button : ButtonModel
    }


type alias ButtonModel =
    { colors : List Buttons.Modifier
    , sizes : List Buttons.Modifier
    , msg : Maybe Msg
    , text : String
    , icon : String
    }


initialModel : Model
initialModel =
    { button = initialButton
    }


initialButton : ButtonModel
initialButton =
    { colors = []
    , sizes = []
    , msg = Just NoOp
    , text = "Button"
    , icon = "shopping-cart"
    }



-- UPDATE


type Msg
    = NoOp
    | UpdateButtonColor Buttons.Modifier
    | UpdateButtonSize Buttons.Modifier
    | UpdateButtonIcon String


update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model

        UpdateButtonColor modifier ->
            { model | button = updateButtonColor model.button modifier }

        UpdateButtonSize modifier ->
            { model | button = updateButtonSize model.button modifier }

        UpdateButtonIcon s ->
            { model | button = updateButtonIcon model.button s }


updateButtonColor : ButtonModel -> Buttons.Modifier -> ButtonModel
updateButtonColor model mod =
    { model | colors = [ mod ] }


updateButtonSize : ButtonModel -> Buttons.Modifier -> ButtonModel
updateButtonSize model mod =
    { model | sizes = [ mod ] }


updateButtonIcon : ButtonModel -> String -> ButtonModel
updateButtonIcon model s =
    { model | icon = s }



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
                    [ Title.title3 "Buttons"
                    , Buttons.button (model.button.colors ++ model.button.sizes)
                        model.button.msg
                        [ viewButtonIcon model.button.icon, span [] [ text "Button" ] ]
                    , Title.title4 "Modifiers"
                    , Columns.columns
                        [ Columns.defaultColumn
                            [ Title.title5 "Colors"
                            , ul [] <|
                                List.map
                                    (\( l, m ) -> li [] [ Form.radio l (List.member m model.button.colors) (UpdateButtonColor m) ])
                                    [ ( "Primary", Buttons.Primary )
                                    , ( "Link", Buttons.Link )
                                    , ( "Info", Buttons.Info )
                                    , ( "Success", Buttons.Success )
                                    , ( "Warning", Buttons.Warning )
                                    , ( "Danger", Buttons.Danger )
                                    , ( "White", Buttons.White )
                                    , ( "Lightest", Buttons.Lightest )
                                    , ( "Lighter", Buttons.Lighter )
                                    , ( "Light", Buttons.Light )
                                    , ( "Dark", Buttons.Dark )
                                    , ( "Darker", Buttons.Darker )
                                    , ( "Darkest", Buttons.Darkest )
                                    , ( "Black", Buttons.Black )
                                    , ( "Text", Buttons.Text )
                                    ]
                            ]
                        , Columns.defaultColumn
                            [ Title.title5 "Sizes"
                            , ul [] <|
                                List.map
                                    (\( l, m ) -> li [] [ Form.radio l (List.member m model.button.sizes) (UpdateButtonSize m) ])
                                    [ ( "Small", Buttons.Small )
                                    , ( "Medium", Buttons.Medium )
                                    , ( "Large", Buttons.Large )
                                    ]
                            ]
                        , Columns.defaultColumn
                            [ Title.title5 "Icons"
                            , Form.field []
                                [ Form.input
                                    { value = model.button.icon
                                    , placeholder = "Icon"
                                    , modifiers = []
                                    , onInput = UpdateButtonIcon
                                    }
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ]


viewButtonIcon : String -> Html Msg
viewButtonIcon s =
    if s == "" then
        text ""

    else
        Icon.icon s


viewSidebar : Html Msg
viewSidebar =
    styled aside
        [ Css.minHeight (vh 100)
        , Css.flex3 zero zero (px 300)
        , Css.position relative
        , Css.backgroundColor Colors.primary
        , Css.color Colors.white
        ]
        []
        [ styled div
            [ Css.position fixed
            , Css.margin2 (rem 3) (rem 1.5)
            , Css.width (calc (px 300) minus (rem 3))
            , Css.displayFlex
            , Css.flexDirection column
            ]
            []
            [ sidebarMenu
            ]
        ]


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
