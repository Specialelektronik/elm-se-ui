module Docs exposing (main)

import Browser
import Html.Styled exposing (Html, text, toUnstyled)
import SE.UI.Container
import SE.UI.Content
import SE.UI.Form
import SE.UI.Form.Input
import SE.UI.Global exposing (global)
import SE.UI.Section
import SE.UI.Title



-- MODEL


type alias Model =
    { sEUITitletitle1 : SEUITitletitle1Model }


type alias SEUITitletitle1Model =
    { a : String
    }


init : Model
init =
    { sEUITitletitle1 = sEUITitletitle1Init }


sEUITitletitle1Init : SEUITitletitle1Model
sEUITitletitle1Init =
    { a = "Hello world"
    }



-- UPDATE


type Msg
    = SEUITitletitle1Msg SEUITitletitle1SubMsg


type SEUITitletitle1SubMsg
    = SEUITitletitle1SubMsgUpdateA String


update : Msg -> Model -> Model
update msg model =
    case msg of
        SEUITitletitle1Msg subMsg ->
            { model | sEUITitletitle1 = sEUITitletitle1Update subMsg model.sEUITitletitle1 }


sEUITitletitle1Update : SEUITitletitle1SubMsg -> SEUITitletitle1Model -> SEUITitletitle1Model
sEUITitletitle1Update msg model =
    case msg of
        SEUITitletitle1SubMsgUpdateA a ->
            { model | a = a }



-- VIEW


view : Model -> Html Msg
view model =
    Html.Styled.div []
        [ global
        , SE.UI.Section.section []
            [ SE.UI.Container.container []
                [ SE.UI.Content.content []
                    [ Html.Styled.h1 [] [ text "SE.UI.Title" ]
                    , Html.Styled.p [] [ text "Bulma Title elements see <https://bulma.io/documentation/elements/title/>" ]
                    , Html.Styled.p [] [ text "Only the title element is supported, not the subtitle" ]
                    , Html.Styled.h2 [] [ text "title1" ]
                    , Html.Styled.p [] [ text "Title in size 1" ]
                    , Html.Styled.code [] [ text "String -> Html msg" ]
                    ]
                , SE.UI.Form.field []
                    [ SE.UI.Form.label "First argument"
                    , SE.UI.Form.Input.text (SEUITitletitle1SubMsgUpdateA >> SEUITitletitle1Msg) model.sEUITitletitle1.a
                        |> SE.UI.Form.Input.withTrigger SE.UI.Form.Input.OnInput
                        |> SE.UI.Form.Input.toHtml
                    ]
                , SE.UI.Title.title1 model.sEUITitletitle1.a
                , Html.Styled.code []
                    [ text ("SE.UI.Title.title1 \"" ++ model.sEUITitletitle1.a ++ "\"")
                    ]
                ]
            ]
        ]



-- MAIN


main =
    Browser.sandbox
        { init = init
        , view = view >> toUnstyled
        , update = update
        }
