require 'faye/websocket'
require 'thread'
require 'json'
require 'erb'

module ActiveCinema
  class WebsocketBackend
    KEEPALIVE_TIME = 15 # in seconds

    def initialize(app)
      @app     = app
      @clients = []
    end

    def call(env)
      if Faye::WebSocket.websocket?(env)
        ws = Faye::WebSocket.new(env, nil, ping: KEEPALIVE_TIME)
        ws.on :open do
          p [:open, ws.object_id]
          @clients << ws
        end

        ws.on :message do |event|
          p [:message, event.data]

          # Active Decision
          if event.data[:decision] == 'active'
            @clients.each { |client| client.send(event.data) }

          # No specific action
          else
            @clients.each { |client| client.send(event.data) }
          end
        end

        ws.on :close do |event|
          p [:close, ws.object_id, event.code, event.reason]
          @clients.delete(ws)
          ws = nil
        end

        # Return async Rack response
        ws.rack_response

      else
        @app.call(env)
      end
    end

    private

    def sanitize(message)
      json = JSON.parse(message)
      json.each { |key, value| json[key] = ERB::Util.html_escape(value) }
      JSON.generate(json)
    end
  end
end
