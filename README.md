# cinema-app
Active Cinema Voting App

# Social media
* [Facebook](https://www.facebook.com/activecinema) (please like and share :)
* [YouTube](https://www.youtube.com/activecinema14) (please like and share :)

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
Host your own cinema server and watch together with friends remotely!
Recommended setup is server hosting on [Heroku](https://www.heroku.com/) and file hosting on [ownCloud](https://owncloud.com/).

* Upload your video files to ownCloud and generate sharable links
* Change video file keys within your config file to shared hash keys (Note: currently only ownCloud hosting supported)
* Set `remote_url` key in config file to your ownCloud domain
* Upload your config file somewhere online (e.g. ownCloud or Dropbox)
* Deploy your server code. Heroku is recommended :) Just connect a new app with your GitHub repo and Heroku takes care of the rest ;)
* Set environment variables on your server application in Heroku:
  * set env `CONFIG_FILE` to `<url-to-config-file>`
  * set env `RACK_ENV` to `production`
* Have fun!
