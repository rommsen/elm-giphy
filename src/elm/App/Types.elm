module App.Types exposing (..)

import Array exposing (Array)
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
    { list : Array GIF
    , current : Int
    }


type Msg
    = InputQuery String
    | GetRandomGif
    | Query
    | Next
    | Previous
    | NewGif (Result Http.Error String)
    | NewQueryResults (Result Http.Error QueryResults)
