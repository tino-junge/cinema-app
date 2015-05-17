require 'faye/websocket'
require 'thread'
require 'json'
require 'erb'
require 'pry'

module ActiveCinema
  class WebsocketBackend
    KEEPALIVE_TIME = 15 # in seconds

    def initialize(app)
      @app     = app
      @clients = []
      @votes   = Hash.new(0)
    end

    def call(env)
      if Faye::WebSocket.websocket?(env)
        ws = Faye::WebSocket.new(env, nil, ping: KEEPALIVE_TIME)
        @video   = ActiveCinema.the_video # Reset to first video on page reload

        ws.on :open do
          p [:open, ws.object_id]
          @clients << ws
        end

        ws.on :message do |event|
          p [:message, event.data]
          json = JSON.parse(event.data)
          if json['decided']
            @votes[json['decided']] += 1
          elsif json['decision']
            @clients.each { |client| client.send(event.data) }
          elsif json['video'] && !@votes.nil? && !@votes.empty?
            @video = if @votes['A'] >= @votes['B']
                       @video.sequels[0]
                     else
                       @video.sequels[1]
                     end
            @clients.each { |client| client.send(JSON.generate(video: @video.stream)) }
            @votes = Hash.new(0)
          else
            @clients.each { |client| client.send(JSON.generate(the_end: true)) }
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
