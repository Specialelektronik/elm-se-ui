module Main exposing (..)

import Browser
import Browser.Navigation as Nav
import Html.Styled as Html exposing (Html)
import Page
import Page.Home as Home
import Url
import Url.Parser as Parser exposing ((</>), Parser, custom, fragment, map, oneOf, s, top)


type alias Model =
    { key : Nav.Key
    , page : Page
    }


type Page
    = NotFound
    | Home Home.Model


type Msg
    = NoOp
    | ClickedLink Browser.UrlRequest
    | ChangedUrl Url.Url
    | HomeMsg Home.Msg



-- INIT


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    stepUrl url
        { key = key
        , page = NotFound
        }



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        NoOp ->
            ( model, Cmd.none )

        ClickedLink urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Nav.pushUrl model.key (Url.toString url)
                    )

                Browser.External href ->
                    ( model
                    , Nav.load href
                    )

        ChangedUrl url ->
            stepUrl url model

        HomeMsg msg ->
            case model.page of
                Home home ->
                    stepHome model (Home.update msg home)

                _ ->
                    ( model, Cmd.none )


stepHome : Model -> ( Home.Model, Cmd Home.Msg ) -> ( Model, Cmd Msg )
stepHome model ( home, cmds ) =
    ( { model | page = Home home }
    , Cmd.map HomeMsg cmds
    )



-- ROUTER


stepUrl : Url.Url -> Model -> ( Model, Cmd Msg )
stepUrl url model =
    let
        parser =
            oneOf
                [ route top
                    (stepHome model Home.init)

                -- , route (s "packages" </> author_ </> project_)
                --     (\author project ->
                --         stepDiff model (Diff.init session author project)
                --     )
                -- , route (s "packages" </> author_ </> project_ </> version_ </> focus_)
                --     (\author project version focus ->
                --         stepDocs model (Docs.init session author project version focus)
                --     )
                -- , route (s "help" </> s "design-guidelines")
                --     (stepHelp model (Help.init session "Design Guidelines" "/assets/help/design-guidelines.md"))
                -- , route (s "help" </> s "documentation-format")
                --     (stepHelp model (Help.init session "Documentation Format" "/assets/help/documentation-format.md"))
                ]
    in
    case Parser.parse parser url of
        Just answer ->
            answer

        Nothing ->
            ( { model | page = NotFound }
            , Cmd.none
            )


route : Parser a b -> a -> Parser (b -> c) c
route parser handler =
    Parser.map handler parser



-- VIEW


view : Model -> Document
view { page } =
    case page of
        Home home ->
            Page.view HomeMsg (Home.view home)

        NotFound ->
            Page.notFound


main =
    Browser.application
        { init = init
        , view = view >> toUnstyled
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = ClickedLink
        , onUrlChange = ChangedUrl
        }


type alias Document =
    { title : String
    , body : List (Html Msg)
    }


toUnstyled : Document -> Browser.Document Msg
toUnstyled { title, body } =
    { title = title
    , body = List.map Html.toUnstyled body
    }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
