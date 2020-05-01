module Templates.Main exposing (header, imports)

import Structure


header : String
header =
    "module Docs exposing (main)\n\n"


{-| Takes a list of names together with a list of exposed functions
-}
imports : List Structure.Module -> String
imports mods =
    List.map (\{ name } -> "import " ++ name) mods
        |> String.join "\n"
        |> (++) "\n"
