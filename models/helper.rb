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
  
  def verify_trade(team_id)
    pitchers    = DATABASE.execute("SELECT count(*) FROM players WHERE team_id = 
     #{team_id} AND position = 'P'")
    catchers    = DATABASE.execute("SELECT count(*) FROM players WHERE team_id = 
     #{team_id} AND position = 'Catcher'")
    infielders  = DATABASE.execute("SELECT count(*) FROM players WHERE team_id = 
     #{team_id} AND position = 'IF'")
    outfielders = DATABASE.execute("SELECT count(*) FROM players WHERE team_id = 
     #{team_id} AND position = 'OF'")
    roster = pitchers + catchers + infielders + outfielders 
  end
  
  def evaluate_trade(war_diff, team_id)
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
      counter_offer(war_diff, team_id)
    end
  end
  
  def accept_trade
    DATABASE.execute("INSERT INTO trades (accepted) VALUES ('yes')") 
    @player_objects[0].each do |x|
      binding.pry
      DATABASE.execute("INSERT INTO transactions (player, source, destination, trade_id) VALUES (#{x.id}, #{x.team_id}, #{@ai_team[0].id}, last_insert_rowid(trades))") 
    end
  end 
  
  def counter_offer(war_diff, team_id)
    counter_offer = DATABASE.execute("SELECT * FROM players WHERE team_id = 
    #{team_id} AND war >= #{war_diff.abs}")
    if counter_offer == [] 
      reject_trade  
      return "That is an absolutely ridiculous offer, and frankly, you should be ashamed of yourself. No one on your roster will make this work."
    else counter_player = Player.new(counter_offer.sample) 
      binding.pry   
      return decide_counter_offer(counter_player) 
    end
  end
  
  def decide_counter_offer(player_object)
  end
  
end