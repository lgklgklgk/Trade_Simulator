require "pry"
#require "sinatra"
require "sqlite3"

DATABASE = SQLite3::Database.new('trade_simulator.db')
DATABASE.results_as_hash = true
DATABASE.execute("CREATE TABLE IF NOT EXISTS players
                 (id INTEGER PRIMARY KEY, first_name TEXT,
                 last_name TEXT, position TEXT, war INTEGER,
                 team_id INTEGER)")
DATABASE.execute("CREATE TABLE IF NOT EXISTS teams
                 (id INTEGER PRIMARY KEY,
                  name TEXT,
                  general_manager TEXT)")
DATABASE.execute("CREATE TABLE IF NOT EXISTS trades
                 (id INTEGER PRIMARY KEY, accepted TEXT, team_1 INTEGER,
                 team_2 INTEGER, player_1 INTEGER, player_2 INTEGER)")
                 
                 
                 
                 
                 
              

                 binding.pry