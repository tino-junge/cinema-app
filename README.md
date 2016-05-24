# Links zum Projekt
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
