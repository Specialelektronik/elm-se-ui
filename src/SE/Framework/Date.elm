module SE.Framework.Date exposing (Date(..))


type Date
    = Date
        { text : String
        , year : Maybe Int
        , month : Maybe Month
        , day : Maybe Int
        }


type Month
    = Jan
    | Feb
    | Mar
    | Apr
    | May
    | Jun
    | Jul
    | Aug
    | Sep
    | Oct
    | Nov
    | Dec


type alias AllowFraction =
    Bool


date : String -> Date
date string =
    Date
        { text = string
        , year = Nothing
        , month = Nothing
        , day = Nothing
        }
        |> extractYear
        |> extractMonth
        |> extractDay


toISO : AllowFraction -> Date -> Maybe String
toISO allowFraction d =
    Debug.todo "Not implemented"


extractYear : Date -> Date
extractYear old =
    old


extractMonth : Date -> Date
extractMonth old =
    old


extractDay : Date -> Date
extractDay old =
    old
