port module Main exposing (..)

import Html exposing (text)
import Json.Decode as JD exposing (Decoder)
import Structure


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
        modules : List Structure.Module
        modules =
            JD.decodeString Structure.decoder json
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


viewModule : Structure.Module -> Html.Html Never
viewModule module_ =
    let
        verifiedFunctions =
            List.map Structure.toVerifiedFunction module_.values
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
