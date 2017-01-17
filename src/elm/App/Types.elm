module App.Types exposing (..)

import Http


type alias Model =
    { query : String
    , queryOffset : Int
    , queryLimit : Int
    , gifs : List GIF
    , current : Maybe GIF
    , thumbnail : Maybe GIF
    }


type alias GIF =
    { gif_url : String
    , width : String
    , height : String
    , thumbnail_url : String
    , thumbnail_gif_url : String
    }


type alias QueryResults =
    { gifs : List GIF }


type Msg
    = InputQuery String
    | Query
    | ThumbnailPreviewStart GIF
    | ThumbnailPreviewEnd
    | Select GIF
    | Deselect
    | AdditionalQuery
    | NewQueryResults (Result Http.Error QueryResults)
    | AdditionalQueryResults (Result Http.Error QueryResults)
