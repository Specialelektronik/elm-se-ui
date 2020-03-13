port module Main exposing (..)

import Html exposing (text)
import Json.Decode as JD exposing (Decoder)


type alias Module =
    { name : String
    , comment : String
    , values : List Function
    }


type alias Function =
    { name : String
    , comment : String
    , type_ : String
    }


type VerifiedFunction
    = Unverified Function
    | Verified
        { name : String
        , comment : String
        , type_ : String
        , arguments : List Argument
        }


type Argument
    = String_


defaultArgument : Argument -> String
defaultArgument argument =
    case argument of
        String_ ->
            "\"Hello World\""


decoder : Decoder (List Module)
decoder =
    JD.list
        (JD.map3 Module
            (JD.field "name" JD.string)
            (JD.field "comment" JD.string)
            (JD.field "values" (JD.list functionDecoder))
        )


functionDecoder : Decoder Function
functionDecoder =
    JD.map3 Function
        (JD.field "name" JD.string)
        (JD.field "comment" JD.string)
        (JD.field "type" JD.string)


toVerifiedFunction : Function -> VerifiedFunction
toVerifiedFunction fn =
    let
        arguments =
            extractArguments fn.type_
    in
    if List.isEmpty arguments then
        Unverified fn

    else
        Verified
            { name = fn.name
            , comment = fn.comment
            , type_ = fn.type_
            , arguments = arguments
            }


extractArguments : String -> List Argument
extractArguments type_ =
    type_
        |> String.split " -> "
        |> dropLast
        |> List.filterMap stringToArgument


dropLast : List a -> List a
dropLast list =
    list
        |> List.reverse
        |> List.drop 1
        |> List.reverse


stringToArgument : String -> Maybe Argument
stringToArgument string =
    case string of
        "String" ->
            Just String_

        _ ->
            Nothing


json =
    """[{
    "name": "SE.UI.Section",
    "comment": " Creates a styled section in line with Bulmas section.",
    "unions": [],
    "aliases": [],
    "values": [
      {
        "name": "section",
        "comment": " Creates a styled section html tag in line with [Bulmas section](https://bulma.io/documentation/layout/section/).",
        "type": "List.List (Html.Styled.Attribute msg) -> List.List (Html.Styled.Html msg) -> Html.Styled.Html msg"
      },
      {
        "name": "p",
        "comment": "Outputs a paragraph",
        "type": "String -> Html.Styled.Html msg"
      }
    ],
    "binops": []
  }]"""


main : Program () () Never
main =
    Platform.worker
        { init = \_ -> ( (), build )
        , update = \_ model -> ( model, Cmd.none )
        , subscriptions = always Sub.none
        }


build : Cmd msg
build =
    let
        modules : List Module
        modules =
            JD.decodeString decoder json
                |> Result.withDefault []

        imports =
            List.map (\m -> "import " ++ m.name) modules
                |> String.join "\n"

        template =
            """module Docs exposing (main)

{{imports}}
"""
                |> String.replace "{{imports}}" imports
    in
    createFile { name = "Docs.elm", content = template }


viewModule : Module -> Html.Html Never
viewModule module_ =
    let
        verifiedFunctions =
            List.map toVerifiedFunction module_.values
    in
    Html.div []
        [ Html.h1 [] [ text module_.name ]
        , Html.p []
            [ Html.strong [] [ text module_.comment ]
            ]
        , Html.div [] (List.map viewVerifiedFunction verifiedFunctions)
        ]


viewVerifiedFunction : VerifiedFunction -> Html.Html Never
viewVerifiedFunction vf =
    text (Debug.toString vf)


port createFile : { name : String, content : String } -> Cmd msg
