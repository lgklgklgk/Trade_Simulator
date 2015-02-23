module Convert  
  
  def trade_conversion(params_hash)
    team_1_players = []
    team_2_players = []
    teams = {}
    teams["player_team"] = params.delete("player_team")
    teams["ai_team"] = params.delete("ai_team")
    players = []
    a = params.values.map(&:to_i)
    a.each { |x| players << Player.seek("id", x) }
    players.flatten!
    team = teams.values.map(&:to_i)
    players.each do |x|
      if x.team_id == team[0]
        team_1_players << x
      else
        team_2_players << x
      end
    end
    return team_1_players, team_2_players
  end
  
  def war_difference(array)
    war_1 = 0
    war_2 = 0
    array[0].each { |x| war_1 += x.war }
    array[1].each { |x| war_2 += x.war }
    return (war_1 - war_2)
  end
  
  def get_player_names(object)
    a = []
    object.each do |x|
      a << x.first_name + " " + x.last_name
    end
    return a
  end
  
  def word_connector(array_to_join)
    if array_to_join.count > 2
      last_word = array_to_join[-1]
      array_to_join.delete_at(-1)
      new_string = array_to_join.join(", ")
      return "#{new_string}, and #{last_word}"
    else
      two_string = array_to_join.join(" and ")
      return "#{two_string}"
    end
  end
  
  def initiate_trade
    amended_player = []
    amended_ai     = []
    a = Player.seek("team_id", @player_team[0].id)
    b = Player.seek("team_id", @ai_team[0].id)
    a.each {|a| amended_player << a.id }
    b.each {|b| amended_ai     << b.id }
    players_to_remove = []
    ai_to_remove      = []
    @player_objects[0].each {|object| players_to_remove << object.id }
    @player_objects[1].each {|object| ai_to_remove      << object.id }
    final_player_array = amended_player - players_to_remove
    final_ai_array     = amended_ai     - ai_to_remove
    final_player_object_array = []
    final_ai_object_array     = []
    final_player_array.each {|id| final_player_object_array << Player.seek("id", id)}
    final_ai_array.each     {|id| final_ai_object_array     << Player.seek("id", id)}
    final_player_object_array << @player_objects[1]
    final_ai_object_array     << @player_objects[0]
    final_player_object_array.flatten!
    final_ai_object_array.flatten!
    if final_player_object_array.length <= 44 && final_ai_object_array.length <= 44
      evaluate_pitchers(final_player_object_array, final_ai_object_array)
    else
      return "Invalid trade, this would give one team too many players!"
    end
  end
  
  def evaluate_pitchers(player, ai)
    if player.select {|x| x.position == "Pitcher"}.length >= 10 && ai.select {|x| x.position == "Pitcher"}.length >= 10
      evaluate_catchers(player, ai)
    else
      return "Invalid trade, one team wouldn't have enough pitchers!"
    end
  end
  
  def evaluate_catchers(player, ai)
    if player.select {|x| x.position == "Catcher"}.length >= 2 && ai.select {|x| x.position == "Catcher"}.length >= 2
      evaluate_infield(player, ai)
    else
      return "Invalid trade, one team wouldn't have enough catchers!"
    end
  end
  
  def evaluate_infield(player, ai)
    if player.select {|x| x.position == "IF"}.length >= 6 && ai.select {|x| x.position == "IF"}.length >= 6
      evaluate_outfield(player, ai)
    else
      return "Invalid trade one team wouldn't have enough infielders!"
    end
  end
     
  def evaluate_outfield(player, ai)
    if player.select {|x| x.position == "OF"}.length >= 4 && ai.select {|x| x.position == "OF"}.length >= 4
      evaluate_trade(@war_diff)
    else
      return "Invalid trade, one team wouldn't have enough outfielders!"
    end
  end
  
  def evaluate_trade(war_diff)
    if war_diff >= 5
      accept_trade
      return "This is an excellent offer. I will happily accept!"
    elsif (war_diff < 5 && war_diff > 1)
      accept_trade
      return "This is agreeable to our needs as a franchise. I accept."
    elsif (war_diff <= 1 && war_diff > (-0.3))
      accept_trade
      return "Hmm, this seems like a very fair offer. I begrudingly accept."
    else
      counter_offer(war_diff)
    end
  end
  
  def accept_trade
    DATABASE.execute("INSERT INTO trades (accepted) VALUES ('yes')") 
    trade_id = DATABASE.execute("SELECT id FROM trades WHERE id = (SELECT MAX(id) FROM trades)")
    @player_objects[0].each do |x|
      DATABASE.execute("INSERT INTO transactions (player, source, destination, trade_id) VALUES (#{x.id}, '#{@player_team[0].name}', '#{@ai_team[0].name}', #{trade_id[0]['id']})") 
    end
    @player_objects[1].each do |x|
      DATABASE.execute("INSERT INTO transactions (player, source, destination, trade_id) VALUES (#{x.id}, '#{@ai_team[0].name}', '#{@player_team[0].name}', #{trade_id[0]['id']})") 
    end
    return
  end 
  
  def reject_trade
    DATABASE.execute("INSERT INTO trades (accepted) VALUES ('no')") 
    trade_id = DATABASE.execute("SELECT id FROM trades WHERE id = (SELECT MAX(id) FROM trades)")
    @player_objects[0].each do |x|
      DATABASE.execute("INSERT INTO transactions (player, source, destination, trade_id) VALUES (#{x.id}, '#{@player_team[0].name}', '#{@ai_team[0].name}', #{trade_id[0]['id']})") 
    end
    @player_objects[1].each do |x|
      DATABASE.execute("INSERT INTO transactions (player, source, destination, trade_id) VALUES (#{x.id}, '#{@ai_team[0].name}', '#{@player_team[0].name}', #{trade_id[0]['id']})") 
    end
    return
  end 
  
  def counter_check
    if params["choice"] == "no"
      @player_objects[0].pop
      reject_trade
      redirect to("/counter")
    end
  end
  
  def display_join
    DATABASE.execute("SELECT transactions.trade_id, trades.accepted, players.last_name, transactions.source, transactions.destination FROM transactions JOIN trades ON transactions.trade_id = trades.id JOIN players ON transactions.player = players.id JOIN teams ON transactions.source = teams.name")
  end
  private
  
  def counter_offer(war_diff)
    a = Player.seek("team_id", @player_team[0].id)
    b = params.values.map {|x| x.to_i}
    b.each {|b| a.delete_if{|a| (a.id) == b}}
    @sample_players = a.select {|x| x.war >= war_diff.abs}
    @sample_player  = @sample_players.sample
    return
  end
    
end