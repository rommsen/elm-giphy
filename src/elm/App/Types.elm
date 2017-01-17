module App.Types exposing (..)

import Http


type alias Model =
    { query : String
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
    | NewQueryResults (Result Http.Error QueryResults)
