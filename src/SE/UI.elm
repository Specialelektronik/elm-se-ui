module SE.UI exposing (main)

import Browser
import Css
import Html.Styled as Html exposing (Html, div, styled, toUnstyled)
import Html.Styled.Attributes as Attributes
import SE.UI.Buttons as Buttons
import SE.UI.Colors as Colors
import SE.UI.Columns as Columns
import SE.UI.Container as Container
import SE.UI.Content as Content
import SE.UI.Control as Control
import SE.UI.Font as Font
import SE.UI.Form as Form
import SE.UI.Form.Input as Input
import SE.UI.Global as Global
import SE.UI.Icon as Icon
import SE.UI.Section as Section
import SE.UI.Title as Title
import SE.UI.Utils as Utils



-- MODEL


type alias Model =
    { count : Int
    , button : ButtonModel
    , input : String
    }


type alias ButtonModel =
    { mods : List Buttons.Modifier
    }


initialModel : Model
initialModel =
    { count = 1
    , button = defaultButton
    , input = ""
    }


defaultButton : ButtonModel
defaultButton =
    { mods = []
    }



-- UPDATE


type Msg
    = NoOp
    | ClickedButton
    | GotInput String
    | GotButtonsMsg ButtonMsg


type ButtonMsg
    = ToggleModifier Buttons.Modifier


update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model

        ClickedButton ->
            model

        GotInput str ->
            { model | input = str }

        GotButtonsMsg subMsg ->
            { model | button = updateButton subMsg model.button }


updateButton : ButtonMsg -> ButtonModel -> ButtonModel
updateButton msg model =
    case msg of
        ToggleModifier mod ->
            let
                newMods =
                    if List.member mod model.mods then
                        List.filter (\a -> a /= mod) model.mods

                    else
                        mod :: model.mods
            in
            { model | mods = newMods }



-- VIEW


view : Model -> Html Msg
view model =
    div
        []
        [ Global.global
        , Html.article []
            [ viewColors
            , viewTypography
            , viewButtons model.button
            , viewSection
            , viewForm model
            ]
        ]


viewTypography : Html Msg
viewTypography =
    Section.section []
        [ Container.container []
            [ Title.title1 "Typography"
            , Content.content
                []
                [ Html.p []
                    [ Html.text "We support the same "
                    , Html.code [] [ Html.text "content" ]
                    , Html.text " as Bulma. Use it wherever you have html content from a wysiwyg-editor that you can (and should not) style yourself."
                    ]
                , Html.h1 [] [ Html.text "H1 Title - This is a H1 title 44.79px/58.2px (mobile: 28.83px/37.5px)" ]
                , Html.h2 [] [ Html.text "H2 Title - This is a H2 title 37.32px/48.5px (mobile: 25.63px/33.3px)" ]
                , Html.h3 [] [ Html.text "H3 Title - This is a H3 title 31.1px/40.4px (mobile: 22.78px/29.6px)" ]
                , Html.h4 [] [ Html.text "H4 Title - This is a H4 title 25.92px/33.7px (mobile: 20.25px/26.3px)" ]
                , Html.h5 [] [ Html.text "H5 Title - This is a H5 title 21.6px/28.1px (mobile: 18px/23.4px)" ]
                , Html.h6 [] [ Html.text "H6 Title - This is a H6 title 18px/23.4px (mobile: 16px/20.8px)" ]
                , Html.p [] [ Html.text "Body Standard 18px/27px", Html.br [] [], Html.text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras id pellentesque lorem, eget efficitur sem. In sit amet ipsum nec massa congue dictum. Duis ultricies lorem erat, eget aliquam nunc luctus eget." ]
                , styled Html.p [ Font.bodySizeEm -1 ] [] [ Html.text "Body Medium 16px/24px", Html.br [] [], Html.text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras id pellentesque lorem, eget efficitur sem. In sit amet ipsum nec massa congue dictum. Duis ultricies lorem erat, eget aliquam nunc luctus eget." ]
                , styled Html.p [ Font.bodySizeEm -2 ] [] [ Html.text "Body Small 14px/21px", Html.br [] [], Html.text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras id pellentesque lorem, eget efficitur sem. In sit amet ipsum nec massa congue dictum. Duis ultricies lorem erat, eget aliquam nunc luctus eget." ]
                , styled Html.p [ Font.bodySizeEm -2, Css.lineHeight (Css.num 1.28571428571) ] [] [ Html.text "Body Small less line-height 14px/18px", Html.br [] [], Html.text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras id pellentesque lorem, eget efficitur sem. In sit amet ipsum nec massa congue dictum. Duis ultricies lorem erat, eget aliquam nunc luctus eget." ]
                , styled Html.p [ Font.bodySizeEm -3 ] [] [ Html.text "Small info text 12px/18px" ]
                , Html.ul []
                    [ Html.li [] [ Html.text "List item 1" ]
                    , Html.li [] [ Html.text "List item 2" ]
                    , Html.li [] [ Html.text "List item 3" ]
                    ]
                , Html.p []
                    [ styled Html.a
                        Font.textButtonStyles
                        []
                        [ Html.text "Visa mer"
                        , Icon.angleDown Control.Small
                        ]
                    ]
                ]
            ]
        ]


viewColors : Html Msg
viewColors =
    let
        greys =
            [ ( Colors.White, "White" )
            , ( Colors.Lightest, "Lightest" )
            , ( Colors.Lighter, "Lighter" )
            , ( Colors.Light, "Light" )
            , ( Colors.Base, "Base" )
            , ( Colors.Dark, "Dark" )
            , ( Colors.Darker, "Darker" )
            , ( Colors.Darkest, "Darkest" )
            , ( Colors.Black, "Black" )
            ]

        colors =
            [ ( Colors.Primary, "Primary" )
            , ( Colors.Link, "Link" )
            , ( Colors.Buy, "Buy" )
            , ( Colors.Danger, "Danger" )
            , ( Colors.Bargain, "Bargain" )
            , ( Colors.DarkGreen, "DarkGreen" )
            , ( Colors.LightBlue, "LightBlue" )
            ]
    in
    Section.section []
        [ Container.container []
            [ Title.title1 "Colors"
            , Title.title3 "Grays"
            , Columns.multilineColumns
                (List.map (\c -> Columns.column [ ( Columns.All, Columns.OneThird ) ] [ viewColorBox c ]) greys)
            , Title.title3 "Others"
            , Columns.multilineColumns
                (List.map (\c -> Columns.column [ ( Columns.All, Columns.OneThird ) ] [ viewColorBox c ]) colors)
            ]
        ]


viewColorBox : ( Colors.Color, String ) -> Html Msg
viewColorBox ( color, label ) =
    styled Html.div
        [ Css.displayFlex
        , Css.alignItems Css.center
        ]
        []
        [ styled div
            [ Css.width (Css.rem 3)
            , Css.height (Css.rem 3)
            , Colors.backgroundColor (color |> Colors.toHsla)
            , Css.boxShadow6 Css.inset Css.zero (Css.px 2) (Css.px 4) Css.zero (Css.rgba 0 0 0 0.06)
            , Css.borderRadius (Css.rem 0.5)
            ]
            []
            []
        , styled div
            [ Css.marginLeft (Css.rem 0.5)
            ]
            []
            [ Html.text label ]
        ]


allMods : List ( Buttons.Modifier, String )
allMods =
    [ ( Buttons.Color Colors.Primary, "Primary" )
    , ( Buttons.Color Colors.Link, "Link" )
    , ( Buttons.Color Colors.Buy, "Buy" )
    , ( Buttons.Color Colors.Bargain, "Bargin" )
    , ( Buttons.Color Colors.Danger, "Danger" )
    , ( Buttons.Color Colors.White, "White" )
    , ( Buttons.Color Colors.Lightest, "Lightest" )
    , ( Buttons.Color Colors.Lighter, "Lighter" )
    , ( Buttons.Color Colors.Light, "Light" )
    , ( Buttons.Color Colors.Base, "Base" )
    , ( Buttons.Color Colors.Dark, "Dark" )
    , ( Buttons.Color Colors.Darker, "Darker" )
    , ( Buttons.Color Colors.Darkest, "Darkest" )
    , ( Buttons.Color Colors.Black, "Black" )
    , ( Buttons.Color Colors.DarkGreen, "DarkGreen" )
    , ( Buttons.Color Colors.LightBlue, "LightBlue" )
    , ( Buttons.Text, "Text" )
    , ( Buttons.Size Control.Regular, "Size Control.Regular" )
    , ( Buttons.Size Control.Small, "Size Control.Small" )
    , ( Buttons.Size Control.Medium, "Size Control.Medium" )
    , ( Buttons.Size Control.Large, "Size Control.Large" )
    , ( Buttons.Fullwidth, "Fullwidth" )
    , ( Buttons.Loading, "Loading" )
    ]


viewButtons : ButtonModel -> Html Msg
viewButtons model =
    Section.section []
        [ Container.container []
            [ Title.title1 "Buttons"
            , Form.field []
                (Form.label "Modifiers"
                    :: List.map (viewButtonModifier model.mods) allMods
                )
            , Buttons.buttons []
                [ Buttons.button model.mods (Just ClickedButton) [ Html.text "Save changes" ]
                ]
            , Html.code []
                [ Html.text ("SE.UI.Buttons.button [ " ++ (List.map modToString model.mods |> String.join ", ") ++ " ] (Just ClickedButton) [ Html.text \"Save changes\" ]")
                ]
            ]
        ]


modToString : Buttons.Modifier -> String
modToString mod =
    case mod of
        Buttons.Color Colors.Primary ->
            "Primary"

        Buttons.Color Colors.Link ->
            "Link"

        Buttons.Color Colors.Buy ->
            "Buy"

        Buttons.Color Colors.Bargain ->
            "Bargain"

        Buttons.Color Colors.Danger ->
            "Danger"

        Buttons.Color Colors.White ->
            "White"

        Buttons.Color Colors.Lightest ->
            "Lightest"

        Buttons.Color Colors.Lighter ->
            "Lighter"

        Buttons.Color Colors.Light ->
            "Light"

        Buttons.Color Colors.Base ->
            "Base"

        Buttons.Color Colors.Dark ->
            "Dark"

        Buttons.Color Colors.Darker ->
            "Darker"

        Buttons.Color Colors.Darkest ->
            "Darkest"

        Buttons.Color Colors.Black ->
            "Black"

        Buttons.Color Colors.DarkGreen ->
            "DarkGreen"

        Buttons.Color Colors.LightBlue ->
            "LightBlue"

        Buttons.Text ->
            "Text"

        Buttons.Size Control.Regular ->
            "Size Control.Regular"

        Buttons.Size Control.Small ->
            "Size Control.Small"

        Buttons.Size Control.Medium ->
            "Size Control.Medium"

        Buttons.Size Control.Large ->
            "Size Control.Large"

        Buttons.Fullwidth ->
            "Fullwidth"

        Buttons.Loading ->
            "Loading"


viewButtonModifier : List Buttons.Modifier -> ( Buttons.Modifier, String ) -> Html Msg
viewButtonModifier activeMods ( mod, label ) =
    Form.control False
        [ Input.checkbox (GotButtonsMsg (ToggleModifier mod)) label (List.member mod activeMods)
            |> Input.toHtml
        ]


viewSection : Html Msg
viewSection =
    Section.section []
        [ Container.container []
            [ Title.title1 "Section"
            , Html.p [] [ Html.text "Creates a styled section html tag in line with ", Html.a [ Attributes.href "https://bulma.io/documentation/layout/section/" ] [ Html.text "Bulmas section" ], Html.text "." ]
            , Html.code []
                [ Html.text "section [] [ Html.text \"I'm the text inside the section!\" ]"
                ]
            ]
        ]


viewForm : Model -> Html Msg
viewForm model =
    Section.section []
        [ Container.container []
            [ Title.title1 "Form"
            , Html.form []
                [ Form.field []
                    [ Form.label "Small label"
                    , Form.control False
                        [ Input.text GotInput model.input
                            |> Input.withPlaceholder "Placeholder"
                            |> Input.toHtml
                        ]
                    ]
                , Form.field []
                    [ Form.label "Select element"
                    , Form.control False
                        [ Input.select GotInput
                            [ { label = "Option 1", value = "option 1" }
                            , { label = "Option 2", value = "option 2" }
                            , { label = "Option 3", value = "option 3" }
                            ]
                            model.input
                            |> Input.withPlaceholder "Placeholder"
                            |> Input.toHtml
                        ]
                    ]
                ]
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
