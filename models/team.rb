class Team
  extend Seek
  attr_reader :name, :general_manager, :id, :image, :abbreviation
  
  def initialize(options)
    @id              = options["id"]
    @name            = options["name"]
    @general_manager = options["general_manager"]
    @image           = options["images"]
    @abbreviation    = options["abbreviation"]
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