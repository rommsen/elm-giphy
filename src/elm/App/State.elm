module App.State exposing (init, update, subscriptions)

import App.Types exposing (..)
import Http exposing (request)
import Json.Decode as JD
import Json.Decode.Pipeline exposing (decode, required, requiredAt)


initialModel : Model
initialModel =
    { query = ""
    , url = "http://giphy.com/embed/14c0YMK7oEVs0o"
    , gifs = Gifs [] Nothing []
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        InputQuery query ->
            ( { model | query = query }, Cmd.none )

        GetRandomGif ->
            ( model, getRandomGif "waiting" )

        Query ->
            if String.isEmpty model.query then
                ( model, Cmd.none )
            else
                ( model, queryGifs model.query )

        Next ->
            ( { model | gifs = getNextGifs model.gifs }, Cmd.none )

        NewGif (Ok url) ->
            ( { model | url = url }, Cmd.none )

        NewGif (Err a) ->
            let
                _ =
                    Debug.log "Error" a
            in
                ( model, Cmd.none )

        NewQueryResults (Ok results) ->
            let
                newGifs =
                    case results.gifs of
                        head :: tail ->
                            Gifs [] (Just head) tail

                        [] ->
                            Gifs [] Nothing []
            in
                ( { model | gifs = newGifs }, Cmd.none )

        NewQueryResults (Err a) ->
            let
                _ =
                    Debug.log "Error" a
            in
                ( model, Cmd.none )


getNextGifs : Gifs -> Gifs
getNextGifs { previous, current, remaining } =
    case ( previous, current, remaining ) of
        ( previous, Just current, head :: tail ) ->
            Gifs (current :: previous) (Just head) tail

        _ ->
            Gifs previous current remaining


getRandomGif : String -> Cmd Msg
getRandomGif topic =
    let
        url =
            "https://api.giphy.com/v1/gifs/search?api_key=dc6zaTOxFJmzC&q=" ++ topic

        request =
            Http.get url decodeGifUrl
    in
        Http.send NewGif request


queryGifs : String -> Cmd Msg
queryGifs string =
    let
        url =
            "https://api.giphy.com/v1/gifs/search?limit=100&api_key=dc6zaTOxFJmzC&q=" ++ string

        request =
            Http.get url decodeResults
    in
        Http.send NewQueryResults request


decodeGifUrl : JD.Decoder String
decodeGifUrl =
    JD.at [ "data", "image_url" ] JD.string


decodeResults : JD.Decoder QueryResults
decodeResults =
    decode QueryResults
        |> requiredAt [ "data" ] (JD.list decodeGif)


decodeGif : JD.Decoder GIF
decodeGif =
    decode GIF
        |> requiredAt [ "images", "downsized_large", "url" ] JD.string
        |> requiredAt [ "images", "downsized_large", "width" ] JD.string
        |> requiredAt [ "images", "downsized_large", "height" ] JD.string



-- SUBSCRIPTIONS


subscriptions : Sub Msg
subscriptions =
    Sub.none
