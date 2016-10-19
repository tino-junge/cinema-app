# Links to movie and moviemakers
* https://www.facebook.com/activecinema (please like and share :)
* https://www.youtube.com/activecinema14 (please like and share :)

# cinema-app
Active Cinema Voting App

## Setup

* `git clone <repository-url>` this repository
* change directory `cd cinema-app`
* run `bundle install`
* create .env file (copy .env.sample)
* create /app/config/config.yml (copy config.yml.sample)

### Create video and sound files

* change directory `cd cinema-app`
* `mkdir app/public/sounds`
* copy decision sound file `decision_sound.mp3` to new sounds folder
* `mkdir app/public/videos`
* copy all video files `iamerror_01.mp4` - `iamerror_37.mp4` to new videos folder

## Running

* change directory `cd cinema-app`
* run `foreman start` in cinema-app directory to start the server

## Test
* run `rake` for the tests

## Deployment
Host you cinema server online and watch together with friends!
Proposed setup is server hosting on Heroku and file hosting on Owncloud.

* Upload your files to Owncloud and generate sharable links
* Change file keys within your config file to shared hash keys (Warning: currently only Owncloud hosting supported)
* Set `remote_url` key in config file to your Owncloud domain
* Upload your config file somewhere online (why not in owncloud)
* Deploy your server code. Heroku is recommended :) Just connect a new app with you github repo and Heroku takes care of the rest ;)
* Set environment variables on your sever application:
  * set env `CONFIG_FILE` to `<url-to-config-file>`
  * set env `RACK_ENV` to `production`
* Have fun!
