require 'bundler/setup'
Bundler.require(:default)

require_all 'app'

set(database: {adapter:'sqlite3', database:'db/day_names.sqlite3'})