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
      @voting_clients = []
      @movie_clients = []
      @votes   = Hash.new(0)
    end

    def call(env)
      if Faye::WebSocket.websocket?(env)
        ws = Faye::WebSocket.new(env, nil, ping: KEEPALIVE_TIME)
        @video = ActiveCinema.the_video # Reset to first video on page reload

        ws.on :open do
          p [:open, ws.object_id]
          case ws.url.split('/').last
          when 'voting'
            @voting_clients << ws
          when 'movie'
            @movie_clients << ws
          else
            add_all(ws)
          end
        end

        ws.on :message do |event|
          p [:message, event.data]
          json = JSON.parse(event.data)
          if json['decided']
            @votes[json['decided']] += 1
          elsif json['decision'] == 'active'
            send_all(event.data)
          elsif json['video'] == 'ended'
            p [:votes, @votes]
            if !@votes.nil? && !@votes.empty?
              @video = @video.sequels[@votes.max_by { |_, v| v }.first]
              send_next_video
              @votes = Hash.new(0)
            elsif @video.sequels
              @video = @video.sequels[0]
              send_next_video
            else
              the_end
            end
          else
            the_end
          end
        end

        ws.on :close do |event|
          p [:close, ws.object_id, event.code, event.reason]
          @movie_clients.delete(ws) if @movie_clients.include?(ws)
          @voting_clients.delete(ws) if @voting_clients.include?(ws)
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

    def add_all(ws)
      @movie_clients << ws
      @voting_clients << ws
    end

    def send_all(data)
      @voting_clients.each { |client| client.send(data) }
      @movie_clients.each { |client| client.send(data) }
    end

    def send_next_video
      @movie_clients.each do |client|
        client.send(
          JSON.generate(
            video: @video.stream,
            question: @video.question))
      end
      @voting_clients.each do |client|
        client.send(
          JSON.generate(
            question: @video.question,
            answers: @video.answers,
            votes: JSON.generate(@votes)))
      end
    end

    def the_end
      send_all(JSON.generate(the_end: true))
    end
  end
end
