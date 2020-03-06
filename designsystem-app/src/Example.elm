module Example exposing (Category(..), Example, categories, categoriesData, categoryFromString)

import Html.Styled exposing (Html)


type alias Example msg =
    { name : String
    , category : Category
    , content : List (Html msg)
    }


type Category
    = Overview
    | Columns
    | Layout
    | Form
    | Elements
    | Components


type alias CategoryData =
    { category : Category
    , title : String
    , id : String
    }


categoriesData : List CategoryData
categoriesData =
    [ { category = Overview
      , title = "Overview"
      , id = "Overview"
      }
    , { category = Columns
      , title = "Columns"
      , id = "columns"
      }
    , { category = Layout
      , title = "Layout"
      , id = "layout"
      }
    , { category = Form
      , title = "Form"
      , id = "form"
      }
    , { category = Elements
      , title = "Elements"
      , id = "elements"
      }
    , { category = Components
      , title = "Components"
      , id = "components"
      }
    ]


categories : List Category
categories =
    List.map .category categoriesData


categoryFromString : String -> Result String CategoryData
categoryFromString string =
    List.foldl
        (\catData carry ->
            if catData.title == string || catData.id == string then
                Ok catData

            else
                carry
        )
        (Err "Invalid String")
        categoriesData
