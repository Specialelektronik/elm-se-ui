module Structure.Argument exposing (Argument, defaultValue, extractArguments)

import Helpers


type Argument
    = String_


defaultValue : Argument -> String
defaultValue argument =
    case argument of
        String_ ->
            "\"Hello World\""


stringToArgument : String -> Maybe Argument
stringToArgument string =
    case string of
        "String" ->
            Just String_

        _ ->
            Nothing


extractArguments : String -> List Argument
extractArguments type_ =
    type_
        |> String.split " -> "
        |> Helpers.dropLast
        |> List.filterMap stringToArgument
