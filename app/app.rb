require 'sinatra/base'
require 'sinatra/config_file'
require 'tilt/erb'
require 'slim'
require 'pry'

module ActiveCinema
  class App < Sinatra::Application
    register Sinatra::ConfigFile
    config_file './config/config.yml'

    %w(models initializers routes).each do |dir|
      require_relative "#{dir}/init"
    end
  end
end
