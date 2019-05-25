module SE.Framework.Date exposing (parse)


type alias Date =
    { year : ( String, Maybe Int )
    , month : ( String, Maybe Month )
    , day : ( String, Maybe Int )
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


type Status
    = Valid
    | Invalid


parse : String -> String
parse input =
    let
        cleanInput =
            String.replace "-" "" input

        newDate =
            { year = extractYear cleanInput
            , month = extractMonth cleanInput
            , day = ( "", Nothing )
            }

        newDateWithDay =
            case Maybe.map2 (extractDay cleanInput) (Tuple.second newDate.year) (Tuple.second newDate.month) of
                Just day ->
                    { newDate | day = day }

                Nothing ->
                    newDate
    in
    Maybe.withDefault (Tuple.first newDateWithDay.year) (Maybe.map (\y -> String.fromInt y ++ "-") (Tuple.second newDateWithDay.year))
        ++ Maybe.withDefault (Tuple.first newDateWithDay.month)
            (Maybe.map
                (\m -> String.padLeft 2 '0' (String.fromInt (monthToInt m)) ++ "-")
                (Tuple.second newDateWithDay.month)
            )
        ++ Maybe.withDefault (Tuple.first newDateWithDay.day)
            (Maybe.map
                (\d -> String.padLeft 2 '0' (String.fromInt d))
                (Tuple.second newDateWithDay.day)
            )


extractYear : String -> ( String, Maybe Int )
extractYear text =
    let
        year =
            String.left 4 text

        maybeYear =
            if String.length text >= 4 then
                String.toInt year

            else
                Nothing
    in
    ( year, maybeYear )


extractMonth : String -> ( String, Maybe Month )
extractMonth text =
    let
        month =
            String.slice 4 6 text

        maybeMonth =
            if String.length text >= 6 then
                String.toInt month

            else
                Nothing
    in
    ( month
    , maybeMonth
        |> Maybe.andThen toValidMonth
    )


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


extractDay : String -> Int -> Month -> ( String, Maybe Int )
extractDay text year month =
    let
        day =
            Debug.log "slice " (String.slice 6 8 text)

        maxDay =
            daysInMonth year month

        maybeDay =
            if String.length text == 8 then
                String.toInt day

            else
                Nothing
    in
    ( day
    , maybeDay
        |> Maybe.andThen
            (\d ->
                if d > 1 && d <= maxDay then
                    Just d

                else
                    Nothing
            )
    )



-- case   of
--     Just d ->
--
--     Nothing -> Nothing


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
