require './app'
require './middlewares/websocket_backend'

use ActiveCinema::WebsocketBackend

run ActiveCinema::App
