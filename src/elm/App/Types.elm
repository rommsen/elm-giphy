module App.Types exposing (..)

import Http


type alias Model =
    { query : String
    , url : String
    , gifs : Gifs
    }


type alias GIF =
    { url : String
    , width : String
    , height : String
    }


type alias QueryResults =
    { gifs : List GIF }


type alias Gifs =
    { previous : List GIF
    , current : Maybe GIF
    , remaining : List GIF
    }


type Msg
    = InputQuery String
    | GetRandomGif
    | Query
    | Next
    | NewGif (Result Http.Error String)
    | NewQueryResults (Result Http.Error QueryResults)
