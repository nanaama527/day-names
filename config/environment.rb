require 'bundler/setup'
Bundler.require(:default)

require 'sinatra/flash'

require_all 'app'

set(database: {adapter:'sqlite3', database:'db/day_names.sqlite3'})