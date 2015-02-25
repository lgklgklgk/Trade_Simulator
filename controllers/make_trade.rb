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
  erb :"make_trade/trade_results"
end                