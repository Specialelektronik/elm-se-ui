module Examples.Button exposing (..)

import Debug.Control as Control exposing (Control)
import Example exposing (Example)
import Html.Styled exposing (text)
import SE.UI.Buttons as Buttons


type alias Model =
    { mods : List Buttons.Modifier
    }
