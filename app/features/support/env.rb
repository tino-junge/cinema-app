ENV['RACK_ENV'] = 'test'
require 'pry'
require 'rack/test'
require 'aruba/api'


module CinemaWorld
  include Rack::Test::Methods

  def root_directory
    Pathname.new(__FILE__).dirname.join("..","..","..","..","cinema-app")
  end

  def copy_app_to_aruba_working_directory
    app_directory_path = Pathname.new(__FILE__).join("..").join("..").join("..").join("..").join("app")
    app_files = Dir.glob(app_directory_path.join("*")).reject{ |f| f.end_with?("public") }
    # skip video files - might be large
    app_files_public = Dir.glob(app_directory_path.join("public/*")).reject{ |f| f.end_with?("videos") }
    create_directory("app/public")
    FileUtils.cp_r(app_files, expand_path("app"))
    FileUtils.cp_r(app_files_public, expand_path("app/public"))
  end

  def app_location
    # this is the location of app.rb in the working directory of aruba
    "app/app.rb"
  end
end

Before('@aruba') do
  setup_aruba
  copy_app_to_aruba_working_directory
end

World(CinemaWorld)
World(Aruba::Api)
