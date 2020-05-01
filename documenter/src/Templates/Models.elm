module Templates.Models exposing (..)

import Structure

{-| Should return something like this:

type alias Model =
    { sEUITitletitle1 : SEUITitletitle1Model }


type alias SEUITitletitle1Model =
    { a : String
    }
-}
models : List ( Structure.Module, List Structure.VerifiedFunction ) -> String
models lst =
    List.map modelsHelper lst

modelsHelper : Structure.Module -> List Structure.VerifiedFunction -> List String
modelsHelper mod vfs =

model : Structure.Module -> Structure.VerifiedFunction -> Maybe String
model mod vf =
    toTypeName mod vf
        |> Maybe.map (++) "type alias "



{-| Removes full stops and upper cases the first letter
-}
toTypeName : Structure.Module -> Structure.VerifiedFunction -> Maybe String -> Maybe String
toTypeName =
    toNameHelper upperCaseFirstLetter


{-| Removes full stops and lower cases the first letter
-}
toFuncName : Structure.Module -> Structure.VerifiedFunction -> Maybe String -> Maybe String
toFuncName =
    toNameHelper lowerCaseFirstLetter


toNameHelper : Structure.Module -> Structure.VerifiedFunction -> Maybe String
toNameHelper mod vf =
    toFullName mod vf
        |> Maybe.map removeFullStops


toFullName : Structure.Module -> Structure.VerifiedFunction -> Maybe String
toFullName mod vf =
    case vf of
        Structure.Unverified _ ->
            Nothing

        Structure.Verified { name } ->
            Just (mod.name ++ "." ++ name)


removeFullStops : String -> String
removeFullStops =
    String.replace "." ""


lowerCaseFirstLetter : String -> String
lowerCaseFirstLetter =
    firstLetterHelper String.toLower


upperCaseFirstLetter : String -> String
upperCaseFirstLetter =
    firstLetterHelper String.toUpper


firstLetterHelper : (String -> String) -> String -> String
firstLetterHelper fn str =
    fn (String.left 1 str)
        ++ String.dropLeft 1 str
