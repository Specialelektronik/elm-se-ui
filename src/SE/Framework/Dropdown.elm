module SE.Framework.Dropdown exposing (Button)


type alias Button msg =
    Html msg



-- https://github.com/xarvh/elm-onclickoutside
-- Can we port this one?
-- Explanation: https://stackoverflow.com/questions/42764494/blur-event-relatedtarget-returns-null
-- dropdown : Html msg
-- dropdown =
-- From https://github.com/rundis/elm-bootstrap/blob/master/src/Bootstrap/Dropdown.elm
-- subscriptions : State -> (State -> msg) -> Sub msg
-- subscriptions ((State { status }) as state) toMsg =
--     case status of
--         Open ->
--             Browser.Events.onAnimationFrame
--                 (\_ -> toMsg <| updateStatus ListenClicks state)
--         ListenClicks ->
--             Browser.Events.onClick
--                 (Json.succeed <| toMsg <| updateStatus Closed state)
--         Closed ->
--             Sub.none
