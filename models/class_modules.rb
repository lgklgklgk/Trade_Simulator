module Seek
  
  
  def verify_trade(team_id)
    pitchers    = DATABASE.execute("SELECT count(*) FROM players WHERE team_id = 
     #{team_id} AND position = 'P'")
    catchers    = DATABASE.execute("SELECT count(*) FROM players WHERE team_id = 
     #{team_id} AND position = 'Catcher'")
    infielders  = DATABASE.execute("SELECT count(*) FROM players WHERE team_id = 
     #{team_id} AND position = 'IF'")
    outfielders = DATABASE.execute("SELECT count(*) FROM players WHERE team_id = 
     #{team_id} AND position = 'OF'")
  end
  
  def seek_all
    b = []
    table_name = class_to_table
    array = DATABASE.execute("SELECT * FROM #{table_name}")
    
    array.each do |hash|
      b << self.new(hash)
    end
    b
  end
  
# Public: seek
#
# Works in cunjunction with pull to get specific item(s) from the SQL table 
# and create objects representing them.
#
# Parameters:
# column_name - String           : The name of the column 
# value       - String or Integer: The value in the column being sought. 
#
# Returns:
# b, an array of one of more objects.

  def seek(column_name,value)
    table_name = class_to_table
    a = pull(table_name,column_name,value)
    b = []
    a.each do |hash|
      
      b << self.new(hash)
    end
    b
  end
  
# Public: class_to_table
#
# Determines the name of the table to be operated on based on the class name.
#
# Returns:
# The table name as a string.  
  
  def class_to_table
    class_names = {"Player" => "players", "Team" => "teams", "Trade" => "trades"}
    table_name = class_names[self.name]
    table_name
  end
  
  # Private: pull
  #
  # Pulls a specific entry from one of the three tables in SQLite.
  #
  # Parameters:
  # table_name  - String           : name of the table being searched
  # column_name - String           : name of the column being searched through
  # value       - String or Integer: name or number being searched for in the 
  #                                  column.
  # Returns
  # A SQL command which returns the value in a specific spot in a column of a 
  # table.
  
  private
  
  def pull(table_name,column_name,value)
    value = "'" + value + "'" if value.is_a?(String)
    sql_string = "SELECT * FROM #{table_name} WHERE #{column_name} = #{value}"
    
    DATABASE.execute(sql_string)
  end

end