module SE.Framework.Date exposing (date, toISO)


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
        , year = extractYear string
        , month = extractMonth string
        , day = extractDay string
        }


toISO : AllowFraction -> Date -> String
toISO allowFraction (Date { year, month, day }) =
    [ Maybe.map String.fromInt year
        |> Maybe.withDefault ""
    , Maybe.map (\m -> String.right 2 ("0" ++ String.fromInt (monthToInt m))) month
        |> Maybe.withDefault ""
    , Maybe.map (\d -> String.right 2 ("0" ++ String.fromInt d)) day
        |> Maybe.withDefault ""
    ]
        |> List.filter (not << String.isEmpty)
        |> String.join "-"


extractYear : String -> Maybe Int
extractYear text =
    String.toInt (String.left 4 text)


extractMonth : String -> Maybe Month
extractMonth text =
    String.toInt (String.slice 4 6 (String.replace "-" "" text))
        |> Maybe.andThen toValidMonth


toValidMonth : Int -> Maybe Month
toValidMonth n =
    case n of
        1 ->
            Just Jan

        2 ->
            Just Feb

        3 ->
            Just Mar

        4 ->
            Just Apr

        5 ->
            Just May

        6 ->
            Just Jun

        7 ->
            Just Jul

        8 ->
            Just Aug

        9 ->
            Just Sep

        10 ->
            Just Oct

        11 ->
            Just Nov

        12 ->
            Just Dec

        _ ->
            Nothing


monthToInt : Month -> Int
monthToInt month =
    case month of
        Jan ->
            1

        Feb ->
            2

        Mar ->
            3

        Apr ->
            4

        May ->
            5

        Jun ->
            6

        Jul ->
            7

        Aug ->
            8

        Sep ->
            9

        Oct ->
            10

        Nov ->
            11

        Dec ->
            12


extractDay : String -> Maybe Int
extractDay text =
    let
        maybeYear =
            extractYear text

        maybeMonth =
            extractMonth text

        maybeDay =
            case String.length text == 8 || String.length text == 10 of
                True ->
                    String.toInt (String.right 2 text)

                False ->
                    Nothing

        maybeMaxDay =
            Maybe.map2 daysInMonth maybeYear maybeMonth
    in
    case ( maybeDay, maybeMaxDay ) of
        ( Just day, Just max ) ->
            if day > 1 && day <= max then
                Just day

            else
                Nothing

        _ ->
            Nothing


daysInMonth : Int -> Month -> Int
daysInMonth year month =
    case month of
        Jan ->
            31

        Feb ->
            if isLeapYear year then
                29

            else
                28

        Mar ->
            31

        Apr ->
            30

        May ->
            31

        Jun ->
            30

        Jul ->
            31

        Aug ->
            31

        Sep ->
            30

        Oct ->
            31

        Nov ->
            30

        Dec ->
            31


{-| From <https://www.timeanddate.com/date/leapyear.html>
In the Gregorian calendar three criteria must be taken into account to identify leap years:

  - The year can be evenly divided by 4;
  - If the year can be evenly divided by 100, it is NOT a leap year, unless;
  - The year is also evenly divisible by 400. Then it is a leap year.
    This means that in the Gregorian calendar, the years 2000 and 2400 are leap years, while 1800, 1900, 2100, 2200, 2300 and 2500 are NOT leap years.

-}
isLeapYear : Int -> Bool
isLeapYear year =
    (modBy 4 year == 0) && ((modBy 100 year /= 0) || (modBy 400 year == 0))
