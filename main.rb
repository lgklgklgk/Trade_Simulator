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
                 
                 
                 
                 
                 
              
class Player
  
  def initialize(options)
    @id         = options["id"]
    @first_name = options["first_name"]
    @last_name  = options["last_name"]
    @position   = options["position"]
    @war        = options["war"]
    @team_id    = options["team_id"] 
  end 
    
  def self.create
    puts "first name?"
    first_name = gets.chomp
    puts "last name?"
    last_name = gets.chomp
    puts "position?"
    position = gets.chomp
    puts "war?"
    war = gets.chomp
    puts "team id?"
    team_id = gets.chomp
    DATABASE.execute("INSERT INTO players (first_name, last_name, position, 
    war, team_id) VALUES ('#{first_name}', '#{last_name}', '#{position}', #{war},
     #{team_id})")
  end            
end
                 binding.pry