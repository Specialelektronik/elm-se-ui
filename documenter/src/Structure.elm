module Structure exposing (Function, Module, VerifiedFunction(..), decoder, toVerifiedFunction)

import Json.Decode as JD exposing (Decoder)
import Structure.Argument exposing (Argument)



-- TYPES


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



-- DECODERS


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
            Structure.Argument.extractArguments fn.type_
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
