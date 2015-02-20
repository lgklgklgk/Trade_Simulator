class Player
  extend Seek
  attr_accessor :team_id
  attr_reader :first_name, :last_name, :position, :war, :id
  
  def initialize(options)
    @id         = options["id"]
    @first_name = options["first_name"]
    @last_name  = options["last_name"]
    @position   = options["position"]
    @war        = options["war"]
    @team_id    = options["team_id"] 
  end 
    
  def self.create_player
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