require './app/app'
require './app/middlewares/websocket_backend'

use ActiveCinema::WebsocketBackend

run ActiveCinema::App
