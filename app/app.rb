require 'open-uri'
require 'sinatra/base'
require 'sinatra/config_file'
require 'tilt/erb'
require 'slim'
require 'pry'

module ActiveCinema
  class App < Sinatra::Application
    if ENV['RACK_ENV'] == 'production' && ENV['CONFIG_FILE']
      File.open('./app/config/config.yml', "w") do |f|
        f.write(open(ENV['CONFIG_FILE']).read)
      end
    end

    register Sinatra::ConfigFile
    config_file './config/config.yml'

    %w(models initializers routes).each do |dir|
      require_relative "#{dir}/init"
    end
  end
end
