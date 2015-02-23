require "pry"
require "sinatra"
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
                  general_manager TEXT, images TEXT)")
DATABASE.execute("CREATE TABLE IF NOT EXISTS trades
                 (id INTEGER PRIMARY KEY, accepted TEXT)")
DATABASE.execute("CREATE TABLE IF NOT EXISTS transactions
                 (id INTEGER PRIMARY KEY, player INTEGER, source TEXT, 
                 destination TEXT, trade_id INTEGER)")
                 
                 
require_relative "models/helper.rb"
require_relative "models/class_modules.rb"
require_relative "models/player.rb"
require_relative "models/team.rb"
require_relative "models/trade.rb"

helpers Convert

get "/" do
  @teams = Team.seek_all
  erb :home_page
end 

get "/next" do
  @player_roster = Player.seek("team_id", params["player_team"])
  @ai_roster     = Player.seek("team_id", params["ai_team"])
  @player_name   = Team.seek("id", params["player_team"])
  @ai_name       = Team.seek("id", params["ai_team"])
  erb :next
end

get "/trade_results" do
  @player_team    = Team.seek("id", params["player_team"])
  @ai_team        = Team.seek("id", params["ai_team"])
  @player_objects = trade_conversion(params)
  @war_diff       = war_difference(@player_objects)
  @your_players   = word_connector(get_player_names(@player_objects[0])) 
  @ai_players     = word_connector(get_player_names(@player_objects[1]))
  counter_check
  @initiate_trade = initiate_trade
  erb :trade_results
end                

get "/counter" do
  erb :counter
end

get "/results" do
  @display = display_join
  erb :results
end
