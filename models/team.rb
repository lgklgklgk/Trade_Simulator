class Team
  
  def initialize(options)
    @name            = options["name"]
    @general_manager = options["general_manager"]
  end
  

  def self.create_team
    puts "Team name?"
    team_name = gets.chomp
    puts "GM?"
    gm = gets.chomp
    DATABASE.execute("INSERT INTO teams (name, general_manager) VALUES 
    ('#{team_name}', '#{gm}')")
  end

end