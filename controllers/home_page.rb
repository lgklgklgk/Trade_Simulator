get "/" do
  @teams = Team.seek_all
  erb :"home_page/home_page"
end 