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
require_relative "controllers/counter_reject"
require_relative "controllers/display_table"
require_relative "controllers/home_page"
require_relative "controllers/make_trade"
require_relative "controllers/select_players"

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
  teams = {}
  teams["player_team"] = params.delete("player_team")
  teams["ai_team"] = params.delete("ai_team")
  @trade = Trade.new({"player_team" => teams["player_team"], "ai_team" => teams["ai_team"], 
    "all_the_player_ids" => params.values.map(&:to_i)})
  counter_check  
  @ai_team      = Team.seek("id", teams["ai_team"])
  @your_players = word_connector(get_player_names(@trade.player_dealt_players)) 
  @ai_players   = word_connector(get_player_names(@trade.ai_dealt_players))
  erb :trade_results
end                

get "/counter" do
  erb :counter
end

get "/results" do
  @display = display_join
  do_not_want_table
  erb :results
end
