module Documentation exposing (Documentation)

import Html.Styled exposing (Html)


type alias Documentation msg =
    { label : String
    , description : String
    , code : Html msg
    }
