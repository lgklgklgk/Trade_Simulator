get "/next" do
  @player_roster = Player.seek("team_id", params["player_team"])
  @ai_roster     = Player.seek("team_id", params["ai_team"])
  @player_name   = Team.seek("id", params["player_team"])
  @ai_name       = Team.seek("id", params["ai_team"])
  erb :"select_players/next"
end
