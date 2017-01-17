module App.State exposing (init, update, subscriptions)

import App.Types exposing (..)
import Http exposing (request)
import Json.Decode as JD
import Json.Decode.Pipeline exposing (decode, required, requiredAt)


initialModel : Model
initialModel =
    { query = ""
    , queryOffset = 0
    , queryLimit = 25
    , gifs = []
    , current = Nothing
    , thumbnail = Nothing
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        InputQuery query ->
            ( { model | query = query }, Cmd.none )

        Query ->
            let
                newModel =
                    if String.isEmpty model.query then
                        { model | query = "idiot" }
                    else
                        model
            in
                ( newModel, queryGifs newModel NewQueryResults )

        AdditionalQuery ->
            let
                newModel =
                    { model | queryOffset = model.queryOffset + model.queryLimit }
            in
                ( newModel, queryGifs newModel AdditionalQueryResults )

        NewQueryResults (Ok results) ->
            ( { model | gifs = results.gifs }, Cmd.none )

        NewQueryResults (Err a) ->
            let
                _ =
                    Debug.log "Error" a
            in
                ( model, Cmd.none )

        AdditionalQueryResults (Ok results) ->
            ( { model | gifs = model.gifs ++ results.gifs }, Cmd.none )

        AdditionalQueryResults (Err a) ->
            let
                _ =
                    Debug.log "Error" a
            in
                ( model, Cmd.none )

        Select gif ->
            ( { model | current = Just gif }, Cmd.none )

        Deselect ->
            ( { model | current = Nothing }, Cmd.none )

        ThumbnailPreviewStart gif ->
            ( { model | thumbnail = Just gif }, Cmd.none )

        ThumbnailPreviewEnd ->
            ( { model | thumbnail = Nothing }, Cmd.none )



-- queryGifs : Model -> Result Http.Error Msg -> Cmd Msg


queryGifs { query, queryOffset, queryLimit } msg =
    let
        url =
            "https://api.giphy.com/v1/gifs/search?api_key=dc6zaTOxFJmzC"
                ++ "&limit="
                ++ toString queryLimit
                ++ "&offset="
                ++ toString queryOffset
                ++ "&q="
                ++ query

        request =
            Http.get url decodeResults
    in
        Http.send msg request


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
        |> requiredAt [ "images", "fixed_width_still", "url" ] JD.string
        |> requiredAt [ "images", "fixed_width", "url" ] JD.string



-- SUBSCRIPTIONS


subscriptions : Sub Msg
subscriptions =
    Sub.none
