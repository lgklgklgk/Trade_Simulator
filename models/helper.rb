module Convert  
  
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
  
  def counter_check
    if params["choice"] == "no"
      @trade.player_dealt_players.pop
      @trade.reject
      redirect to("/counter")
    end
  end
  
  def display_join
    DATABASE.execute("SELECT transactions.trade_id, trades.accepted, players.last_name, transactions.source, transactions.destination FROM transactions JOIN trades ON transactions.trade_id = trades.id JOIN players ON transactions.player = players.id JOIN teams ON transactions.source = teams.abbreviation")
  end
  
  def do_not_want_table
    if params["choice"] == "no"
      redirect to "/"
    end
  end
 
end